<?php
require __DIR__ . '/includes/auth_check.php';

$user_id = (int) $_SESSION['user_id'];

$stmt = $pdo->prepare(
    "SELECT id, judul, lokasi, status, permintaan_volunteer, created_at
     FROM laporan
     WHERE user_id = ? AND deleted_at IS NULL
     ORDER BY created_at DESC"
);
$stmt->execute([$user_id]);
$daftar = $stmt->fetchAll();

$label_status = [
    'reported'      => 'Dilaporkan',
    'gotong_royong' => 'Gotong Royong',
    'done'          => 'Selesai',
];
$label_permintaan = [
    'tidak'     => '-',
    'menunggu'  => 'Menunggu persetujuan admin',
    'disetujui' => 'Disetujui',
    'ditolak'   => 'Ditolak',
];

$judul_halaman = 'Laporan Saya';
include 'includes/header.php';
?>
<div class="card-box">
    <h2>Laporan Saya</h2>
    <a href="lapor.php" class="btn-primary">Buat Laporan</a>

    <?php if (empty($daftar)): ?>
        <p>Anda belum membuat laporan.</p>
    <?php else: ?>
        <table class="table-data">
            <tr><th>Judul</th><th>Lokasi</th><th>Status</th><th>Pengajuan Volunteer</th><th>Tanggal</th></tr>
            <?php foreach ($daftar as $r): ?>
                <tr>
                    <td><a href="detail.php?id=<?= (int) $r['id'] ?>"><?= htmlspecialchars($r['judul'], ENT_QUOTES, 'UTF-8') ?></a></td>
                    <td><?= htmlspecialchars($r['lokasi'], ENT_QUOTES, 'UTF-8') ?></td>
                    <td>
                        <span class="badge-status" data-status="<?= htmlspecialchars($r['status'], ENT_QUOTES, 'UTF-8') ?>">
                            <?= htmlspecialchars($label_status[$r['status']] ?? $r['status'], ENT_QUOTES, 'UTF-8') ?>
                        </span>
                    </td>
                    <td><?= htmlspecialchars($label_permintaan[$r['permintaan_volunteer']] ?? '-', ENT_QUOTES, 'UTF-8') ?></td>
                    <td><?= htmlspecialchars(date('d-m-Y', strtotime($r['created_at'])), ENT_QUOTES, 'UTF-8') ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
</div>
<?php include 'includes/footer.php'; ?>