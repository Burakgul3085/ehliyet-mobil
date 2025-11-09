import 'package:flutter/material.dart';

class PoliceIsaretleriPage extends StatelessWidget {
  const PoliceIsaretleriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Polis işaretleri listesi
    final policeSigns = [
      PoliceSign(
        name: 'Bir kırmızı fazda trafiğin çekilmesi işareti.',
        description:
            'Trafik polisi bu işaretle tüm araçların durmasını ve trafiğin çekilmesini sağlar. Kırmızı ışık yanıyorken bu işaret gösterilir.',
        imagePath: 'lib/assests/police/1.jpg',
        color: Colors.red,
      ),
      PoliceSign(
        name: 'Araç durdurma işareti sağa doğru.',
        description:
            'Polis bu işaretle sağ taraftaki araçların durmasını, sola giden araçların geçebileceğini belirtir.',
        imagePath: 'lib/assests/police/2.jpg',
        color: Colors.blue,
      ),
      PoliceSign(
        name: 'Araç durdurma işareti sola doğru.',
        description:
            'Bu işaretle polis sol taraftaki araçların durmasını, sağa giden araçların geçebileceğini gösterir.',
        imagePath: 'lib/assests/police/3.jpg',
        color: Colors.green,
      ),
      PoliceSign(
        name:
            'Ön ve arka taraftaki trafik duracak, her iki kol yönündeki trafik hareket edebilir.',
        description:
            'Bu işaretle polis karşılıklı yönlerdeki trafiği durdururken, yan yönlerdeki araçların geçişine izin verir.',
        imagePath: 'lib/assests/police/4.jpg',
        color: Colors.orange,
      ),
      PoliceSign(
        name:
            'Ön ve arka taraftaki trafik duracak, her iki kol yönündeki trafik hareket edebilir.',
        description:
            'Benzer şekilde bu işaret de karşılıklı trafiği durdurur, yan yönlere geçiş izni verir.',
        imagePath: 'lib/assests/police/5.jpg',
        color: Colors.purple,
      ),
      PoliceSign(
        name: 'Sağ taraftaki trafik sola gidebilir.',
        description:
            'Bu işaretle polis sağ taraftaki araçların sola dönüş yapabileceğini, diğer yönlerin durması gerektiğini belirtir.',
        imagePath: 'lib/assests/police/6.jpg',
        color: Colors.teal,
      ),
      PoliceSign(
        name: 'Sol taraftaki trafik sağa gidebilir.',
        description:
            'Polis bu işaretle sol taraftaki araçların sağa dönüş yapabileceğini, diğer yönlerin beklemesi gerektiğini gösterir.',
        imagePath: 'lib/assests/police/7.jpg',
        color: Colors.amber,
      ),
      PoliceSign(
        name: 'Trafiğin bütün istikametlere kapatılması - sağ kol.',
        description:
            'Bu işaretle polis tüm yönlerdeki trafiği durdurur. Sağ kolunu kullanarak bu işareti verir.',
        imagePath: 'lib/assests/police/8.jpg',
        color: Colors.cyan,
      ),
      PoliceSign(
        name: 'Trafiğin bütün istikametlere kapatılması - sol kol.',
        description:
            'Benzer şekilde tüm trafiği durdurur ancak bu sefer sol kolunu kullanarak işaret verir.',
        imagePath: 'lib/assests/police/9.jpg',
        color: Colors.indigo,
      ),
      PoliceSign(
        name: 'Trafiği hızlandırma hareketi - sol kol.',
        description:
            'Polis bu işaretle araçların hızlanmasını ve trafik akışının hızlanmasını sağlar.',
        imagePath: 'lib/assests/police/10.jpg',
        color: Colors.teal,
      ),
      PoliceSign(
        name: 'Trafiği yavaşlatma hareketi - sağ kol.',
        description:
            'Bu işaretle polis araçların yavaşlamasını ve daha kontrollü hareket etmesini sağlar.',
        imagePath: 'lib/assests/police/11.jpg',
        color: Colors.deepOrange,
      ),
      PoliceSign(
        name: 'Gece dönüş işareti.',
        description:
            'Karanlıkta veya görüşün kısıtlı olduğu durumlarda polis bu işaretle araçların dönüş yapabileceğini belirtir.',
        imagePath: 'lib/assests/police/12.jpg',
        color: Colors.deepPurple,
      ),
      PoliceSign(
        name: 'Gece geç işareti.',
        description:
            'Geceleri veya görüşün az olduğu durumlarda polis bu işaretle araçların geçebileceğini gösterir.',
        imagePath: 'lib/assests/police/13.jpg',
        color: Colors.lime,
      ),
      PoliceSign(
        name: 'Gece dur işareti.',
        description:
            'Karanlıkta veya görüşün kısıtlı olduğu durumlarda polis bu işaretle araçların durması gerektiğini belirtir.',
        imagePath: 'lib/assests/police/14.jpg',
        color: Colors.pink,
      ),
      PoliceSign(
        name: 'Yön tayini sağa işareti.',
        description:
            'Polis bu işaretle araçların sağa doğru yönlenmesini ve sağa dönüş yapmasını sağlar.',
        imagePath: 'lib/assests/police/15.jpg',
        color: Colors.brown,
      ),
      PoliceSign(
        name: 'Yön tayini sola işareti.',
        description:
            'Bu işaretle polis araçların sola doğru yönlenmesini ve sola dönüş yapmasını sağlar.',
        imagePath: 'lib/assests/police/16.jpg',
        color: Colors.grey,
      ),
      PoliceSign(
        name: 'Kırmızı ışıkta trafiği çekme işareti.',
        description:
            'Kırmızı ışık yanıyorken polis bu işaretle araçların çekilmesini ve trafiğin açılmasını sağlar.',
        imagePath: 'lib/assests/police/17.jpg',
        color: Colors.blueGrey,
      ),
      PoliceSign(
        name: 'Trafik akımını kesme işareti.',
        description:
            'Bu işaretle polis trafik akışını keser ve araçların durmasını sağlar. Genellikle acil durumlarda kullanılır.',
        imagePath: 'lib/assests/police/18.jpg',
        color: Colors.redAccent,
      ),
      PoliceSign(
        name: 'Trafik akımının trafik ışıklarına bırakılması işareti.',
        description:
            'Polis bu işaretle trafik kontrolünü tekrar trafik ışıklarına bırakır ve normal trafik akışına döner.',
        imagePath: 'lib/assests/police/19.jpg',
        color: Colors.greenAccent,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Polis İşaretleri',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFF5F5F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İşaretler listesi
            Text(
              'Polis İşaretleri',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: policeSigns.length,
              itemBuilder: (context, index) {
                return _buildPoliceSignCard(
                  context,
                  policeSigns[index],
                  isDark,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoliceSignCard(
    BuildContext context,
    PoliceSign sign,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tek resim
            Center(
              child: Container(
                width: 200,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    sign.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: sign.color.withOpacity(0.1),
                        child: Icon(
                          Icons.local_police,
                          color: sign.color,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (sign.name.isNotEmpty) ...[
              const SizedBox(height: 16),
              // Başlık
              Text(
                sign.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[100] : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
            ] else
              const SizedBox(height: 8),
            // Açıklama
            Text(
              sign.description,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[200] : Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PoliceSign {
  final String name;
  final String description;
  final String imagePath;
  final Color color;

  PoliceSign({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}
