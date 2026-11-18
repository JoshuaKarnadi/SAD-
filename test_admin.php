<?php
require_once __DIR__ . '/includes/auth_check.php';
wajib_role('admin');
$judul_halaman = 'Tes Admin';
include_once 'includes/header.php';
?>
<div class="card-box"><p>Halaman admin.</p></div>
<?php include_once 'includes/footer.php'; ?>
