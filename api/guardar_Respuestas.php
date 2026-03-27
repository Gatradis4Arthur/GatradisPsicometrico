<?php declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');

function jsonOut(array $data, int $status = 200): never {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonOut(['ok' => false, 'mensaje' => 'Método no permitido'], 405);
}

$raw  = file_get_contents('php://input');
$body = json_decode($raw, true);

if (!is_array($body)) {
    jsonOut(['ok' => false, 'mensaje' => 'JSON inválido'], 400);
}

$respuestas = $body['respuestas'] ?? null;

if (!is_array($respuestas) || empty($respuestas)) {
    jsonOut(['ok' => false, 'mensaje' => 'Sin respuestas'], 422);
}

require_once __DIR__ . '/../config/db.php';

try {

    $pdo->beginTransaction();

    $json = json_encode($respuestas, JSON_UNESCAPED_UNICODE);
    if ($json === false) {
        throw new RuntimeException('Error al codificar JSON');
    }

    $stmt = $pdo->prepare("CALL almacenaRespuestas(:json)");
    $stmt->execute([':json' => $json]);

    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    $stmt->closeCursor();
    while ($stmt->nextRowset()) { /* limpiar buffers */ }

    if (!$result) {
        throw new RuntimeException('El SP no devolvió datos');
    }

    $pdo->commit();

    jsonOut([
        'ok' => (bool)$result['ok'],
        'mensaje' => $result['mensaje']
    ]);

} catch (Throwable $e) {

    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }

    error_log($e->getMessage());

    jsonOut([
        'ok' => false,
        'mensaje' => 'Error interno'
    ], 500);
}