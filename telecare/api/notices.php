<?php
session_start();
header('Content-Type: application/json; charset=utf-8');
include __DIR__ . '/../db_connect.php';

$isAdmin = ($_SESSION['user']['role'] ?? '') === 'admin';

// ---- GET: ilista ang announcements ----
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT announcement_id AS id, title, category AS cat, status, message AS body, updated_at AS date FROM announcement";
    if (!$isAdmin) $sql .= " WHERE status = 'Published'";
    $sql .= " ORDER BY updated_at DESC, announcement_id DESC";
    echo json_encode($conn->query($sql)->fetch_all(MYSQLI_ASSOC));
    exit;
}

// ---- POST: admin lang ----
if (!$isAdmin) {
    http_response_code(403);
    echo json_encode(['ok' => false, 'error' => 'Admin only']);
    exit;
}

$in      = json_decode(file_get_contents('php://input'), true);
$action  = $in['action'] ?? '';
$id      = (int)($in['id'] ?? 0);
$today   = date('Y-m-d');
$adminId = (int)$_SESSION['user']['id'];

if ($action === 'save') {
    $title  = trim($in['title'] ?? '');
    $cat    = trim($in['cat'] ?? '');
    $status = ($in['status'] ?? '') === 'Published' ? 'Published' : 'Draft';
    $body   = trim($in['body'] ?? '');

    if ($title === '' || $body === '') {
        http_response_code(400);
        echo json_encode(['ok' => false, 'error' => 'Title and message are required']);
        exit;
    }

    if ($id) {
        $stmt = $conn->prepare("UPDATE announcement SET title=?, category=?, status=?, message=?, updated_at=? WHERE announcement_id=?");
        $stmt->bind_param("sssssi", $title, $cat, $status, $body, $today, $id);
    } else {
        $stmt = $conn->prepare("INSERT INTO announcement (admin_id, title, category, status, message, updated_at) VALUES (?,?,?,?,?,?)");
        $stmt->bind_param("isssss", $adminId, $title, $cat, $status, $body, $today);
    }
    $stmt->execute();

} elseif ($action === 'toggle') {
    $stmt = $conn->prepare("UPDATE announcement SET status = IF(status='Published','Draft','Published'), updated_at=? WHERE announcement_id=?");
    $stmt->bind_param("si", $today, $id);
    $stmt->execute();

} elseif ($action === 'delete') {
    $stmt = $conn->prepare("DELETE FROM announcement WHERE announcement_id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

} else {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'Unknown action']);
    exit;
}

echo json_encode(['ok' => true]);
$conn->close();