<?php
// test_db.php - Connection Testing Script for TeleCare
include 'db_connect.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TeleCare - Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 40px; color: #333; }
        .container { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); max-width: 600px; margin: auto; }
        h2 { color: #1b365d; }
        .success { color: #27ae60; font-weight: bold; font-size: 1.1em; }
        ul { background: #f9f9f9; padding: 15px 30px; border-radius: 5px; border: 1px solid #ddd; }
        li { margin-bottom: 6px; font-family: Consolas, monospace; }
    </style>
</head>
<body>
    <div class="container">
        <h2>TeleCare System Environment Test</h2>
        <p class="success">✔ SUCCESS: Database Connection Established Successfully to <code>telecare_db</code>!</p>
        <hr>
        <h3>Detected Database Tables (ERD Entities):</h3>
        <ul>
        <?php
        $result = $conn->query("SHOW TABLES");
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_row()) {
                echo "<li>" . htmlspecialchars($row[0]) . "</li>";
            }
        } else {
            echo "<li>No tables found. Please run the SQL schema script.</li>";
        }
        $conn->close();
        ?>
        </ul>
    </div>
</body>
</html>`