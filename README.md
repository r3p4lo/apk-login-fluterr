# Aplikasi Form Login Flutter dengan Firebase

Repository ini berisi **kode sumber (source code) aplikasi Form Login Android yang dibuat menggunakan Flutter dan Dart**. README ini menjadi panduan belajar dari menyiapkan lingkungan Flutter, membuat proyek Firebase, menghubungkan aplikasi dengan Firebase, menguji autentikasi, sampai membangun file APK.

> **Penting untuk siswa:** Gunakan akun Google dan proyek Firebase milik sendiri. Jangan memakai akun, kredensial, atau database milik pembuat repository.
>
> **Catatan tentang fitur:** Panduan ini berfokus pada autentikasi email/password. Cloud Firestore dan REST API eksternal dijelaskan sebagai materi tambahan. Ikuti hanya bagian yang memang digunakan oleh source code aplikasi.

## Daftar Isi

1. [Gambaran Aplikasi](#1-gambaran-aplikasi)
2. [Teknologi yang Digunakan](#2-teknologi-yang-digunakan)
3. [Persiapan Perangkat](#3-persiapan-perangkat)
4. [Mengunduh Source Code](#4-mengunduh-source-code)
5. [Membuat Proyek Firebase](#5-membuat-proyek-firebase)
6. [Mendaftarkan Aplikasi Android ke Firebase](#6-mendaftarkan-aplikasi-android-ke-firebase)
7. [Mengaktifkan Firebase Authentication](#7-mengaktifkan-firebase-authentication)
8. [Menghubungkan Flutter ke Firebase dengan FlutterFire CLI](#8-menghubungkan-flutter-ke-firebase-dengan-flutterfire-cli)
9. [Menambahkan Cloud Firestore (Opsional)](#9-menambahkan-cloud-firestore-opsional)
10. [Memahami API Key dan Pengambilan Data API](#10-memahami-api-key-dan-pengambilan-data-api)
11. [Menjalankan dan Menguji Aplikasi](#11-menjalankan-dan-menguji-aplikasi)
12. [Membangun APK Android](#12-membangun-apk-android)
13. [Struktur Folder Flutter](#13-struktur-folder-flutter)
14. [Masalah yang Sering Terjadi](#14-masalah-yang-sering-terjadi)
15. [Referensi Resmi](#15-referensi-resmi)

---

## 1. Gambaran Aplikasi

Aplikasi Form Login adalah aplikasi Android sederhana untuk mempelajari proses autentikasi pengguna.

Alur fitur yang menjadi sasaran pembelajaran:

1. Pengguna membuka aplikasi.
2. Pengguna membuat akun dengan email dan password melalui halaman Register.
3. Firebase Authentication memproses pembuatan akun.
4. Pengguna login menggunakan email dan password.
5. Aplikasi memeriksa status autentikasi dan menampilkan halaman yang sesuai.
6. Pengguna dapat logout.

Firebase Authentication menyimpan dan mengelola akun autentikasi, termasuk UID pengguna. **Authentication bukan database umum untuk menyimpan seluruh data profil aplikasi.** Jika aplikasi perlu menyimpan nama lengkap, alamat, atau data profil lainnya, gunakan database seperti Cloud Firestore.

## 2. Teknologi yang Digunakan

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework untuk membangun aplikasi antarmuka Android. |
| Dart | Bahasa pemrograman Flutter. |
| Visual Studio Code | Editor kode. |
| Android Studio / Android SDK | Emulator, platform tools, dan perangkat build Android. |
| Firebase Authentication | Register, login, dan logout dengan email/password. |
| Cloud Firestore (opsional) | Menyimpan data tambahan pengguna. |
| FlutterFire CLI | Menghubungkan proyek Flutter dengan proyek Firebase. |
| Git dan GitHub | Menyimpan source code serta riwayat perubahan. |

## 3. Persiapan Perangkat

Gunakan Windows 10/11 atau sistem operasi lain yang didukung Flutter. Untuk mengikuti tutorial Android, siapkan:

- Flutter SDK dan Dart.
- Git.
- Visual Studio Code beserta ekstensi Flutter dan Dart.
- Android Studio dan Android SDK.
- Akun Google untuk Firebase.
- Koneksi internet.
- Node.js dan npm untuk memasang Firebase CLI melalui npm.

Periksa instalasi Flutter dan Git di PowerShell atau terminal VS Code:

```powershell
flutter --version
flutter doctor -v
git --version
node --version
npm --version
```

Selesaikan masalah yang ditunjukkan oleh `flutter doctor` untuk target Android sebelum melanjutkan.

## 4. Mengunduh Source Code

Buka PowerShell atau terminal VS Code, lalu jalankan:

```powershell
git clone https://github.com/USERNAME/aplikasi-form-login-flutter.git
cd aplikasi-form-login-flutter
flutter pub get
```

Ganti `USERNAME` dengan nama akun GitHub pemilik repository. Jika nama repository berbeda, sesuaikan URL dan nama foldernya.

`flutter pub get` mengunduh dependensi yang tercatat di `pubspec.yaml` dan `pubspec.lock`.

## 5. Membuat Proyek Firebase

Setiap siswa sebaiknya membuat proyek Firebase sendiri agar akun dan data latihan terpisah.

1. Buka [Firebase Console](https://console.firebase.google.com/).
2. Login menggunakan akun Google.
3. Pilih **Add project / Create a project**.
4. Masukkan nama proyek, misalnya `belajar-form-login-nama-kamu`.
5. Ikuti langkah pembuatan proyek. Google Analytics boleh diaktifkan atau dilewati sesuai kebutuhan latihan.
6. Setelah proyek dibuat, buka halaman ringkasan proyek Firebase.

Nama tampilan proyek tidak harus sama dengan nama folder Flutter. Firebase juga memiliki **Project ID** yang menjadi identitas unik proyek.

## 6. Mendaftarkan Aplikasi Android ke Firebase

1. Di Firebase Console, buka proyek yang baru dibuat.
2. Pilih ikon Android untuk menambahkan aplikasi Android.
3. Cari **Android package name** aplikasi Flutter.
   - Buka `android/app/build.gradle.kts` atau `android/app/build.gradle`.
   - Cari nilai `applicationId` di dalam `defaultConfig`.
   - Gunakan nilai tersebut secara persis saat mendaftarkan aplikasi. Jangan menebak atau menggantinya dengan nama folder proyek.
4. Isi nama aplikasi (opsional).
5. Untuk latihan email/password, SHA-1 biasanya tidak diperlukan. SHA-1/SHA-256 diperlukan untuk sejumlah metode integrasi tertentu, misalnya beberapa alur Google Sign-In atau Phone Authentication.
6. Klik **Register app** dan ikuti petunjuk Firebase.

> Jika `applicationId` diubah setelah aplikasi Android didaftarkan, konfigurasi Firebase harus disesuaikan dengan package name yang baru.

## 7. Mengaktifkan Firebase Authentication

1. Di Firebase Console, buka **Authentication**.
2. Pilih **Get started** jika diminta.
3. Buka tab **Sign-in method** atau **Sign-in providers**.
4. Pilih **Email/Password**.
5. Aktifkan provider Email/Password, lalu simpan.

Setelah aktif, aplikasi dapat menggunakan Firebase Authentication untuk membuat akun dan login. Secara umum, kode Flutter memakai metode berikut:

```dart
// Membuat akun
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Login
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Logout
await FirebaseAuth.instance.signOut();
```

Contoh di atas menjelaskan metode SDK; sesuaikan validasi, nama variabel, penanganan error, dan alur halaman dengan source code aplikasi.

ini untuk mengecek API database di firebase
https://docs.google.com/presentation/d/1bAAg7RhBfvWPjMRRYRW_EHDFEeiwKnxQ/edit?usp=drive_link&ouid=113530282555190240769&rtpof=true&sd=true

## 8. Menghubungkan Flutter ke Firebase dengan FlutterFire CLI

FlutterFire CLI membuat konfigurasi Firebase untuk platform yang dipilih. Jalankan perintah berikut.

### 8.1 Pasang Firebase CLI

Jika Node.js dan npm sudah terpasang:

```powershell
npm install -g firebase-tools
```

Periksa instalasi:

```powershell
firebase --version
```

### 8.2 Login ke Firebase

```powershell
firebase login
```

Browser akan terbuka untuk proses login. Gunakan akun Google yang memiliki akses ke proyek Firebase yang dibuat.

### 8.3 Pasang FlutterFire CLI

```powershell
dart pub global activate flutterfire_cli
```

Periksa:

```powershell
flutterfire --version
```

Jika PowerShell tidak mengenali `flutterfire`, tambahkan folder executable Pub Cache Dart ke PATH Windows. Lokasi yang umum adalah `%LOCALAPPDATA%\Pub\Cache\bin`. Setelah mengubah PATH, tutup dan buka kembali terminal.

### 8.4 Konfigurasikan proyek

Pastikan terminal berada di folder utama proyek Flutter (folder yang berisi `pubspec.yaml`), lalu jalankan:

```powershell
flutterfire configure
```

Pilih proyek Firebase milik sendiri dan platform **Android**. Pastikan package name Android cocok dengan yang didaftarkan di Firebase Console.

FlutterFire CLI akan menghasilkan file konfigurasi Dart, umumnya `lib/firebase_options.dart`, dan memperbarui konfigurasi platform yang diperlukan. File tersebut berisi identitas konfigurasi aplikasi Firebase, bukan kredensial Admin.

### 8.5 Pasang plugin Firebase

Untuk autentikasi email/password:

```powershell
flutter pub add firebase_core
flutter pub add firebase_auth
```

Setelah menambahkan produk Firebase atau mengubah platform, jalankan kembali konfigurasi jika diminta atau diperlukan:

```powershell
flutterfire configure
```

### 8.6 Inisialisasi Firebase di `main.dart`

Pastikan file `lib/main.dart` menginisialisasi Firebase sebelum menjalankan aplikasi. Pola dasarnya:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

Jika `main.dart` milik repository sudah memiliki inisialisasi Firebase, jangan menambahkan inisialisasi kedua. Sesuaikan import dan nama widget dengan kode yang tersedia.

## 9. Menambahkan Cloud Firestore (Opsional)

**Lewati bagian ini bila aplikasi hanya memakai Firebase Authentication dan tidak menyimpan data profil tambahan.**

### 9.1 Membuat database

1. Buka Firebase Console dan pilih proyek.
2. Masuk ke **Firestore Database**.
3. Pilih **Create database**.
4. Pilih lokasi database yang sesuai. Lokasi database tidak dapat diganti begitu saja setelah database dibuat.
5. Untuk pembelajaran, gunakan mode produksi agar aturan akses perlu ditentukan secara eksplisit.
6. Selesaikan pembuatan database.

### 9.2 Struktur data contoh

Untuk menyimpan profil, struktur sederhana yang bisa dipelajari adalah:

```text
users (collection)
  └── UID_PENGGUNA (document)
      ├── name: "Nama Siswa"
      ├── email: "siswa@example.com"
      └── createdAt: timestamp
```

Gunakan UID dari Firebase Authentication sebagai ID dokumen agar data profil terkait dengan akun yang benar.

### 9.3 Pasang plugin Firestore

Di folder utama proyek:

```powershell
flutter pub add cloud_firestore
flutterfire configure
```

Contoh menyimpan data profil setelah pengguna login atau register:

```dart
final user = FirebaseAuth.instance.currentUser;

if (user != null) {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set({
    'name': namaPengguna,
    'email': user.email,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

Contoh ini memerlukan import `firebase_auth` dan `cloud_firestore`. Terapkan hanya jika aplikasi memang mempunyai fitur penyimpanan profil.

### 9.4 Aturan keamanan dasar untuk koleksi `users`

Di tab **Rules** Firestore, aturan contoh berikut membatasi setiap pengguna agar hanya dapat membaca dan menulis dokumen dengan ID UID miliknya sendiri:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

Aturan ini hanya contoh awal untuk koleksi `users`. Jika struktur database atau kebutuhan aplikasi berubah, aturan harus ditinjau dan diuji kembali. Jangan membiarkan database produksi memakai aturan terbuka seperti `allow read, write: if true`.

## 10. Memahami API Key dan Pengambilan Data API

Ada dua hal berbeda yang sering disebut “mengambil API”.

### 10.1 API Key konfigurasi Firebase

Untuk aplikasi Flutter yang memakai plugin Firebase, umumnya siswa **tidak perlu menyalin API Key secara manual**. `flutterfire configure` menghasilkan `firebase_options.dart` yang berisi konfigurasi seperti API Key, App ID, dan Project ID.

API Key Firebase untuk aplikasi klien pada umumnya berfungsi mengidentifikasi proyek/aplikasi, bukan menjadi password database. Hak akses data tetap harus diamankan dengan Firebase Authentication, Firebase Security Rules, dan pengaturan keamanan lain yang sesuai. API Key untuk layanan lain (bukan Firebase) harus dibuat terpisah dan dibatasi sesuai API yang digunakan.

Jika ingin melihat konfigurasi aplikasi, buka Firebase Console → **Project settings** → **General** → **Your apps**. Jangan pernah mengunggah kredensial Admin atau private key.

### 10.2 Memanggil REST API eksternal (opsional)

Jika aplikasi perlu mengambil data dari server REST API di luar Firebase, gunakan paket `http` dan URL endpoint dari penyedia API. Contoh berikut hanya pola umum; ganti URL dan struktur JSON sesuai dokumentasi API yang benar-benar digunakan.

Pasang paket:

```powershell
flutter pub add http
```

Contoh GET sederhana:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> ambilData() async {
  final response = await http.get(
    Uri.parse('https://example.com/api/data'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  } else {
    throw Exception('Gagal mengambil data: ${response.statusCode}');
  }
}
```

`https://example.com/api/data` adalah placeholder, bukan endpoint yang disediakan oleh proyek ini. Jangan menaruh API key rahasia, token admin, atau kredensial server di aplikasi mobile yang dibagikan ke publik. Untuk API yang memerlukan rahasia, gunakan backend yang aman.

## 11. Menjalankan dan Menguji Aplikasi

Setelah konfigurasi Firebase selesai, jalankan dari folder utama proyek:

```powershell
flutter clean
flutter pub get
flutter analyze
flutter devices
flutter run
```

Pilih emulator Android atau perangkat fisik yang terhubung. Uji alur berikut:

1. Register menggunakan email yang belum terdaftar.
2. Periksa apakah akun muncul pada Firebase Console → Authentication → Users.
3. Logout.
4. Login memakai akun yang baru dibuat.
5. Tutup dan buka kembali aplikasi untuk menguji pemulihan sesi, jika fitur tersebut diterapkan.
6. Coba email/password yang salah untuk memeriksa pesan error.
7. Jika Firestore diterapkan, periksa dokumen profil dan uji bahwa satu pengguna tidak dapat membaca atau mengubah dokumen milik pengguna lain.

## 12. Membangun APK Android

Pastikan aplikasi berhasil dijalankan sebelum build.

### 12.1 Membuat satu APK

```powershell
flutter build apk --release
```

Lokasi hasil build:

```text
build/app/outputs/flutter-apk/app-release.apk
```

File ini dapat dipindahkan ke perangkat Android untuk pengujian instalasi. Android mungkin meminta izin memasang aplikasi dari sumber tersebut.

### 12.2 Membuat APK terpisah berdasarkan arsitektur

```powershell
flutter build apk --split-per-abi
```

Hasilnya berada di `build/app/outputs/flutter-apk/`, dengan file terpisah untuk arsitektur Android yang didukung. Pilih APK yang sesuai dengan perangkat uji.

> Untuk publikasi ke Google Play, format yang umumnya disarankan adalah Android App Bundle (`.aab`), bukan APK. Proses rilis publik juga memerlukan konfigurasi penandatanganan (signing) yang aman.

## 13. Struktur Folder Flutter

Struktur dapat berbeda sesuai versi Flutter dan isi proyek. Folder yang umum dijumpai:

| Folder/File | Fungsi |
|---|---|
| `lib/` | Kode Dart utama aplikasi: halaman, widget, model, service, dan logika. |
| `lib/main.dart` | Titik awal aplikasi dan biasanya tempat inisialisasi Firebase. |
| `pubspec.yaml` | Nama proyek, versi, aset, font, dan daftar dependensi. |
| `pubspec.lock` | Mengunci versi dependensi yang dipakai pada proyek aplikasi. Simpan file ini di Git. |
| `android/` | Konfigurasi native Android, Gradle, manifest, dan pengaturan build. |
| `assets/` | Gambar, ikon, dan berkas statis jika digunakan. |
| `test/` | Unit test dan widget test jika tersedia. |
| `build/` | Hasil sementara/keluaran build. Dibuat ulang dan tidak perlu diunggah ke GitHub. |
| `.dart_tool/` | Berkas kerja yang dibuat oleh tooling Dart/Flutter. Tidak perlu diunggah. |
| `lib/firebase_options.dart` | Konfigurasi Firebase yang dihasilkan FlutterFire CLI. Buat ulang untuk proyek Firebase milik masing-masing siswa jika file ini tidak disertakan di repository. |

## 14. Masalah yang Sering Terjadi

| Masalah | Langkah pemeriksaan |
|---|---|
| `flutter` tidak dikenali | Periksa instalasi Flutter dan PATH, lalu buka terminal baru. |
| `firebase` tidak dikenali | Pastikan Firebase CLI terpasang dan PATH npm global tersedia. |
| `flutterfire` tidak dikenali | Pastikan FlutterFire CLI aktif dan `%LOCALAPPDATA%\Pub\Cache\bin` ada di PATH. |
| Firebase tidak bisa terhubung | Periksa hasil `flutterfire configure`, Project ID, package name, dan inisialisasi Firebase di `main.dart`. |
| Register gagal | Pastikan provider Email/Password sudah aktif, email valid, dan password memenuhi syarat Firebase. |
| Firestore `permission-denied` | Periksa Firebase Authentication, UID dokumen, dan Firestore Security Rules. |
| Build APK gagal | Jalankan `flutter doctor -v`, `flutter clean`, `flutter pub get`, lalu baca error Gradle pertama yang muncul. |
| APK tidak dapat memakai konfigurasi Firebase | Buat konfigurasi untuk proyek Firebase sendiri dengan `flutterfire configure`, lalu build ulang. |

## 15. Referensi Resmi

- [Flutter – Install](https://docs.flutter.dev/get-started/install)
- [Flutter – Build dan release Android](https://docs.flutter.dev/deployment/android)
- [Firebase – Setup untuk Flutter](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication – Email dan password di Flutter](https://firebase.google.com/docs/auth/flutter/password-auth)
- [Cloud Firestore – Memulai](https://firebase.google.com/docs/firestore/quickstart)
- [Firebase – Memahami dan mengelola API Key](https://firebase.google.com/docs/projects/api-keys)
- [GitHub Docs – Menambahkan kode lokal ke GitHub](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)

---

**Catatan pemeliharaan:** README ini adalah panduan dasar. Perbarui daftar fitur, struktur folder, screenshot, dan instruksi API setelah mencocokkannya dengan source code yang benar-benar ada di repository.
