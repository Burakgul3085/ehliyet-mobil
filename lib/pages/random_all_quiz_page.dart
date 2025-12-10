import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RandomAllQuizPage extends StatefulWidget {
  const RandomAllQuizPage({super.key});

  @override
  State<RandomAllQuizPage> createState() => _RandomAllQuizPageState();
}

class _RandomAllQuizPageState extends State<RandomAllQuizPage> {
  bool _loading = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _docs = [];
  int _index = 0;
  int? _selectedOption;
  bool _locked = false;

  late List<int?> _selectedOptionsByIndex;
  late List<bool> _lockedByIndex;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final q = await FirebaseFirestore.instance.collection('sorular').get();
    final all = q.docs;
    final rng = Random();
    final picked = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    final used = <int>{};
    final desired = min(15, all.length);
    while (picked.length < desired) {
      final i = rng.nextInt(all.length);
      if (!used.contains(i)) {
        used.add(i);
        picked.add(all[i]);
      }
    }
    _docs = picked;
    _selectedOptionsByIndex = List<int?>.filled(_docs.length, null);
    _lockedByIndex = List<bool>.filled(_docs.length, false);
    _index = 0;
    _selectedOption = null;
    _locked = false;
    setState(() => _loading = false);
  }

  void _next() {
    // Lock current question on next (allowing blanks)
    if (!_lockedByIndex[_index]) {
      _lockedByIndex[_index] = true;
    }
    if (_index < _docs.length - 1) {
      setState(() {
        _index++;
        _selectedOption = _selectedOptionsByIndex[_index];
        _locked = _lockedByIndex[_index];
      });
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _selectedOption = _selectedOptionsByIndex[_index];
        _locked = _lockedByIndex[_index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rastgele Sınav'), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _docs.isEmpty
          ? const Center(child: Text('Soru bulunamadı.'))
          : _buildBody(context),
      bottomNavigationBar: _docs.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.all(12),
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
                    child: _index < _docs.length - 1
                        ? ElevatedButton.icon(
                            onPressed: _next,
                            icon: const Icon(Icons.navigate_next),
                            label: const Text('Sonraki'),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              // Lock last question if not locked
                              if (!_lockedByIndex[_index]) {
                                setState(() {
                                  _lockedByIndex[_index] = true;
                                  _locked = true;
                                });
                              }
                              _showSummary();
                            },
                            icon: const Icon(Icons.checklist),
                            label: const Text('Özet Göster'),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final d = _docs[_index].data();
    final String soru = (d['soru'] ?? '').toString();
    final List<dynamic> cevaplar = (d['cevaplar'] ?? []) as List<dynamic>;
    final int cevapIndex = d['cevap'] is int
        ? d['cevap'] as int
        : int.tryParse('${d['cevap']}') ?? -1;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = _docs.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '(${_index + 1}/$total) Rastgele',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(cevaplar.length, (i) {
            final bool isSelected = _selectedOption == i;
            final bool isCorrect = i == cevapIndex;
            Color? tileColor;
            Color borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
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
                title: _buildAnswerContent(cevaplar[i]),
                onTap: () {
                  if (_locked) return;
                  setState(() {
                    _selectedOption = i;
                    _selectedOptionsByIndex[_index] = i;
                    _locked = true;
                    _lockedByIndex[_index] = true;
                  });
                },
              ),
            );
          }),
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
          ),
        ),
        if (resimUrl.isNotEmpty) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}


  void _showSummary() {
    int correct = 0;
    int wrong = 0;
    for (int i = 0; i < _docs.length; i++) {
      if (!_lockedByIndex[i]) continue;
      final d = _docs[i].data();
      final int answerIndex = d['cevap'] is int
          ? d['cevap'] as int
          : int.tryParse('${d['cevap']}') ?? -1;
      final sel = _selectedOptionsByIndex[i];
      if (sel == null) continue;
      if (sel == answerIndex) {
        correct++;
      } else {
        wrong++;
      }
    }

    final blanks = _docs.length - (correct + wrong);
    final int total = _docs.isEmpty ? 1 : _docs.length;
    final double success = correct / total;
    final bool isRisk = success < 0.70;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Text('Sınav Özeti'),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _stat('Doğru', correct, Colors.green),
                  _stat('Yanlış', wrong, Colors.red),
                  _stat('Boş', blanks, Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '%${(((correct) / (_docs.length == 0 ? 1 : _docs.length)) * 100).round()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
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

  Widget _stat(String label, int value, Color color) {
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
          Icon(
            label == 'Doğru'
                ? Icons.check_circle
                : label == 'Yanlış'
                ? Icons.cancel
                : Icons.help_outline,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
