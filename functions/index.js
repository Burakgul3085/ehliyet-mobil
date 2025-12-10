// ✅ V2 Functions import
const { setGlobalOptions } = require("firebase-functions/v2");
const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// --------------------------------------------------------------------
// Global ayarlar
// --------------------------------------------------------------------
setGlobalOptions({
  region: "us-central1",
  maxInstances: 5,
});

// --------------------------------------------------------------------
// Sabit Gemini model adı (Ücretli, daha güçlü model)
// --------------------------------------------------------------------
// İstersen bunu "gemini-2.5-flash" veya "gemini-1.5-pro" olarak da değiştirebilirsin.
const GEMINI_MODEL_NAME = "gemini-2.5-pro";

// --------------------------------------------------------------------
// Gemini API key okuma
// --------------------------------------------------------------------
function getGeminiApiKey() {
  // 1) Ortam değişkeni (.env -> GEMINI_API_KEY)
  if (process.env.GEMINI_API_KEY) {
    return process.env.GEMINI_API_KEY;
  }

  // 2) firebase functions:config:set gemini.key="API_KEY"
  try {
    const functions = require("firebase-functions"); // v1 config okuma
    const cfg = functions.config();
    if (cfg && cfg.gemini && cfg.gemini.key) {
      return cfg.gemini.key;
    }
  } catch (e) {
    logger.warn(
      "functions.config() okunamadı (muhtemelen lokal emülatör / yeni runtime):",
      e.message || e
    );
  }

  return null;
}

// ❗ let yaptık ki çalışma anında tekrar doldurabilelim
let GEMINI_API_KEY = getGeminiApiKey();

if (!GEMINI_API_KEY) {
  // Deploy sırasında config tam yüklenmemiş olabilir, bunu fatal hata yapmıyoruz
  logger.warn(
    "Gemini API key şu anda bulunamadı, çalışma anında tekrar okunacak. (.env veya functions:config kontrol et)"
  );
} else {
  logger.info("✅ Gemini API key yüklendi.");
}

// --------------------------------------------------------------------
// Gemini çağrısını manuel yapan yardımcı fonksiyon (REST, v1beta endpoint)
// 503 / 500 ve bazı ağ hatalarında birkaç kere tekrar dener
// --------------------------------------------------------------------
async function safeCallGemini(modelName, prompt, callerTag) {
  // Çalışma anında tekrar dene, belki başlangıçta boştu
  if (!GEMINI_API_KEY) {
    GEMINI_API_KEY = getGeminiApiKey();
  }

  if (!GEMINI_API_KEY) {
    logger.warn(
      `Gemini API anahtarı olmadığı için istek atılmadı (${callerTag}).`
    );
    return null;
  }

  // 🔁 Model adı parametrede boş gelirse default modeli kullan
  const effectiveModelName = modelName || GEMINI_MODEL_NAME;

  // 🔧 v1beta endpoint + yeni model adı
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(
    effectiveModelName
  )}:generateContent?key=${encodeURIComponent(GEMINI_API_KEY)}`;

  const body = {
    contents: [
      {
        role: "user",
        parts: [{ text: prompt }],
      },
    ],
  };

  const maxAttempts = 3; // 3 defaya kadar tekrar dene

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      const resp = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: JSON.stringify(body),
      });

      if (!resp.ok) {
        const errText = await resp.text();

        // 429 → kota / rate limit
        if (resp.status === 429) {
          logger.error(
            `Gemini QUOTA / RATE LIMIT hatası (${callerTag}): 429 - ${errText.slice(
              0,
              200
            )}`
          );
          return null;
        }

        // 503 veya 500 → model/sunucu geçici sıkıntı, tekrar dene
        if (resp.status === 503 || resp.status === 500) {
          logger.warn(
            `Gemini geçici servis hatası (${callerTag}), attempt=${attempt}: ${resp.status} - ${resp.statusText}`
          );
          if (attempt < maxAttempts) {
            const delayMs = 400 * attempt; // 400ms, 800ms, 1200ms...
            await new Promise((r) => setTimeout(r, delayMs));
            continue; // bir sonraki denemeye geç
          }
          // tüm denemeler başarısız → pes et
          return null;
        }

        // Diğer hatalar → logla ve pes et
        logger.error(
          `Gemini HTTP hata (${callerTag}): ${resp.status} ${
            resp.statusText
          } - ${errText.slice(0, 400)}`
        );
        return null;
      }

      const data = await resp.json();
      const parts = (data.candidates?.[0]?.content?.parts || []).map(
        (p) => p.text || ""
      );
      const text = parts.join("\n").trim();

      if (!text) {
        logger.warn(`Gemini boş yanıt döndürdü (${callerTag}).`);
        return null;
      }

      logger.info(
        `Gemini yanıtı (${callerTag}) kısaltılmış: ${text.slice(0, 200)}`
      );
      return text;
    } catch (err) {
      logger.error(
        `❌ safeCallGemini ağ/istemci hatası (${callerTag}), attempt=${attempt}:`,
        err
      );
      if (attempt < maxAttempts) {
        await new Promise((r) => setTimeout(r, 400 * attempt));
        continue;
      }
      return null;
    }
  }

  return null;
}

// --------------------------------------------------------------------
// Yanıt metnini mobil için sadeleştiren yardımcı (Markdown temizleme)
// --------------------------------------------------------------------
function normalizeAnswerText(raw) {
  if (!raw) return "";
  let txt = String(raw);

  // **kalın** işaretlerini kaldır
  txt = txt.replace(/\*\*/g, "");

  // Fazla boş satırları azalt
  txt = txt.replace(/\r\n/g, "\n");
  txt = txt.replace(/\n{3,}/g, "\n\n");

  // Baş / son boşlukları kırp
  txt = txt.trim();

  return txt;
}

// --------------------------------------------------------------------
// Yerel (fallback) sınav analizi üretici
// --------------------------------------------------------------------
function buildLocalExamAnalysis(total, correct, wrong, topicStats) {
  const answered = correct + wrong;
  const successRate =
    answered > 0 ? Math.round((correct / answered) * 100) : 0;
  const unanswered = total - answered;

  const topicLines = Object.entries(topicStats || {})
    .map(([name, info]) => {
      const wrongRate = info.total
        ? Math.round((info.wrong / info.total) * 100)
        : 0;
      return `• ${name}: ${info.total} soru, ${info.wrong} yanlış (%${wrongRate})`;
    })
    .join("\n");

  const strongTopics = [];
  const weakTopics = [];

  for (const [name, info] of Object.entries(topicStats || {})) {
    if (!info.total) continue;
    const wrongRate = info.wrong / info.total;
    if (wrongRate <= 0.25) strongTopics.push(name);
    else if (wrongRate >= 0.5) weakTopics.push(name);
  }

  const studyPlan = [
    "Yanlış yaptığın soruları tekrar inceleyip doğrusunu öğren.",
    "Zayıf olduğun konulardan her gün en az 10–15 soru çöz.",
    "Sınav süresini daha iyi yönetmek için süre tutarak deneme çöz.",
    "Karıştırdığın trafik işaretlerini küçük notlar halinde tekrar et.",
  ];

  const summary =
    `Toplam ${total} sorudan ${answered} tanesine cevap verdin. ` +
    `${correct} doğru, ${wrong} yanlışın var. ` +
    `Genel başarı oranın yaklaşık %${successRate}. ` +
    (unanswered > 0 ? `${unanswered} soruyu boş bırakmışsın. ` : "") +
    (topicLines ? `Konu bazlı performansın:\n${topicLines}` : "");

  return {
    summary,
    strongTopics,
    weakTopics,
    studyPlan,
    motivation:
      "Düzenli tekrar ve planlı çalışmayla ehliyet sınavını rahatlıkla geçebilecek seviyedesin, pes etme!",
  };
}

// --------------------------------------------------------------------
// 1) Sınav Analizi Fonksiyonu
// --------------------------------------------------------------------
exports.analyzeExam = onRequest(async (req, res) => {
  // CORS
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  if (req.method !== "POST") {
    res.status(405).json({ error: "Sadece POST isteği destekleniyor." });
    return;
  }

  const body = req.body || {};
  const questions = body.questions;

  if (!Array.isArray(questions) || questions.length === 0) {
    res.status(400).json({ error: "Geçersiz veri: questions listesi boş." });
    return;
  }

  // ✅ İstatistikleri çıkar
  const total = questions.length;
  let correct = 0;
  let wrong = 0;
  const topicStats = {}; // { "Trafik İşaretleri": { total, wrong } }

  for (const q of questions) {
    // 🔧 Kullanıcının işaretlediği şık için daha esnek alan okuma
    let userIndex =
      q.userIndex ??
      q.userAnswerIndex ??
      q.selectedIndex ??
      q.selectedOptionIndex ??
      q.userChoiceIndex ??
      q.userAnswer ??
      null;

    let correctIndex =
      q.correctIndex ??
      q.correctAnswerIndex ??
      q.answerIndex ??
      q.trueIndex ??
      null;

    // Sayı değilse sayıya çevir (örn: "1" string gelmiş olabilir)
    if (typeof userIndex === "string") {
      const parsed = parseInt(userIndex, 10);
      if (!Number.isNaN(parsed)) userIndex = parsed;
    }
    if (typeof correctIndex === "string") {
      const parsed = parseInt(correctIndex, 10);
      if (!Number.isNaN(parsed)) correctIndex = parsed;
    }

    const isAnswered = userIndex !== null && userIndex !== undefined;
    const isCorrect = isAnswered && userIndex === correctIndex;

    if (isAnswered) {
      if (isCorrect) correct += 1;
      else wrong += 1;
    }

    const topic =
      q.category || q.topic || q.categoryName || q.konu || "Diğer";

    if (!topicStats[topic]) {
      topicStats[topic] = { total: 0, wrong: 0 };
    }
    topicStats[topic].total += 1;
    if (isAnswered && !isCorrect) {
      topicStats[topic].wrong += 1;
    }
  }

  const topicSummaryLines = Object.entries(topicStats)
    .map(([name, info]) => {
      const wrongRate = info.total
        ? Math.round((info.wrong / info.total) * 100) : 0;
      return `• ${name}: ${info.total} soru, ${info.wrong} yanlış (%${wrongRate})`;
    })
    .join("\n");

  // ✅ Prompt
  const prompt = `
Sen Türkiye'deki ehliyet yazılı sınavına hazırlanan bir öğrenci için AKILLI SINAV KOÇUSUN.

Elindeki genel istatistikler:
- Toplam soru: ${total}
- Doğru sayısı (tahmini): ${correct}
- Yanlış sayısı (tahmini): ${wrong}

Konu bazlı performans:
${topicSummaryLines || "Konu bazlı detay bilgisi sınırlı."}

Aşağıda her bir soru için JSON formatında detaylar var:
${JSON.stringify(questions).slice(0, 12000)}

Görevlerin:
1) Kısa bir GENEL ÖZET (1 paragraf) yaz.
2) "Güçlü Olduğun Konular" başlığı altında 2–5 madde yaz.
3) "Zayıf Olduğun Konular" başlığı altında 2–5 madde yaz.
4) "Somut Çalışma Önerileri" başlığı altında 3–7 madde yaz. Her madde çok net ve uygulanabilir olsun.
5) Sondaki "motivation" alanında tek cümlelik motive edici bir cümle yaz.

Cevabını SADECE şu JSON formatında döndür (başka bir şey ekleme):

{
  "summary": "...",
  "strongTopics": ["...", "..."],
  "weakTopics": ["...", "..."],
  "studyPlan": ["...", "..."],
  "motivation": "..."
}
`;

  let payload;

  try {
    // ✅ Yeni model adı ile Gemini çağrısı
    const aiText = await safeCallGemini(
      GEMINI_MODEL_NAME,
      prompt,
      "analyzeExam"
    );

    if (aiText && aiText.trim()) {
      let parsed = null;
      try {
        parsed = JSON.parse(aiText);
      } catch (e) {
        logger.warn(
          "Gemini JSON parse hatası, düz metin kullanılacak:",
          e.message || e
        );
      }

      if (parsed && typeof parsed === "object") {
        payload = {
          summary: parsed.summary || "",
          strongTopics: parsed.strongTopics || [],
          weakTopics: parsed.weakTopics || [],
          studyPlan: parsed.studyPlan || [],
          motivation: parsed.motivation || "",
        };
      } else {
        payload = {
          summary: aiText,
          strongTopics: [],
          weakTopics: [],
          studyPlan: [],
          motivation:
            "Düzenli tekrar yaparsan bu performansı hızla yükseltebilirsin, devam et!",
        };
      }
    } else {
      logger.warn(
        "Gemini yanıtı boş, local analiz üretilecek (analyzeExam)."
      );
      payload = buildLocalExamAnalysis(total, correct, wrong, topicStats);
    }
  } catch (err) {
    logger.error(
      "analyzeExam içinde beklenmeyen hata, local analiz dönülecek:",
      err
    );
    payload = buildLocalExamAnalysis(total, correct, wrong, topicStats);
  }

  // ❗ Artık her durumda 200 dönüyoruz, frontend "analiz metni boş" dememeli
  res.status(200).json(payload);
});

// --------------------------------------------------------------------
// 2) Trafik Koçu Sohbet Fonksiyonu (soru JSON'u ile çalışacak şekilde güçlendirildi)
// --------------------------------------------------------------------
exports.trafficCoachChat = onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Headers", "Content-Type");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  if (req.method !== "POST") {
    res.status(405).json({ error: "Sadece POST isteği destekleniyor." });
    return;
  }

  const body = req.body || {};
  const question = body.question || "";

  if (!question) {
    res.status(400).json({ error: "Soru metni (question) boş olamaz." });
    return;
  }

  const normalized = question.toLowerCase().trim();

  // ✅ 0-A) Küfür / hakaret filtresi
  const profanityKeywords = [
    "salak",
    "aptal",
    "gerizekalı",
    "mal",
    "embesil",
    "oç",
    "orospu",
    "siktir",
    "sikerim",
    "sikiyim",
    "piç",
    "şerefsiz",
    "ibne",
    "yarrak",
    "amk",
    "aq",
  ];
  const hasProfanity = profanityKeywords.some((w) =>
    normalized.includes(w)
  );

  if (hasProfanity) {
    return res.status(200).json({
      answer:
        "Lütfen daha saygılı bir dil kullan. Ben sadece ehliyet sınavı, trafik kuralları, trafik işaretleri, ilk yardım ve araç tekniği konularında eğitim amaçlı yardımcı olabilirim.",
    });
  }

  // ✅ 0-B) İsteğe bağlı olarak sınav sorusu JSON'u da gelebilir
  // body.currentQuestion: { text, options, correctIndex, ... }
  // body.questions: [ ... ] + body.currentQuestionIndex: 0..N
  const examQuestions = Array.isArray(body.questions) ? body.questions : [];
  const currentQuestionIndex =
    typeof body.currentQuestionIndex === "number"
      ? body.currentQuestionIndex
      : null;

  let focusedQuestion = null;

  if (body.currentQuestion && typeof body.currentQuestion === "object") {
    focusedQuestion = body.currentQuestion;
  } else if (
    currentQuestionIndex !== null &&
    examQuestions[currentQuestionIndex]
  ) {
    focusedQuestion = examQuestions[currentQuestionIndex];
  }

  const examContextJson = JSON.stringify(
    {
      focusedQuestion: focusedQuestion || null,
      examQuestions: focusedQuestion ? undefined : examQuestions,
    },
    null,
    2
  ).slice(0, 4000);

  // 1) Selamlaşma (kısa ve direkt)
  const greetingKeywords = [
    "merhaba",
    "selam",
    "selamlar",
    "merhabalar",
    "hello",
    "hi",
    "günaydın",
    "iyi akşamlar",
    "iyi günler",
  ];
  const isGreeting = greetingKeywords.some((g) =>
    normalized.startsWith(g)
  );
  if (isGreeting) {
    return res.status(200).json({
      answer:
        "Ben Trafik Koçu yapay zekâyım. Ehliyet sınavı, trafik kuralları, trafik işaretleri, ilk yardım ve araç tekniğiyle ilgili sorun varsa yaz; birlikte çözelim.",
    });
  }

  // 2) Basit off-topic filtresi (yalnızca bariz durumlarda)
  const offTopicKeywords = [
    "yemek",
    "tarif",
    "sevgili",
    "ilişki",
    "sevgilim",
    "bitcoin",
    "kripto",
    "borsa",
    "yatırım",
    "döviz",
    "oyun",
    "pubg",
    "valorant",
    "lol",
    "csgo",
    "film",
    "dizi",
    "netflix",
    "şarkı",
    "müzik",
    "instagram",
    "tiktok",
    "youtube",
    "programlama",
    "yazılım",
    "python",
    "flutter",
    "javascript",
  ];
  const examHintKeywords = [
    "soru",
    "test",
    "deneme",
    "şık",
    "cevap",
    "doğru mu",
    "yanlış mı",
    "çöz",
    "çözer misin",
    "cozermisin",
    "çözer misin?",
    "açıkla",
    "açıklarmısın",
    "açıklayarak",
    "anlamadım",
  ];

  const hasOffTopic = offTopicKeywords.some((k) =>
    normalized.includes(k)
  );
  const hasExamHint = examHintKeywords.some((k) =>
    normalized.includes(k)
  );

  if (hasOffTopic && !hasExamHint) {
    return res.status(200).json({
      answer:
        "Ben bir trafik koçuyum; yalnızca ehliyet sınavı, trafik kuralları, trafik işaretleri, ilk yardım ve araç tekniği ile ilgili sorularda yardımcı olabiliyorum.",
    });
  }

  // ✅ 3) Ehliyet / trafik alanına ait anahtar kelimeler
  const domainKeywords = [
    "ehliyet",
    "trafik",
    "ilk yardım",
    "ilkyardım",
    "araç",
    "aracın",
    "motor",
    "şerit",
    "kavşak",
    "ışık",
    "lamba",
    "sürücü",
    "sürüş",
    "park",
    "durma",
    "duraklama",
    "geçiş üstünlüğü",
    "trafik adabı",
    "trafik ve çevre",
    "çevre bilgisi",
    "emniyet kemeri",
    "hız",
    "takip mesafesi",
    "lastik",
    "fren",
    "debriyaj",
    "vites",
    "yaya",
    "levha",
    "işaret",
    "kırmızı ışık",
    "kontak",
    "marş",
    "sürücü belgesi",
    "sürücü kursu",
  ];

  const hasDomainKeyword = domainKeywords.some((k) =>
    normalized.includes(k)
  );
  const isExamContextAvailable = !!focusedQuestion || examQuestions.length > 0;

  // Eğer mesajda ehliyet / trafik alanına dair bir iz yoksa VE sınav sorusu JSON'u da yoksa → cevap verme
  if (!hasDomainKeyword && !hasExamHint && !isExamContextAvailable) {
    return res.status(200).json({
      answer:
        "Ben sadece ehliyet yazılı sınavı, trafik kuralları, trafik işaretleri, ilk yardım, trafik adabı ve araç tekniği konularında yardımcı olabilirim. Bu alanlardan bir soru ya da kural yazarsan ayrıntılı şekilde açıklarım.",
    });
  }

  // 4) Prompt – KISA VE NET + sınav sorusu JSON'u ile çalışma
  const prompt = `
Sen Türkiye'deki ehliyet yazılı sınavına hazırlanan bir öğrenciye
yardım eden UZMAN TRAFİK KOÇU yapay zekâsın.

Yalnızca şu alanlarda cevap ver:
- Trafik kuralları, trafik ve çevre bilgisi, trafik işaretleri
- Trafik adabı ve sürücü psikolojisi
- İlk yardım (ehliyet müfredatı kapsamındaki konular)
- Motor ve araç tekniği (motor çalışma prensibi, fren, debriyaj, vites, lastikler vb.)
- Ehliyet sınavı ve sürücü belgesi süreci

ELİNDE OPSİYONEL SINAV SORUSU VERİSİ VAR (JSON):
${examContextJson || "boş"}

Bu JSON'da:
- "focusedQuestion" alanı tek bir soruyu temsil edebilir. Örnek:
  {
    "text": "Aracın motorunu çalıştıran ...?",
    "options": ["A) ...", "B) ...", "C) ...", "D) ..."],
    "correctIndex": 1
  }
- Eğer focusedQuestion null ise, "examQuestions" dizisinde birden fazla soru olabilir.

ÖNEMLİ:
- Öğrencinin mesajında "bu soruyu çöz", "bu 1. soruyu çöz",
  "5. soruyu açıklar mısın", "az önceki soruyu anlat" gibi ifadeler varsa
  ve JSON içinde bir soru varsa, O SORUYU baz al.
    - Soru metnini kendi cümlelerinle kısaca özetle.
    - Sonra mutlaka şu başlıkları kullan:

Cevap:
Doğru Şık: (örneğin "C) Antifrizli su")

Açıklama:
Kısa ama net 2-4 cümle ile doğru şıkkın mantığını açıkla.

Şıkların Değerlendirilmesi:
A) ... (neden yanlış)
B) ... (neden yanlış)
C) ... (neden doğru)
D) ... (neden yanlış)

- Bu başlıkları (Cevap:, Açıklama:, Şıkların Değerlendirilmesi:) aynen koru.
- Ekstra markdown işareti kullanma.

- Eğer genel bir trafik / ilk yardım / motor / sınav sorusu ise,
  konuyu ehliyet sınavı seviyesinde örneklerle açıkla, ama yine kısa başlıklar ve
  kısa paragraflar kullan. Gereksiz yere uzatma.

FORMAT KURALLARI (ÇOK ÖNEMLİ):
- Kesinlikle MARKDOWN kullanma. Yani **, *, -, •, # gibi işaretler YAZMA.
- Yalnızca düz metin, satır başı ve gerektiğinde tek boş satır kullan.
- Madde göstermek istersen "1)", "2)" veya "A)" gibi klasik metin kullan.
- Özellikle "**" karakteri hiç geçmesin.

HER ZAMAN TÜRKÇE cevap ver.
Cevapların:
- Sorulmuş bir sınav sorusunu açıklıyorsan detaylı ve öğretici,
- Genel açıklama sorularında ise gereksiz uzatmadan, net ve anlaşılır olsun.

ÖĞRENCİNİN SORUSU:
"${question}"
`;

  let answer;

  try {
    const aiText = await safeCallGemini(
      GEMINI_MODEL_NAME,
      prompt,
      "trafficCoachChat"
    );

    if (aiText && aiText.trim()) {
      // UI/UX için cevabı sadeleştir
      answer = normalizeAnswerText(aiText.trim());
    } else {
      logger.warn(
        "Gemini yanıtı boş, teknik fallback kullanılıyor (trafficCoachChat)."
      );
      answer =
        "Şu anda teknik bir sorun yaşadım, lütfen sorunu birkaç dakika sonra tekrar dener misin?";
    }
  } catch (err) {
    logger.error("trafficCoachChat içinde beklenmeyen hata:", err);
    answer =
      "Şu anda teknik bir sorun yaşadım, lütfen sorunu birkaç dakika sonra tekrar dener misin?";
  }

  res.status(200).json({ answer });
});
