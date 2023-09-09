-- MySQL dump 10.13  Distrib 8.0.24, for Linux (x86_64)
--
-- Host: localhost    Database: manhole
-- ------------------------------------------------------
-- Server version	8.0.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `AdminID` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Contact` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`AdminID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'root','123456','管理员','根账户'),(2,'wrm244','778899','管理员','根账户');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cameras`
--

DROP TABLE IF EXISTS `cameras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cameras` (
  `CameraID` int NOT NULL AUTO_INCREMENT,
  `CameraName` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Description` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `InstallationDate` date DEFAULT NULL,
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '视频流',
  PRIMARY KEY (`CameraID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cameras`
--

LOCK TABLES `cameras` WRITE;
/*!40000 ALTER TABLE `cameras` DISABLE KEYS */;
INSERT INTO `cameras` VALUES (1,'one','桂电中央食堂大门','第1台相机','2023-08-20','http://192.168.3.48:8081/0/stream'),(2,'two','桂电中央食堂侧门','第2台相机','2023-08-26','http://192.168.3.49:8081/0/stream'),(3,'thire','桂电F区宿舍门口','第3台相机','2023-08-26','http://192.168.3.49:8081/0/stream'),(4,'f','桂电A区宿舍门口','第4台相机','2023-08-28','http://192.168.3.49:8081/0/stream'),(5,'f','桂电B区宿舍门口','第4台相机','2023-08-28','http://192.168.3.49:8081/0/stream');
/*!40000 ALTER TABLE `cameras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wellcoverlogs`
--

DROP TABLE IF EXISTS `wellcoverlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wellcoverlogs` (
  `LogID` int NOT NULL AUTO_INCREMENT,
  `WellCoverID` int NOT NULL,
  `DateTime` datetime NOT NULL,
  `Status` int NOT NULL,
  `Location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `RecognitionResult` int DEFAULT NULL,
  `CameraID` int DEFAULT NULL,
  `AlgorithmVersion` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `AdditionalInfo` char(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`LogID`),
  KEY `WellCoverID` (`WellCoverID`),
  KEY `CameraID` (`CameraID`),
  CONSTRAINT `wellcoverlogs_ibfk_1` FOREIGN KEY (`WellCoverID`) REFERENCES `wellcovers` (`WellCoverID`),
  CONSTRAINT `wellcoverlogs_ibfk_2` FOREIGN KEY (`CameraID`) REFERENCES `cameras` (`CameraID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wellcoverlogs`
--

LOCK TABLES `wellcoverlogs` WRITE;
/*!40000 ALTER TABLE `wellcoverlogs` DISABLE KEYS */;
INSERT INTO `wellcoverlogs` VALUES (1,1,'2023-07-01 08:00:00',1,'桂电中央食堂大门',1,1,'第一版本',NULL),(2,1,'2023-08-01 09:00:00',0,'桂电中央食堂侧门',1,2,'第一版本',NULL),(3,1,'2023-09-01 21:34:00',1,'桂电中央食堂侧门',1,3,'第一版本',NULL),(4,1,'2023-09-08 21:34:00',1,'桂电A区门口',1,4,'第一版本',NULL),(5,1,'2023-09-09 21:34:00',1,'桂电B区门口',1,2,'第一版本',NULL),(6,1,'2023-09-09 21:34:00',0,'桂电田径场',1,5,'第一版本',NULL),(7,1,'2023-09-10 21:34:00',1,'桂电田径场',1,3,'第一版本',NULL);
/*!40000 ALTER TABLE `wellcoverlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wellcovers`
--

DROP TABLE IF EXISTS `wellcovers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wellcovers` (
  `WellCoverID` int NOT NULL AUTO_INCREMENT,
  `Location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `InstallationDate` date DEFAULT NULL,
  `LastInspectionDate` date DEFAULT NULL,
  PRIMARY KEY (`WellCoverID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wellcovers`
--

LOCK TABLES `wellcovers` WRITE;
/*!40000 ALTER TABLE `wellcovers` DISABLE KEYS */;
INSERT INTO `wellcovers` VALUES (1,'桂电b区','2','2023-08-20','2023-08-20'),(2,'桂电田径场','2','2023-08-20','2023-08-20'),(3,'桂电A区宿舍','2','2023-08-20','2023-08-20');
/*!40000 ALTER TABLE `wellcovers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'manhole'
--

--
-- Dumping routines for database 'manhole'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-09 15:15:06
