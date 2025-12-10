import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteQuestionsPage extends StatefulWidget {
  const FavoriteQuestionsPage({super.key});

  @override
  State<FavoriteQuestionsPage> createState() => _FavoriteQuestionsPageState();
}

class _FavoriteQuestionsPageState extends State<FavoriteQuestionsPage> {
  List<String> _favoriteKeys = <String>[];
  bool _loading = true;
  int _index = 0;
  List<_FavQuestion> _questions = <_FavQuestion>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _questions = <_FavQuestion>[];
    });
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorite_questions') ?? <String>[];
    _favoriteKeys = List<String>.from(list);
    for (final favKey in _favoriteKeys) {
      final parts = favKey.split('-');
      if (parts.length < 4) continue;
      final yil = int.tryParse(parts[0].substring(1)) ?? 0;
      final ay = parts[1];
      final gun = int.tryParse(parts[2].substring(1)) ?? 0;
      final soruId = parts.sublist(3).join('-');

      final q = await FirebaseFirestore.instance
          .collection('sorular')
          .where('yıl', isEqualTo: yil)
          .where('ay', isEqualTo: ay)
          .where('gün', isEqualTo: gun)
          .where(FieldPath.documentId, isEqualTo: soruId)
          .limit(1)
          .get();
      if (q.docs.isNotEmpty) {
        _questions.add(
          _FavQuestion(
            yil: yil,
            ay: ay,
            gun: gun,
            soruId: soruId,
            data: q.docs.first.data(),
          ),
        );
      }
    }
    setState(() {
      _loading = false;
      if (_index >= _questions.length) _index = 0;
    });
  }

  Future<void> _removeCurrentFavorite() async {
    if (_questions.isEmpty) return;
    final favKey =
        'y${_questions[_index].yil}-${_questions[_index].ay}-g${_questions[_index].gun}-${_questions[_index].soruId}';
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorite_questions') ?? <String>[];
    list.remove(favKey);
    await prefs.setStringList('favorite_questions', list);
    await _load();
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
  }

  void _next() {
    if (_index < _questions.length - 1) setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Sorularım'),
        centerTitle: true,
        actions: [
          if (_questions.isNotEmpty)
            IconButton(
              tooltip: 'Favoriden kaldır',
              onPressed: _removeCurrentFavorite,
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
          ? const Center(child: Text('Henüz favori soru yok.'))
          : _buildQuestionView(
              context,
              _questions[_index],
              _index,
              _questions.length,
            ),
      bottomNavigationBar: _questions.isEmpty
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
                      onPressed: _index < _questions.length - 1 ? _next : null,
                      icon: const Icon(Icons.navigate_next),
                      label: const Text('Sonraki'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuestionView(
    BuildContext context,
    _FavQuestion fq,
    int idx,
    int total,
  ) {
    final d = fq.data;
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F766E)
                      : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${idx + 1}/$total',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (kategori.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2E2A57)
                        : const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    kategori,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFCAC4FF)
                          : const Color(0xFF4F46E5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                '${fq.gun} ${fq.ay} ${fq.yil}',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  soru,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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
            final bool isCorrect = i == cevapIndex;
            Color? tileColor;
            Color borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
            IconData? leadingIcon;
            if (isCorrect) {
              tileColor = Colors.green.withOpacity(0.12);
              borderColor = Colors.green;
              leadingIcon = Icons.check_circle;
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
                        ? Colors.green.withOpacity(0.15)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: leadingIcon != null
                          ? Colors.green
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
                title: _buildAnswerContent(cevaplar[i]),
                trailing: leadingIcon != null
                    ? Icon(leadingIcon, color: Colors.green)
                    : null,
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

  Widget _buildQuestionImages(List<dynamic> resimler) {
    final validResimler = resimler
        .where((url) => url.toString().isNotEmpty)
        .toList();
    if (validResimler.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: validResimler.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionVideo(String videoUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black12,
          alignment: Alignment.center,
          child: Text(
            'Video: $videoUrl',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _FavQuestion {
  final int yil;
  final String ay;
  final int gun;
  final String soruId;
  final Map<String, dynamic> data;
  _FavQuestion({
    required this.yil,
    required this.ay,
    required this.gun,
    required this.soruId,
    required this.data,
  });
}

// Removed dialog detail in favor of full-screen single-question view
