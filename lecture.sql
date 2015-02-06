-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: LECTURE
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
-- Table structure for table `lecture_link`
--

DROP TABLE IF EXISTS `lecture_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lecture_link` (
  `lecture_id` int(11) NOT NULL DEFAULT '0',
  `lecture_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`lecture_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lecture_link`
--

LOCK TABLES `lecture_link` WRITE;
/*!40000 ALTER TABLE `lecture_link` DISABLE KEYS */;
INSERT INTO `lecture_link` VALUES (1,'WC'),(2,'DSP'),(3,'ES'),(4,'PE'),(5,'MW'),(6,'CPD'),(7,'PROJECT'),(8,'DSP LAB'),(9,'MW LAB'),(10,'WC LAB'),(11,'PE LAB'),(12,'ES LAB');
/*!40000 ALTER TABLE `lecture_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prof_link`
--

DROP TABLE IF EXISTS `prof_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prof_link` (
  `prof_id` int(11) NOT NULL DEFAULT '0',
  `prof_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`prof_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prof_link`
--

LOCK TABLES `prof_link` WRITE;
/*!40000 ALTER TABLE `prof_link` DISABLE KEYS */;
INSERT INTO `prof_link` VALUES (1,'GF'),(2,'PP'),(3,'PJB'),(4,'UN'),(5,'ABU'),(6,'NDP'),(7,'SKR'),(8,'NJB'),(9,'MCS');
/*!40000 ALTER TABLE `prof_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timetable`
--

DROP TABLE IF EXISTS `timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timetable` (
  `id` int(11) NOT NULL DEFAULT '0',
  `day` int(11) DEFAULT NULL,
  `professor_id` int(11) DEFAULT NULL,
  `lec_id` int(11) DEFAULT NULL,
  `fromtime` varchar(20) DEFAULT NULL,
  `totime` varchar(20) DEFAULT NULL,
  `batch` varchar(5) DEFAULT NULL,
  `room` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `professor_id` (`professor_id`),
  KEY `lec_id` (`lec_id`),
  CONSTRAINT `timetable_ibfk_1` FOREIGN KEY (`professor_id`) REFERENCES `prof_link` (`prof_id`),
  CONSTRAINT `timetable_ibfk_2` FOREIGN KEY (`lec_id`) REFERENCES `lecture_link` (`lecture_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable`
--

LOCK TABLES `timetable` WRITE;
/*!40000 ALTER TABLE `timetable` DISABLE KEYS */;
INSERT INTO `timetable` VALUES (1,0,NULL,NULL,NULL,NULL,NULL,NULL),(2,2,1,1,'8:30','9:30','all',952),(3,2,1,2,'9:30','10:30','all',952),(4,2,2,3,'10:30','11:30','all',952),(5,2,3,2,'11:30','12:30','all',952),(6,2,4,1,'1:00','2:00','all',969),(7,2,2,3,'2:00','3:00','all',969),(8,2,NULL,6,'3:15','5:15','all',959),(9,3,1,4,'8:30','10:30','B1',970),(10,3,1,5,'8:30','10:30','B2',958),(11,3,1,1,'8:30','10:30','B3',960),(12,3,5,2,'8:30','10:30','B4',951),(13,3,6,4,'10:30','11:30','all',952),(14,3,7,1,'11:30','12:30','all',952),(15,3,7,1,'1:00','3:00','B1',960),(16,3,3,2,'1:00','3:00','B2',951),(17,3,6,4,'1:00','3:00','B3',970),(18,3,5,5,'1:00','3:00','B4',958),(19,3,2,3,'3:15','5:15','B3',953),(20,3,8,3,'3:15','5:15','B4',953),(21,4,1,2,'8:30','9:30','all',952),(22,4,1,5,'9:30','10:30','all',969),(23,4,NULL,6,'10:30','12:30','all',952),(24,4,5,5,'1:00','3:00','B1',958),(25,4,7,1,'1:00','3:00','B2',960),(26,4,3,2,'1:00','3:00','B3',951),(27,4,1,4,'1:00','3:00','B4',970),(28,4,3,2,'3:15','5:15','B1',951),(29,4,1,4,'3:15','5:15','B2',970),(30,4,1,5,'3:15','5:15','B3',958),(31,4,1,1,'3:15','5:15','B4',960),(32,5,1,5,'8:30','9:30','all',952),(33,5,8,3,'9:30','10:30','all',952),(34,5,6,4,'10:30','11:30','all',952),(35,5,7,1,'11:30','12:30','all',952),(36,5,3,2,'1:00','2:00','all',959),(37,5,9,5,'2:00','3:00','all',959),(38,5,2,3,'3:15','5:15','B1',951),(39,5,8,3,'3:15','5:15','B2',951),(40,1,NULL,7,'8:30','5:15',NULL,NULL),(41,6,NULL,7,'8:30','5:15',NULL,NULL);
/*!40000 ALTER TABLE `timetable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-10 19:09:26
