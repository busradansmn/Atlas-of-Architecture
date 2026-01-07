# 🏛️ Mimarlık Uygulaması (Riverpod + Dio)

AI destekli mimarlık haberleri, makaleler ve soru-cevap platformu. **Riverpod** state management ve **Dio** HTTP client kullanılarak geliştirilmiştir.

## ✨ Özellikler

### 👤 Kullanıcı Özellikleri
- **🤖 AI Asistan (Gemini)**: Mimarlık hakkında sorular sorun, öneriler alın
- **📰 Güncel Haberler**: Mimarlık dünyasından en son haberler ve makaleler
- **🔖 Kaydetme**: İlginizi çeken makaleleri kaydedin
- **🏷️ Etiket Filtreleme**: İlgi alanlarınıza göre içerikleri filtreleyin
- **🔍 Arama**: Makalelerde arama yapın
- **👤 Profil Yönetimi**: Hesabınızı yönetin

### 🛡️ Admin Özellikleri
- **👥 Kullanıcı Yönetimi**: Kullanıcıları görüntüleyin ve yönetin
- **📝 İçerik Yönetimi**: Makale ekleyin, düzenleyin, silin
- **🔗 Kaynak Yönetimi**: Haber kaynaklarını ekleyin ve yönetin
- **📊 Admin Paneli**: Kapsamlı yönetim paneli

## 🛠️ Teknolojiler

- **Frontend**: Flutter 3.x, Dart
- **State Management**: **Riverpod 2.x** (Provider yerine)
- **HTTP Client**: **Dio 5.x** (http paketi yerine)
- **Backend**: Firebase
    - Authentication (Email/Password)
    - Firestore Database
    - Cloud Storage
- **AI**: Google Gemini API

## 📦 Kullanılan Paketler

```yaml
dependencies:
  # State Management - Riverpod
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # HTTP Client - Dio
  dio: ^5.4.0
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  
  # AI & Utils
  google_generative_ai: ^0.2.2
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1
  intl: ^0.19.0
  url_launcher: ^6.2.4

dev_dependencies:
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

## 📂 Proje Yapısı (Riverpod)

```
lib/
├── main.dart                    # ProviderScope ile sarmalanmış
├── models/                      # Data modelleri
│   └── article.dart
├── providers/                   # Riverpod Providers
│   ├── auth_provider.dart      # Auth state & service
│   ├── dio_provider.dart       # Dio instance
│   ├── gemini_provider.dart    # AI service
│   ├── news_provider.dart      # News service
│   └── firestore_provider.dart # Firestore service
└── screens/                     # ConsumerWidget/StatefulWidget
    ├── main_screen.dart
    ├── home/
    │   └── home_screen.dart
    ├── trends/
    │   └── trends_screen.dart
    ├── saved/
    │   └── saved_screen.dart
    ├── auth/
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── profile/
    │   └── profile_screen.dart
    └── admin/
        └── admin_panel.dart
```

## 🚀 Kurulum

### 1. Projeyi Oluşturun
```bash
flutter create mimarlik_uygulamasi
cd mimarlik_uygulamasi
```

### 2. Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### 3. Firebase Yapılandırması
- Firebase Console'da proje oluşturun
- `google-services.json` dosyasını `android/app/` klasörüne ekleyin
- Authentication ve Firestore'u etkinleştirin

### 4. Gemini API Key
`lib/providers/gemini_provider.dart` dosyasını açın:
```dart
const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

### 5. Uygulamayı Çalıştırın
```bash
flutter run
```

## 🎯 Riverpod vs Provider Farkları

### Provider (Eski):
```dart
// Provider ile
Provider.of<AuthService>(context)

// Context gerektiren widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    // ...
  }
}
```

### Riverpod (Yeni):
```dart
// Riverpod ile
ref.watch(authServiceProvider)
ref.read(authServiceProvider)

// ConsumerWidget kullanımı
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    // ...
  }
}
```

## 📊 Riverpod Provider Tipleri

### 1. **Provider** - Basit değerler
```dart
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});
```

### 2. **StateProvider** - Değiştirilebilir state
```dart
final searchQueryProvider = StateProvider<String>((ref) => '');

// Kullanımı:
ref.watch(searchQueryProvider); // Okuma
ref.read(searchQueryProvider.notifier).state = 'yeni değer'; // Yazma
```

### 3. **StreamProvider** - Stream veriler
```dart
final articlesStreamProvider = StreamProvider<List<Article>>((ref) {
  return firestore.collection('articles').snapshots();
});

// Kullanımı:
final articlesAsync = ref.watch(articlesStreamProvider);
articlesAsync.when(
  data: (articles) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Hata: $error'),
);
```

### 4. **FutureProvider** - Future veriler
```dart
final isAdminProvider = FutureProvider<bool>((ref) async {
  return await checkIsAdmin();
});
```

### 5. **StateNotifierProvider** - Kompleks state
```dart
final chatSessionProvider = StateNotifierProvider<ChatSessionNotifier, ChatSession?>((ref) {
  return ChatSessionNotifier();
});
```

## 🌐 Dio vs HTTP Farkları

### HTTP (Eski):
```dart
final response = await http.get(Uri.parse('https://example.com'));
if (response.statusCode == 200) {
  final data = json.decode(response.body);
}
```

### Dio (Yeni):
```dart
final response = await dio.get('https://example.com');
final data = response.data; // Otomatik JSON parse
```

### Dio Avantajları:
- ✅ Otomatik JSON serialization
- ✅ Interceptors (loglama, hata yönetimi)
- ✅ Request cancellation
- ✅ Timeout ayarları
- ✅ FormData desteği
- ✅ Daha temiz hata yönetimi

## 🔧 Önemli Notlar

### Riverpod Kullanım Kuralları:
1. **Widget'lar `Consumer` olmalı:**
    - `ConsumerWidget` (StatelessWidget yerine)
    - `ConsumerStatefulWidget` (StatefulWidget yerine)

2. **Provider'a erişim:**
    - `ref.watch()` - Widget rebuild olsun
    - `ref.read()` - Tek seferlik okuma
    - `ref.listen()` - Yan etki için dinle

3. **AsyncValue kullanımı:**
   ```dart
   articlesAsync.when(data: (articles) => ...,
     loading: () => ...,
     error: (error, stack) => ...,
   );
   ```

### Dio Kullanım Kuralları:
1. **Interceptor ile loglama:**
   ```dart
   dio.interceptors.add(LogInterceptor(
     requestBody: true,
     responseBody: true,
   ));
   ```

2. **Hata yönetimi:**
   ```dart
   try {
     await dio.get('/endpoint');
   } on DioException catch (e) {
     print('Dio hatası: ${e.message}');
   }
   ```

## 🎓 Örnek Kullanımlar

### State Okuma ve Güncelleme:
```dart
// Okuma
final searchQuery = ref.watch(searchQueryProvider);

// Güncelleme
ref.read(searchQueryProvider.notifier).state = 'yeni arama';
```

### Stream Dinleme:
```dart
final articlesAsync = ref.watch(articlesStreamProvider);

articlesAsync.when(
  data: (articles) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (error, _) => Text('Hata: $error'),
);
```

### Provider'ı Yenileme:
```dart
ref.invalidate(isArticleSavedProvider(articleId));
```

## 📝 Migration Notları

Provider'dan Riverpod'a geçiş yapıyorsanız:

1. `Provider.of<T>(context)` → `ref.watch(provider)`
2. `context.read<T>()` → `ref.read(provider)`
3. `ChangeNotifierProvider` → `StateNotifierProvider`
4. `StreamProvider.value()` → `StreamProvider()`

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun
3. Commit edin
4. Push edin
5. Pull Request açın

## 📄 Lisans

MIT Lisansı - Eğitim amaçlıdır.

---

**Geliştirme:** Riverpod + Dio ile modern Flutter uygulaması 🚀