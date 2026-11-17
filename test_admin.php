<?php
require __DIR__ . '/includes/auth_check.php';
wajib_role('admin');
$judul_halaman = 'Tes Admin';
include 'includes/header.php';
?>
<div class="card-box"><p>Halaman admin.</p></div>
<?php include 'includes/footer.php'; ?>