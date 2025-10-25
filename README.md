# BEKUP CREATE – Inscore App

Inscore App adalah aplikasi penilaian holistik untuk membantu UMKM membangun kredibilitas bisnis melalui metrik digital (seperti media sosial), sehingga dapat menjembatani akses ke pendanaan. Aplikasi ini dikembangkan dalam program BEKUP CREATE.

## Kelompok
- Nama Kelompok: B25-PG007
- Anggota:
  - BC25B017 — Ahmad Muqtafi
  - BC25B018 — Bintoro
  - BC25B069 — Muhammad Zulkifly Al Firdausy
  - BC25B072 — Farras Abdulaziz El-Fahd

## Deskripsi Aplikasi
Inscore mengumpulkan, memvisualisasikan, dan menilai performa digital bisnis (mis. Instagram/Facebook) menjadi skor yang mudah dipahami. Dengan pendekatan penilaian holistik, UMKM dapat menunjukkan kredibilitas non-fisik (jejak digital, engagement, jangkauan, dsb.) kepada pemberi dana. Alur aplikasi mencakup onboarding, autentikasi, penghubung akun sosial, pengambilan metrik, visualisasi data, skor harian/mingguan, dan leaderboard.

## Fitur Utama
- Onboarding interaktif untuk pengenalan konsep penilaian holistik.
- Autentikasi:
  - Registrasi, Login, Lupa Password (sheet), Logout.
  - Ganti kata sandi dari menu akun.
- Dashboard/Home:
  - Today Score, per-platform score, weekly comparison, trend chart mingguan.
  - Sapaan dan tanggal lokal (Indonesia).
- Leaderboard:
  - Peringkat harian dan mingguan, sortir skor tertinggi, avatar.
- Profil:
  - Lihat profil dan skor, kartu poin per platform (Instagram/Facebook).
  - Edit profil dan avatar (opsional).
- Integrasi Media Sosial:
  - Cek status koneksi, hubungkan/putuskan Instagram & Facebook.
  - Ambil metrik: followers, reach, engagement rate, engagement per post, reach ratio, dsb.
- Pengaturan:
  - Manajemen tema (light/dark via ThemeProvider), pengaturan lain.
  - Instruksi penghapusan akun (Delete Account).
- Dukungan multi-platform (Android, iOS, Web, Desktop) berbasis Flutter.

## Unduh Aplikasi
- Android (APK Release): https://github.com/AZulUye/Inscore-App/releases/download/v1.0.0/app-release.apk

## Panduan Penggunaan
- Dokumen panduan: https://docs.google.com/document/d/1WXQIEKAug-iAzK3mYjC7rSYDHO63mplrGIBQ3Wfybqg/edit?usp=sharing

## Teknologi
- Flutter, Dart
- State management: Provider
- Routing: GoRouter
- HTTP Client: Dio
- Penyimpanan aman: flutter_secure_storage
- Preferensi lokal: shared_preferences
- Utilities: url_launcher, connectivity_plus, intl, file_selector, fl_chart (untuk grafik)

## Konfigurasi API
- Base URL API terset di: [lib/core/constants.dart](lib/core/constants.dart)
  - Default: `https://inscore.fly.biz.id/api`
- Pastikan backend aktif dan kredensial/token valid untuk mengakses endpoint.

## Menjalankan Proyek (Developer)
Prasyarat:
- Flutter SDK dan Dart terpasang
- Java/Android SDK untuk build Android, Xcode untuk iOS (opsional sesuai target)

Langkah:
1. Install dependencies:
   - flutter pub get
2. Jalankan aplikasi (contoh Android):
   - flutter run
3. Build release (Android APK):
   - flutter build apk --release

Opsional platform lain (sesuaikan toolchain):
- Web: flutter run -d chrome atau flutter build web
- Windows: flutter build windows
- Linux: flutter build linux
- macOS: flutter build macos

## Struktur Proyek (ringkas)
- lib/
  - core/ (routes, theme, constants)
  - features/
    - auth/ (login, register, change password)
    - home/ (dashboard, widgets dan model home)
    - leaderboard/ (repository, model, UI leaderboard)
    - profile/ (repository, domain model/metrik, UI profil)
  - providers/ (AuthProvider, HomeProvider, LeaderboardProvider, SocialMediaProvider, dll.)
  - screens/ (splash, onboarding, settings, main, delete account)
  - shared/ (komponen bersama: app bar, loading, text)
  - utils/ (helper & formatter)

## Catatan
- Beberapa fitur membutuhkan koneksi dan otorisasi ke platform sosial yang relevan (Instagram/Facebook).
