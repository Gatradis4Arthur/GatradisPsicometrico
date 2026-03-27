<?php declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');

function jsonOut(array $data, int $status = 200): never {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

// Validar método HTTP
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonOut(['ok' => false, 'mensaje' => 'Método no permitido'], 405);
}

// Leer body
$raw  = file_get_contents('php://input');
$body = json_decode($raw, true);

if (!is_array($body)) {
    jsonOut(['ok' => false, 'mensaje' => 'JSON inválido'], 400);
}

// Validar estructura
$respuestas = $body['respuestas'] ?? null;

if (!is_array($respuestas) || empty($respuestas)) {
    jsonOut(['ok' => false, 'mensaje' => 'Sin respuestas'], 422);
}

// Conexión a BD
require_once __DIR__ . '/../config/db.php';

try {

    // Convertir a JSON
    $json = json_encode($respuestas, JSON_UNESCAPED_UNICODE);
    if ($json === false) {
        throw new RuntimeException('Error al codificar JSON');
    }

    // Ejecutar procedimiento almacenado
    $stmt = $pdo->prepare("CALL almacenaRespuestas(:json)");
    $stmt->execute([':json' => $json]);

    // Obtener resultado
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    // Limpiar buffers (importante en SP)
    $stmt->closeCursor();
    while ($stmt->nextRowset()) {}

    if (!$result) {
        throw new RuntimeException('El SP no devolvió datos');
    }

    // Respuesta OK
    jsonOut([
        'ok' => (bool)$result['ok'],
        'mensaje' => $result['mensaje']
    ]);

} catch (Throwable $e) {

    // Log interno
    error_log($e->getMessage());

    jsonOut([
        'ok' => false,
        'mensaje' => 'Error interno'
    ], 500);
}
?>
