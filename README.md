## Özet

Bu proje, kullanıcılara ehliyet sınavlarına hazırlanmaları için interaktif bir platform sunan bir mobil uygulamadır. Uygulama, trafik işaretleri, hız kuralları, polis işaretleri gibi çeşitli konularda bilgi ve pratik testler içerir. Firebase Cloud Functions ile desteklenen bu uygulama, kullanıcıların sınavlara daha etkili bir şekilde hazırlanmalarını sağlar.

## Teknolojiler

Bu proje aşağıdaki temel teknolojileri ve kütüphaneleri kullanmaktadır:

**Mobil Uygulama (Flutter):**
*   **Flutter:** Mobil uygulama geliştirmek için kullanılan UI toolkit.
*   **Dart:** Flutter'ın programlama dili.
*   **Provider:** Durum yönetimi için.
*   **Firebase Core & Cloud Firestore:** Gerçek zamanlı veritabanı ve Firebase hizmetleri entegrasyonu.
*   **url_launcher:** Uygulama içinden URL açmak için.
*   **shared_preferences:** Yerel veri depolama için.
*   **video_player & chewie:** Video oynatma özellikleri için.
*   **webview_flutter:** Uygulama içinde web içeriği göstermek için.
*   **share_plus:** İçerik paylaşımı için.
*   **animations:** Kullanıcı arayüzü animasyonları için.
*   **intl:** Uluslararasılaşma ve yerelleştirme için.

**Arka Uç (Firebase Cloud Functions):**
*   **Node.js 22:** Cloud Functions çalışma zamanı.
*   **Firebase Admin SDK:** Firebase hizmetleriyle sunucu tarafı etkileşimleri için.
*   **Firebase Functions:** Sunucusuz işlevler oluşturmak için.
*   **@google/generative-ai:** Google Generative AI hizmetleriyle entegrasyon için.

## Kurulum

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyin:

### Gereksinimler

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (Sürüm doğrulanmalı)
*   [Firebase CLI](https://firebase.google.com/docs/cli)
*   Node.js (Cloud Functions için)

### Kurulum Adımları

1.  **Depoyu Klonlayın:**
    ```bash
    git clone https://github.com/Burakgul3085/ehliyet-mobil.git
    cd ehliyet-mobil
    ```

2.  **Flutter Bağımlılıklarını Yükleyin:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Projesi Oluşturun ve Yapılandırın:**
    *   [Firebase Konsolu](https://console.firebase.google.com/) üzerinden yeni bir Firebase projesi oluşturun.
    *   Projeniz için Android ve iOS uygulamalarını kaydedin. Firebase yapılandırma dosyalarını (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) projenizin uygun dizinlerine (`android/app`, `ios/Runner`) yerleştirin.
    *   Firebase projeniz için Cloud Firestore'u etkinleştirin.
    *   `lib/firebase_options.dart` dosyasını kendi Firebase projenizin yapılandırmasına göre güncelleyin veya oluşturun.

4.  **Firebase Cloud Functions Kurulumu:**
    *   `functions` dizinine gidin:
        ```bash
        cd functions
        ```
    *   Node.js bağımlılıklarını yükleyin:
        ```bash
        npm install
        ```
    *   Cloud Functions'ı Firebase'e dağıtın (isteğe bağlı, geliştirme ortamında emülatörler kullanılabilir):
        ```bash
        firebase deploy --only functions
        ```
    *   Ana proje dizinine geri dönün:
        ```bash
        cd ..
        ```

5.  **Uygulamayı Çalıştırın:**
    *   Bir Android emülatör veya fiziksel cihaz bağlayın.
    *   Uygulamayı çalıştırın:
        ```bash
        flutter run
        ```

Bu adımlar projenin temel kurulumunu sağlamalıdır. Detaylı yapılandırma ve geliştirme için proje kodunu incelemeniz gerekebilir.

## Özellikler

Uygulama, ehliyet sınavlarına hazırlık sürecini desteklemek amacıyla zengin özellikler sunar:

*   **Kapsamlı Soru Bankası:** Günlük sorular, tüm sorular ve favorilere eklenen sorular ile geniş bir soru havuzu.
*   **Kategori Bazlı Testler:** Kullanıcıların belirli konulara odaklanmasını sağlayan kategoriye özel sınavlar.
*   **Trafik İşaretleri Bilgisi:** Detaylı görseller ve açıklamalarla trafik işaretleri kataloğu.
*   **Hız Kuralları Rehberi:** Farklı araç tipleri ve yol koşulları için hız limitleri hakkında bilgiler.
*   **Polis İşaretleri Eğitimi:** Polis tarafından kullanılan işaretlerin anlamları ve uygulama şekilleri.
*   **Kullanıcı Rehberliği:** Uygulama kullanımı ve ehliyet süreci hakkında yardımcı bilgiler içeren rehber sayfaları.
*   **Duyurular Bölümü:** Uygulama güncellemeleri, yeni özellikler ve önemli duyurular.
*   **Gizlilik Politikası ve Sorumluluk Reddi:** Yasal bilgilere kolay erişim.
*   **Sıkça Sorulan Sorular (SSS):** Kullanıcıların sıkça sorduğu sorulara yanıtlar.
*   **Video Ders Entegrasyonu:** Konuların daha iyi anlaşılması için video içerik desteği. (Video_player ve chewie paketleri kullanıldığı için bu özellik varsayılmıştır.)
*   **Sosyal Medya Entegrasyonu:** Uygulama içinden Instagram, TikTok gibi sosyal medya platformlarına erişim ve WhatsApp desteği.

## Katkı

Projeye katkıda bulunmak isterseniz, lütfen depoyu çatallayın (fork), değişikliklerinizi yapın ve bir Pull Request (Çekme İsteği) gönderin. Yeni özellik önerileri, hata düzeltmeleri veya dokümantasyon iyileştirmeleri memnuniyetle karşılanır.

## Lisans

Bu projenin lisans bilgisi şu an için açıkça belirtilmemiştir. Genellikle açık kaynak projeler için [MIT Lisansı](https://opensource.org/licenses/MIT) veya benzeri lisanslar kullanılır. Detaylı bilgi için proje sahibine danışılması veya gelecekte eklenecek bir `LICENSE` dosyası takip edilmesi önerilir.
