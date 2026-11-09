<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
include __DIR__ . '/../db_connect.php';

$in    = json_decode(file_get_contents('php://input'), true);
$email = strtolower(trim($in['email'] ?? ''));
$pass  = $in['password'] ?? '';
$role  = ($in['role'] ?? '') === 'admin' ? 'admin' : 'resident';

$table = $role;
$idcol = $role . '_id';

$stmt = $conn->prepare("SELECT $idcol AS id, full_name, password_hash FROM $table WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();

if ($row && password_verify($pass, $row['password_hash'])) {
    session_regenerate_id(true);
    $_SESSION['user'] = ['id' => $row['id'], 'role' => $role];
    echo json_encode(['ok' => true, 'user' => ['name' => $row['full_name'], 'email' => $email, 'role' => $role]]);
} else {
    http_response_code(401);
    echo json_encode(['ok' => false]);
}
$conn->close();