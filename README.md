# Ehliyet Pratik AI

Bu proje, ehliyet sınavına hazırlanan sürücü adayları için tasarlanmış, yapay zeka destekli bir eğitim uygulamasıdır. Kullanıcıların sınav performanslarını analiz eder, kişiselleştirilmiş çalışma planları sunar ve trafik kuralları, ilk yardım, araç tekniği gibi konularda anlık sohbet desteği sağlar. Uygulama, Flutter ile geliştirilmiş bir mobil/web/masaüstü arayüze ve Firebase Cloud Functions üzerinde çalışan güçlü bir yapay zeka arka ucuna sahiptir.

## Proje Özeti

Ehliyet Pratik AI, aşağıdaki temel özelliklere odaklanır:

*   **Akıllı Sınav Analizi**: Kullanıcıların tamamladığı ehliyet deneme sınavlarının sonuçlarını (doğru/yanlış cevaplar, konu bazlı performans) analiz ederek güçlü ve zayıf yönlerini belirler. Google Gemini AI entegrasyonu sayesinde kişiselleştirilmiş bir özet, iyileştirme önerileri ve motivasyonel geri bildirimler sunar.
*   **Yapay Zeka Destekli Trafik Koçu**: Kullanıcıların ehliyet sınavı, trafik kuralları, trafik işaretleri, ilk yardım ve araç tekniği konularındaki sorularını yanıtlayan interaktif bir chatbot sunar. Ayrıca belirli tarihlerdeki veya kategorilerdeki sınav sorularını getirip açıklayabilir.
*   **Kapsamlı Trafik İşaretleri Veritabanı**: Uygulama içerisinde Türk Karayolları Genel Müdürlüğü'nün trafik işaretlerini içeren bir veri seti bulunur. Bu sayede kullanıcılar işaretlerin anlamlarını ve açıklamalarını kolayca öğrenebilirler.
*   **Çoklu Platform Desteği**: Flutter altyapısı sayesinde iOS, Android, Web, macOS ve Windows platformlarında sorunsuz bir kullanıcı deneyimi sunar.

## Kullanılan Teknolojiler

Bu proje, modern ve ölçeklenebilir teknolojileri bir araya getirerek geliştirilmiştir:

*   **Frontend**:
    *   **Flutter**: Google'ın UI araç kiti ile hızlı ve esnek mobil, web ve masaüstü uygulamaları geliştirme.
    *   **Dart**: Flutter uygulamalarının temel programlama dili.
*   **Backend**:
    *   **Firebase Cloud Functions (Node.js)**: Sunucusuz mimari ile ölçeklenebilir arka uç mantığı sağlar.
    *   **Google Gemini API**: Yapay zeka destekli içerik üretimi ve analiz için kullanılır (sınav analizi ve sohbet).
    *   **Firebase Admin SDK**: Firestore veritabanı ve diğer Firebase servisleri ile etkileşim için kullanılır.
*   **Veritabanı**:
    *   **Google Cloud Firestore**: Sınav soruları ve uygulama istatistikleri gibi dinamik verileri depolamak için kullanılan NoSQL bulut veritabanı.
*   **Altyapı ve Dağıtım**:
    *   **Firebase**: Kimlik doğrulama, veritabanı, sunucusuz işlevler ve hosting gibi birçok hizmeti sunar.

## Klasör Yapısı

Projenin temel klasör yapısı aşağıdaki gibidir:

| Bölüm / klasör      | Kısa açıklama                                                      |
| :------------------ | :----------------------------------------------------------------- |
| `functions/`        | Firebase Cloud Functions için backend kodları ve bağımlılıklar.    |
| `ios/`              | Flutter iOS uygulamasının native proje dosyaları.                  |
| `lib/`              | Flutter uygulamasının Dart kaynak kodları ve statik verileri.      |
| `macos/`            | Flutter macOS uygulamasının native proje dosyaları.                |
| `web/`              | Flutter web uygulamasının build çıktıları ve yapılandırma dosyaları.|
| `windows/`          | Flutter Windows masaüstü uygulamasının native proje dosyaları.     |
| `README.md`         | Projenin genel açıklaması ve kurulum talimatları.                  |

<details><summary>Detaylı yapı</summary>
<ul>
    <li><code>functions/</code>:
        <ul>
            <li><code>index.js</code>: Ana Cloud Functions mantığı, AI ve Firestore entegrasyonu.</li>
            <li><code>package.json</code>: Functions için Node.js bağımlılıkları ve script'ler.</li>
            <li><code>package-lock.json</code>: Functions bağımlılıklarının kilit dosyası.</li>
        </ul>
    </li>
    <li><code>ios/</code>:
        <ul>
            <li><code>Runner/Assets.xcassets/</code>: Uygulama ikonları ve açılış ekranı görselleri.</li>
            <li>Diğer iOS platformuna özgü yapılandırma ve kod dosyaları.</li>
        </ul>
    </li>
    <li><code>lib/</code>:
        <ul>
            <li><code>data/traffic_signs.json</code>: Türk Karayolları Genel Müdürlüğü'nün trafik işaretleri veritabanı.</li>
            <li>Diğer Flutter uygulamasının Dart kaynak kodları (UI, iş mantığı vb.).</li>
        </ul>
    </li>
    <li><code>macos/</code>:
        <ul>
            <li><code>Runner/Assets.xcassets/</code>: macOS uygulama ikonları.</li>
            <li>Diğer macOS platformuna özgü yapılandırma ve kod dosyaları.</li>
        </ul>
    </li>
    <li><code>web/</code>:
        <ul>
            <li><code>index.html</code>: Web uygulamasının ana HTML dosyası.</li>
            <li><code>manifest.json</code>: Progresif Web Uygulaması (PWA) manifest dosyası.</li>
        </ul>
    </li>
    <li><code>windows/</code>:
        <ul>
            <li><code>runner/</code>: Windows masaüstü uygulamasının C++ başlatma ve pencere yönetimi kodları.</li>
            <li>Diğer Windows platformuna özgü yapılandırma ve kaynak dosyaları.</li>
        </ul>
    </li>
</ul>
</details>

## Kurulum ve Çalıştırma Adımları

Bu projeyi yerel ortamınızda kurmak ve çalıştırmak için aşağıdaki adımları takip edin:

### 1. Önkoşullar

*   **Flutter SDK**: [Flutter resmi web sitesinden](https://flutter.dev/docs/get-started/install) yükleyin.
*   **Firebase CLI**: `npm install -g firebase-tools` komutu ile yükleyin.
*   **Node.js ve npm**: Firebase Functions için gereklidir. [Node.js resmi web sitesinden](https://nodejs.org/en/download/) yükleyin.
*   **Git**: Projeyi klonlamak için gereklidir.

### 2. Projeyi Klonlayın

```bash
git clone <proje-depo-adresi>
cd ehliyet-pratik-ai # veya proje klasörünüzün adı
```

### 3. Firebase Projesi Kurulumu

1.  **Yeni Bir Firebase Projesi Oluşturun**: [Firebase Konsolu'na](https://console.firebase.google.com/) gidin ve yeni bir proje oluşturun.
2.  **Firebase CLI ile Giriş Yapın**:
    ```bash
    firebase login
    ```
3.  **Firebase Projesini Başlatın**: Proje kök dizininde aşağıdaki komutu çalıştırın ve Cloud Functions ile Firestore özelliklerini etkinleştirin:
    ```bash
    firebase init
    ```
    *   `Functions` ve `Firestore` seçeneklerini seçtiğinizden emin olun.
    *   Mevcut Firebase projenizi seçin.
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
    *   Bu koleksiyonu örnek verilerle doldurmanız gerekecektir.

### 4. Google Gemini API Anahtarını Yapılandırın

Cloud Functions, Google Gemini API'ye erişmek için bir API anahtarı gerektirir. Bu anahtarı Firebase Functions yapılandırmasına eklemeniz gerekir:

1.  **Google AI Studio'dan API Anahtarı Edinin**: [Google AI Studio](https://aistudio.google.com/) adresinden yeni bir Gemini API anahtarı oluşturun.
2.  **API Anahtarını Firebase'e Ekleyin**:
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
        flutter run
        ```
    *   **iOS için**: Bir iOS simülatörü veya fiziksel cihaz bağlı olduğundan emin olun ve Xcode kurulumu yapın.
        ```bash
        flutter run
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