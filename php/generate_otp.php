<?php
session_start();
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';



include 'db.php';

$otp = rand(100000, 999999);
$UserID = $_SESSION['UserID'];

$query = "UPDATE user SET otp=$otp where UserID='$UserID'";


if ($result = $conn->query($query)) {
    
    $UID = "SELECT * FROM user WHERE UserID='$UserID'";
    $fetch = $conn->query($UID);
    $row = $fetch->fetch_assoc();
    $generated_otp = $row['otp'];
    // Create a new PHPMailer instance
    $mail = new PHPMailer(true);

    try {
        // Server settings
        $mail->isSMTP();
        $mail->Host       = getenv('SMTP_HOST') ?: 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = getenv('SMTP_USERNAME') ?: '';
        $mail->Password   = getenv('SMTP_PASSWORD') ?: '';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port       = getenv('SMTP_PORT') ?: 587;

        // Set email format to HTML
        $mail->isHTML(true);
        $fromEmail = getenv('SMTP_FROM') ?: $mail->Username;
        $mail->setFrom($fromEmail, 'OTP');

        $UserID = $_SESSION['UserID'];
        $to = $_SESSION['Email'];
        $mail->addAddress($to);  // Add the recipient

        // Content
        $mail->Subject = "Your OTP";
        $mail->Body    = nl2br(htmlspecialchars($generated_otp));  // Escape special characters

        // Send email
        if ($mail->send()) {
            echo "Email sent to: " . htmlspecialchars($to) . "<br>";          
        } else {
            echo "Failed to send email to: " . htmlspecialchars($to) . "<br>";
        }

        // Clear the recipient for the next iteration
        $mail->clearAddresses();
    } catch (Exception $e) {
        echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
    }
}

?>
