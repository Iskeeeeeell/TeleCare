-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2026 at 07:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `telecare_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `full_name`, `email`, `password_hash`, `created_at`) VALUES
(1, 'Clinic Administrator', 'admin@telecare.demo', '$2y$10$/QY86sTLvn7L6GfkNjDNxuQOw3Y60MLVBIyBi2NKoSwC1PftHsXTq', '2026-11-06 04:34:50');

-- --------------------------------------------------------

--
-- Table structure for table `announcement`
--

CREATE TABLE `announcement` (
  `announcement_id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `title` varchar(80) NOT NULL,
  `category` varchar(40) NOT NULL,
  `status` enum('Published','Draft') NOT NULL DEFAULT 'Draft',
  `message` text NOT NULL,
  `updated_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcement`
--

INSERT INTO `announcement` (`announcement_id`, `admin_id`, `title`, `category`, `status`, `message`, `updated_at`) VALUES
(1, NULL, 'Clinic hours before you visit', 'Schedule notice', 'Published', 'Operating hours are awaiting confirmation. Please verify the schedule directly with the clinic.', '2026-10-16'),
(2, NULL, 'Explore the clinic service directory', 'Service information', 'Published', 'Read about consultations, check-ups and emergency assistance offered in person.', '2026-10-15'),
(3, NULL, 'Welcome to your clinic information hub', 'Community update', 'Published', 'Find essential clinic details in one place. You can browse without an account.', '2026-10-14'),
(4, NULL, 'Verify clinic contact details', 'Clinic information', 'Draft', 'Confirm the official clinic address, phone and email before launch.', '2026-11-06');

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `appointment_id` int(11) NOT NULL,
  `resident_id` int(11) NOT NULL,
  `type` enum('Clinic','Vet') NOT NULL,
  `appt_date` date NOT NULL,
  `appt_time` varchar(20) NOT NULL,
  `reason` varchar(200) NOT NULL,
  `pet_name` varchar(80) DEFAULT NULL,
  `pet_type` varchar(40) DEFAULT NULL,
  `status` enum('Pending','Confirmed','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`appointment_id`, `resident_id`, `type`, `appt_date`, `appt_time`, `reason`, `pet_name`, `pet_type`, `status`, `created_at`) VALUES
(1, 2, 'Clinic', '2026-11-13', '9:00 AM', 'Antie baries', NULL, NULL, 'Confirmed', '2026-11-11 16:58:09');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_information`
--

CREATE TABLE `clinic_information` (
  `clinic_id` int(11) NOT NULL,
  `clinic_name` varchar(120) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `about_description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_information`
--

INSERT INTO `clinic_information` (`clinic_id`, `clinic_name`, `address`, `phone`, `email`, `about_description`) VALUES
(1, 'Barangay clinic - name to be confirmed', 'To be confirmed by the clinic', 'To be confirmed by the clinic', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `clinic_service`
--

CREATE TABLE `clinic_service` (
  `service_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_service`
--

INSERT INTO `clinic_service` (`service_id`, `title`, `description`) VALUES
(1, 'Medical consultations', 'Learn about in-person consultations at the barangay clinic.'),
(2, 'Check-ups', 'Find information about routine, in-person health check-ups.'),
(3, 'Emergency assistance', 'Understand the clinic\'s in-person assistance and its limitations.');

-- --------------------------------------------------------

--
-- Table structure for table `healthcare_team`
--

CREATE TABLE `healthcare_team` (
  `team_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `healthcare_team`
--

INSERT INTO `healthcare_team` (`team_id`, `title`, `description`) VALUES
(1, 'Consultation team', 'Provider names and availability to be confirmed.'),
(2, 'Nursing team', 'Staff names and duty hours to be confirmed.'),
(3, 'Barangay health workers', 'Community team details to be confirmed.');

-- --------------------------------------------------------

--
-- Table structure for table `medical_record`
--

CREATE TABLE `medical_record` (
  `record_id` int(11) NOT NULL,
  `resident_id` int(11) NOT NULL,
  `visit_date` date NOT NULL,
  `record_type` varchar(30) NOT NULL DEFAULT 'Check-up',
  `complaint` varchar(255) NOT NULL,
  `blood_pressure` varchar(15) DEFAULT NULL,
  `temperature` decimal(4,1) DEFAULT NULL,
  `weight_kg` decimal(5,1) DEFAULT NULL,
  `diagnosis` varchar(255) DEFAULT NULL,
  `treatment` text DEFAULT NULL,
  `follow_up_date` date DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `operating_hour`
--

CREATE TABLE `operating_hour` (
  `hour_id` int(11) NOT NULL,
  `days` varchar(60) NOT NULL,
  `hours` varchar(60) DEFAULT NULL,
  `status` varchar(40) DEFAULT 'To be confirmed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `operating_hour`
--

INSERT INTO `operating_hour` (`hour_id`, `days`, `hours`, `status`) VALUES
(1, 'Monday - Friday', '8:00 AM-5:00 PM', 'To be confirmed'),
(2, 'Saturday', '10:00 AM-5:00 PM', 'To be confirmed'),
(3, 'Sunday & holidays', 'To be confirmed', 'To be confirmed');

-- --------------------------------------------------------

--
-- Table structure for table `resident`
--

CREATE TABLE `resident` (
  `resident_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resident`
--

INSERT INTO `resident` (`resident_id`, `full_name`, `email`, `password_hash`, `created_at`) VALUES
(1, 'John Michael P Casin', 'jmcasin011307@gmail.com', '$2y$10$h3OmK.mTNOF0HbASusI6zu20YBgztN.vlvCA5d1xQo9pNm1N4Cjvm', '2026-11-06 06:24:45'),
(2, 'john michael casin', 'johnmichael@gmail.com', '$2y$10$1qR9o2EkDKAF1Gyev94egOOEMxxEnwaiKBda27UJ/QoL49EEw2Bve', '2026-11-11 16:24:56');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `announcement`
--
ALTER TABLE `announcement`
  ADD PRIMARY KEY (`announcement_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `idx_resident` (`resident_id`),
  ADD KEY `idx_slot` (`type`,`appt_date`,`appt_time`);

--
-- Indexes for table `clinic_information`
--
ALTER TABLE `clinic_information`
  ADD PRIMARY KEY (`clinic_id`);

--
-- Indexes for table `clinic_service`
--
ALTER TABLE `clinic_service`
  ADD PRIMARY KEY (`service_id`);

--
-- Indexes for table `healthcare_team`
--
ALTER TABLE `healthcare_team`
  ADD PRIMARY KEY (`team_id`);

--
-- Indexes for table `medical_record`
--
ALTER TABLE `medical_record`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `idx_mr_resident` (`resident_id`,`visit_date`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indexes for table `operating_hour`
--
ALTER TABLE `operating_hour`
  ADD PRIMARY KEY (`hour_id`);

--
-- Indexes for table `resident`
--
ALTER TABLE `resident`
  ADD PRIMARY KEY (`resident_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `announcement`
--
ALTER TABLE `announcement`
  MODIFY `announcement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_information`
--
ALTER TABLE `clinic_information`
  MODIFY `clinic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_service`
--
ALTER TABLE `clinic_service`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `healthcare_team`
--
ALTER TABLE `healthcare_team`
  MODIFY `team_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `medical_record`
--
ALTER TABLE `medical_record`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `operating_hour`
--
ALTER TABLE `operating_hour`
  MODIFY `hour_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `resident`
--
ALTER TABLE `resident`
  MODIFY `resident_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcement`
--
ALTER TABLE `announcement`
  ADD CONSTRAINT `announcement_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE SET NULL;

--
-- Constraints for table `medical_record`
--
ALTER TABLE `medical_record`
  ADD CONSTRAINT `medical_record_ibfk_1` FOREIGN KEY (`resident_id`) REFERENCES `resident` (`resident_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `medical_record_ibfk_2` FOREIGN KEY (`recorded_by`) REFERENCES `admin` (`admin_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
