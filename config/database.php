<?php
// config/database.php

$db_host = 'localhost';
$db_port = '5432';
$db_name = 'db_pedulilingkungan';
$db_user = 'postgres';
$db_pass = 'melisa';

try {
    $dsn = "pgsql:host=$db_host;port=$db_port;dbname=$db_name";

    $pdo = new PDO($dsn, $db_user, $db_pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ]);
} catch (PDOException $e) {
    error_log('Koneksi database gagal: ' . $e->getMessage());
    http_response_code(500);
    exit('Terjadi kesalahan pada server.');
}
