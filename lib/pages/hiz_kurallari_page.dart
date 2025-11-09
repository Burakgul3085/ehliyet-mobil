import 'package:flutter/material.dart';

class HizKurallariPage extends StatelessWidget {
  const HizKurallariPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hız Kuralları',
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
            // Hız kuralları kartları
            Text(
              'Hız Sınırları',
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
              itemCount: _getVehicleTypes().length,
              itemBuilder: (context, index) {
                return _buildVehicleCard(_getVehicleTypes()[index], isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<VehicleType> _getVehicleTypes() {
    return [
      VehicleType(
        name: 'Otomobil',
        imagePath: 'lib/assests/vehicles/otomobil.png',
        citySpeed: '50',
        outsideSpeed: '90',
        dividedSpeed: '110',
        highwaySpeed: '130*',
        color: Colors.blue,
      ),
      VehicleType(
        name: 'Minibüs',
        imagePath: 'lib/assests/vehicles/minibüs.png',
        citySpeed: '50',
        outsideSpeed: '80',
        dividedSpeed: '90',
        highwaySpeed: '100',
        color: Colors.green,
      ),
      VehicleType(
        name: 'Otobüs',
        imagePath: 'lib/assests/vehicles/otobüs.png',
        citySpeed: '50',
        outsideSpeed: '80',
        dividedSpeed: '90',
        highwaySpeed: '100',
        color: Colors.orange,
      ),
      VehicleType(
        name: 'Kamyonet',
        imagePath: 'lib/assests/vehicles/kamyonet.png',
        citySpeed: '50',
        outsideSpeed: '80',
        dividedSpeed: '85',
        highwaySpeed: '95',
        color: Colors.purple,
      ),
      VehicleType(
        name: 'Kamyon/Çekici',
        imagePath: 'lib/assests/vehicles/kamyon.png',
        citySpeed: '50',
        outsideSpeed: '80',
        dividedSpeed: '85',
        highwaySpeed: '90',
        color: Colors.red,
      ),
      VehicleType(
        name: 'Motosiklet',
        imagePath: 'lib/assests/vehicles/motosiklet.png',
        citySpeed: '50',
        outsideSpeed: '80',
        dividedSpeed: '90',
        highwaySpeed: '100',
        color: Colors.teal,
      ),
      VehicleType(
        name: 'Motorlu Bisiklet',
        imagePath: 'lib/assests/vehicles/motorlu_bisiklet.png',
        citySpeed: '30',
        outsideSpeed: '45',
        dividedSpeed: '45',
        highwaySpeed: 'Giremez',
        color: Colors.brown,
      ),
      VehicleType(
        name: 'Motorsuz bisiklet',
        imagePath: 'lib/assests/vehicles/motorsuz_bisiklet.png',
        citySpeed: '30',
        outsideSpeed: '45',
        dividedSpeed: '45',
        highwaySpeed: 'Giremez',
        color: Colors.brown,
      ),
      VehicleType(
        name: 'Traktör',
        imagePath: 'lib/assests/vehicles/traktor.png',
        citySpeed: '20',
        outsideSpeed: '30',
        dividedSpeed: '40',
        highwaySpeed: 'Giremez',
        color: Colors.grey,
      ),
      VehicleType(
        name: 'İş Makinesi',
        imagePath: 'lib/assests/vehicles/is_makinesi.png',
        citySpeed: '20',
        outsideSpeed: '20',
        dividedSpeed: '20',
        highwaySpeed: 'İzin gerekli',
        color: Colors.grey,
      ),
    ];
  }

  Widget _buildVehicleCard(VehicleType vehicle, bool isDark) {
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
        child: Row(
          children: [
            // Araç resmi
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  vehicle.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: vehicle.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: vehicle.color,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Hız bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSpeedInfo('Şehir İçi', vehicle.citySpeed, isDark),
                  _buildSpeedInfo('Şehir Dışı', vehicle.outsideSpeed, isDark),
                  _buildSpeedInfo('Bölünmüş Yol', vehicle.dividedSpeed, isDark),
                  _buildSpeedInfo('Otoyol', vehicle.highwaySpeed, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedInfo(String label, String speed, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            speed,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleType {
  final String name;
  final String imagePath;
  final String citySpeed;
  final String outsideSpeed;
  final String dividedSpeed;
  final String highwaySpeed;
  final Color color;

  VehicleType({
    required this.name,
    required this.imagePath,
    required this.citySpeed,
    required this.outsideSpeed,
    required this.dividedSpeed,
    required this.highwaySpeed,
    required this.color,
  });
}
