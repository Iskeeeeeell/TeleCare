<?php
// db_connect.php - Database connection script for TeleCare Clinic Information System
$servername = "localhost";
$username   = "root";
$password   = ""; // Default XAMPP MySQL password is blank
$dbname     = "telecare_db";

// Create connection using MySQLi
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Database Connection Failed: " . $conn->connect_error);
}

// Set charset to utf8mb4
$conn->set_charset("utf8mb4");
?>