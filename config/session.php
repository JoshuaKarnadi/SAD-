<?php
// config/session.php

function mulai_sesi_aman(): void
{
    if (session_status() === PHP_SESSION_ACTIVE) {
        return;
    }

    $https = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off';

    ini_set('session.use_strict_mode', '1');
    ini_set('session.use_only_cookies', '1');

    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'secure'   => $https,
        'httponly' => true,
        'samesite' => 'Lax',
    ]);

    session_start();
}

const BATAS_IDLE_DETIK = 900;   // 15 menit

function sesi_idle_habis(): bool
{
    if (empty($_SESSION['user_id'])) {
        return false;
    }
    $terakhir = $_SESSION['last_activity'] ?? 0;
    return (time() - $terakhir) > BATAS_IDLE_DETIK;
}