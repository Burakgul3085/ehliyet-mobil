import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Firestore',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF111827),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF2563EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: const BorderSide(color: Color(0xFF2563EB)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const DatePickerPage(),
    );
  }
}

// 📅 Tarih Seçme Sayfası
class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime? _selectedDate;

  final _aylar = const [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Ağustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık",
  ];

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _goToQuestions() {
    if (_selectedDate == null) return;

    final yil = _selectedDate!.year;
    final ay = _aylar[_selectedDate!.month - 1];
    final gun = _selectedDate!.day;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizQuestionsPage(yil: yil, ay: ay, gun: gun),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Tarih Seç"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEF2FF),
              Color(0xFFE0F2FE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ehliyet Sınavı Çalışma',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tarihi seç ve o güne ait sınavı çöz.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDate == null
                                  ? "Henüz tarih seçilmedi"
                                  : DateFormat("d MMMM yyyy", "tr_TR")
                                      .format(_selectedDate!),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickDate,
                                icon: const Icon(Icons.date_range_outlined),
                                label: const Text("Tarih Seç"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    _selectedDate == null ? null : _goToQuestions,
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text("Sorulara Git"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Seçtiğin tarih, Firestore’daki "yıl / ay / gün" alanlarına göre filtrelenir.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ❓ Soru Listesi Sayfası
class QuizQuestionsPage extends StatefulWidget {
  final int yil;
  final String ay;
  final int gun;

  const QuizQuestionsPage({
    super.key,
    required this.yil,
    required this.ay,
    required this.gun,
  });

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  Query<Map<String, dynamic>> _query() {
    return FirebaseFirestore.instance
        .collection('sorular')
        .where('yıl', isEqualTo: widget.yil)
        .where('ay', isEqualTo: widget.ay)
        .where('gün', isEqualTo: widget.gun);
  }

  @override
  Widget build(BuildContext context) {
    final title =
        '${widget.gun} ${widget.ay} ${widget.yil} • Deneme Sınavı';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF1F5F9),
              Color(0xFFE0F2FE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _query().snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Bu tarihe ait soru bulunamadı.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            // Save exam total and last exam key for home progress
            () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                final examKey = 'y${widget.yil}-${widget.ay}-g${widget.gun}';
                await prefs.setInt('exam_total_' + examKey, docs.length);
                await prefs.setString('last_exam_key', examKey);
              } catch (_) {}
            }();

            return SafeArea(
              child: _QuestionFlow(
                docs: docs,
                yil: widget.yil,
                ay: widget.ay,
                gun: widget.gun,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuestionFlow extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final int yil;
  final String ay;
  final int gun;
  const _QuestionFlow({
    required this.docs,
    required this.yil,
    required this.ay,
    required this.gun,
  });

  @override
  State<_QuestionFlow> createState() => _QuestionFlowState();
}

class _QuestionFlowState extends State<_QuestionFlow> {
  int _index = 0;
  int? _selectedOption;
  bool _locked = false;
  int _correctCount = 0;
  int _wrongCount = 0;
  Duration _remaining = const Duration(minutes: 45);
  Timer? _timer;
  bool _isReviewMode = false;
  List<int> _reviewIndices = <int>[];

  // Persisted state per question
  late List<int?> _selectedOptionsByIndex;
  late List<bool> _lockedByIndex;
  String get _examKey => 'y${widget.yil}-${widget.ay}-g${widget.gun}';

  // 🔗 Yapay zekâ analiz fonksiyonu URL'i
  static const String _aiAnalyzeUrl =
      'https://analyzeexam-3l4xnlf4ba-uc.a.run.app';

  // 💬 Yapay zekâ sohbet (soru-cevap) fonksiyonu URL'i
  static const String _aiChatUrl =
      'https://trafficcoachchat-3l4xnlf4ba-uc.a.run.app';

  @override
  void initState() {
    super.initState();
    _selectedOptionsByIndex = List<int?>.filled(widget.docs.length, null);
    _lockedByIndex = List<bool>.filled(widget.docs.length, false);
    _restoreExamProgress();
    _restoreTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
        }
      });
      _saveTimer();
    });
  }

  Widget _buildMetaChips(String kategori) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color chipBg =
        isDark ? const Color(0xFF2E2A57) : const Color(0xFFEDE9FE);
    final Color chipBorder =
        isDark ? const Color(0xFF5B56A6) : const Color(0xFFDAD5FB);
    final Color chipText =
        isDark ? const Color(0xFFCAC4FF) : const Color(0xFF4F46E5);

    final List<Widget> chips = [];
    if (kategori.isNotEmpty) {
      chips.add(
        Chip(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          avatar: Icon(Icons.folder_open, size: 16, color: chipText),
          label: Text(
            kategori,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: chipText,
            ),
          ),
          backgroundColor: chipBg,
          shape: StadiumBorder(side: BorderSide(color: chipBorder)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
      );
    }

    chips.add(
      Chip(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        avatar: Icon(Icons.confirmation_number, size: 16, color: chipText),
        label: Text(
          'Soru ${_index + 1}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: chipText,
          ),
        ),
        backgroundColor:
            isDark ? const Color(0xFF0F766E) : const Color(0xFFD1FAE5),
        shape: StadiumBorder(
          side: BorderSide(
            color: isDark ? const Color(0xFF115E59) : const Color(0xFFA7F3D0),
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      ),
    );

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Future<void> _restoreExamProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList('answers_' + _examKey);
      if (savedList != null && savedList.length == widget.docs.length) {
        for (int i = 0; i < savedList.length; i++) {
          final v = int.tryParse(savedList[i]);
          if (v != null && v >= 0) {
            _selectedOptionsByIndex[i] = v;
            _lockedByIndex[i] = true;
          } else {
            _selectedOptionsByIndex[i] = null;
            _lockedByIndex[i] = false;
          }
        }

        int firstUnansweredIndex = 0;
        for (int i = 0; i < _lockedByIndex.length; i++) {
          if (!_lockedByIndex[i]) {
            firstUnansweredIndex = i;
            break;
          }
        }

        setState(() {
          _index = firstUnansweredIndex;
          _selectedOption = _selectedOptionsByIndex[_index];
          _locked = _lockedByIndex[_index];
          _recalculateStats();
        });
      } else {
        setState(() {
          _selectedOption = _selectedOptionsByIndex[_index];
          _locked = _lockedByIndex[_index];
        });
      }
    } catch (_) {}
  }

  Future<void> _restoreTimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final examStartTime = prefs.getInt('exam_start_time_' + _examKey);
      if (examStartTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final elapsed = (now - examStartTime) ~/ 1000;
        final totalSeconds = 45 * 60;
        final remainingSeconds = totalSeconds - elapsed;

        if (remainingSeconds > 0) {
          _remaining = Duration(seconds: remainingSeconds);
        } else {
          _remaining = Duration.zero;
        }
      } else {
        final now = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('exam_start_time_' + _examKey, now);
        _remaining = const Duration(minutes: 45);
      }
    } catch (_) {
      _remaining = const Duration(minutes: 45);
    }
  }

  Future<void> _saveTimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final examStartTime = prefs.getInt('exam_start_time_' + _examKey);
      if (examStartTime == null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('exam_start_time_' + _examKey, now);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _next() {
    if (_isReviewMode) {
      final pos = _reviewIndices.indexOf(_index);
      if (pos >= 0 && pos < _reviewIndices.length - 1) {
        setState(() {
          _index = _reviewIndices[pos + 1];
          _selectedOption = _selectedOptionsByIndex[_index];
          _locked = _lockedByIndex[_index];
        });
      }
    } else {
      if (_index < widget.docs.length - 1) {
        setState(() {
          _index++;
          _selectedOption = _selectedOptionsByIndex[_index];
          _locked = _lockedByIndex[_index];
        });
      }
    }
  }

  void _prev() {
    if (_isReviewMode) {
      final pos = _reviewIndices.indexOf(_index);
      if (pos > 0) {
        setState(() {
          _index = _reviewIndices[pos - 1];
          _selectedOption = _selectedOptionsByIndex[_index];
          _locked = _lockedByIndex[_index];
        });
      }
    } else {
      if (_index > 0) {
        setState(() {
          _index--;
          _selectedOption = _selectedOptionsByIndex[_index];
          _locked = _lockedByIndex[_index];
        });
      }
    }
  }

  void _recalculateStats() {
    int correct = 0;
    int wrong = 0;
    for (int i = 0; i < widget.docs.length; i++) {
      final d = widget.docs[i].data();
      final int answerIndex = d['cevap'] is int
          ? d['cevap'] as int
          : int.tryParse('${d['cevap']}') ?? -1;
      final sel = _selectedOptionsByIndex[i];
      final isLocked = _lockedByIndex[i];
      if (isLocked && sel != null) {
        if (sel == answerIndex) {
          correct++;
        } else {
          wrong++;
        }
      }
    }
    _correctCount = correct;
    _wrongCount = wrong;
  }

  Map<String, dynamic> _buildQuestionPayload(int i) {
    final d = widget.docs[i].data();
    final String soru = (d['soru'] ?? '').toString();
    final List<dynamic> cevaplar = (d['cevaplar'] ?? []) as List<dynamic>;
    final int cevapIndex = d['cevap'] is int
        ? d['cevap'] as int
        : int.tryParse('${d['cevap']}') ?? -1;
    final String kategori = (d['kategori'] ?? '').toString();

    String _optionText(dynamic cevap) {
      if (cevap is Map<String, dynamic>) {
        return (cevap['metin'] ?? '').toString();
      }
      return cevap.toString();
    }

    String _indexToLetter(int index) =>
        String.fromCharCode('A'.codeUnitAt(0) + index);

    final Map<String, String> options = {};
    for (int j = 0; j < cevaplar.length; j++) {
      options[_indexToLetter(j)] = _optionText(cevaplar[j]);
    }

    final sel = _selectedOptionsByIndex[i];
    final isLocked = _lockedByIndex[i];
    final String userAnswer =
        (isLocked && sel != null) ? _indexToLetter(sel) : '';
    final String correctAnswer =
        (cevapIndex >= 0 && cevapIndex < cevaplar.length)
            ? _indexToLetter(cevapIndex)
            : '';

    return {
      'text': soru,
      'options': options,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'topic': kategori,
    };
  }

  // 🔥 Gelişmiş Yapay Zekâ Analiz + Sohbet Fonksiyonu
  Future<void> _analyzeWithAI() async {
    _recalculateStats();

    final List<Map<String, dynamic>> questionsPayload = [];
    for (int i = 0; i < widget.docs.length; i++) {
      questionsPayload.add(_buildQuestionPayload(i));
    }

    // Loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        Uri.parse(_aiAnalyzeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'questions': questionsPayload,
          'totalCorrect': _correctCount,
          'totalWrong': _wrongCount,
        }),
      );

      Navigator.of(context).pop(); // loading kapat

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analiz alınamadı (HTTP ${response.statusCode}).'),
          ),
        );
        return;
      }

      Map<String, dynamic> data = jsonDecode(response.body);

      String summary = (data['summary'] ?? '').toString();
      List<String> strongTopics =
          (data['strongTopics'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
      List<String> weakTopics =
          (data['weakTopics'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
      List<String> studyPlan =
          (data['studyPlan'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
      String motivation = (data['motivation'] ?? '').toString();

      // Gerekirse ```json bloklarını temizle
      try {
        final cleaned =
            summary.replaceAll('```json', '').replaceAll('```', '').trim();
        if (cleaned.startsWith('{')) {
          final inner = jsonDecode(cleaned);
          summary = (inner['summary'] ?? summary).toString();
          strongTopics = (inner['strongTopics'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              strongTopics;
          weakTopics = (inner['weakTopics'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              weakTopics;
          studyPlan = (inner['studyPlan'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              studyPlan;
          motivation = (inner['motivation'] ?? motivation).toString();
        }
      } catch (_) {
        summary =
            summary.replaceAll('```json', '').replaceAll('```', '').trim();
      }

      final bool empty = summary.trim().isEmpty &&
          strongTopics.isEmpty &&
          weakTopics.isEmpty &&
          studyPlan.isEmpty &&
          motivation.trim().isEmpty;

      if (empty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Yapay Zekâ Analizi'),
            content: const Text('Analiz üretilemedi. Lütfen tekrar deneyin.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kapat'),
              ),
            ],
          ),
        );
        return;
      }

      List<Widget> buildBullets(String title, List<String> items) {
        if (items.isEmpty) return [];
        return [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 6),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 15)),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 15, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
        ];
      }

      // 💬 Sohbet için local state değişkenleri
      final TextEditingController questionController = TextEditingController();
      String? chatAnswer;
      bool sending = false;

      showDialog(
        context: context,
        builder: (dialogCtx) {
          return StatefulBuilder(
            builder: (dialogCtx, setDialogState) {
              final isDark =
                  Theme.of(context).brightness == Brightness.dark;
              return AlertDialog(
                backgroundColor: isDark
                    ? const Color(0xFF111827)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                title: const Text(
                  '📊 Yapay Zekâ Analizi',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (summary.trim().isNotEmpty) ...[
                        Text(
                          summary.trim(),
                          style: const TextStyle(fontSize: 15, height: 1.45),
                        ),
                        const SizedBox(height: 18),
                      ],
                      ...buildBullets('🟩 Güçlü Olduğun Konular', strongTopics),
                      ...buildBullets('🟥 Zayıf Olduğun Konular', weakTopics),
                      ...buildBullets('📘 Somut Çalışma Önerileri', studyPlan),
                      if (motivation.trim().isNotEmpty) ...[
                        const Text(
                          '✨ Motivasyon',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          motivation.trim(),
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Yapay zekâya soru sor',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: questionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Anlamadığın bir soruyu, konuyu veya çalışma planını sor...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: sending
                              ? null
                              : () async {
                                  final q =
                                      questionController.text.trim();
                                  if (q.isEmpty) return;

                                  setDialogState(() {
                                    sending = true;
                                    chatAnswer = null;
                                  });

                                  // Sohbet için de exam bağlamını gönder
                                  final chatQuestionsPayload =
                                      <Map<String, dynamic>>[];
                                  for (int i = 0;
                                      i < widget.docs.length;
                                      i++) {
                                    chatQuestionsPayload
                                        .add(_buildQuestionPayload(i));
                                  }

                                  try {
                                    final chatResponse = await http.post(
                                      Uri.parse(_aiChatUrl),
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                      body: jsonEncode({
                                        'question': q,
                                        'questions': chatQuestionsPayload,
                                        'totalCorrect': _correctCount,
                                        'totalWrong': _wrongCount,
                                      }),
                                    );

                                    if (chatResponse.statusCode == 200) {
                                      final dataChat =
                                          jsonDecode(chatResponse.body);
                                      final ans = (dataChat['answer'] ??
                                              chatResponse.body)
                                          .toString();
                                      setDialogState(() {
                                        chatAnswer = ans;
                                      });
                                    } else {
                                      setDialogState(() {
                                        chatAnswer =
                                            'Cevap alınamadı (HTTP ${chatResponse.statusCode}).';
                                      });
                                    }
                                  } catch (e) {
                                    setDialogState(() {
                                      chatAnswer = 'Bir hata oluştu: $e';
                                    });
                                  } finally {
                                    setDialogState(() {
                                      sending = false;
                                    });
                                  }
                                },
                          icon: sending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(
                            sending ? 'Gönderiliyor...' : 'Soruyu Gönder',
                          ),
                        ),
                      ),
                      if (chatAnswer != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chatAnswer!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogCtx).pop(),
                    child: const Text('Kapat'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      Navigator.of(context).pop(); // loading kapat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  int get _blankCount {
    final answered = _lockedByIndex.where((e) => e).length;
    return widget.docs.length - answered;
  }

  List<int> _collectWrongIndices() {
    final List<int> wrongs = <int>[];
    for (int i = 0; i < widget.docs.length; i++) {
      final d = widget.docs[i].data();
      final int answerIndex = d['cevap'] is int
          ? d['cevap'] as int
          : int.tryParse('${d['cevap']}') ?? -1;
      final sel = _selectedOptionsByIndex[i];
      final isLocked = _lockedByIndex[i];
      if (isLocked && sel != null && sel != answerIndex) {
        wrongs.add(i);
      }
    }
    return wrongs;
  }

  void _enterReviewWrong() {
    final wrongs = _collectWrongIndices();
    if (wrongs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yanlış soru yok.')),
      );
      return;
    }
    setState(() {
      _isReviewMode = true;
      _reviewIndices = wrongs;
      _index = wrongs.first;
      _selectedOption = _selectedOptionsByIndex[_index];
      _locked = _lockedByIndex[_index];
    });
  }

  void _exitReviewMode() {
    setState(() {
      _isReviewMode = false;
      _reviewIndices = <int>[];
    });
  }

  void _finishExam() {
    _recalculateStats();
    final total = widget.docs.length;
    final success = total > 0 ? _correctCount / total : 0.0;
    final isRisk = success < 0.70;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          title: Row(
            children: [
              const Text(
                'Sınav Özeti',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              if (isRisk)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Text(
                    'Riskli',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statChip(
                      Icons.check_circle,
                      'Doğru',
                      _correctCount,
                      Colors.green,
                    ),
                    _statChip(Icons.cancel, 'Yanlış', _wrongCount, Colors.red),
                    _statChip(
                      Icons.help_outline,
                      'Boş',
                      _blankCount,
                      Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '%${(success * 100).round()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _enterReviewWrong();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Yanlışları Gör ve Düzelt'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _analyzeWithAI();
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Yapay Zekâ ile Analiz Et'),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  Widget _statChip(IconData icon, String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Future<void> _recordSolvedIfNeeded(
    int questionIndex,
    int selectedIndex,
    int correctIndex,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final solved = prefs.getStringList('solved_questions') ?? <String>[];
      final d = widget.docs[questionIndex];
      final String soruId = d.id.toString();
      final key = _examKey + '-' + soruId;
      if (!solved.contains(key)) {
        solved.add(key);
        await prefs.setStringList('solved_questions', solved);
      }

      final answers = List<String>.generate(widget.docs.length, (i) {
        if (_lockedByIndex[i] && _selectedOptionsByIndex[i] != null) {
          return _selectedOptionsByIndex[i]!.toString();
        }
        return '-1';
      });
      await prefs.setStringList('answers_' + _examKey, answers);

      final solvedCount = _lockedByIndex.where((e) => e).length;
      await prefs.setInt('exam_solved_' + _examKey, solvedCount);

      if (solvedCount == widget.docs.length) {
        await prefs.remove('exam_start_time_' + _examKey);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.docs[_index].data();
    final String soru = (d['soru'] ?? '').toString();
    final List<dynamic> cevaplar = (d['cevaplar'] ?? []) as List<dynamic>;
    final int cevapIndex = d['cevap'] is int
        ? d['cevap'] as int
        : int.tryParse('${d['cevap']}') ?? -1;

    final List<dynamic> soruResimleri =
        (d['soru_resimleri'] ?? []) as List<dynamic>;
    final String soruVideosu = (d['soru_videosu'] ?? '').toString();
    final String kategori = (d['kategori'] ?? '').toString();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final total = widget.docs.length;
    final progress = (_index + 1) / total;
    String two(int n) => n.toString().padLeft(2, '0');
    final timerText =
        '${two(_remaining.inMinutes.remainder(60))}:${two(_remaining.inSeconds.remainder(60))}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.quiz_outlined,
                        size: 16,
                        color: Color(0xFF4B5563),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Soru ${_index + 1} / $total',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_correctCount',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$_wrongCount',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF111827),
                        Color(0xFF1F2937),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timerText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1F2933)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (Theme.of(context).brightness != Brightness.dark)
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildMetaChips(kategori)),
                            const SizedBox(width: 8),
                            _FavoriteButton(
                              docs: widget.docs,
                              index: _index,
                              examKey: _examKey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          soru,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                        if (soruResimleri.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildQuestionImages(soruResimleri),
                        ],
                        if (soruVideosu.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildQuestionVideo(soruVideosu),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(cevaplar.length, (i) {
                    final bool isSelected = _selectedOption == i;
                    final bool isCorrect = i == cevapIndex;
                    Color? tileColor;
                    Color borderColor =
                        isDark ? Colors.grey[700]! : Colors.grey[300]!;
                    IconData? leadingIcon;

                    if (_locked) {
                      if (isCorrect) {
                        tileColor = Colors.green.withOpacity(0.12);
                        borderColor = Colors.green;
                        leadingIcon = Icons.check_circle;
                      } else if (isSelected && !isCorrect) {
                        tileColor = Colors.red.withOpacity(0.12);
                        borderColor = Colors.red;
                        leadingIcon = Icons.cancel;
                      }
                    } else if (isSelected) {
                      tileColor = (isDark ? Colors.white : Colors.black)
                          .withOpacity(0.04);
                    }

                    final letter =
                        String.fromCharCode('A'.codeUnitAt(0) + i);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          if (!_locked && isSelected)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor, width: 2),
                            color: leadingIcon != null
                                ? (isCorrect ? Colors.green : Colors.red)
                                    .withOpacity(0.15)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: leadingIcon != null
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : (isDark
                                      ? Colors.white
                                      : Colors.black87),
                            ),
                          ),
                        ),
                        title: _buildAnswerContent(cevaplar[i]),
                        onTap: () async {
                          if (_locked && !_isReviewMode) return;
                          setState(() {
                            _selectedOption = i;
                            _locked = true;
                            _selectedOptionsByIndex[_index] = i;
                            _lockedByIndex[_index] = true;
                            _recalculateStats();
                          });
                          await _recordSolvedIfNeeded(_index, i, cevapIndex);
                          if (_isReviewMode) {
                            final d = widget.docs[_index].data();
                            final int correctIndex = d['cevap'] is int
                                ? d['cevap'] as int
                                : int.tryParse('${d['cevap']}') ?? -1;
                            if (_selectedOptionsByIndex[_index] ==
                                correctIndex) {
                              final pos =
                                  _reviewIndices.indexOf(_index);
                              if (pos != -1) {
                                _reviewIndices.removeAt(pos);
                                if (_reviewIndices.isEmpty) {
                                  _exitReviewMode();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Tüm yanlışlar düzeltildi.'),
                                    ),
                                  );
                                } else {
                                  if (pos < _reviewIndices.length) {
                                    _index = _reviewIndices[pos];
                                  } else {
                                    _index = _reviewIndices.last;
                                  }
                                  setState(() {
                                    _selectedOption =
                                        _selectedOptionsByIndex[_index];
                                    _locked = _lockedByIndex[_index];
                                  });
                                }
                              }
                            }
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(8, 4, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _index > 0 ? _prev : null,
                    icon: const Icon(Icons.navigate_before),
                    label: const Text('Önceki'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _finishExam,
                    child: const Text('Sınavı Bitir'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isReviewMode
                        ? (_reviewIndices.indexOf(_index) <
                                _reviewIndices.length - 1
                            ? _next
                            : null)
                        : (_index < widget.docs.length - 1 ? _next : null),
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('Sonraki'),
                  ),
                ),
              ],
            ),
          ),
          if (_isReviewMode)
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: TextButton.icon(
                  onPressed: _exitReviewMode,
                  icon: const Icon(Icons.list_alt_outlined),
                  label: const Text('Tüm Sorulara Dön'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerContent(dynamic cevap) {
    if (cevap is Map<String, dynamic>) {
      final String metin = cevap['metin'] ?? '';
      final String resimUrl = cevap['resim_url'] ?? '';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metin,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          if (resimUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 140,
                width: double.infinity,
                color: Colors.black12,
                alignment: Alignment.center,
                child: Image.network(
                  resimUrl,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      return Text(
        cevap.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      );
    }
  }

  Widget _buildQuestionImages(List<dynamic> resimler) {
    final validResimler =
        resimler.where((url) => url.toString().isNotEmpty).toList();

    if (validResimler.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Soru Resimleri:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: validResimler.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    validResimler[index].toString(),
                    height: 220,
                    width: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        height: 220,
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionVideo(String videoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Soru Videosu:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: QuestionVideoPlayer(url: videoUrl),
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final int index;
  final String examKey;
  const _FavoriteButton({
    required this.docs,
    required this.index,
    required this.examKey,
  });

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  @override
  void didUpdateWidget(_FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index ||
        oldWidget.examKey != widget.examKey) {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list =
          prefs.getStringList('favorite_questions') ?? <String>[];
      final soruId = widget.docs[widget.index].id.toString();
      final favKey = widget.examKey + '-' + soruId;
      if (mounted) {
        setState(() => _isFav = list.contains(favKey));
      }
    } catch (_) {}
  }

  Future<void> _toggle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list =
          prefs.getStringList('favorite_questions') ?? <String>[];
      final soruId = widget.docs[widget.index].id.toString();
      final favKey = widget.examKey + '-' + soruId;

      setState(() {
        if (list.contains(favKey)) {
          list.remove(favKey);
          _isFav = false;
        } else {
          list.add(favKey);
          _isFav = true;
        }
      });

      await prefs.setStringList('favorite_questions', list);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _isFav ? 'Favoriden çıkar' : 'Favorilere ekle',
      onPressed: _toggle,
      icon: Icon(
        _isFav ? Icons.favorite : Icons.favorite_border,
        color: _isFav
            ? Colors.red
            : (Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black45),
      ),
    );
  }
}

class QuestionVideoPlayer extends StatefulWidget {
  final String url;
  const QuestionVideoPlayer({super.key, required this.url});

  @override
  State<QuestionVideoPlayer> createState() => _QuestionVideoPlayerState();
}

class _QuestionVideoPlayerState extends State<QuestionVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _initTried = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (_initTried) return;
    _initTried = true;
    try {
      final videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      await videoController.initialize();
      final chewie = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
        allowMuting: true,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blueAccent,
          backgroundColor: Colors.black26,
          bufferedColor: Colors.white54,
        ),
      );
      if (!mounted) {
        await videoController.dispose();
        chewie.dispose();
        return;
      }
      setState(() {
        _controller = videoController;
        _chewieController = chewie;
      });
    } catch (_) {
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null || _controller == null) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    if (!_controller!.value.isInitialized) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    return Chewie(controller: _chewieController!);
  }
}
