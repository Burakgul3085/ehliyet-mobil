import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RandomCategoryQuizPage extends StatefulWidget {
  final String title;
  final String kategori;
  final int questionCount;
  const RandomCategoryQuizPage({
    super.key,
    required this.title,
    required this.kategori,
    required this.questionCount,
  });

  @override
  State<RandomCategoryQuizPage> createState() => _RandomCategoryQuizPageState();
}

class _RandomCategoryQuizPageState extends State<RandomCategoryQuizPage> {
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
    final base = FirebaseFirestore.instance.collection('sorular');
    final q = await base.where('kategori', isEqualTo: widget.kategori).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> all = q.docs;

    if (all.isEmpty) {
      // Fallback: try common aliases for known categories
      final aliases = _kategoriAliases(widget.kategori);
      if (aliases.isNotEmpty) {
        try {
          final qa = await base.where('kategori', whereIn: aliases).get();
          all = qa.docs;
        } catch (_) {
          // whereIn may fail if aliases length > 10 or index not supported; try sequential
          for (final k in aliases) {
            if (all.isNotEmpty) break;
            final qi = await base.where('kategori', isEqualTo: k).get();
            if (qi.docs.isNotEmpty) {
              all = qi.docs;
              break;
            }
          }
        }
      }
    }
    final rng = Random();
    final picked = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    final used = <int>{};
    final desired = widget.questionCount.clamp(0, all.length);
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

  List<String> _kategoriAliases(String kategori) {
    final k = kategori.trim();
    if (k == 'Motor ve Araç Bakımı' ||
        k == 'Araç Teknik' ||
        k == 'Araç Tekniği (Motor ve Araç Bakımı)') {
      return [
        'Motor ve Araç Bakımı',
        'Araç Teknik',
        'Araç Tekniği (Motor ve Araç Bakımı)',
      ];
    }
    return [];
  }

  void _next() {
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
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _docs.isEmpty
          ? const Center(child: Text('Bu kategori için soru bulunamadı.'))
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
                    child: ElevatedButton.icon(
                      onPressed: _index < _docs.length - 1 ? _next : null,
                      icon: const Icon(Icons.navigate_next),
                      label: const Text('Sonraki'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '(${_index + 1}/$total) ${widget.kategori}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
              ),
              IconButton(
                tooltip: 'Yenile',
                onPressed: _load,
                icon: const Icon(Icons.shuffle),
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
                    _locked = true;
                    _selectedOptionsByIndex[_index] = i;
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                    return const Center(child: CircularProgressIndicator());
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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
    }
  }
}
