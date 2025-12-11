import 'package:flutter/material.dart';

/// Temel resmi kaynak bilgisini taşıyan model.
class OfficialSource {
  final String title;
  final String url;
  final String description;
  final IconData icon;

  const OfficialSource({
    required this.title,
    required this.url,
    required this.description,
    required this.icon,
  });
}

/// Uygulamada gösterilen ve verilerin alındığı kamuya açık kaynak listesi.
const List<OfficialSource> officialSources = [
  OfficialSource(
    title: 'MEB e-Sınav Portalı',
    url: 'https://esinavdeneme.meb.gov.tr/',
    description:
        'Deneme sınavları ve kitapçık arşivi. Sınav soruları buradaki kamuya açık PDF’lerden alınır.',
    icon: Icons.quiz_outlined,
  ),
  OfficialSource(
    title: 'MEB e-Sınav Harita',
    url: 'https://esinav.meb.gov.tr/harita',
    description: 'Sınav merkezleri ve güncel duyurular için resmi MEB portalı.',
    icon: Icons.map_outlined,
  ),
  OfficialSource(
    title: 'Milli Eğitim Bakanlığı (meb.gov.tr)',
    url: 'https://www.meb.gov.tr',
    description:
        'Resmi sınav duyuruları, yönetmelikler ve kamuya açık mevzuat bilgilendirmeleri.',
    icon: Icons.school_outlined,
  ),
  OfficialSource(
    title: 'Mevzuat Bilgi Sistemi',
    url: 'https://www.mevzuat.gov.tr',
    description:
        'Karayolları Trafik Kanunu ve sürücü yönetmeliklerinin güncel halleri.',
    icon: Icons.rule_folder_outlined,
  ),
  OfficialSource(
    title: 'İçişleri Bakanlığı / EGM',
    url: 'https://www.egm.gov.tr',
    description:
        'Trafik güvenliği kampanyaları, hız limitleri ve sürücü eğitim materyalleri.',
    icon: Icons.local_police_outlined,
  ),
];