-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: project
-- ------------------------------------------------------
-- Server version	5.5.38-0ubuntu0.14.04.1

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
-- Table structure for table `friday`
--

DROP TABLE IF EXISTS `friday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friday` (
  `id` int(11) NOT NULL,
  `lecture_name` varchar(20) DEFAULT NULL,
  `faculty_name` varchar(20) DEFAULT NULL,
  `room_num` int(11) DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friday`
--

LOCK TABLES `friday` WRITE;
/*!40000 ALTER TABLE `friday` DISABLE KEYS */;
INSERT INTO `friday` VALUES (1,'MW','GF',952,'8:30 TO 9:30'),(2,'ES','NJB',952,'9:30 TO 10:30'),(3,'PE','NDP',952,'10:30 TO 11:30'),(4,'WC','SKR',952,'11:30 TO 12:30'),(5,'DSP','PJB',959,'1:00 TO 2:00'),(6,'MW','MCS',959,'2:00 TO 3:00'),(7,'ES-B1','PPP',951,'3:15 TO 5:15'),(8,'ES-B2','NJB',951,'3:15 TO 5:15');
/*!40000 ALTER TABLE `friday` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thursday`
--

DROP TABLE IF EXISTS `thursday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `thursday` (
  `id` int(11) NOT NULL,
  `lecture_name` varchar(20) DEFAULT NULL,
  `faculty_name` varchar(20) DEFAULT NULL,
  `room_num` int(11) DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thursday`
--

LOCK TABLES `thursday` WRITE;
/*!40000 ALTER TABLE `thursday` DISABLE KEYS */;
INSERT INTO `thursday` VALUES (1,'DSP','GF',952,'8:30 TO 9:30'),(2,'MW','GF',969,'9:30 TO 10:30'),(3,'CPD','',952,'10:30 TO 12:30'),(4,'MW-B1','ABU',958,'1:00 TO 3:00'),(5,'WC-B2','SKR',960,'1:00 TO 3:00'),(6,'DSP-B3','PJB',951,'1:00 TO 3:00'),(7,'PE-B4','GF',970,'1:00 TO 3:00'),(8,'DSP-B1','PJB',951,'3:15 TO 5:15'),(9,'PE-B2','GF',970,'3:15 TO 5:15'),(10,'MW-B3','GF',958,'3:15 TO 5:15'),(11,'WC-B4','GF',960,'3:15 TO 5:15');
/*!40000 ALTER TABLE `thursday` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tuesday`
--

DROP TABLE IF EXISTS `tuesday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tuesday` (
  `id` int(11) NOT NULL DEFAULT '0',
  `lecture_name` varchar(20) DEFAULT NULL,
  `faculty_name` varchar(20) DEFAULT NULL,
  `room_num` int(11) DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tuesday`
--

LOCK TABLES `tuesday` WRITE;
/*!40000 ALTER TABLE `tuesday` DISABLE KEYS */;
INSERT INTO `tuesday` VALUES (1,'WC','GF',952,'8:30 TO 9:30'),(2,'DSP','GF',952,'9:30 TO 10:30'),(3,'ES','PPP',952,'10:30 TO 11:30'),(4,'DSP','PJB',952,'11:30 TO 12:30'),(5,'WC','UN',969,'1:00 TO 2:00'),(6,'ES','PPP',969,'2:00 TO 3:00'),(7,'CPD','',959,'3:15 TO 5:15');
/*!40000 ALTER TABLE `tuesday` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wednesday`
--

DROP TABLE IF EXISTS `wednesday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wednesday` (
  `id` int(11) NOT NULL,
  `lecture_name` varchar(20) DEFAULT NULL,
  `faculty_name` varchar(20) DEFAULT NULL,
  `room_num` int(11) DEFAULT NULL,
  `time` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wednesday`
--

LOCK TABLES `wednesday` WRITE;
/*!40000 ALTER TABLE `wednesday` DISABLE KEYS */;
INSERT INTO `wednesday` VALUES (1,'PE-B1','GF',970,'8:30 TO 10:30'),(2,'MW-B2','GF',958,'8:30 TO 10:30'),(3,'WC-B3','GF',960,'8:30 TO 10:30'),(4,'DSP-B4','ABU',951,'8:30 TO 10:30'),(5,'PE','NDP',952,'10:30 TO 11:30'),(6,'WC','SKR',952,'11:30 TO 12:30'),(7,'WC-B1','SKR',960,'1:00 TO 3:00'),(8,'DSP-B2','PJB',951,'1:00 TO 3:00'),(9,'PE-B3','NDP',970,'1:00 TO 3:00'),(10,'MW-B4','ABU',958,'1:00 TO 3:00'),(11,'ES-B3','PPP',953,'3:15 TO 5:15'),(12,'ES-B4','NJB',953,'3:15 TO 5:15');
/*!40000 ALTER TABLE `wednesday` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-10 19:32:35
