-- MySQL dump 10.13  Distrib 5.7.24, for osx11.1 (x86_64)
--
-- Host: localhost    Database: epaper_price
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `display_status_logs`
--

DROP TABLE IF EXISTS `display_status_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `display_status_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `display_id` bigint unsigned NOT NULL,
  `battery_level` tinyint unsigned DEFAULT NULL,
  `signal_strength` tinyint DEFAULT NULL,
  `status` enum('online','offline','error') DEFAULT NULL,
  `firmware_version` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_status_display` (`display_id`),
  CONSTRAINT `fk_status_display` FOREIGN KEY (`display_id`) REFERENCES `displays` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `display_status_logs`
--

LOCK TABLES `display_status_logs` WRITE;
/*!40000 ALTER TABLE `display_status_logs` DISABLE KEYS */;
INSERT INTO `display_status_logs` VALUES (1,2,NULL,NULL,'online',NULL,'2026-02-03 16:58:58'),(2,2,NULL,NULL,'online',NULL,'2026-02-03 16:59:17'),(3,2,NULL,NULL,'online',NULL,'2026-02-03 17:00:15'),(4,3,NULL,NULL,'online',NULL,'2026-02-03 17:00:54'),(5,3,NULL,NULL,'online',NULL,'2026-02-03 17:01:20'),(6,3,NULL,NULL,'online',NULL,'2026-02-03 17:01:44'),(7,3,NULL,NULL,'online',NULL,'2026-02-03 17:02:09'),(8,3,NULL,NULL,'online',NULL,'2026-02-03 17:02:38'),(9,3,NULL,NULL,'online',NULL,'2026-02-03 17:02:49'),(10,1,NULL,NULL,'online',NULL,'2026-02-03 17:03:49'),(11,1,NULL,NULL,'online',NULL,'2026-02-03 17:04:49'),(12,1,NULL,NULL,'online',NULL,'2026-02-03 17:05:49'),(13,1,NULL,NULL,'online',NULL,'2026-02-03 17:06:49'),(14,1,NULL,NULL,'online',NULL,'2026-02-03 17:07:51'),(15,1,NULL,NULL,'online',NULL,'2026-02-03 17:08:49'),(16,1,NULL,NULL,'online',NULL,'2026-02-03 17:09:49'),(17,1,NULL,NULL,'online',NULL,'2026-02-03 17:10:50'),(18,1,NULL,NULL,'online',NULL,'2026-02-03 17:11:49'),(19,1,NULL,NULL,'online',NULL,'2026-02-03 17:12:49'),(20,1,NULL,NULL,'online',NULL,'2026-02-03 17:13:49'),(21,1,NULL,NULL,'online',NULL,'2026-02-03 17:14:22'),(22,1,NULL,NULL,'online',NULL,'2026-02-03 17:14:37'),(23,1,NULL,NULL,'online',NULL,'2026-02-03 17:15:38'),(24,1,NULL,NULL,'online',NULL,'2026-02-03 17:16:19'),(25,1,NULL,NULL,'online',NULL,'2026-02-03 17:16:58'),(26,1,NULL,NULL,'online',NULL,'2026-02-03 17:17:15'),(27,1,NULL,NULL,'online',NULL,'2026-02-03 17:18:17'),(28,1,NULL,NULL,'online',NULL,'2026-02-03 17:19:57'),(29,1,NULL,NULL,'online',NULL,'2026-02-03 17:22:56'),(30,1,NULL,NULL,'online',NULL,'2026-02-03 17:24:33'),(31,1,NULL,NULL,'online',NULL,'2026-02-03 17:25:09'),(32,1,NULL,NULL,'online',NULL,'2026-02-03 17:25:41'),(33,1,NULL,NULL,'online',NULL,'2026-02-03 17:26:59'),(34,1,NULL,NULL,'online',NULL,'2026-02-03 17:27:41'),(35,4,NULL,NULL,'online',NULL,'2026-02-03 17:30:09'),(36,5,NULL,NULL,'online',NULL,'2026-02-03 17:31:01'),(37,5,NULL,NULL,'online',NULL,'2026-02-03 17:31:22'),(38,5,NULL,NULL,'online',NULL,'2026-02-03 17:31:56'),(39,5,NULL,NULL,'online',NULL,'2026-02-03 17:33:11'),(40,5,NULL,NULL,'online',NULL,'2026-02-03 17:34:05'),(41,6,NULL,NULL,'online',NULL,'2026-02-03 17:35:29'),(42,6,NULL,NULL,'online',NULL,'2026-02-03 17:36:20'),(43,2,NULL,NULL,'online',NULL,'2026-02-03 17:37:20'),(44,2,NULL,NULL,'online',NULL,'2026-02-03 17:38:20'),(45,3,NULL,NULL,'online',NULL,'2026-02-03 17:39:20'),(46,3,NULL,NULL,'online',NULL,'2026-02-03 17:40:20'),(47,3,NULL,NULL,'online',NULL,'2026-02-03 17:41:21'),(48,1,NULL,NULL,'online',NULL,'2026-02-03 17:42:20'),(49,1,NULL,NULL,'online',NULL,'2026-02-03 17:43:06'),(50,1,NULL,NULL,'online',NULL,'2026-02-03 17:44:06'),(51,1,NULL,NULL,'online',NULL,'2026-02-03 17:45:06'),(52,2,NULL,NULL,'online',NULL,'2026-02-03 17:45:58'),(53,2,NULL,NULL,'online',NULL,'2026-02-03 17:46:59'),(54,2,NULL,NULL,'online',NULL,'2026-02-03 17:49:02'),(55,2,NULL,NULL,'online',NULL,'2026-02-03 17:50:25'),(56,2,NULL,NULL,'online',NULL,'2026-02-03 17:51:26'),(57,3,NULL,NULL,'online',NULL,'2026-02-03 17:52:25'),(58,3,NULL,NULL,'online',NULL,'2026-02-03 17:53:28'),(59,3,NULL,NULL,'online',NULL,'2026-02-03 17:53:48'),(60,5,NULL,NULL,'online',NULL,'2026-02-03 17:54:19'),(61,5,NULL,NULL,'online',NULL,'2026-02-03 17:54:49'),(62,5,NULL,NULL,'online',NULL,'2026-02-03 17:55:55'),(63,5,NULL,NULL,'online',NULL,'2026-02-03 17:56:14'),(64,5,NULL,NULL,'online',NULL,'2026-02-03 17:57:57'),(65,5,NULL,NULL,'online',NULL,'2026-02-03 17:58:10'),(66,5,NULL,NULL,'online',NULL,'2026-02-03 17:58:33'),(67,5,NULL,NULL,'online',NULL,'2026-02-03 17:58:46'),(68,5,NULL,NULL,'online',NULL,'2026-02-03 17:59:27'),(69,5,NULL,NULL,'online',NULL,'2026-02-03 18:00:01'),(70,4,NULL,NULL,'online',NULL,'2026-02-03 18:02:01'),(71,4,NULL,NULL,'online',NULL,'2026-02-03 18:03:48'),(72,4,NULL,NULL,'online',NULL,'2026-02-03 18:04:49'),(73,4,NULL,NULL,'online',NULL,'2026-02-03 18:05:49'),(74,4,NULL,NULL,'online',NULL,'2026-02-03 18:06:49'),(75,4,NULL,NULL,'online',NULL,'2026-02-03 18:07:49'),(76,4,NULL,NULL,'online',NULL,'2026-02-03 18:09:57'),(77,6,NULL,NULL,'online',NULL,'2026-02-03 18:11:57'),(78,2,NULL,NULL,'online',NULL,'2026-02-03 18:12:42'),(79,2,NULL,NULL,'online',NULL,'2026-02-04 06:33:41'),(80,4,NULL,NULL,'online',NULL,'2026-02-04 06:34:55'),(81,4,NULL,NULL,'online',NULL,'2026-02-04 06:35:14'),(82,4,NULL,NULL,'online',NULL,'2026-02-04 06:36:08'),(83,6,NULL,NULL,'online',NULL,'2026-02-04 06:37:58'),(84,6,NULL,NULL,'online',NULL,'2026-02-04 06:38:49'),(85,1,NULL,NULL,'online',NULL,'2026-02-04 06:43:11'),(86,1,NULL,NULL,'online',NULL,'2026-02-04 06:48:51'),(87,1,NULL,NULL,'online',NULL,'2026-02-04 06:49:33'),(88,1,NULL,NULL,'online',NULL,'2026-02-04 06:50:19'),(89,1,NULL,NULL,'online',NULL,'2026-02-04 06:51:01'),(90,1,NULL,NULL,'online',NULL,'2026-02-04 06:54:19'),(91,1,NULL,NULL,'online',NULL,'2026-02-04 06:57:08'),(92,1,NULL,NULL,'online',NULL,'2026-02-04 06:58:26'),(93,1,NULL,NULL,'online',NULL,'2026-02-04 07:01:28'),(94,1,NULL,NULL,'online',NULL,'2026-02-04 07:01:45'),(95,1,NULL,NULL,'online',NULL,'2026-02-04 07:01:57'),(96,1,NULL,NULL,'online',NULL,'2026-02-04 07:02:32'),(97,1,NULL,NULL,'online',NULL,'2026-02-04 07:02:47'),(98,1,NULL,NULL,'online',NULL,'2026-02-04 07:03:48'),(99,1,NULL,NULL,'online',NULL,'2026-02-04 07:04:58'),(100,1,NULL,NULL,'online',NULL,'2026-02-04 07:06:46'),(101,1,NULL,NULL,'online',NULL,'2026-02-04 07:07:47'),(102,1,NULL,NULL,'online',NULL,'2026-02-04 07:09:06'),(103,1,NULL,NULL,'online',NULL,'2026-02-04 08:35:59'),(104,3,NULL,NULL,'online',NULL,'2026-02-04 08:37:12'),(105,4,NULL,NULL,'online',NULL,'2026-02-04 08:38:28'),(106,1,NULL,NULL,'online',NULL,'2026-02-04 08:39:12'),(107,1,NULL,NULL,'online',NULL,'2026-02-04 08:40:13'),(108,1,NULL,NULL,'online',NULL,'2026-02-04 08:43:03'),(109,1,NULL,NULL,'online',NULL,'2026-02-04 08:45:04'),(110,1,NULL,NULL,'online',NULL,'2026-02-04 08:46:04'),(111,1,NULL,NULL,'online',NULL,'2026-02-04 08:56:17'),(112,5,NULL,NULL,'online',NULL,'2026-02-04 08:57:18'),(113,5,NULL,NULL,'online',NULL,'2026-02-04 08:57:41'),(114,3,NULL,NULL,'online',NULL,'2026-02-04 08:58:13'),(115,3,NULL,NULL,'online',NULL,'2026-02-05 01:40:15'),(116,5,NULL,NULL,'online',NULL,'2026-02-05 01:41:28'),(117,1,NULL,NULL,'online',NULL,'2026-02-05 01:42:01'),(118,4,NULL,NULL,'online',NULL,'2026-02-05 01:59:54'),(119,6,NULL,NULL,'online',NULL,'2026-02-05 02:00:37'),(120,2,NULL,NULL,'online',NULL,'2026-02-05 02:01:53'),(121,2,NULL,NULL,'online',NULL,'2026-02-05 02:02:13'),(122,2,NULL,NULL,'online',NULL,'2026-02-05 02:03:14'),(123,4,NULL,NULL,'online',NULL,'2026-02-05 02:04:08'),(124,4,NULL,NULL,'online',NULL,'2026-02-05 02:05:09'),(125,2,NULL,NULL,'online',NULL,'2026-02-05 02:05:50'),(126,4,NULL,NULL,'online',NULL,'2026-02-05 03:34:24'),(127,1,NULL,NULL,'online',NULL,'2026-02-05 03:35:09'),(128,1,NULL,NULL,'online',NULL,'2026-02-05 03:36:10'),(129,1,NULL,NULL,'online',NULL,'2026-02-05 03:37:10'),(130,1,NULL,NULL,'online',NULL,'2026-02-05 03:38:10'),(131,1,NULL,NULL,'online',NULL,'2026-02-05 03:39:10'),(132,4,NULL,NULL,'online',NULL,'2026-02-05 03:40:10'),(133,4,NULL,NULL,'online',NULL,'2026-02-05 03:41:10'),(134,4,NULL,NULL,'online',NULL,'2026-02-05 03:42:11'),(135,4,NULL,NULL,'online',NULL,'2026-02-05 03:43:11'),(136,4,NULL,NULL,'online',NULL,'2026-02-05 03:44:11'),(137,4,NULL,NULL,'online',NULL,'2026-02-05 03:45:11'),(138,4,NULL,NULL,'online',NULL,'2026-02-05 03:46:11'),(139,4,NULL,NULL,'online',NULL,'2026-02-05 03:47:10'),(140,4,NULL,NULL,'online',NULL,'2026-02-05 03:48:11'),(141,4,NULL,NULL,'online',NULL,'2026-02-05 03:49:11'),(142,4,NULL,NULL,'online',NULL,'2026-02-05 03:50:10'),(143,4,NULL,NULL,'online',NULL,'2026-02-05 03:51:10'),(144,4,NULL,NULL,'online',NULL,'2026-02-05 03:52:11'),(145,4,NULL,NULL,'online',NULL,'2026-02-05 03:53:11'),(146,4,NULL,NULL,'online',NULL,'2026-02-05 03:54:11'),(147,4,NULL,NULL,'online',NULL,'2026-02-05 03:55:11'),(148,4,NULL,NULL,'online',NULL,'2026-02-05 03:56:11'),(149,4,NULL,NULL,'online',NULL,'2026-02-05 03:57:11'),(150,4,NULL,NULL,'online',NULL,'2026-02-05 03:58:11'),(151,4,NULL,NULL,'online',NULL,'2026-02-05 03:59:11'),(152,4,NULL,NULL,'online',NULL,'2026-02-05 04:00:11'),(153,5,NULL,NULL,'online',NULL,'2026-02-05 04:01:46');
/*!40000 ALTER TABLE `display_status_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `displays`
--

DROP TABLE IF EXISTS `displays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `displays` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `product_id` bigint unsigned DEFAULT NULL,
  `battery_level` tinyint unsigned DEFAULT NULL,
  `signal_strength` tinyint DEFAULT NULL,
  `last_seen_at` datetime DEFAULT NULL,
  `status` enum('online','offline','error') NOT NULL DEFAULT 'offline',
  `firmware_version` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_displays_code` (`code`),
  KEY `fk_displays_product` (`product_id`),
  CONSTRAINT `fk_displays_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `displays`
--

LOCK TABLES `displays` WRITE;
/*!40000 ALTER TABLE `displays` DISABLE KEYS */;
INSERT INTO `displays` VALUES (1,'D001','BOX 1','HUST',1,NULL,NULL,'2026-02-05 03:39:10','online',NULL,'2025-12-18 22:44:19','2026-02-05 03:39:10'),(2,'D002','BOX 2','Kệ Áo Mùa Đông',2,NULL,NULL,'2026-02-05 02:05:50','online',NULL,'2025-12-18 22:55:52','2026-02-05 02:05:50'),(3,'D003','BOX 3','Kệ Mũ',3,NULL,NULL,'2026-02-05 01:40:15','online',NULL,'2025-12-18 22:55:52','2026-02-05 01:40:15'),(4,'D004','BOX 4','Kệ Hàng Hot',4,NULL,NULL,'2026-02-05 04:00:11','online',NULL,'2025-12-18 22:55:52','2026-02-05 04:00:11'),(5,'D005','BOX 5','Kệ Balo',5,NULL,NULL,'2026-02-05 04:01:46','online',NULL,'2025-12-18 22:55:52','2026-02-05 04:01:46'),(6,'D006','BOX 6','Quầy Thu Ngân',6,NULL,NULL,'2026-02-05 02:00:37','online',NULL,'2025-12-18 22:55:52','2026-02-05 02:00:37');
/*!40000 ALTER TABLE `displays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'VND',
  `description` text,
  `image_url` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive','deleted') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_products_sku` (`sku`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'HUST UNIFORM','HUST T-SHIRT',7.00,'$','Hust Uniform Collection 2025','','active','2025-12-18 22:44:19','2025-12-18 22:44:19'),(2,'HUST-HOODIE','HUST HOODIE',15.00,'$','Winter Collection Warm','','active','2025-12-18 22:52:26','2025-12-18 22:55:40'),(3,'HUST-BAG','HUST BAG',5.00,'$','Red/White Standard','','active','2025-12-18 22:52:26','2025-12-18 22:55:40'),(4,'HUST-BOMBER','HUST BOMBER',25.00,'$','Limited Edition','','active','2025-12-18 22:52:26','2025-12-18 22:55:40'),(5,'HUST-BACKPACK','HUST PACK',12.00,'$','Laptop Friendly','','active','2025-12-18 22:52:26','2026-02-04 00:33:29'),(6,'HUST-MUG','HUST MUG',4.00,'$','Office Accessories','','active','2025-12-18 22:52:26','2025-12-18 22:55:40');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `key` varchar(64) NOT NULL,
  `value` varchar(255) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('active_display_code','D005','2026-02-05 11:00:38');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-09 22:38:58
