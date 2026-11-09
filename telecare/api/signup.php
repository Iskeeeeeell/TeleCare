<?php
header('Content-Type: application/json; charset=utf-8');
include __DIR__ . '/../db_connect.php';

$in    = json_decode(file_get_contents('php://input'), true);
$name  = trim($in['name'] ?? '');
$email = strtolower(trim($in['email'] ?? ''));
$pass  = $in['password'] ?? '';

if ($name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($pass) < 6) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Check your name, email and password (at least 6 characters).']);
    exit;
}

$check = $conn->prepare("SELECT resident_id FROM resident WHERE email = ?");
$check->bind_param("s", $email);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    http_response_code(409);
    echo json_encode(['ok' => false, 'error' => 'An account with this email already exists. Log in instead.']);
    exit;
}

$hash = password_hash($pass, PASSWORD_DEFAULT);
$stmt = $conn->prepare("INSERT INTO resident (full_name, email, password_hash) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $email, $hash);
$stmt->execute();

echo json_encode(['ok' => true]);
$conn->close();