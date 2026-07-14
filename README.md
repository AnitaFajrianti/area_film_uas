# AREA FILM - Professional Movie Explorer App

AREA FILM adalah aplikasi penjelajah film modern yang dibangun dengan Flutter oleh afan production. Aplikasi ini mengintegrasikan The Movie Database (TMDB) API untuk menyediakan pengalaman mencari dan menjelajahi informasi film yang komprehensif serta user-friendly.

## Fitur Utama

1. Home Screen - Jelajahi Film
* Kategori Film: Pilih antara Now Playing, Popular, Top Rated, dan Upcoming movies
* Hero Section: Tampilan utama dengan banner film pilihan, rating, dan tombol play
* Movie Cards: Grid horizontal dengan poster, judul, dan rating film
* Kategori Tontonan: Pilihan filter dinamis (All, Movies, TV Shows, Trending)

2. Search Screen - Cari Film
* Real-time Search: Pencarian otomatis menggunakan TMDB API dengan mengetik kata kunci
* Top Search: Memuat daftar film populer secara default sebelum pengguna mengetik pencarian
* Hasil Terperinci: Tampilkan poster, judul, rating, tahun rilis, dan sinopsis lengkap
* Empty States: Tampilan UI yang jelas untuk kondisi jika hasil pencarian tidak ditemukan

3. Detail Screen - Informasi Lengkap
* Backdrop Image: Gambar latar belakang cuplikan film beresolusi tinggi
* Informasi Film: Menyajikan judul, tahun rilis, rating, dan sinopsis cerita film
* Trailer: Tombol play trailer yang terhubung langsung dan dapat diputar via YouTube
* Watchlist Button: Tombol interaktif untuk menambahkan atau menghapus film dari daftar favorit

4. Watchlist Screen - Koleksi Pribadi
* Local Storage: Simpan daftar film favorit secara lokal di penyimpanan perangkat HP
* Persistent: Film tetap tersimpan aman di perangkat bahkan setelah aplikasi ditutup
* Quick Actions: Menampilkan koleksi film yang kamu sukai dalam bentuk daftar ringkas
* Empty State: Pesan informasi yang jelas dan rapi saat watchlist masih kosong

5. Profile Screen & About Us
* Informasi Akun: Halaman khusus yang menampilkan profile pengguna dan informasi afan production
* Navigation ke About Us: Ketika menu navigasi utama diklik, aplikasi akan mengarahkan ke halaman About Us
* About Us Content: Berisi profil singkat startup afan production, visi pengembang, serta detail legalitas aplikasi

6. Navigation & Auth
* Authentication: Dilengkapi halaman Onboarding awal, halaman Login, dan halaman Signup akun baru
* Bottom Navigation Bar: Sistem navigasi bawah yang memuat 4 menu utama (Home, Search, Watchlist, Profile)
* Notification Screen: Halaman khusus untuk menampilkan daftar pemberitahuan atau notifikasi terbaru

## Design System

Color Palette
* Background: #0B1320 (Warna gelap utama)
* Card: #1F2A40 (Warna kartu/elevasi)
* Primary: #5A40A3 (Ungu - aksen utama)
* Secondary: #2F80ED (Biru - aksen sekunder)
* Accent: #56CCF2 (Cyan - highlight)
* CTA Orange: Colors.orange[600] (Tombol call-to-action)

Typography
* Font Family: Google Fonts - Poppins
* Title: 26px, Bold
* Section Title: 18px, Bold
* Body: 14px, Regular
* Caption: 12px, Regular

Components
* Border Radius: 15px (cards), 20px (containers)
* Shadows: Subtle shadows untuk depth visual yang estetis
* Loading Animation: Shimmer effects berupa efek bayangan abu-abu saat data dimuat

## Teknologi & Dependencies

Framework
* Flutter: ^3.41.4
* Dart: ^3.11.1

API
* TMDB API v3: Sumber data film utama
* Base URL: https://api.themoviedb.org/3
* API Key: Tersimpan aman di lib/services/api_service.dart

Packages
* dependencies:
  flutter: sdk: flutter
  http: ^1.5.0 (Client HTTP untuk request data API)
  cached_network_image: ^3.4.1 (Membaca dan mengoptimalkan cache gambar cover film)
  google_fonts: ^6.3.1 (Kustomisasi tipografi font Poppins)
  url_launcher: ^6.3.0 (Membuka link eksternal video YouTube)
  shimmer: ^3.0.0 (Membuat efek animasi loading sebelum data muncul)
  intl: ^0.19.0 (Mengatur format tanggal dan lokalisasi data)

## Project Structure

```text
area_film_uas/
├── android/ : Folder konfigurasi untuk sistem Android
├── assets/ : Folder untuk menyimpan aset gambar, ikon, atau font
├── ios/ : Folder konfigurasi untuk sistem iOS
├── lib/
│   ├── models/
│   │   └── movie_model.dart : Mengatur struktur data film dari API
│   ├── services/
│   │   ├── api_service.dart : Mengambil data dari server internet
│   │   └── watchlist_service.dart : Mengatur penyimpanan film favorit di HP
│   ├── utils/
│   │   └── constants.dart : Menyimpan setelan warna dan gambar
│   ├── widgets/
│   │   ├── movie_card.dart : Desain kartu tampilan film
│   │   └── shimmer_widget.dart : Efek loading bayangan sebelum data muncul
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart : Tampilan halaman masuk akun pengguna
│   │   │   ├── onboarding_screen.dart : Tampilan halaman pengenalan awal aplikasi
│   │   │   └── signup_screen.dart : Tampilan halaman pendaftaran akun baru
│   │   ├── detail/
│   │   │   ├── movie_detail_screen.dart : Detail lengkap cerita dan info film
│   │   │   └── see_all_screen.dart : Tampilan daftar film secara menyeluruh
│   │   ├── home/
│   │   │   └── home_screen_new.dart : Tampilan utama dan navigasi menu
│   │   ├── notification/
│   │   │   └── notification_screen.dart : Tampilan halaman notifikasi
│   │   ├── profile/
│   │   │   └── profile_screen.dart : Tampilan halaman profil pengguna
│   │   ├── search/
│   │   │   └── search_screen.dart : Tampilan halaman pencarian film
│   │   └── watchlist/
│   │       └── watchlist_screen.dart : Tampilan halaman film favorit
│   └── main.dart : Berkas utama untuk menjalankan aplikasi pertama kali
├── linux/ : Folder konfigurasi untuk sistem Linux
├── macos/ : Folder konfigurasi untuk sistem macOS
├── test/ : Folder untuk pengujian kode aplikasi
├── web/ : Folder konfigurasi untuk sistem Web
├── windows/ : Folder konfigurasi untuk sistem Windows
├── .gitignore : File untuk mengabaikan file tertentu saat diunggah ke GitHub
├── analysis_options.yaml : File aturan standarisasi penulisan kode Flutter
└── pubspec.yaml : File konfigurasi library, dependencies, dan aset aplikasi

## Instalasi & Setup

Prerequisites
* Flutter SDK (versi 3.0.0 atau lebih tinggi)
* Dart SDK (versi 3.11.1 atau lebih tinggi)
* TMDB API Key (gratis dari https://www.themoviedb.org/settings/api)

Langkah-langkah
1. Clone repository GitHub milik Anda
2. Buka folder project: cd area_film_uas
3. Install dependencies: flutter pub get
4. Jalankan aplikasi langsung di HP: flutter run

Konfigurasi API Key
1. Buka berkas lib/services/api_service.dart
2. Perbarui variabel API Key dengan key pribadi Anda dari TMDB

## Endpoints API yang Digunakan

* /movie/now_playing : Mengambil data film yang sedang tayang
* /movie/popular : Mengambil data film terpopuler saat ini
* /movie/top_rated : Mengambil data film dengan rating tertinggi
* /movie/upcoming : Mengambil data film yang akan segera datang
* /search/movie : Mencari judul film berdasarkan query input kata kunci
* /movie/{id}/videos : Mengambil data video trailer untuk diputar via YouTube

## UAS Requirements Met

* [x] 4 Menu Utama: Home, Search, Watchlist, Profile
* [x] Navigasi Tambahan: Navigation Bar ke Halaman About Us
* [x] Autentikasi: Halaman Onboarding, Login, dan Signup pengguna
* [x] Single API Source: The Movie Database (TMDB) API
* [x] Responsive Design: Antarmuka bekerja optimal di berbagai ukuran layar HP Android
* [x] Dark Theme: Penerapan warna tema gelap yang konsisten dan modern dari afan production
* [x] User-Friendly: Interface yang intuitif, bersih, rapi, dan menarik
* [x] Error Handling & Shimmer: Penanganan error yang baik dan efek animasi loading yang mulus