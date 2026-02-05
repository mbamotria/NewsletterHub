-- NewsletterHub MySQL schema
-- Generated on 2026-02-05

CREATE DATABASE IF NOT EXISTS `newsletter`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `newsletter`;

CREATE TABLE IF NOT EXISTS `user` (
  `UserID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserName` VARCHAR(50) NULL,
  `Password` VARCHAR(255) NULL,
  `FName` VARCHAR(50) NULL,
  `LName` VARCHAR(50) NULL,
  `Email` VARCHAR(120) NOT NULL,
  `PhoneNumber` VARCHAR(30) NULL,
  `otp` VARCHAR(6) NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `uq_user_email` (`Email`),
  UNIQUE KEY `uq_user_username` (`UserName`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `userrole` (
  `RoleID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `RoleName` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`RoleID`),
  UNIQUE KEY `uq_userrole_rolename` (`RoleName`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `roleofuser` (
  `UserID` INT UNSIGNED NOT NULL,
  `RoleID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`UserID`),
  KEY `ix_roleofuser_roleid` (`RoleID`),
  CONSTRAINT `fk_roleofuser_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE,
  CONSTRAINT `fk_roleofuser_role` FOREIGN KEY (`RoleID`) REFERENCES `userrole` (`RoleID`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `member` (
  `MemberID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`MemberID`),
  UNIQUE KEY `uq_member_user` (`UserID`),
  CONSTRAINT `fk_member_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `admin` (
  `AdminID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`AdminID`),
  UNIQUE KEY `uq_admin_user` (`UserID`),
  CONSTRAINT `fk_admin_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `writer` (
  `WriterID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`WriterID`),
  UNIQUE KEY `uq_writer_user` (`UserID`),
  CONSTRAINT `fk_writer_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `category` (
  `CategoryID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CategoryName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`CategoryID`),
  UNIQUE KEY `uq_category_name` (`CategoryName`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `subscriber` (
  `SubscriberNo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`SubscriberNo`),
  UNIQUE KEY `uq_subscriber_user` (`UserID`),
  CONSTRAINT `fk_subscriber_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `subscription` (
  `SubscriberNo` INT UNSIGNED NOT NULL,
  `CategoryID` INT UNSIGNED NOT NULL,
  `UserID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`SubscriberNo`, `CategoryID`),
  UNIQUE KEY `uq_subscription_user_category` (`UserID`, `CategoryID`),
  KEY `ix_subscription_category` (`CategoryID`),
  CONSTRAINT `fk_subscription_subscriber` FOREIGN KEY (`SubscriberNo`) REFERENCES `subscriber` (`SubscriberNo`) ON DELETE CASCADE,
  CONSTRAINT `fk_subscription_category` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_subscription_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `blog` (
  `BlogID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(200) NOT NULL,
  `Content` LONGTEXT NOT NULL,
  `PublishDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CategoryName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`BlogID`),
  KEY `ix_blog_category` (`CategoryName`),
  CONSTRAINT `fk_blog_category` FOREIGN KEY (`CategoryName`) REFERENCES `category` (`CategoryName`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `newsletter` (
  `NewsletterNo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(200) NOT NULL,
  `Content` LONGTEXT NOT NULL,
  `CategoryName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`NewsletterNo`),
  KEY `ix_newsletter_category` (`CategoryName`),
  CONSTRAINT `fk_newsletter_category` FOREIGN KEY (`CategoryName`) REFERENCES `category` (`CategoryName`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `publishedas` (
  `NewsletterNo` INT UNSIGNED NOT NULL,
  `CategoryID` INT UNSIGNED NOT NULL,
  `BlogID` INT UNSIGNED NOT NULL,
  `PublishDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`NewsletterNo`, `CategoryID`, `BlogID`),
  KEY `ix_publishedas_blog` (`BlogID`),
  CONSTRAINT `fk_publishedas_newsletter` FOREIGN KEY (`NewsletterNo`) REFERENCES `newsletter` (`NewsletterNo`) ON DELETE CASCADE,
  CONSTRAINT `fk_publishedas_category` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_publishedas_blog` FOREIGN KEY (`BlogID`) REFERENCES `blog` (`BlogID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `newsletterreceivers` (
  `NewsletterNo` INT UNSIGNED NOT NULL,
  `CategoryID` INT UNSIGNED NOT NULL,
  `UserID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`NewsletterNo`, `CategoryID`, `UserID`),
  KEY `ix_newsletterreceivers_user` (`UserID`),
  CONSTRAINT `fk_newsletterreceivers_newsletter` FOREIGN KEY (`NewsletterNo`) REFERENCES `newsletter` (`NewsletterNo`) ON DELETE CASCADE,
  CONSTRAINT `fk_newsletterreceivers_category` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_newsletterreceivers_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `application` (
  `ApplicationID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` INT UNSIGNED NOT NULL,
  `approval_status` ENUM('Pending','Approved','Denied') NOT NULL DEFAULT 'Pending',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ApplicationID`),
  UNIQUE KEY `uq_application_user` (`UserID`),
  CONSTRAINT `fk_application_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `writings` (
  `WritingID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `WriterID` INT UNSIGNED NOT NULL,
  `CategoryName` VARCHAR(50) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approval_status` ENUM('Pending','Approved','Denied') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`WritingID`),
  KEY `ix_writings_writer` (`WriterID`),
  CONSTRAINT `fk_writings_writer` FOREIGN KEY (`WriterID`) REFERENCES `writer` (`WriterID`) ON DELETE CASCADE,
  CONSTRAINT `fk_writings_category` FOREIGN KEY (`CategoryName`) REFERENCES `category` (`CategoryName`) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `feedback` (
  `FeedbackID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Message` TEXT NOT NULL,
  `FeedbackDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FeedbackID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `receivesfeedback` (
  `FeedbackID` INT UNSIGNED NOT NULL,
  `AdminID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`FeedbackID`, `AdminID`),
  KEY `ix_receivesfeedback_admin` (`AdminID`),
  CONSTRAINT `fk_receivesfeedback_feedback` FOREIGN KEY (`FeedbackID`) REFERENCES `feedback` (`FeedbackID`) ON DELETE CASCADE,
  CONSTRAINT `fk_receivesfeedback_admin` FOREIGN KEY (`AdminID`) REFERENCES `admin` (`AdminID`) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO `userrole` (`RoleName`) VALUES
  ('Admin'),
  ('Member'),
  ('Writer')
ON DUPLICATE KEY UPDATE `RoleName` = VALUES(`RoleName`);

INSERT INTO `category` (`CategoryName`) VALUES
  ('Business'),
  ('Sports'),
  ('Books'),
  ('Quotes')
ON DUPLICATE KEY UPDATE `CategoryName` = VALUES(`CategoryName`);
