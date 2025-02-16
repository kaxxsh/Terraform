<?php
$host = "your-rds-endpoint";
$username = "your-username";
$password = "your-password";
$dbname = "your-database";

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully!";
?>