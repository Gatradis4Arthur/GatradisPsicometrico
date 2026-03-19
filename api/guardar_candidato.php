<?php declare(strict_types=1);
// api/guardar_candidato.php
// ─────────────────────────────────────────────────────────────────────────────
// Recibe: { nombre, email, telefono, puesto }
// Devuelve: { ok, candidato_id, session_id, battery_code, mensaje? }
// ─────────────────────────────────────────────────────────────────────────────

header('Content-Type: application/json; charset=utf-8');

// ── Helpers ──────────────────────────────────────────────────────────────────
function jsonOut(array $data, int $status = 200): never
{
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function cleanStr(string $v, int $maxLen = 255): string
{
    return mb_substr(trim(strip_tags($v)), 0, $maxLen);
}

// ── Sólo POST ────────────────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonOut(['ok' => false, 'mensaje' => 'Método no permitido'], 405);
}

// ── Leer JSON ────────────────────────────────────────────────────────────────
$raw = file_get_contents('php://input');
$body = json_decode($raw, true);

if (!$body) {
    jsonOut(['ok' => false, 'mensaje' => 'Cuerpo JSON inválido'], 400);
}

// ── Validar campos requeridos ─────────────────────────────────────────────────
$nombre   = cleanStr($body['nombre']   ?? '', 200);
$email    = cleanStr($body['email']    ?? '', 150);
$telefono = cleanStr($body['telefono'] ?? '',  20);
$puesto   = cleanStr($body['puesto']   ?? '', 150);

if (!$nombre || !$email || !$telefono || !$puesto) {
    jsonOut(['ok' => false, 'mensaje' => 'Todos los campos son obligatorios'], 422);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    jsonOut(['ok' => false, 'mensaje' => 'El correo electrónico no es válido'], 422);
}

// ── Conexión a BD ─────────────────────────────────────────────────────────────
// db.php está un nivel arriba (en www/ raíz)
require_once __DIR__ . '/../config/db.php';   // devuelve $pdo (PDO)

// ── Determinar la batería según el puesto ─────────────────────────────────────
// Regla simple por palabras clave; ajusta según tu lógica de negocio.
// battery_types.code: ADM | GER | OPR | TRP
function detectBatteryCode(string $puesto): string
{
    $p = mb_strtolower($puesto);

    $mapas = [
        'TRP' => ['chofer','conductor','operador','autotanque','transporte','tanque'],
        'GER' => ['gerente','director','jefe','coordinador','supervisor','manager'],
        'ADM' => ['administrativo','asistente','secretaria','recepcionista','contador','analista'],
        'OPR' => [],   // default / catch-all
    ];

    foreach ($mapas as $code => $palabras) {
        foreach ($palabras as $kw) {
            if (str_contains($p, $kw)) {
                return $code;
            }
        }
    }
    return 'OPR';
}

$batteryCode = detectBatteryCode($puesto);

try {
    $pdo->beginTransaction();

    // 1. Obtener battery_type_id
    $stmt = $pdo->prepare('SELECT id FROM battery_types WHERE code = ?');
    $stmt->execute([$batteryCode]);
    $batteryTypeId = $stmt->fetchColumn();

    if (!$batteryTypeId) {
        throw new RuntimeException("Batería no encontrada: $batteryCode");
    }

    // 2. Insertar candidato
    $stmt = $pdo->prepare('
        INSERT INTO candidates (full_name, email, phone, position)
        VALUES (:nombre, :email, :telefono, :puesto)
    ');
    $stmt->execute([
        ':nombre'   => $nombre,
        ':email'    => $email,
        ':telefono' => $telefono,
        ':puesto'   => $puesto,
    ]);
    $candidatoId = (int) $pdo->lastInsertId();

    // 3. Generar token único para la sesión
    $token = bin2hex(random_bytes(32));

    // 4. Crear sesión de evaluación
    $stmt = $pdo->prepare('
        INSERT INTO evaluation_sessions
            (candidate_id, battery_type_id, token, status, expires_at)
        VALUES
            (:cid, :bid, :token, "pending",
             DATE_ADD(NOW(), INTERVAL 24 HOUR))
    ');
    $stmt->execute([
        ':cid'   => $candidatoId,
        ':bid'   => $batteryTypeId,
        ':token' => $token,
    ]);
    $sessionId = (int) $pdo->lastInsertId();

    $pdo->commit();

    jsonOut([
        'ok'             => true,
        'candidato_id'   => $candidatoId,
        'session_id'     => $sessionId,
        'battery_code'   => $batteryCode,
        'battery_type_id'=> $batteryTypeId,
        'token'          => $token,
    ]);

} catch (Throwable $e) {
    $pdo->rollBack();
    // En producción: loguear $e->getMessage() y no exponerlo
    jsonOut([
        'ok'      => false,
        'mensaje' => 'Error interno. Inténtalo de nuevo.',
    ], 500);
}