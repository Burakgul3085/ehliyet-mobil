import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrafficSignsPage extends StatefulWidget {
  const TrafficSignsPage({super.key});

  @override
  State<TrafficSignsPage> createState() => _TrafficSignsPageState();
}

class _TrafficSignsPageState extends State<TrafficSignsPage> {
  List<TrafficSign> signs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrafficSigns();
  }

  Future<void> _loadTrafficSigns() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/data/traffic_signs.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      setState(() {
        signs = (jsonData['signs'] as List)
            .map((sign) => TrafficSign.fromJson(sign))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler yüklenirken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trafik İşaretleri'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : signs.isEmpty
              ? const Center(
                  child: Text(
                    'Trafik işaretleri yüklenemedi.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: signs.length,
                  itemBuilder: (context, index) {
                    final sign = signs[index];
                    return _buildSignItem(sign, isDark);
                  },
                ),
    );
  }


  Widget _buildSignItem(TrafficSign sign, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gerçek trafik işareti resmi
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  sign.image,
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Debug için hata mesajını yazdır
                    print('Resim yüklenemedi: ${sign.image}');
                    print('Hata: $error');
                    // Resim yüklenemezse varsayılan ikon göster
                    return Container(
                      color: Colors.red[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 20,
                          ),
                          Text(
                            'HATA',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.red[800],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sign.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                Text(
                  sign.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  softWrap: true,
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TrafficSign {
  final String id;
  final String name;
  final String description;
  final String image;

  TrafficSign({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory TrafficSign.fromJson(Map<String, dynamic> json) {
    return TrafficSign(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}
