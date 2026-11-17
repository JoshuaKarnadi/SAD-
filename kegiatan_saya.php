<?php
require __DIR__ . '/includes/auth_check.php';

$user_id = (int) $_SESSION['user_id'];

$stmt = $pdo->prepare(
    "SELECT l.id, l.judul, l.lokasi, l.status, l.tanggal_aksi, p.joined_at
     FROM laporan_participants p
     JOIN laporan l ON l.id = p.laporan_id
     WHERE p.user_id = ? AND l.deleted_at IS NULL
     ORDER BY l.tanggal_aksi DESC NULLS LAST, p.joined_at DESC"
);
$stmt->execute([$user_id]);
$daftar = $stmt->fetchAll();

$label_status = [
    'reported'      => 'Dilaporkan',
    'gotong_royong' => 'Gotong Royong',
    'done'          => 'Selesai',
];

$judul_halaman = 'Kegiatan Saya';
include 'includes/header.php';
?>
<div class="card-box">
    <h2>Kegiatan Saya</h2>

    <?php if (empty($daftar)): ?>
        <p>Anda belum mendaftar di kegiatan apa pun.
           <a href="index.php?filter=gotong_royong">Lihat kegiatan yang dibuka</a>.</p>
    <?php else: ?>
        <table class="table-data">
            <tr><th>Kegiatan</th><th>Lokasi</th><th>Tanggal Aksi</th><th>Status</th><th>Terdaftar Pada</th></tr>
            <?php foreach ($daftar as $r): ?>
                <tr>
                    <td><a href="detail.php?id=<?= (int) $r['id'] ?>"><?= htmlspecialchars($r['judul'], ENT_QUOTES, 'UTF-8') ?></a></td>
                    <td><?= htmlspecialchars($r['lokasi'], ENT_QUOTES, 'UTF-8') ?></td>
                    <td><?= $r['tanggal_aksi'] !== null
                        ? htmlspecialchars(date('d-m-Y', strtotime($r['tanggal_aksi'])), ENT_QUOTES, 'UTF-8')
                        : '-' ?></td>
                    <td>
                        <span class="badge-status" data-status="<?= htmlspecialchars($r['status'], ENT_QUOTES, 'UTF-8') ?>">
                            <?= htmlspecialchars($label_status[$r['status']] ?? $r['status'], ENT_QUOTES, 'UTF-8') ?>
                        </span>
                    </td>
                    <td><?= htmlspecialchars(date('d-m-Y', strtotime($r['joined_at'])), ENT_QUOTES, 'UTF-8') ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
</div>
<?php include 'includes/footer.php'; ?>