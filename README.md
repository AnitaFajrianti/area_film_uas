# MovieHub - Professional Movie Streaming App

MovieHub adalah aplikasi streaming film modern yang dibangun dengan Flutter, mengintegrasikan The Movie Database (TMDB) API untuk menyediakan pengalaman menonton yang komprehensif dan user-friendly.

## 🎬 Fitur Utama

### 1. **Home Screen - Jelajahi Film**
- **Kategori Film**: Pilih antara Now Playing, Popular, Top Rated, dan Upcoming movies
- **Hero Section**: Tampilan utama dengan film pilihan, rating, dan tombol play
- **Movie Cards**: Grid horizontal dengan poster, judul, dan rating
- **Search Integration**: Navigasi cepat ke search screen

### 2. **Search Screen - Cari Film**
- **Real-time Search**: Pencarian otomatis menggunakan TMDB API
- **Hasil Terperinci**: Tampilkan poster, judul, rating, tahun rilis, dan sinopsis
- **Empty States**: UI yang jelas untuk kondisi tanpa hasil pencarian
- **Error Handling**: Pesan error informatif jika pencarian gagal

### 3. **Detail Screen - Informasi Lengkap**
- **Backdrop Image**: Gambar latar belakang film beresolusi tinggi
- **Informasi Film**: Judul, tahun rilis, rating, sinopsis
- **Cast List**: Daftar aktor dengan foto profil dan karakter (horizontal scrollable)
- **Trailer**: Tombol play trailer yang terhubung ke YouTube
- **Watchlist Button**: Tombol untuk menambahkan/menghapus dari watchlist

### 4. **Watchlist Screen - Koleksi Pribadi**
- **Local Storage**: Simpan film menggunakan Hive (database lokal)
- **Persistent**: Film tersimpan bahkan setelah aplikasi ditutup
- **Quick Actions**: Hapus film dari watchlist dengan sekali klik
- **Empty State**: Pesan yang jelas saat watchlist kosong

### 5. **Profile Screen - Profil Pengguna**
- **User Stats**: Menampilkan jumlah film di watchlist
- **Settings Menu**: Akses ke berbagai pengaturan
- **About**: Informasi lengkap tentang aplikasi
- **App Version**: Nomor versi aplikasi (v1.0.0)

### 6. **Navigation**
- **Bottom Navigation Bar**: 4 menu utama (Home, Search, Watchlist, Profile)
- **Drawer Menu**: Akses cepat ke semua halaman
- **AppBar**: Header dengan ikon notifikasi dan profile

## 🎨 Design System

### Color Palette
- **Background**: `#0B1320` (Warna gelap utama)
- **Card**: `#1F2A40` (Warna kartu/elevasi)
- **Primary**: `#5A40A3` (Ungu - aksen utama)
- **Secondary**: `#2F80ED` (Biru - aksen sekunder)
- **Accent**: `#56CCF2` (Cyan - highlight)
- **CTA Orange**: `Colors.orange[600]` (Tombol call-to-action)

### Typography
- **Font Family**: Google Fonts - Poppins
- **Title**: 26px, Bold
- **Section Title**: 18px, Bold
- **Body**: 14px, Regular
- **Caption**: 12px, Regular

### Components
- **Border Radius**: 15px (cards), 20px (containers)
- **Shadows**: Subtle shadows untuk depth
- **Loading Animation**: Shimmer effects saat data loading

## 🔧 Teknologi & Dependencies

### Framework
- **Flutter**: ^3.0.0
- **Dart**: ^3.11.1

### API
- **TMDB API v3**: Sumber data film utama
- **Base URL**: `https://api.themoviedb.org/3`
- **API Key**: Tersimpan di `lib/services/api_service.dart`

### Packages
```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.5.0                          # HTTP client untuk API calls
  cached_network_image: ^3.4.1         # Image caching & optimization
  google_fonts: ^6.3.1                 # Typography
  url_launcher: ^6.3.0                 # Membuka link eksternal (YouTube)
  shimmer: ^3.0.0                      # Loading animation
  hive: ^2.2.3                         # Local database
  hive_flutter: ^1.1.0                 # Hive integration
  intl: ^0.19.0                        # Internationalization

dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^6.0.0
  hive_generator: ^2.0.1              # Code generation untuk Hive
  build_runner: ^2.4.6                # Build system
```

## 📁 Project Structure

```
lib/
├── main.dart                          # Entry point aplikasi
├── models/
│   ├── movie_model.dart              # Data model untuk film
│   └── cast_model.dart               # Data model untuk cast/crew
├── screens/
│   ├── home/
│   │   └── home_screen_new.dart     # Home screen dengan API integration
│   ├── search/
│   │   └── search_screen.dart       # Search functionality
│   ├── detail/
│   │   └── movie_detail_screen.dart # Detail view dengan cast & trailer
│   ├── watchlist/
│   │   └── watchlist_screen.dart    # Watchlist management
│   └── profile/
│       └── profile_screen.dart      # User profile & settings
├── services/
│   ├── api_service.dart             # TMDB API integration
│   └── watchlist_service.dart       # Local storage dengan Hive
├── widgets/
│   ├── movie_card.dart              # Movie card widget
│   ├── movie_list_tile.dart         # Movie list item widget
│   └── shimmer_widget.dart          # Loading placeholders
└── utils/
    └── constants.dart               # Colors, styles, utilities
```

## 🚀 Instalasi & Setup

### Prerequisites
- Flutter SDK (versi 3.0.0 atau lebih tinggi)
- Dart SDK (versi 3.11.1 atau lebih tinggi)
- TMDB API Key (gratis di https://www.themoviedb.org/settings/api)

### Langkah-langkah
1. Clone repository
2. Buka folder project: `cd area_film_uas`
3. Install dependencies: `flutter pub get`
4. Jalankan aplikasi: `flutter run`

### Konfigurasi API Key
1. Buka `lib/services/api_service.dart`
2. Update `_apiKey` dengan API key Anda dari TMDB

## 📱 Endpoints API yang Digunakan

| Endpoint | Deskripsi |
|----------|-----------|
| `/movie/now_playing` | Film yang sedang tayang |
| `/movie/popular` | Film populer |
| `/movie/top_rated` | Film terbaik |
| `/movie/upcoming` | Film akan datang |
| `/search/movie` | Cari film berdasarkan query |
| `/movie/{id}/credits` | Daftar cast & crew |
| `/movie/{id}/videos` | Video trailer |

## 🎯 UAS Requirements Met

✅ **4 Menu Utama**: Home, Search, Watchlist, Profile
✅ **Single API Source**: The Movie Database (TMDB) API
✅ **Responsive Design**: Bekerja di berbagai ukuran layar
✅ **Dark Theme**: Tema gelap yang konsisten
✅ **User-Friendly**: Interface yang intuitif dan menarik
✅ **Local Storage**: Watchlist tersimpan lokal dengan Hive
✅ **Error Handling**: Penanganan error yang baik
✅ **Loading States**: Shimmer effects saat loading
✅ **Navigation**: BottomNav + Drawer menu

## 📝 Fitur Tambahan

### Loading Effects
- **Shimmer Animation**: Placeholder visual saat data loading
- **Progress Indicator**: Circular loading indicator
- **Optimized Images**: Caching otomatis untuk performa

### Error Handling
- **Network Errors**: Pesan error yang user-friendly
- **Empty States**: UI yang jelas saat tidak ada data
- **Fallback UI**: Default images untuk data yang gagal load

### Performance
- **Image Caching**: Menggunakan CachedNetworkImage
- **Lazy Loading**: Data dimuat sesuai kebutuhan
- **Optimized Builds**: Release build untuk performa maksimal

## 🔐 Data Persistence

Film di watchlist disimpan menggunakan **Hive** - database lokal yang cepat:
- Otomatis menyimpan ketika menambah film
- Otomatis menghapus ketika menghapus film
- Tersimpan di device storage, bukan cloud
- Diakses secara instant tanpa API call

## 🎓 Educational Value

Aplikasi ini mendemonstrasikan:
- ✅ REST API integration dengan Flutter
- ✅ State management dan FutureBuilder
- ✅ Local database (Hive)
- ✅ Image caching dan optimization
- ✅ Responsive UI design
- ✅ Error handling & empty states
- ✅ Navigation patterns
- ✅ Production-ready code structure

## 📞 Support & Feedback

Untuk pertanyaan atau feedback, silakan hubungi developer atau buat issue di repository.

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License.

---

**MovieHub** - Bringing movies to your fingertips ✨

