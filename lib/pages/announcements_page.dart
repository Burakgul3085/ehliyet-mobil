import 'package:flutter/material.dart';

class AnnouncementsPage extends StatelessWidget {
  final String? initialText;

  const AnnouncementsPage({super.key, this.initialText});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Duyurular'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sınav İçin Öneriler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                initialText ??
                    'Merhaba, sadece soru çözerek hazırlanmak size kısa vadede fayda sağlasa da sınavda zorlanmanıza sebep olabilir. Ezberlemek yerine konuları anlayarak ilerlemek çok daha etkili olacaktır. Bunun için her gün 1-2 eğitim videosu izlemenizi öneriyorum. Videolara ana ekrandaki YouTube bölümünden kolayca ulaşabilirsiniz. Ayrıca günlük ortalama 250 soru çözerseniz, sınavı başarıyla geçmeniz çok daha garanti olur. Bu uygulama, sınava hazırlanmanız için ihtiyacınız olan tüm desteği sağlar',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F1F1F)
                      : const Color(0xFFF5FAFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : const Color(0xFFE3F2FD),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: isDark ? Colors.amber : Colors.amber[800],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kısa Özet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _bullet(
                      context,
                      'Konuyu anlaya anlaya ilerleyin, ezbere kaçmayın.',
                    ),
                    _bullet(context, 'Her gün 1-2 eğitim videosu izleyin.'),
                    _bullet(
                      context,
                      'Günlük ortalama 250 soru çözmeyi hedefleyin.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _bullet(BuildContext context, String text) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7),
          decoration: BoxDecoration(
            color: isDark ? Colors.amber : Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}
