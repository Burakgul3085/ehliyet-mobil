import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuestionPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const DailyQuestionPage({super.key, required this.data});

  @override
  State<DailyQuestionPage> createState() => _DailyQuestionPageState();
}

class _DailyQuestionPageState extends State<DailyQuestionPage> {
  int? _selected;
  bool _locked = false;
  late final String _todayKey;

  @override
  void initState() {
    super.initState();
    _todayKey = DateTime.now().toIso8601String().substring(0, 10);
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedKey = prefs.getString('daily_q_key');
      if (savedKey == _todayKey) {
        final sel = prefs.getInt('daily_q_selected');
        final locked = prefs.getBool('daily_q_locked') ?? false;
        if (mounted) {
          setState(() {
            _selected = sel;
            _locked = locked;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('daily_q_key', _todayKey);
      if (_selected != null) await prefs.setInt('daily_q_selected', _selected!);
      await prefs.setBool('daily_q_locked', _locked);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final String soru = (widget.data['soru'] ?? '').toString();
    final List<dynamic> cevaplar =
        (widget.data['cevaplar'] ?? []) as List<dynamic>;
    final int cevapIndex = widget.data['cevap'] is int
        ? widget.data['cevap'] as int
        : int.tryParse('${widget.data['cevap']}') ?? -1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Günün Sınavı'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                soru,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(cevaplar.length, (i) {
              final bool isSelected = _selected == i;
              final bool isCorrect = i == cevapIndex;
              Color? tileColor;
              Color borderColor = isDark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!;
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
                tileColor = (isDark ? Colors.white : Colors.black).withOpacity(
                  0.06,
                );
              }

              final letter = String.fromCharCode('A'.codeUnitAt(0) + i);
              final String text = cevaplar[i] is Map<String, dynamic>
                  ? ((cevaplar[i] as Map<String, dynamic>)['metin'] ?? '')
                        .toString()
                  : cevaplar[i].toString();
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 2),
                      color: leadingIcon != null
                          ? (isCorrect ? Colors.green : Colors.red).withOpacity(
                              0.15,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: leadingIcon != null
                            ? (isCorrect ? Colors.green : Colors.red)
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                  title: Text(text),
                  onTap: () async {
                    if (_locked) return;
                    setState(() {
                      _selected = i;
                      _locked = true;
                    });
                    await _persist();
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
