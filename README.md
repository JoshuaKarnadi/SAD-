# PeduliLingkungan

Aplikasi web pelaporan masalah lingkungan dan koordinasi kegiatan *volunteer* berbasis komunitas yang dibangun menggunakan **PHP Native** dan **PostgreSQL** dengan pendekatan **Secure Software Development Life Cycle (SSDLC)** mengacu pada standar **OWASP Top 10:2025**.

## Fitur Utama

* **Autentikasi & Manajemen Sesi Aman:** Registrasi, login, dan logout dengan *hashing* kata sandi Bcrypt, regenerasi ID sesi, serta *session idle timeout* (15 menit).

* **Kontrol Akses Berbasis Peran (RBAC):**

  * **Guest:** Melihat daftar laporan lingkungan yang telah diverifikasi beserta filter status.

  * **User:** Membuat laporan masalah lingkungan baru (dengan unggah foto opsional), memantau status laporan sendiri, serta mendaftar pada kegiatan *volunteer*.

  * **Admin:** Memoderasi laporan masuk (setujui/tolak), mengelola kuota dan peserta *volunteer*, menghapus laporan (*soft delete*), memantau *audit log* aktivitas, dan membuka blokir IP (*rate limit*).

* **Pencatatan Jejak Audit (*Audit Logging*):** Tabel `activity_logs` menerapkan kebijakan *append-only* untuk merekam setiap aktivitas penting beserta alamat IP pengguna.

## Arsitektur & Kontrol Keamanan

1. **Pencegahan SQL Injection:** Menggunakan *native prepared statements* PHP PDO (`PDO::ATTR_EMULATE_PREPARES => false`).

2. **Proteksi Cross-Site Scripting (XSS):** Validasi parameter input berbasis *whitelist* (`in_array`) dan *output escaping* menggunakan `htmlspecialchars(..., ENT_QUOTES, 'UTF-8')`.

3. **Proteksi Cross-Site Request Forgery (CSRF):** Token CSRF acak berbasis `random_bytes(32)` yang divalidasi pada setiap pengiriman formulir `POST`.

4. **Mitigasi Brute Force:** *Rate limiting* berbasis alamat IP untuk membatasi percobaan login gagal maupun pembuatan laporan berulang.

5. **Validasi & Sanitasi File Upload:** Pengecekan ukuran maksimal (2 MB), validasi MIME type asli, serta proses *re-encoding* gambar melalui pustaka GD PHP untuk mencegah unggahan *polyglot* maupun *web shell*.

6. **Least Privilege Database:** Pemisahan peran pengguna basis data aplikasi (`app_pedulilingkungan`) agar tidak memiliki hak `UPDATE` maupun `DELETE` pada tabel `activity_logs`.

7. **HTTP Security Headers & Router Isolation:** Penerapan `Content-Security-Policy`, `X-Frame-Options: SAMEORIGIN`, `X-Content-Type-Options: nosniff`, `Cache-Control: no-store`, serta pemblokiran akses langsung ke berkas sensitif (`.env`, `.git`, `config/`, `includes/`) melalui `router.php`.

## Panduan Instalasi & Menjalankan dari Nol (Windows)

### 1. Prasyarat Sistem

Pastikan perangkat lunak berikut sudah terpasang di Windows:

* **PHP 8.2+** (Standalone, tanpa XAMPP)

* **PostgreSQL 14+** (beserta `pgAdmin 4` atau `psql`)

* **Git**

### 2. Daftarkan PHP ke Environment Variables (PATH) Windows

1. Ekstrak folder instalasi PHP Anda (misalnya ke `C:\php`).

2. Tekan tombol **Windows**, ketik **Edit the system environment variables**, lalu buka.

3. Klik tombol **Environment Variables...** di pojok kanan bawah.

4. Pada bagian **System variables**, pilih variabel **`Path`**, lalu klik **Edit...**.

5. Klik **New**, masukkan lokasi folder PHP Anda (`C:\php`), lalu klik **OK** pada semua jendela.

6. Buka terminal baru (CMD/PowerShell) dan pastikan PHP sudah dikenali:

   ```
   php -v
   
   ```

### 3. Konfigurasi `php.ini`

1. Masuk ke folder instalasi PHP (`C:\php`), salin berkas `php.ini-development` lalu ubah namanya menjadi **`php.ini`**.

2. Buka `php.ini` menggunakan editor teks, lalu aktifkan ekstensi yang dibutuhkan dengan menghapus tanda titik koma (`;`) di awal baris berikut:

   ```
    extension=fileinfo
    extension=gd
    extension=mbstring
    extension=exif
    extension=pdo_pgsql
   
   
   ```

3. Sembunyikan informasi versi PHP pada *HTTP response header* untuk mencegah kebocoran informasi server:

   ```
   expose_php = Off
   
   ```

4. Simpan perubahan (`Ctrl + S`).

### 4. Clone Repositori Proyek

Buka terminal pada direktori induk tempat Anda ingin menyimpan proyek (misalnya `C:\Projects\`), lalu jalankan:

```
git clone https://github.com/JoshuaKarnadi/SAD-.git

```

### 5. Konfigurasi Basis Data PostgreSQL (*Least Privilege*)

1. Buka **pgAdmin 4** (atau terminal `psql` menggunakan akun `postgres`).

2. Buat database baru bernama **`db_pedulilingkungan`**.

3. Impor skema tabel (`users`, `laporan`, `laporan_participants`, `activity_logs`) dan akun peran aplikasi terbatas (**`app_pedulilingkungan`**) dari berkas `.sql` yang tersedia di dalam folder repositori `SAD-`.
   *(Catatan: Akun `app_pedulilingkungan` telah dikonfigurasi menggunakan prinsip least privilege agar tidak dapat melakukan `UPDATE` maupun `DELETE` pada tabel audit `activity_logs`)*.

### 6. Buat Berkas `.env` di Luar Folder Proyek

Demi keamanan agar kredensial tidak berada di dalam *web root*, buat satu berkas bernama **`.env`** sejajar di luar folder `SAD-` seperti struktur berikut:

```
Folder_Induk/
├── SAD-/          <-- Folder repositori proyek
└── .env           <-- Letakkan file .env persis di luar folder SAD-

```

Isi berkas **`.env`** tersebut dan sesuaikan `DB_USER` serta `DB_PASS` dengan kredensial PostgreSQL Anda:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=db_pedulilingkungan
DB_USER=app_pedulilingkungan
DB_PASS=ganti_dengan_password_anda

```

### 7. Menjalankan Server Aplikasi

Masuk ke dalam folder proyek `SAD-` melalui terminal:

```
cd SAD-

```

Pilih salah satu mode menjalankan server berikut sesuai kebutuhan (wajib menyertakan `router.php` agar pemblokiran akses berkas sensitif dan *HTTP security headers* tetap aktif):

* **Opsi A — Akses dari PC/Laptop Saja (`localhost`):**

  ```
  php -S localhost:8000 router.php
  
  ```

  Buka peramban di PC dan akses: **`http://localhost:8000`**

* **Opsi B — Akses dari HP & Perangkat Lain dalam Satu Jaringan Wi-Fi:**

  ```
  php -S 0.0.0.0:8000 router.php
  
  ```

  Cek alamat IPv4 PC Anda (jalankan `ipconfig` di terminal, misalnya `192.168.1.10`), lalu buka peramban di HP dan akses: **`http://192.168.1.10:8000`**

## Struktur Direktori

```
SAD-/
├── actions/            # Pemroses formulir POST (login, register, lapor, gabung, moderasi admin)
├── assets/
│   ├── css/            # Stylesheet aplikasi
│   └── uploads/        # Penyimpanan gambar laporan tervalidasi
├── config/
│   ├── database.php    # Koneksi PostgreSQL berbasis environment variable
│   └── session.php     # Inisialisasi sesi aman & HTTP security headers
├── helpers/
│   ├── gambar.php      # Validasi & re-encoding gambar GD
│   └── logger.php      # Pencatatan audit log ke PostgreSQL
├── includes/           # Komponen UI (header, footer) dan middleware auth_check.php
├── router.php          # Custom router untuk proteksi berkas tersembunyi & header aset statis
└── index.php           # Halaman utama daftar laporan

```