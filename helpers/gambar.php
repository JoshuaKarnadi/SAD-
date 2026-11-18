<?php
// helpers/gambar.php

const FOLDER_UPLOAD    = __DIR__ . '/../assets/uploads/';
const POLA_NAMA_GAMBAR = '/\A[a-f0-9]{32}\.(jpg|png)\z/';

// Apakah ini nama berkas buatan server kita?
function nama_gambar_valid(?string $nama): bool
{
    return $nama !== null && preg_match(POLA_NAMA_GAMBAR, $nama) === 1;
}

// Alamat gambar untuk tag <img>, atau null jika tidak ada / tidak sah
function url_gambar(?string $nama): ?string
{
    return nama_gambar_valid($nama) ? 'assets/uploads/' . $nama : null;
}

// Memeriksa dan membuat ulang gambar. Mengembalikan [pesan_error|null, mime|null, data|null]
function proses_gambar($berkas): array
{
    if (!is_array($berkas) || ($berkas['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
        return [null, null, null];   // gambar bersifat opsional
    }
    if ($berkas['error'] === UPLOAD_ERR_INI_SIZE || $berkas['error'] === UPLOAD_ERR_FORM_SIZE) {
        return ['Ukuran gambar maksimal 2 MB.', null, null];
    }
    if ($berkas['error'] !== UPLOAD_ERR_OK) {
        return ['Gambar gagal diunggah. Silakan coba lagi.', null, null];
    }

    $tmp = $berkas['tmp_name'];
    if (!is_string($tmp) || !is_uploaded_file($tmp)) {
        return ['Berkas tidak valid.', null, null];
    }
    $ukuran = filesize($tmp);
    if ($ukuran === false || $ukuran > 2 * 1024 * 1024) {
        return ['Ukuran gambar maksimal 2 MB.', null, null];
    }

    // Tipe asli dibaca dari ISI berkas, bukan dari nama atau tipe kiriman browser
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mime  = $finfo->file($tmp);
    $boleh = ['image/jpeg' => IMAGETYPE_JPEG, 'image/png' => IMAGETYPE_PNG];
    if (!is_string($mime) || !isset($boleh[$mime])) {
        return ['Format gambar harus JPG atau PNG.', null, null];
    }

    $info = @getimagesize($tmp);
    if ($info === false || $info[2] !== $boleh[$mime]) {
        return ['Berkas bukan gambar yang valid.', null, null];
    }
    if ($info[0] < 1 || $info[1] < 1 || $info[0] * $info[1] > 12000000) {
        return ['Dimensi gambar terlalu besar (maksimal 12 megapiksel).', null, null];
    }

    ini_set('memory_limit', '256M');

    $img = ($mime === 'image/jpeg') ? @imagecreatefromjpeg($tmp) : @imagecreatefrompng($tmp);
    if ($img === false) {
        return ['Gambar tidak dapat diproses.', null, null];
    }

    // EXIF dibuang saat dibuat ulang, jadi putar dulu sesuai orientasi foto HP
    if ($mime === 'image/jpeg' && function_exists('exif_read_data')) {
        $exif  = @exif_read_data($tmp);
        $sudut = [3 => 180, 6 => -90, 8 => 90][(int) ($exif['Orientation'] ?? 1)] ?? 0;
        if ($sudut !== 0) {
            $putar = imagerotate($img, $sudut, 0);
            if ($putar !== false) {
                $img = $putar;
            }
        }
    }

    // Perkecil jika lebih lebar dari 1600 piksel
    if (imagesx($img) > 1600) {
        $kecil = imagescale($img, 1600);
        if ($kecil !== false) {
            $img = $kecil;
        }
    }

    // Buat ulang dari piksel: membuang metadata (EXIF/GPS) dan isi tersembunyi
    ob_start();
    if ($mime === 'image/png') {
        imagealphablending($img, false);
        imagesavealpha($img, true);
        imagepng($img, null, 6);
    } else {
        imagejpeg($img, null, 85);
    }
    $data = ob_get_clean();

    if ($data === false || $data === '') {
        return ['Gambar tidak dapat diproses.', null, null];
    }

    return [null, $mime, $data];
}

// Menulis gambar ke folder dengan nama acak buatan server. Mengembalikan nama berkas atau null.
function simpan_berkas_gambar(string $data, string $mime): ?string
{
    $nama = bin2hex(random_bytes(16)) . '.' . ($mime === 'image/png' ? 'png' : 'jpg');

    if (!is_dir(FOLDER_UPLOAD) && !mkdir(FOLDER_UPLOAD, 0755, true)) {
        return null;
    }
    if (file_put_contents(FOLDER_UPLOAD . $nama, $data, LOCK_EX) === false) {
        return null;
    }
    return $nama;
}

// Menghapus berkas gambar. Nama diperiksa dulu agar tidak bisa keluar dari folder.
function hapus_berkas_gambar(?string $nama): void
{
    if (!nama_gambar_valid($nama)) {
        return;
    }
    $path = FOLDER_UPLOAD . $nama;
    if (is_file($path) && !unlink($path)) {
        error_log('Gagal menghapus berkas gambar: ' . $nama);
    }
}
