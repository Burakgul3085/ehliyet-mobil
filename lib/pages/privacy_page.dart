import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizlilik Şartları'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _section(
              context,
              icon: Icons.privacy_tip,
              title: 'Gizlilik Şartları',
              content:
                  'Ehliyet Soru Çözüm uygulaması, kullanıcıların deneyimini iyileştirmek ve temel işlevleri sağlamak amacıyla asgari düzeyde veri işler. ' 
                  'Toplanan veriler yalnızca uygulamanın çalışması, kullanıcı ilerlemesinin saklanması ve temel analizler için kullanılır. ' 
                  'Veriler, hukuka ve dürüstlük kurallarına uygun şekilde; amaçla sınırlı, ölçülü ve şeffaf biçimde işlenir.',
            ),
            const SizedBox(height: 12),
            _section(
              context,
              icon: Icons.storage_rounded,
              title: 'Verilerin Kullanımı',
              content:
                  'Uygulama; çözülen sorular, başarı yüzdesi ve tema tercihleri gibi yerel cihaz verilerini saklayabilir. ' 
                  'Bu bilgiler, profilinizde ilerleme göstermek ve kişiselleştirilmiş bir deneyim sunmak için kullanılır. ' 
                  'Herhangi bir kişisel veriniz, açık onayınız olmadan üçüncü taraflarla paylaşılmaz.',
            ),
            const SizedBox(height: 12),
            _section(
              context,
              icon: Icons.security_rounded,
              title: 'Veri Güvenliği',
              content:
                  'Veri güvenliği, tasarımın her aşamasında göz önünde bulundurulur. ' 
                  'Yerel depolanan bilgiler işletim sisteminin sağladığı güvenlik önlemleri ile korunur. ' 
                  'Harici servislere yönlendirmelerde (ör. YouTube) ilgili platformun gizlilik ve güvenlik ilkeleri geçerlidir.',
            ),
            const SizedBox(height: 12),
            _section(
              context,
              icon: Icons.balance,
              title: 'Kullanıcı Hakları',
              content:
                  'Kullanıcılar; verilerine erişme, düzeltme, silme ve işlenmesini kısıtlama haklarına sahiptir. ' 
                  'Uygulama içi profil bilgileriniz üzerinde tasarruf edebilirsiniz. ' 
                  'Gizlilikle ilgili sorularınız veya talepleriniz için bize uygulama içinden veya mağaza sayfasından ulaşabilirsiniz.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, {required IconData icon, required String title, required String content}) {
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
                  color: isDark ? Colors.blueGrey : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white),
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
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}


