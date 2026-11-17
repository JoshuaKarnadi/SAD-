<?php
require __DIR__ . '/includes/auth_check.php';

$judul_halaman = 'Buat Laporan';
$besok = (new DateTimeImmutable('tomorrow', new DateTimeZone('Asia/Jakarta')))->format('Y-m-d');

$flash_error = $_SESSION['flash_error'] ?? '';
$input_lama  = $_SESSION['input_lama'] ?? [
    'judul' => '', 'lokasi' => '', 'deskripsi' => '',
    'ajukan_volunteer' => false, 'deskripsi_volunteer' => '',
    'tanggal_aksi' => '', 'kuota' => '',
];
unset($_SESSION['flash_error'], $_SESSION['input_lama']);

include 'includes/header.php';
?>
<div class="card-box">
    <h2>Buat Laporan</h2>

    <?php if ($flash_error !== ''): ?>
        <div class="alert-error"><?= htmlspecialchars($flash_error, ENT_QUOTES, 'UTF-8') ?></div>
    <?php endif; ?>

    <form action="actions/proses_lapor.php" method="post" enctype="multipart/form-data">
        <input type="hidden" name="csrf_token"
               value="<?= htmlspecialchars($_SESSION['csrf_token'], ENT_QUOTES, 'UTF-8') ?>">

        <div class="form-group">
            <label for="judul">Judul</label>
            <input class="form-input" type="text" id="judul" name="judul"
                   maxlength="150" required
                   value="<?= htmlspecialchars($input_lama['judul'] ?? '', ENT_QUOTES, 'UTF-8') ?>">
        </div>

        <div class="form-group">
            <label for="lokasi">Lokasi</label>
            <input class="form-input" type="text" id="lokasi" name="lokasi"
                   maxlength="255" required
                   value="<?= htmlspecialchars($input_lama['lokasi'] ?? '', ENT_QUOTES, 'UTF-8') ?>">
        </div>

        <div class="form-group">
            <label for="deskripsi">Deskripsi</label>
            <textarea class="form-input" id="deskripsi" name="deskripsi"
                      rows="6" maxlength="2000" required><?= htmlspecialchars($input_lama['deskripsi'] ?? '', ENT_QUOTES, 'UTF-8') ?></textarea>
        </div>

        <div class="form-group">
            <label for="gambar">Foto (opsional, JPG atau PNG, maksimal 2 MB)</label>
            <input class="form-input" type="file" id="gambar" name="gambar" accept="image/jpeg,image/png">
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="ajukan_volunteer" value="1"
                    <?= !empty($input_lama['ajukan_volunteer']) ? 'checked' : '' ?>>
                Saya ingin mengadakan kegiatan volunteer untuk masalah ini
            </label>
            <p>Laporan tetap langsung tampil. Jika dicentang, isi deskripsi, tanggal, dan kuota di bawah. Admin akan memeriksa dan bisa mengubahnya sebelum menyetujui.</p>
        </div>

        <div class="form-group">
            <label for="deskripsi_volunteer">Deskripsi kegiatan volunteer (apa yang dikerjakan, titik kumpul, yang perlu dibawa)</label>
            <textarea class="form-input" id="deskripsi_volunteer" name="deskripsi_volunteer"
                    rows="4" maxlength="1000"><?= htmlspecialchars($input_lama['deskripsi_volunteer'] ?? '', ENT_QUOTES, 'UTF-8') ?></textarea>
        </div>

        <div class="form-group">
            <label for="tanggal_aksi">Usulan tanggal aksi</label>
            <input class="form-input" type="date" id="tanggal_aksi" name="tanggal_aksi"
                min="<?= htmlspecialchars($besok, ENT_QUOTES, 'UTF-8') ?>"
                value="<?= htmlspecialchars($input_lama['tanggal_aksi'] ?? '', ENT_QUOTES, 'UTF-8') ?>">
        </div>

        <div class="form-group">
            <label for="kuota">Usulan kuota relawan (1-500)</label>
            <input class="form-input" type="number" id="kuota" name="kuota" min="1" max="500"
                value="<?= htmlspecialchars((string) ($input_lama['kuota'] ?? ''), ENT_QUOTES, 'UTF-8') ?>">
        </div>

        <button type="submit" class="btn-primary">Kirim Laporan</button>
    </form>
</div>
<?php include 'includes/footer.php'; ?>