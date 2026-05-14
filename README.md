# 🏃 CATAT LARI 

## Nama Anggota Kelompok 2 Kelas IV-B :
Safira Choirun Nisa’ (24082010046)
Patrich Moratti (24082010080)
Achmad Atfal Jaya R. (24082010085)
Muhammad Yahya Zahid (24082010086)

## Deskripsi Aplikasi
CatatLari adalah aplikasi mobile yang dirancang untuk membantu para pelari dari pemula hingga yang berpengalaman dalam mencatat, memantau, dan menganalisis setiap sesi lari mereka secara terstruktur dan menarik. Pengguna dapat mencatat setiap aktivitas lari dengan detail seperti tanggal, jarak tempuh, dan durasi. Aplikasi secara otomatis menghitung pace, kalori yang terbakar, serta kategori intensitas lari yang ditentukan otomatis berdasarkan jarak tempuh, Easy (< 3 km), Moderate (3–7 km), Long (7–12 km), dan Ultra (≥ 12 km), sehingga pengguna mendapatkan gambaran menyeluruh tentang performa dan progres latihan mereka dari waktu ke waktu. Aplikasi ini dibangun menggunakan Flutter dengan penerapan pola arsitektur MVVM (Model-View-ViewModel), Catat Lari memiliki tampilan yang intuitif dengan tema warna hitam dan oranye yang energik, mencerminkan semangat dan dinamika aktivitas lari.

## Fitur Aplikasi
### 1. 🔐 Autentikasi Pengguna
Sistem autentikasi lengkap untuk manajemen akun pengguna secara aman.
#### Daftar Akun
- Formulir registrasi dengan input : Nama Lengkap, Email, Nomor Telepon, Password, dan Konfirmasi Password
- Validasi input secara real-time untuk memastikan kelengkapan dan kebenaran data
#### Login
- Formulir masuk dengan input: Email dan Password
- Tersedia akun demo yang dapat mengisi proses login secara otomatis dengan satu klik, memudahkan proses eksplorasi aplikasi tanpa perlu registrasi manual
### 2. 🏠 Dashboard (Beranda)
Halaman utama yang informatif dan personal sebagai pusat aktivitas pengguna.
- Sapaan personal : menampilkan nama pengguna yang sedang login (contoh: *"Halo, Budi!"*)
- Informasi hari dan tanggal hari ini secara dinamis
- Ikon profil berinisial : menampilkan inisial nama pengguna sebagai avatar, berfungsi sebagai navigasi cepat ke halaman profil
- Ringkasan statistik : menampilkan akumulasi total jarak tempuh, durasi, dan kalori dari seluruh riwayat lari pengguna
- Daftar card aktivitas lari : setiap kartu riwayat aktivitas lari menampilkan detail tanggal, jarak, durasi, pace, dan kalori
- Menu aksi pada kartu : ikon tiga titik (⋮) di setiap kartu membuka opsi Edit atau Hapus riwayat aktivitas lari
- Tombol Catat Lari Baru (+) : tombol aksi mengambang di pojok kanan bawah untuk menambahkan riwayat lari baru
### 3. ➕ Catat Lari Baru
Halaman formulir untuk mencatat sesi lari baru secara detail.
- Input tanggal : dilengkapi *date picker* berupa kalender interaktif, sehingga aplikasi dapat secara otomatis memformat tampilan hari dan tanggal lari
- Input jarak tempuh dalam satuan kilometer (km)
- Input durasi : kotak input jam dan menit dipisahkan secara mandiri untuk kemudahan pengisian
- Kartu summary otomatis : setelah mengisi durasi, aplikasi secara langsung menampilkan kalkulasi:
  - ⚡ Pace (menit per km)
  - 🔥 Kalori yang terbakar
  - 🏷️ Kategori lari (contohnya Easy (< 3 km), Moderate (3–7 km), Long (7–12 km), dan Ultra (≥ 12 km))
### 4. ✏️ Edit Aktivitas Lari
Halaman untuk memperbarui data sesi lari yang telah tercatat.
- Tampilan formulir identik dengan halaman Catat Lari Baru
- Logika validasi pada ViewModel membedakan alur create (data kosong) dan update (data sudah ada), menjaga konsistensi kode sesuai prinsip MVVM
### 5. 🗑️ Hapus Aktivitas Lari
Fitur penghapusan data dengan konfirmasi untuk mencegah penghapusan yang tidak disengaja.
- Diakses melalui menu tiga titik (⋮) pada kartu aktivitas di dashboard
- Menampilkan dialog konfirmasi (Pop-Up) dengan pilihan button Hapus atau Batal
### 6. 👤 Profil Pengguna
Halaman yang menampilkan identitas dan statistik keseluruhan pengguna.
- Avatar berinisial : ikon profil dengan inisial nama pengguna
- Resume statistik : card ringkasan berisi total sesi lari, total jarak, dan total kalori yang telah tercatat
- Informasi detail : Nama, Email, dan Nomor Telepon
- Button Edit Profil : navigasi ke halaman edit data profil pengguna
- Button Logout : keluar dari sesi pengguna dan diarahkan kembali ke halaman Login
### 7. 🛠️ Edit Profil Pengguna
Halaman untuk memperbarui informasi akun pengguna.
- Formulir input untuk edit : Nama Lengkap, Email, dan Nomor Telepon
- Opsi keamanan untuk Ubah Password (dapat diaktifkan/dinonaktifkan) :
  - Jika diaktifkan, akan muncul kolom input Password Baru dan Konfirmasi Password Baru
  - Jika tidak diaktifkan, bagian ubah password tersembunyi dan password lama tetap berlaku

## Arsitektur & Tech Stack
Flutter : Framework utama untuk pengembangan aplikasi mobile lintas platform
Dart : Bahasa pemrograman yang digunakan bersama Flutter
MVVM Pattern : Pola arsitektur untuk pemisahkan logika bisnis dan antarmuka pengguna
