# Laporan Responsi Pemrograman Mobile

## Identitas
- Nama: [Nama Mahasiswa]
- NIM: [NIM]
- Kelas: [Kelas]
- Mata Kuliah: Pemrograman Mobile (ST407)

## 1. Deskripsi Aplikasi

Aplikasi **Profil Mahasiswa dengan Catatan Kuliah** adalah aplikasi Flutter yang menerapkan materi Pertemuan 1–6. Aplikasi memiliki dua fitur utama: pengelolaan profil mahasiswa dan pengelolaan catatan kuliah.

Fitur utama:
1. **Profil Mahasiswa** — menampilkan nama, NIM, program studi, email, dan avatar inisial; data dapat diubah melalui tombol Edit Profil.
2. **Catatan Kuliah** — menambah, melihat, dan menghapus catatan dengan validasi judul 3–50 karakter dan isi 10–1000 karakter.
3. **Penyimpanan aman** — metadata catatan disimpan di SharedPreferences, sedangkan isi catatan disimpan terenkripsi di flutter_secure_storage.
4. **Integrasi API** — mengambil data pengguna dari `/users` menggunakan HTTP GET dan menampilkannya di ListView.
5. **Keamanan** — konfigurasi melalui `.env`, logging tanpa data sensitif, serta `INTERNET` dan `allowBackup="false"` pada Android.

## 2. Arsitektur Aplikasi

```text
UI (Screens & Widgets)
        │  membaca state / mengirim aksi
        ▼
AppProvider (InheritedWidget)
AppProviderWrapper (StatefulWidget)
        │
        ▼
NoteRepository
        ├── SharedPreferences
        │   └── metadata: id, judul, tanggal (JSON list)
        └── SecureStorageService
            └── isi catatan terenkripsi: note_content_<id>

UI (HomeScreen) → ApiService → HTTP GET /users → ListView
```

Alur data:
- **UI** hanya menampilkan data dan meneruskan aksi pengguna.
- **Provider** menyimpan state `student`, `notes`, `isLoading`, dan `errorMessage`.
- **Repository** menjadi satu-satunya pintu akses data catatan.
- **Storage** memisahkan metadata (SharedPreferences) dan isi catatan (flutter_secure_storage) agar isi catatan tidak ikut tersimpan sebagai JSON biasa.
- **ApiService** menangani request HTTP, timeout, dan error handling.

## 3. Penerapan Sub-CPMK

### 3.1 sub.cpmk.ST407.CPMK051.1 — Instalasi, Struktur Proyek, dan Git

Proyek dibuat dengan nama `responsi_profil_mahasiswa` dan struktur direktori sesuai PDF. Git digunakan dengan lebih dari 5 commit dan beberapa branch fitur, yaitu `setup-proyek`, `fitur-profil`, `fitur-catatan`, `fitur-api-keamanan`, dan `rapikan-dokumentasi`. Semua branch telah di-merge ke `main`.

`.gitignore` mengabaikan `.env`, `build/`, dan `.dart_tool/`. File `.env.example` disertakan sebagai contoh konfigurasi, sedangkan `.env` asli tidak di-commit.

### 3.2 sub.cpmk.ST407.CPMK051.2 — Widget Modular dan Profil Mahasiswa

Model `Student` memiliki field `name`, `nim`, `programStudi`, dan `email`. `ProfileScreen` menampilkan `ProfileCard` yang berisi `CircleAvatar` dengan inisial nama, data profil, dan tombol Edit Profil. Layout menggunakan `Row`, `Column`, `Container`, dan `EdgeInsets`.

Widget dipisahkan ke file masing-masing, yaitu `screens/profile_screen.dart` dan `widgets/profile_card.dart`. Logika penyimpanan state tidak ditulis di widget, sehingga prinsip separation of concerns terpenuhi.

### 3.3 sub.cpmk.ST407.CPMK051.3 — State Management dan Validasi

`AppProvider` merupakan turunan `InheritedWidget` yang menyediakan `student`, `notes`, `updateStudent`, `addNote`, dan `deleteNote`. `AppProviderWrapper` merupakan turunan `StatefulWidget` yang mengelola state dan menyediakan provider ke seluruh subtree.

`NoteFormScreen` menggunakan `Form` dan `TextFormField`. Validasi dilakukan oleh `Validators.validateTitle` (3–50 karakter), `Validators.validateContent` (10–1000 karakter), dan `Validators.sanitize` untuk membersihkan karakter `<`, `>`, `"`, dan `'`. Perubahan state dilakukan seperlunya sesuai prinsip least privilege.

### 3.4 sub.cpmk.ST407.CPMK051.4 — Keamanan Penyimpanan, HTTP, dan Logging

`SecureStorageService` menyediakan `saveContent`, `getContent`, dan `deleteContent` dengan key `note_content_<id>`. `NoteRepository` menyimpan metadata catatan sebagai JSON list di SharedPreferences dan menyimpan isi catatan di secure storage. Jika penyimpanan metadata gagal, isi catatan yang sudah tersimpan akan dihapus kembali.

`AppConfig` memuat `BASE_URL` dan `API_KEY` dari `.env`, sehingga tidak ada credential yang di-hardcode. `ApiService` melakukan HTTP GET ke `/users` dengan timeout 10 detik dan menangani `TimeoutException`, `SocketException`, serta `FormatException`.

`Logger` hanya aktif pada mode debug dan menyamarkan token, password, API key, serta authorization sebelum dicetak. AndroidManifest sudah memuat permission `INTERNET` dan `android:allowBackup="false"`.

## 4. Git Log

Perintah:

```powershell
git log --graph --oneline --all
```

Output:

```text
*   b51dfe4 merge: fitur-profil
|\
| * 12d78d8 feat(ui): bedakan tampilan profil dan catatan
|/
*   f5c71f7 merge: rapikan-dokumentasi
|\
| * 42cef8f docs: rapikan dartdoc dan layout ProfileCard
|/
*   78e9f3b merge: fitur-api-keamanan
|\
| * b6da20d feat(api): tambah HTTP GET aman dan konfigurasi Android
|/
*   0911b66 merge: fitur-catatan
|\
| * ff8f5e8 feat(catatan): implementasi penyimpanan aman, repository, provider, dan UI catatan
|/
*   b1ed15e merge: fitur-profil
|\
| * c30adf4 feat(profil): tambah model, provider, kartu, dan edit profil
|/
*   77c2dd0 merge: setup-proyek
|\
| * 4e867b5 chore(setup): siapkan dependensi, env, config, dan utilitas
|/
* 40b5061 commit pertama
```

## 5. Kendala dan Solusi

1. **Versi shared_preferences tidak kompatibel** — versi 2.5.6 membutuhkan Dart `^3.11.0`, sedangkan proyek memakai Dart 3.10.4. Solusinya menggunakan `shared_preferences: ^2.5.5`.
2. **`.env` tidak boleh di-commit** — file ini dibutuhkan sebagai asset. Solusinya menyediakan `.env.example`, mengabaikan `.env` di `.gitignore`, dan menyalin `.env.example` menjadi `.env` saat menjalankan proyek.
3. **Batas minSdk flutter_secure_storage** — package membutuhkan Android API 23, sedangkan Flutter versi ini memakai minSdk 24. Tidak diperlukan perubahan.
4. **Tampilan profil dan catatan terlalu mirip** — keduanya awalnya memakai `Card` + `ListTile` + `CircleAvatar`. Solusinya profil diubah menjadi banner berwarna dengan avatar, sedangkan catatan memakai ikon dokumen dan border lembut.
5. **Error jaringan** — ditangani dengan timeout, `try-catch`, dan pesan error yang ramah pengguna, tanpa mencetak data sensitif.
6. **Sinkronisasi branch** — `fitur-profil` disinkronkan ulang dari `main` sebelum perubahan UI agar tidak terjadi konflik saat merge.

## 6. Link Repositori

https://github.com/fynthevibecodinger/responsi_profil_mahasiswa
