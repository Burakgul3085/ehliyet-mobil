# Ehliyet Pratik AI

Bu proje, ehliyet sınavına hazırlanan sürücü adayları için tasarlanmış, yapay zeka destekli bir eğitim uygulamasıdır. Kullanıcıların sınav performanslarını analiz eder, kişiselleştirilmiş çalışma planları sunar ve trafik kuralları, ilk yardım, araç tekniği gibi konularda anlık sohbet desteği sağlar. Uygulama, Flutter ile geliştirilmiş bir mobil/web/masaüstü arayüze ve Firebase Cloud Functions üzerinde çalışan güçlü bir yapay zeka arka ucuna sahiptir.

## Proje Özeti

Ehliyet Pratik AI, ehliyet sınavına hazırlık sürecini modern teknolojiyle dönüştürmeyi hedefleyen kapsamlı bir çözümdür. Temel özellikleri şunlardır:

*   **Akıllı Sınav Analizi**: Kullanıcıların tamamladığı ehliyet deneme sınavlarının sonuçlarını (doğru/yanlış cevaplar, konu bazlı performans) derinlemesine analiz eder. Google Gemini AI entegrasyonu sayesinde her sınav sonrası kişiselleştirilmiş bir özet, güçlü ve zayıf yönlerini belirten iyileştirme önerileri ve motive edici geri bildirimler sunar. Bu, kullanıcıların öğrenme süreçlerini optimize etmelerine yardımcı olur.
*   **Yapay Zeka Destekli Trafik Koçu**: Kullanıcıların ehliyet sınavı, trafik kuralları, trafik işaretleri, ilk yardım ve araç tekniği konularındaki sorularını yanıtlayan interaktif bir chatbot görevi görür. Ayrıca, belirli tarihlerdeki veya kategorilerdeki sınav sorularını getirip ayrıntılı bir şekilde açıklayabilir, böylece kullanıcılar anında ve doğru bilgilere ulaşabilir.
*   **Kapsamlı Trafik İşaretleri Veritabanı**: Uygulama içerisinde Türk Karayolları Genel Müdürlüğü'nün trafik işaretlerini içeren güncel ve detaylı bir veri seti bulunur. Bu sayede kullanıcılar işaretlerin anlamlarını ve açıklamalarını kolayca öğrenebilir, görsel hafızalarını güçlendirebilirler.
*   **Çoklu Platform Desteği**: Google'ın UI araç kiti Flutter altyapısı sayesinde iOS, Android, Web, macOS ve Windows gibi farklı platformlarda tutarlı ve sorunsuz bir kullanıcı deneyimi sunar.

## Kullanılan Teknolojiler

Bu proje, modern ve ölçeklenebilir teknolojileri bir araya getirerek geliştirilmiştir:

*   **Frontend (Flutter/Dart)**:
    *   **Flutter**: Google'ın tek bir kod tabanından hızlı ve esnek mobil, web ve masaüstü uygulamaları geliştirmek için kullandığı UI araç kitidir.
    *   **Dart**: Flutter uygulamalarının temel programlama dilidir; performanslı ve modern bir dil yapısına sahiptir.
*   **Backend (Firebase Cloud Functions - Node.js)**:
    *   **Firebase Cloud Functions**: Sunucusuz bir mimari sağlayarak arka uç mantığını yönetir. Ölçeklenebilir, olay tabanlı işlevler sunar. (`Node.js 22` ortamında çalışır.)
    *   **Google Gemini API**: Yapay zeka destekli içerik üretimi ve analiz için ana motor görevi görür. Sınav analizlerinin ve interaktif sohbet yanıtlarının oluşturulmasında kullanılır. Özellikle `gemini-2.5-pro` modeli tercih edilmiştir.
    *   **Firebase Admin SDK**: Firebase hizmetleriyle (özellikle Firestore) Node.js ortamından güvenli ve yetkilendirilmiş etkileşimler sağlamak için kullanılır.
*   **Veritabanı**:
    *   **Google Cloud Firestore**: Sınav soruları, kullanıcı istatistikleri ve diğer dinamik verileri depolamak için kullanılan esnek, ölçeklenebilir NoSQL bulut veritabanıdır.
*   **Altyapı ve Dağıtım**:
    *   **Firebase**: Kimlik doğrulama, veritabanı, sunucusuz işlevler (Cloud Functions) ve hosting gibi birçok temel arka uç hizmetini tek bir platformda sunar, geliştirme ve dağıtım süreçlerini basitleştirir.

## Klasör Yapısı

Projenin temel klasör yapısı aşağıdaki gibidir:

```
.
├── README.md                                # Projenin ana açıklaması ve dökümantasyonu.
├── functions/                               # Firebase Cloud Functions (Backend) kaynak kodları.
│   ├── index.js                             # Ana Cloud Functions mantığı. analyzeExam ve trafficCoachChat fonksiyonlarını, Gemini API ve Firestore entegrasyonlarını içerir.
│   ├── package-lock.json                    # Functions bağımlılıklarının kesin sürümlerini kilitleyen dosya.
│   └── package.json                         # Functions için Node.js bağımlılıkları ve script'leri tanımlayan dosya (Node.js 22).
├── ios/                                     # Flutter iOS uygulamasına özel dosyalar.
│   └── Runner/
│       └── Assets.xcassets/                 # iOS uygulama ikonları ve açılış ekranı görselleri.
│           ├── AppIcon.appiconset/Contents.json # Uygulama ikon boyutları ve adlandırmaları.
│           ├── LaunchImage.imageset/Contents.json # Açılış ekranı görselleri boyutları ve adlandırmaları.
│           └── LaunchImage.imageset/README.md   # Açılış ekranı görselleri hakkında ek bilgi.
├── lib/                                     # Flutter uygulamasının Dart kaynak kodları (Frontend).
│   └── data/
│       └── traffic_signs.json               # Türk Karayolları Genel Müdürlüğü'nün trafik işaretlerini içeren statik veri dosyası.
├── macos/                                   # Flutter macOS uygulamasına özel dosyalar.
│   └── Runner/
│       └── Assets.xcassets/                 # macOS uygulama ikonları.
│           └── AppIcon.appiconset/Contents.json # Uygulama ikon boyutları ve adlandırmaları.
├── web/                                     # Flutter web uygulamasına özel dosyalar.
│   ├── index.html                           # Web uygulamasının ana HTML dosyası, Flutter uygulamasının başlatılmasını sağlar.
│   └── manifest.json                        # Web uygulama manifest dosyası, PWA (Progressive Web App) özelliklerini tanımlar.
└── windows/                                 # Flutter Windows uygulamasına özel dosyalar.
    └── runner/                              # Windows masaüstü uygulamasının C++ başlatma ve pencere yönetimi kodları.
        ├── flutter_window.cpp               # Flutter penceresinin oluşturulması ve yönetimi.
        ├── main.cpp                         # Windows uygulamasının ana giriş noktası.
        ├── utils.cpp                        # Komut satırı argümanları ve konsol yönetimi gibi yardımcı işlevler.
        └── win32_window.cpp                 # Temel Win32 penceresi oluşturma ve olay işleme mantığı.
```

## Kurulum ve Çalıştırma Adımları

Bu projeyi yerel ortamınızda kurmak ve çalıştırmak için aşağıdaki adımları takip edin:

### 1. Önkoşullar

*   **Flutter SDK**: [Flutter resmi web sitesinden](https://flutter.dev/docs/get-started/install) yükleyin.
*   **Firebase CLI**: `npm install -g firebase-tools` komutu ile yükleyin.
*   **Node.js ve npm**: Firebase Functions için gereklidir. `functions/package.json` dosyasında belirtildiği üzere **Node.js (sürüm 22)** veya üzeri bir sürümü [Node.js resmi web sitesinden](https://nodejs.org/en/download/) yükleyin.
*   **Git**: Projeyi klonlamak için gereklidir.
*   **Platform Spesifik Geliştirme Ortamları**:
    *   **iOS**: Xcode
    *   **Android**: Android Studio
    *   **Windows/macOS**: Platformun geliştirme araçları (örn. Visual Studio, Xcode)

### 2. Projeyi Klonlayın

```bash
git clone <proje-depo-adresi> # Buraya GitHub depo adresini yapıştırın
cd ehliyet-pratik-ai          # Klonladığınız depo klasörüne gidin
```

### 3. Firebase Projesi Kurulumu

1.  **Yeni Bir Firebase Projesi Oluşturun**: [Firebase Konsolu'na](https://console.firebase.google.com/) gidin ve yeni bir proje oluşturun. Projenizin kimliğini (Project ID) not alın.
2.  **Firebase CLI ile Giriş Yapın**:
    ```bash
    firebase login
    ```
3.  **Firebase Projesini Başlatın**: Proje kök dizininde aşağıdaki komutu çalıştırın ve `Functions` ile `Firestore` özelliklerini etkinleştirin:
    ```bash
    firebase init
    ```
    *   Sırasıyla `Functions` ve `Firestore` seçeneklerini seçtiğinizden emin olun.
    *   CLI size mevcut Firebase projenizi seçeceğiniz bir liste sunacaktır, burada adım 1'de oluşturduğunuz projenizi seçin.
    *   Gerekli dosya oluşturma sorularına onay verin (`functions` klasörü içinde `package.json` vs. varsa `N` diyebilirsiniz).
4.  **Firestore Veritabanını Ayarlayın**:
    *   Firebase Konsolu'nda Firestore'a gidin.
    *   `sorular` adında bir koleksiyon oluşturun. Cloud Functions backend'i, ehliyet sorularını bu koleksiyondan çeker. Her bir soru dokümanı şu alanları içermelidir:
        *   `yıl` (number)
        *   `ay` (string/number - örn: "Temmuz" veya 7)
        *   `gün` (number)
        *   `kategori` (string - örn: "Trafik ve Çevre Bilgisi")
        *   `soruMetni` (string)
        *   `secenekler` (array of strings, örn: `["Şık A", "Şık B"]`)
        *   `correctIndex` (number, doğru şıkkın 0 tabanlı indeksi)
    *   Bu koleksiyonu uygulamanın düzgün çalışması için örnek ehliyet sınavı verileriyle doldurmanız gerekecektir.

### 4. Google Gemini API Anahtarını Yapılandırın

Cloud Functions, Google Gemini API'ye erişmek için bir API anahtarı gerektirir. Bu anahtarı Firebase Functions yapılandırmasına eklemeniz gerekir:

1.  **Google AI Studio'dan API Anahtarı Edinin**: [Google AI Studio](https://aistudio.google.com/) adresine gidin ve yeni bir Gemini API anahtarı oluşturun.
2.  **API Anahtarını Firebase'e Ekleyin**: Proje kök dizininde aşağıdaki komutu çalıştırın:
    ```bash
    firebase functions:config:set gemini.key="YOUR_GEMINI_API_KEY"
    ```
    `YOUR_GEMINI_API_KEY` yerine kendi edindiğiniz anahtarı yapıştırın.

### 5. Firebase Cloud Functions'ı Dağıtın

1.  `functions` dizinine gidin:
    ```bash
    cd functions
    ```
2.  Node.js bağımlılıklarını yükleyin:
    ```bash
    npm install
    ```
3.  Fonksiyonları Firebase'e dağıtın:
    ```bash
    firebase deploy --only functions
    ```
    Bu işlem tamamlandığında `analyzeExam` ve `trafficCoachChat` adında iki adet HTTP tetiklemeli fonksiyonunuz Firebase üzerinde çalışır durumda olacaktır.

### 6. Flutter Uygulamasını Çalıştırma

Proje kök dizinine geri dönün:

```bash
cd ..
```

1.  Flutter bağımlılıklarını yükleyin:
    ```bash
    flutter pub get
    ```
2.  Uygulamayı tercih ettiğiniz platformda çalıştırın:

    *   **Web için**:
        ```bash
        flutter run -d web
        ```
    *   **Android için**: Bir Android emülatörü veya fiziksel cihaz bağlı olduğundan emin olun.
        ```bash
        flutter run -d android
        ```
    *   **iOS için**: Bir iOS simülatörü veya fiziksel cihaz bağlı olduğundan emin olun ve Xcode kurulumu yapın.
        ```bash
        flutter run -d ios
        ```
    *   **Windows için**:
        ```bash
        flutter run -d windows
        ```
    *   **macOS için**:
        ```bash
        flutter run -d macos
        ```

Uygulama başarıyla başlatıldığında, ehliyet sınavı hazırlık sürecinize yapay zeka destekli bir asistanla başlayabilirsiniz!