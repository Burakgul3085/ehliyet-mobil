import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<_FAQItem> _items = [
    _FAQItem(
      question: "Ehliyet sınavı puanı nasıl hesaplanır?",
      answer:
          "Adayların sorulara verdikleri doğru cevap sayıları tespit edilerek 100 puan üzerinden hesaplama yapılır. Yanlış cevaplar netinizi düşürmez. Merkezi sistem sınavında her soru eşit puandadır. 100 üzerinden 70 ve üzeri puan alan adaylar başarılı sayılır.",
    ),
    _FAQItem(
      question: "Ehliyet sınav soru dağılımı nasıldır?",
      answer:
          "Trafik ve Çevre Bilgisi: 23 soru\nİlk Yardım Bilgisi: 12 soru\nAraç Tekniği (Motor ve Araç Bakımı): 9 soru\nTrafik Adabı: 6 soru",
    ),
    _FAQItem(
      question: "Ehliyet sınavında kaç soru var?",
      answer: "Ehliyet sınavında toplam 50 soru bulunmaktadır.",
    ),
    _FAQItem(
      question: "Ehliyet sınavında trafik dersinden kaç soru var?",
      answer:
          "Ehliyet sınavındaki soruların 27`si trafik dersinden sorulmaktadır.",
    ),
    _FAQItem(
      question: "Ehliyet sınavında ilk yardım bilgisinden kaç soru var?",
      answer:
          "Ehliyet sınavındaki soruların 13`ü ilk yardım bilgisi dersinden sorulmaktadır.",
    ),
    _FAQItem(
      question: "Ehliyet sınavında motordan kaç soru var?",
      answer:
          "Ehliyet sınavındaki soruların 10 tanesi araç tekniği (motor) dersinden sorulmaktadır.",
    ),
    _FAQItem(
      question: "Ehliyet sınavında 3 yanlış 1 doğruyu götürüyor mu?",
      answer:
          "Hayır. Ehliyet sınavında yanlış cevapladığınız sorular net sayınızı etkilemez.",
    ),
    _FAQItem(
      question: "Ehliyet sınavını geçebilmek için kaç puan almalıyım?",
      answer: "Her testten en az 70 puan almanız gerekir.",
    ),
    _FAQItem(
      question:
          "Ehliyet sınavını geçebilmek için kaç soruyu doğru yanıtlamalıyım?",
      answer: "Sınavı geçebilmek için en az 35 soruyu doğru yanıtlamalısınız.",
    ),
    _FAQItem(
      question: "Ehliyet teori (yazılı) sınavına kaç kez girme hakkı var?",
      answer:
          "Adaylar en fazla 4 yazılı ve 4 uygulama sınavına girme hakkına sahiptir.",
    ),
    _FAQItem(
      question: "Ehliyet direksiyon sınavına kaç kez girme hakkı var?",
      answer:
          "Direksiyon sınavına her sürücü adayının 4 kez girme hakkı vardır.",
    ),
    _FAQItem(
      question: "Sınav süresi toplam kaç saattir?",
      answer: "Toplam 60 dakikadır.",
    ),
    _FAQItem(
      question: "Sınavda toplam kaç soru sorulur?",
      answer: "Sınavda toplam 50 soru sorulur.",
    ),
    _FAQItem(
      question: "Sınav başarı puan barajı kaçtır?",
      answer: "Başarı barajı 100 üzerinden 70’dir.",
    ),
    _FAQItem(
      question:
          "Sınavda verdiğim yanlış cevaplar doğru cevaplarımı etkiler mi?",
      answer: "Etkilemez, yanlış doğruyu götürmüyor.",
    ),
    _FAQItem(
      question: "Ders saatlerinde ne kadar devamsızlık yapabilirim?",
      answer: "Mazeretsiz olarak toplam ders saatlerinin %20’si kadar.",
    ),
    _FAQItem(
      question:
          "Sürücü belgemi almadan sürücü sertifikasıyla araç kullanabilir miyim?",
      answer:
          "Hayır. Trafik Tescil Bürosuna başvurup sürücü belgenizi aldıktan sonra araç kullanabilirsiniz.",
    ),
    _FAQItem(
      question: "Sınavda başarısız olduğumda kaç defa sınava girme hakkım var?",
      answer:
          "Sınavdan başarısız olduktan sonra toplam 4 sınav hakkınız vardır (ilk + 3 tekrar).",
    ),
    _FAQItem(
      question: "Yazılı ve direksiyon sınavı nerede yapılıyor?",
      answer:
          "Sultanbeyli’deki sürücü kurslarının direksiyon sınavları, Sultanbeyli Eşref Bitlis Bulvarı üzerinde yapılmaktadır.",
    ),
    _FAQItem(
      question: "Sürücü olur raporu nerelerden alınabilir?",
      answer:
          "Devlet hastaneleri ve sürücü olur raporu vermeye yetkili özel hastanelerden alınabilir.",
    ),
    _FAQItem(
      question: "Sınav komisyon üyeleri kimlerden oluşur?",
      answer:
          "İlçe Milli Eğitim Müdürlüğünün belirlediği sınav yapma yeterliliği olan öğretmenlerden oluşur.",
    ),
    _FAQItem(
      question:
          "Sürücü sertifikamı aldıktan sonra ne kadar süre içinde Trafik Tescil Bürosuna başvurmalıyım? Süreyi kaçırırsam sertifikam iptal olur mu?",
      answer:
          "Sertifikalar alındığı tarihten itibaren 2 yıl geçerlidir. Sağlık raporu 1 yıl geçerlidir; süresi dolarsa yenisi dosyaya eklenir.",
    ),
    _FAQItem(
      question:
          "İlkokul mezunu olanlar hangi tarihe kadar sürücü belgesi için müracaat edebilir?",
      answer:
          "İlkokul mezunları sürücü belgesi alabilir; şu an için süre kısıtlaması yoktur.",
    ),
    _FAQItem(
      question: "Stajyer ehliyet nedir?",
      answer:
          "Sürücü, 2 yıl içinde 75 ceza puanına ulaşırsa ehliyetine el konur ve psikoteknik değerlendirmeye girer. Gerekli belgeler sonrası sürücü kursuna başvurup yeniden ehliyet alması gerekir.",
    ),
    _FAQItem(
      question: "2 yıl süre ile dikkat edilmesi gerekenler",
      answer:
          "2 yıl içinde 5 kez kırmızı ışık, 5 kez hız ihlali, alkollü/uyuşturucu etkisiyle araç kullanma, asli kusurlu ölümlü-yaralanmalı kaza ve 75 ceza puanı ihlallerinde belge iptal edilir. İhlal yoksa 1 yıl içinde başvurulursa belge verilir.",
    ),
    _FAQItem(
      question:
          "Ben bir sürücü kursuna kayıt oldum, sınavlara girdim başarısız oldum. Kurs değiştirebilir miyim?",
      answer:
          "Hayır. Sürücü kurslarında okullardaki gibi nakil işlemi bulunmamaktadır.",
    ),
    _FAQItem(
      question:
          "Sınavda toplam kaç soru sorulur? Her dersten kaç doğru bilmem gerekiyor?",
      answer: "Toplam 50 soru sorulur; 35 doğru geçer.",
    ),
    _FAQItem(
      question:
          "Ehliyet Sınavında verdiğim yanlış cevaplar doğru cevapları etkiler mi?",
      answer: "Etkilemez, yanlış doğruyu götürmez.",
    ),
    _FAQItem(
      question: "İlköğretim 6. sınıftan terk ettim ehliyet alabilir miyim?",
      answer:
          "Evet. İlköğretim 6., 7. ve 8. sınıflardan terk etmiş olanlar da ehliyet alabilmektedir.",
    ),
    _FAQItem(
      question: "Ehliyet sınavları ne kadar zamanda bir yapılmaktadır?",
      answer:
          "Genellikle ayda bir (istisnalar olabilir) MEB tarafından merkezi sınav sistemiyle Türkiye genelinde yapılır.",
    ),
    _FAQItem(
      question:
          "Ehliyet almaya hak kazandım, dosyamı aldım ama 1 sene geçti. Bir tanıdığım benim için ehliyeti alabilir mi? Ne yapmalıyım?",
      answer:
          "1 sene geçtiyse sağlık raporu ve adli sicil belgesini yenilemeniz gerekir. Başvuru şahsen yapılır; vekalet veya başkası aracılığıyla işlem yapılamaz.",
    ),
    _FAQItem(
      question: "Ehliyetimi kaybettim, kayıp ehliyet nasıl yeniden çıkarılır?",
      answer:
          "Gazeteye kayıp ilanı veya karakol tutanağı önerilir. İlgili Trafik Tescil Bürosuna 2 fotoğraf, nüfus cüzdanı aslı, form ve güncel ücretle başvurarak yenileyebilirsiniz. Başka şehirdeyseniz bulunduğunuz yerdeki Trafik Tescil’e başvurabilirsiniz.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sıkça Sorulan Sorular'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          final expanded = item.expanded;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => item.expanded = !item.expanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.question,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          Icon(
                            expanded ? Icons.remove : Icons.add,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (expanded) ...[
                    Divider(
                      height: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      child: Text(
                        item.answer,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FAQItem {
  final String question;
  final String answer;
  bool expanded = false;

  _FAQItem({required this.question, required this.answer});
}
