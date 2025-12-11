import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/official_sources.dart';

class DisclaimerPage extends StatelessWidget {
  final bool isFirstLaunch;

  const DisclaimerPage({super.key, this.isFirstLaunch = false});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _onAccept(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disclaimer_accepted', true);
    if (isFirstLaunch && context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isFirstLaunch, // İlk açılışta geri dönüşü engelle
      child: Scaffold(
        appBar: isFirstLaunch
            ? null
            : AppBar(
                title: const Text('Sorumluluk Reddi ve Kaynaklar'),
                centerTitle: true,
              ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _section(
                context,
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.orange,
                title: 'ÖNEMLİ: Sorumluluk Reddi',
                content: [
                  const TextSpan(
                    text:
                        '⚠️ Pratik AI, Milli Eğitim Bakanlığı veya herhangi bir kamu kurumu tarafından geliştirilmemiştir. '
                        'Uygulama, resmi işlemleri gerçekleştirmez ve bir devlet kuruluşunu temsil etmez.\n\n',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Tüm içerik yalnızca eğitim/tekrar amaçlıdır ve sınav soruları, MEB tarafından kamuya açık olarak paylaşılan '
                        'e-Sınav kitapçıklarından derlenmiştir. Gerçek sınavlarda kullanılacak sorular MEB tarafından belirlenir.\n\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text:
                        'Güncel duyurular, başvuru süreçleri veya resmi mevzuat değişiklikleri için her zaman aşağıda listelenen '
                        'resmi kaynakları ziyaret ediniz.',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                context,
                icon: Icons.link,
                iconColor: Colors.blue,
                title: 'Referans Kaynaklar',
                content: [
                  const TextSpan(
                    text:
                        'Sorular, trafik işaretleri ve mevzuat açıklamaları aşağıdaki resmi ve kamuya açık kaynaklardan alınmaktadır:\n\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  WidgetSpan(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final source in officialSources) ...[
                          _buildLinkButton(
                            context,
                            source.title,
                            source.url,
                            source.icon,
                            description: source.description,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                context,
                icon: Icons.info_outline,
                iconColor: Colors.blueGrey,
                title: 'Önemli Uyarılar',
                content: [
                  const TextSpan(
                    text:
                        '• Güncel sınav tarihleri ve sonuçları için yukarıdaki yetkili web sitelerini kontrol ediniz.\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text:
                        '• Trafik kuralları ve mevzuat değişiklikleri için yetkili kaynakları takip ediniz.\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text:
                        '• Sınav başvuruları ve işlemler için mutlaka yetkili kurumlara başvurunuz.\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                context,
                icon: Icons.contact_support,
                iconColor: Colors.green,
                title: 'İletişim',
                content: [
                  const TextSpan(
                    text:
                        'Uygulama hakkında sorularınız, önerileriniz veya geri bildirimleriniz için:\n\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text: 'Instagram: @burakgul1006\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text: 'TikTok: @eyuphurkan44\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text: 'Telefon (Burak Gül): +90 542 658 85 30\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text: 'E-posta: burakgul3085@gmail.com\n',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const TextSpan(
                    text: 'Yazılım ve uygulama geliştirme desteği: ',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () => _launchUrl('https://www.linkedin.com/in/burakgul1006/'),
                      child: Text(
                        'https://www.linkedin.com/\n',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text:
                        '\nSınav kayıtları ve resmi işlemler için lütfen yetkili kurumlarla iletişime geçiniz.',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
              // İlk açılışta kabul butonu ekle
              if (isFirstLaunch) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _onAccept(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Kabul Ediyorum ve Devam Et',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<InlineSpan> content,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.08),
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
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              children: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String title,
    String url,
    IconData icon, {
    String? description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.blueGrey.withValues(alpha: 0.2)
              : Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? Colors.blueGrey.withValues(alpha: 0.3)
                : Colors.blue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDark ? Colors.blue : Colors.blue.shade700,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.blue.shade300
                          : Colors.blue.shade700,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark
                      ? Colors.blueGrey.shade100
                      : Colors.blueGrey.shade800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}