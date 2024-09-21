CREATE DATABASE  IF NOT EXISTS `drylandapp` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `drylandapp`;
-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: drylandapp
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `birdnestingsites`
--

DROP TABLE IF EXISTS `birdnestingsites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `birdnestingsites` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Level` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `birdnestingsites`
--

LOCK TABLES `birdnestingsites` WRITE;
/*!40000 ALTER TABLE `birdnestingsites` DISABLE KEYS */;
INSERT INTO `birdnestingsites` VALUES (1,'Very Poor',0),(2,'Poor',1),(3,'Average',3),(4,'Good',5);
/*!40000 ALTER TABLE `birdnestingsites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `canopy`
--

DROP TABLE IF EXISTS `canopy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `canopy` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CanopySize` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `canopy`
--

LOCK TABLES `canopy` WRITE;
/*!40000 ALTER TABLE `canopy` DISABLE KEYS */;
INSERT INTO `canopy` VALUES (1,'None',0),(2,'Low',1),(3,'Low/Med',2),(4,'Med',3),(5,'Med/High',4),(6,'High',5);
/*!40000 ALTER TABLE `canopy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conservationthreat`
--

DROP TABLE IF EXISTS `conservationthreat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conservationthreat` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ConservationThreatStatus` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conservationthreat`
--

LOCK TABLES `conservationthreat` WRITE;
/*!40000 ALTER TABLE `conservationthreat` DISABLE KEYS */;
INSERT INTO `conservationthreat` VALUES (1,'Not Threatened',0),(2,'At Risk – Naturally Uncommon',1),(3,'At Risk – Relict ',2),(4,'At Risk – Recovering',3),(5,'At Risk – Declining',4),(6,'Threatened - Nationally Increasing',5),(7,'Threatened – Nationally Vulnerable',6),(8,'Threatened – Nationally Endangered',7),(9,'Threatened – Nationally Critical',8);
/*!40000 ALTER TABLE `conservationthreat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `defoliation`
--

DROP TABLE IF EXISTS `defoliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `defoliation` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ToleranceToDefoliation` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `defoliation`
--

LOCK TABLES `defoliation` WRITE;
/*!40000 ALTER TABLE `defoliation` DISABLE KEYS */;
INSERT INTO `defoliation` VALUES (1,'Low',1),(2,'Low/Med',2),(3,'Med',3),(4,'Med/High',4),(5,'High',5);
/*!40000 ALTER TABLE `defoliation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `droughttolerance`
--

DROP TABLE IF EXISTS `droughttolerance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `droughttolerance` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DroughtTolerance` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `droughttolerance`
--

LOCK TABLES `droughttolerance` WRITE;
/*!40000 ALTER TABLE `droughttolerance` DISABLE KEYS */;
INSERT INTO `droughttolerance` VALUES (1,'Low',1),(2,'Low/Med',2),(3,'Med',3),(4,'Med/High',4),(5,'High',5);
/*!40000 ALTER TABLE `droughttolerance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `User` int NOT NULL,
  `Plant` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `User_idx` (`User`),
  KEY `Plant_idx` (`Plant`),
  CONSTRAINT `Plant` FOREIGN KEY (`Plant`) REFERENCES `plantdetail` (`ID`),
  CONSTRAINT `User` FOREIGN KEY (`User`) REFERENCES `user` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flammability`
--

DROP TABLE IF EXISTS `flammability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flammability` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Flammability` varchar(255) NOT NULL,
  `Score` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flammability`
--

LOCK TABLES `flammability` WRITE;
/*!40000 ALTER TABLE `flammability` DISABLE KEYS */;
INSERT INTO `flammability` VALUES (1,'High','1'),(2,'Mod/High','2'),(3,'Moderate','3'),(4,'Low/Mod','4'),(5,'Low','5');
/*!40000 ALTER TABLE `flammability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foodsources`
--

DROP TABLE IF EXISTS `foodsources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodsources` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SourceQuantity` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foodsources`
--

LOCK TABLES `foodsources` WRITE;
/*!40000 ALTER TABLE `foodsources` DISABLE KEYS */;
INSERT INTO `foodsources` VALUES (1,'One',1),(2,'Two',2),(3,'Three',3),(4,'Four',4),(5,'Five',5);
/*!40000 ALTER TABLE `foodsources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `frosttolerance`
--

DROP TABLE IF EXISTS `frosttolerance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `frosttolerance` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FrostTolerance` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frosttolerance`
--

LOCK TABLES `frosttolerance` WRITE;
/*!40000 ALTER TABLE `frosttolerance` DISABLE KEYS */;
INSERT INTO `frosttolerance` VALUES (1,'Low',1),(2,'Low/Med',2),(3,'Med',3),(4,'Med/High',4),(5,'High',5);
/*!40000 ALTER TABLE `frosttolerance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `growthrate`
--

DROP TABLE IF EXISTS `growthrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `growthrate` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `GrowthRate` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `growthrate`
--

LOCK TABLES `growthrate` WRITE;
/*!40000 ALTER TABLE `growthrate` DISABLE KEYS */;
INSERT INTO `growthrate` VALUES (1,'Slow',1),(2,'Slow/Med',2),(3,'Med',3),(4,'Fast/Med',4),(5,'Fast',5);
/*!40000 ALTER TABLE `growthrate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `height`
--

DROP TABLE IF EXISTS `height`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `height` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PlantHeight (m)` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `height`
--

LOCK TABLES `height` WRITE;
/*!40000 ALTER TABLE `height` DISABLE KEYS */;
INSERT INTO `height` VALUES (1,'<1',0),(2,'1-2m',1),(3,'2-5m',2),(4,'5-10m',3),(5,'10-15m',4),(6,'15<',5);
/*!40000 ALTER TABLE `height` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `palatability`
--

DROP TABLE IF EXISTS `palatability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `palatability` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Level` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `palatability`
--

LOCK TABLES `palatability` WRITE;
/*!40000 ALTER TABLE `palatability` DISABLE KEYS */;
INSERT INTO `palatability` VALUES (1,'Plain',0),(2,'Low',1),(3,'Low/Med',2),(4,'Med',3),(5,'Med/High',4),(6,'High',5);
/*!40000 ALTER TABLE `palatability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantattribute`
--

DROP TABLE IF EXISTS `plantattribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantattribute` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PlantID` int NOT NULL,
  `ConservationThreatStatus` int NOT NULL,
  `Palatability` int NOT NULL,
  `Defoliation` int NOT NULL,
  `GrowthRate` int NOT NULL,
  `ToxicParts` int NOT NULL,
  `Height` int NOT NULL,
  `Shade` int NOT NULL,
  `Shelter` int NOT NULL,
  `Canopy` int NOT NULL,
  `FoodSources` int NOT NULL,
  `BirdNestingSites` int NOT NULL,
  `DroughtTolerance` int NOT NULL,
  `FrostTolerance` int NOT NULL,
  `WindTolerance` int NOT NULL,
  `SaltTolerance` int NOT NULL,
  `SunPreferences` int NOT NULL,
  `SoilDrainage` int NOT NULL,
  `SoilDepth` int NOT NULL,
  `SoilMoisture` int NOT NULL,
  `SoilType` int NOT NULL,
  `Wetland` int NOT NULL,
  `Flammability` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PlantID_idx` (`PlantID`),
  KEY `ConservationThreatStatus_idx` (`ConservationThreatStatus`),
  KEY `Palatability_idx` (`Palatability`),
  KEY `Defoliation_idx` (`Defoliation`),
  KEY `GrowthRate_idx` (`GrowthRate`),
  KEY `ToxicParts_idx` (`ToxicParts`),
  KEY `Height_idx` (`Height`),
  KEY `Shade_idx` (`Shade`),
  KEY `Shelter_idx` (`Shelter`),
  KEY `Canopy_idx` (`Canopy`),
  KEY `FoodSources_idx` (`FoodSources`),
  KEY `BirdNestingSites_idx` (`BirdNestingSites`),
  KEY `DroughtTolerance_idx` (`DroughtTolerance`),
  KEY `FrostTolerance_idx` (`FrostTolerance`),
  KEY `WindTolerance_idx` (`WindTolerance`),
  KEY `SaltTolerance_idx` (`SaltTolerance`),
  KEY `SunPreferences_idx` (`SunPreferences`),
  KEY `SoilDrainage_idx` (`SoilDrainage`),
  KEY `SoilDepth_idx` (`SoilDepth`),
  KEY `SoilMoisture_idx` (`SoilMoisture`),
  KEY `SoilType_idx` (`SoilType`),
  KEY `Wetland_idx` (`Wetland`),
  KEY `Flammability_idx` (`Flammability`),
  CONSTRAINT `BirdNestingSites` FOREIGN KEY (`BirdNestingSites`) REFERENCES `birdnestingsites` (`ID`),
  CONSTRAINT `Canopy` FOREIGN KEY (`Canopy`) REFERENCES `canopy` (`ID`),
  CONSTRAINT `ConservationThreatStatus` FOREIGN KEY (`ConservationThreatStatus`) REFERENCES `conservationthreat` (`ID`),
  CONSTRAINT `Defoliation` FOREIGN KEY (`Defoliation`) REFERENCES `defoliation` (`ID`),
  CONSTRAINT `DroughtTolerance` FOREIGN KEY (`DroughtTolerance`) REFERENCES `droughttolerance` (`ID`),
  CONSTRAINT `Flammability` FOREIGN KEY (`Flammability`) REFERENCES `flammability` (`ID`),
  CONSTRAINT `FoodSources` FOREIGN KEY (`FoodSources`) REFERENCES `foodsources` (`ID`),
  CONSTRAINT `FrostTolerance` FOREIGN KEY (`FrostTolerance`) REFERENCES `frosttolerance` (`ID`),
  CONSTRAINT `GrowthRate` FOREIGN KEY (`GrowthRate`) REFERENCES `growthrate` (`ID`),
  CONSTRAINT `Height` FOREIGN KEY (`Height`) REFERENCES `height` (`ID`),
  CONSTRAINT `Palatability` FOREIGN KEY (`Palatability`) REFERENCES `palatability` (`ID`),
  CONSTRAINT `PlantID` FOREIGN KEY (`PlantID`) REFERENCES `plantdetail` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `SaltTolerance` FOREIGN KEY (`SaltTolerance`) REFERENCES `salttolerance` (`ID`),
  CONSTRAINT `Shade` FOREIGN KEY (`Shade`) REFERENCES `shade` (`ID`),
  CONSTRAINT `Shelter` FOREIGN KEY (`Shelter`) REFERENCES `shelter` (`ID`),
  CONSTRAINT `SoilDepth` FOREIGN KEY (`SoilDepth`) REFERENCES `soildepth` (`ID`),
  CONSTRAINT `SoilDrainage` FOREIGN KEY (`SoilDrainage`) REFERENCES `soildrainage` (`ID`),
  CONSTRAINT `SoilMoisture` FOREIGN KEY (`SoilMoisture`) REFERENCES `soilmoisture` (`ID`),
  CONSTRAINT `SoilType` FOREIGN KEY (`SoilType`) REFERENCES `soiltype` (`ID`),
  CONSTRAINT `SunPreferences` FOREIGN KEY (`SunPreferences`) REFERENCES `sunpreference` (`ID`),
  CONSTRAINT `ToxicParts` FOREIGN KEY (`ToxicParts`) REFERENCES `toxicparts` (`ID`),
  CONSTRAINT `Wetland` FOREIGN KEY (`Wetland`) REFERENCES `wetland` (`ID`),
  CONSTRAINT `WindTolerance` FOREIGN KEY (`WindTolerance`) REFERENCES `windtolerance` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantattribute`
--

LOCK TABLES `plantattribute` WRITE;
/*!40000 ALTER TABLE `plantattribute` DISABLE KEYS */;
INSERT INTO `plantattribute` VALUES (1,1,1,6,4,4,1,1,1,1,1,3,2,5,5,3,1,3,6,3,5,4,5,4),(2,2,5,5,4,3,1,1,1,1,1,1,2,5,5,5,4,5,6,2,6,3,6,2),(3,3,7,2,1,1,1,6,6,6,2,5,4,4,2,4,1,5,4,5,5,7,1,3),(4,4,1,1,5,3,2,4,6,4,4,2,4,3,1,5,3,5,6,5,3,4,1,5),(5,5,3,3,3,4,1,2,1,1,2,1,2,2,5,5,1,5,4,1,5,7,1,4),(6,6,1,2,5,1,1,2,1,1,1,1,2,5,5,5,5,5,2,1,4,7,3,4),(7,7,1,6,4,2,1,3,1,2,2,3,2,5,5,3,1,5,5,3,5,7,1,5),(8,8,1,6,4,4,1,5,3,4,5,3,3,1,4,2,1,3,3,4,2,6,5,4),(9,9,1,6,3,3,1,1,1,1,1,1,2,1,1,1,1,2,4,1,3,3,6,5),(10,10,1,6,1,3,1,2,1,1,2,2,2,3,1,3,1,2,4,1,3,2,5,4),(11,11,1,2,2,3,1,3,2,4,2,2,2,3,5,5,3,5,5,2,1,7,4,2),(12,12,1,4,4,4,1,2,1,1,1,1,2,2,5,5,4,5,1,1,1,1,2,4),(13,13,1,2,1,1,1,6,6,6,6,2,4,1,1,1,1,3,2,5,1,4,6,4),(14,14,1,5,1,3,1,1,1,1,1,1,2,5,3,5,1,3,6,1,3,1,5,5),(15,15,1,5,1,3,1,1,1,1,1,1,2,5,3,3,1,3,2,1,1,1,3,5),(16,16,1,5,1,3,1,1,1,1,1,1,2,3,3,3,3,3,2,1,2,1,4,5),(17,17,9,6,1,3,1,1,1,1,1,2,2,5,5,5,1,5,6,1,5,3,1,4),(18,18,1,2,3,3,1,1,1,1,1,2,2,5,2,5,3,4,6,1,3,3,4,5),(19,19,1,2,5,5,1,1,1,1,1,2,2,5,3,5,5,5,6,1,6,5,6,4),(20,20,1,2,5,3,1,1,1,1,1,1,2,5,3,5,1,5,6,1,3,1,1,1),(21,21,5,2,5,5,1,1,1,1,1,3,2,5,3,5,4,5,4,1,2,4,4,5),(22,22,1,2,5,5,1,1,1,1,1,1,2,5,5,5,4,4,6,1,3,1,4,1),(23,23,1,2,5,3,1,1,1,1,1,1,2,5,5,5,1,4,4,1,3,1,5,5),(24,24,1,2,5,3,1,1,1,1,1,1,2,5,5,5,1,4,4,1,3,1,3,5),(25,25,5,2,5,3,1,1,1,1,1,1,2,5,5,5,4,4,4,1,3,1,2,2),(26,26,1,2,5,3,1,1,1,1,1,1,2,5,5,5,4,4,4,1,3,1,2,1),(27,27,1,2,5,5,1,1,1,1,1,1,2,3,5,5,5,4,4,1,3,1,2,1),(28,28,1,2,5,5,1,1,1,1,1,1,2,4,5,5,3,4,4,1,3,1,3,2),(29,29,1,5,2,3,1,3,1,1,2,3,2,5,5,5,2,5,6,2,4,5,5,4),(30,30,5,5,2,3,1,3,2,1,2,3,2,5,5,5,1,5,6,3,4,5,5,2),(31,31,7,5,2,1,1,1,1,1,1,3,2,5,5,5,1,5,6,1,6,5,1,4),(32,32,7,6,2,3,1,3,1,1,1,3,2,4,5,5,2,5,2,1,6,5,1,4),(33,33,9,5,3,3,1,4,2,1,2,3,2,4,4,4,1,5,6,3,4,5,1,4),(34,34,1,4,4,3,1,5,2,4,4,4,4,4,3,5,1,5,4,4,1,4,5,5),(35,35,1,4,3,3,1,2,1,2,2,1,2,5,5,5,3,5,4,1,3,4,1,1),(36,36,1,4,4,3,1,2,1,2,1,1,2,5,3,5,1,4,6,1,4,2,1,5),(37,37,1,4,5,3,1,2,1,2,1,2,2,3,3,3,2,4,6,1,3,2,6,5),(38,38,9,5,1,4,1,3,1,2,2,2,2,4,3,3,3,4,6,2,6,3,1,4),(39,39,5,4,4,1,1,3,2,2,2,3,2,4,4,5,3,5,6,2,5,3,6,4),(40,40,1,4,3,3,1,3,2,3,3,3,2,5,5,5,2,4,6,2,4,3,5,4),(41,41,1,4,4,3,1,3,2,3,2,3,2,5,5,5,3,5,2,3,5,3,1,4),(42,42,1,4,3,4,1,2,1,2,2,3,2,5,5,5,3,5,5,3,2,3,4,4),(43,43,1,6,2,5,1,4,3,3,4,3,2,1,5,5,4,3,2,4,5,7,5,5),(44,44,5,4,4,3,1,3,2,3,2,3,2,4,4,5,2,5,6,1,4,5,6,4),(45,45,1,4,4,3,1,4,3,4,2,3,2,2,2,5,1,5,5,3,4,5,6,4),(46,46,1,6,3,3,1,4,2,4,3,3,2,3,3,3,3,5,5,3,5,7,5,4),(47,47,1,3,3,4,1,3,2,3,2,3,2,3,4,5,3,2,6,1,5,3,1,4),(48,48,7,3,3,5,1,3,2,3,3,3,2,4,5,5,5,2,6,2,4,3,5,4),(49,49,5,4,4,3,1,4,3,4,2,3,2,2,4,2,1,5,2,3,1,4,3,4),(50,50,1,4,3,4,1,4,2,4,2,3,2,5,5,5,5,5,5,2,4,7,4,5),(51,51,1,5,5,3,1,4,2,4,4,3,2,3,3,5,5,3,5,2,5,3,1,5),(52,52,1,3,5,3,1,2,2,2,2,3,2,5,5,5,3,5,6,1,6,3,6,4),(53,53,1,4,3,3,1,2,2,3,2,3,2,3,3,3,3,3,5,1,2,6,4,4),(54,54,1,6,3,4,1,4,2,4,3,3,2,3,3,3,3,3,5,2,5,3,5,5),(55,55,1,4,4,3,1,4,2,4,4,3,2,3,3,5,1,4,2,2,5,3,4,4),(56,56,1,4,4,3,1,3,3,3,3,3,2,2,4,4,2,4,6,2,6,5,1,4),(57,57,1,3,3,3,1,3,2,3,2,3,2,5,5,5,4,5,6,2,6,6,5,4),(58,58,5,4,3,5,1,3,2,3,2,3,2,5,4,5,1,5,6,2,5,3,6,4),(59,59,5,4,4,3,1,3,2,3,2,3,2,2,4,5,1,5,5,2,1,7,1,4),(60,60,1,4,5,3,1,5,3,5,3,4,4,5,5,5,3,3,4,4,4,7,4,4),(61,61,1,1,4,4,3,4,2,3,3,3,2,3,3,3,1,4,5,4,5,7,6,4),(62,62,1,4,4,4,1,3,2,4,2,3,2,5,5,5,3,5,5,2,5,7,6,4),(63,63,1,4,3,3,2,5,4,5,4,2,4,3,1,5,5,5,4,5,5,7,6,5),(64,64,1,3,4,1,1,1,1,1,1,3,2,5,3,5,5,5,1,1,1,1,3,5),(65,65,1,2,3,1,1,3,2,2,2,2,2,5,5,5,1,4,4,1,2,7,1,5),(66,66,1,5,3,3,1,4,2,2,3,2,3,3,5,5,1,3,2,1,5,1,5,2),(67,67,1,6,4,5,1,3,1,1,1,2,2,4,5,5,5,4,2,2,1,1,3,3),(68,68,1,2,3,1,1,6,6,6,6,3,4,1,4,5,1,5,5,5,3,6,4,3),(69,69,1,2,3,1,1,6,6,6,6,2,4,1,1,3,3,1,4,5,2,3,5,2),(70,70,5,5,1,3,1,1,1,1,1,3,2,5,5,5,5,5,6,1,6,5,1,1),(71,71,5,3,4,3,1,3,2,4,3,2,2,5,5,5,3,4,6,1,5,6,6,1),(72,72,1,3,2,5,1,1,1,1,1,2,2,4,1,5,5,5,6,1,6,1,6,5),(73,73,1,2,3,5,1,4,5,5,4,3,3,5,2,5,5,4,6,1,5,5,1,2),(74,74,1,4,2,5,1,1,1,1,1,3,2,3,2,5,5,5,1,1,1,1,2,5),(75,75,1,5,4,3,1,6,6,5,6,1,4,4,2,5,5,4,6,4,3,6,1,5),(76,76,1,4,4,3,1,6,6,6,6,4,4,1,5,5,1,4,2,4,2,6,1,5),(77,77,1,4,3,3,1,5,6,5,5,3,4,3,2,5,1,4,6,4,5,6,4,5),(78,78,1,6,4,5,1,1,1,1,1,1,2,5,3,5,4,4,6,1,3,6,1,4),(79,79,5,6,1,3,1,2,1,1,1,2,2,5,5,5,5,5,6,1,6,5,1,4),(80,80,1,6,1,3,1,1,1,1,1,1,2,1,1,1,3,3,2,1,2,7,1,4),(81,81,1,6,4,3,1,1,1,1,1,1,2,5,5,5,2,5,6,1,5,6,6,4),(82,82,1,6,4,3,1,5,4,5,5,3,3,4,5,5,2,4,5,4,4,6,5,5),(83,83,1,6,3,3,1,5,6,6,5,2,4,2,5,5,3,4,5,4,4,4,4,4),(84,84,1,6,3,3,1,6,6,6,6,2,4,2,5,5,1,4,4,5,1,4,5,4),(85,85,1,6,5,3,1,6,6,6,6,2,4,5,5,5,2,4,5,5,5,4,1,4),(86,86,1,6,5,5,1,3,2,3,3,2,4,3,1,3,1,4,6,2,3,6,5,5),(87,87,1,6,3,3,1,4,5,4,6,5,3,5,3,5,5,4,5,3,4,3,5,5),(88,88,1,6,3,5,1,4,5,5,4,5,2,5,5,5,5,4,5,3,4,3,1,5),(89,89,1,3,3,5,1,5,5,5,5,3,4,2,5,3,1,4,2,4,1,5,6,4),(90,90,1,3,4,3,1,3,2,3,2,3,2,5,5,5,1,4,6,2,4,3,1,4),(91,91,1,5,4,3,1,1,1,1,1,1,2,5,1,4,3,5,1,4,3,5,4,4),(92,92,1,4,4,3,1,5,6,5,4,3,4,4,5,5,3,4,5,5,4,7,5,4),(93,93,1,4,3,3,1,4,6,5,4,4,4,3,3,3,1,4,6,4,5,6,1,4),(94,94,1,5,4,5,1,4,6,4,4,4,4,3,3,3,1,4,6,4,4,6,5,4),(95,95,1,5,4,5,1,1,1,1,1,1,2,3,3,3,1,4,5,4,4,7,6,5),(96,96,1,4,3,3,1,1,1,1,1,1,2,1,5,5,5,3,1,1,2,1,3,4),(97,97,1,4,3,3,1,1,1,1,1,1,2,1,5,5,5,3,1,1,2,1,3,4),(98,98,1,4,3,3,1,1,1,1,1,1,2,5,5,5,5,5,6,1,2,1,3,4),(99,99,1,4,4,1,1,6,6,6,6,2,4,1,1,5,1,4,6,5,5,6,6,4),(100,100,7,2,3,3,1,4,3,4,4,4,4,5,5,5,1,4,6,4,5,6,1,1),(101,101,7,2,3,3,1,4,3,2,4,4,4,5,3,5,1,5,6,3,5,6,1,1),(102,102,1,3,3,5,1,1,1,1,1,4,2,5,5,5,5,1,6,1,4,7,4,5),(103,103,9,3,3,5,1,1,1,1,1,4,2,5,5,5,5,1,2,1,4,7,1,5),(104,104,5,3,3,5,1,1,1,1,1,4,2,5,5,5,5,1,6,1,6,7,1,5),(105,105,1,3,3,3,1,1,1,1,1,4,2,5,5,5,5,1,6,1,6,7,4,5),(106,106,5,2,3,3,1,3,3,4,4,2,3,5,5,5,1,4,4,3,5,7,4,1),(107,107,1,2,3,5,1,1,1,1,1,1,2,1,3,5,3,5,1,1,1,1,2,4),(108,108,9,4,4,3,1,4,3,3,4,3,3,5,1,5,1,4,5,3,5,2,5,4),(109,109,1,3,3,3,1,6,6,6,6,1,4,5,5,5,1,4,5,5,3,7,5,4),(110,110,8,2,3,3,1,1,3,1,1,1,2,5,5,3,4,4,6,1,2,5,3,5),(111,111,1,2,3,1,1,3,3,3,3,2,2,5,1,5,1,3,2,2,4,7,1,4),(112,112,1,2,3,5,1,4,4,4,4,3,3,4,2,4,1,5,6,2,4,3,1,4),(113,113,1,3,3,1,1,2,1,3,2,3,2,5,5,5,3,5,6,2,5,3,5,4),(114,114,1,5,3,3,1,4,4,3,4,4,3,1,5,3,3,4,2,2,1,3,1,4),(115,115,1,5,3,3,1,6,4,5,5,3,4,3,3,3,1,4,5,4,2,6,5,4),(116,116,7,2,3,2,1,5,5,6,5,3,4,1,2,5,5,4,6,4,5,6,1,4),(117,117,7,5,1,1,1,6,5,6,6,2,4,1,3,5,5,4,5,4,3,6,6,3),(118,118,1,6,5,3,1,1,1,1,1,2,2,1,1,2,1,4,2,1,5,7,1,4),(119,119,1,5,4,1,1,1,1,1,1,2,2,4,3,4,3,4,6,1,5,3,6,5),(120,120,2,2,1,3,1,1,1,1,1,2,2,1,5,5,5,5,1,1,1,1,2,1),(121,121,7,2,4,3,1,3,2,3,3,3,2,5,5,5,4,5,5,3,5,7,1,4),(122,122,1,2,3,3,1,1,2,1,2,3,2,4,5,5,1,5,5,2,5,7,1,4),(123,123,1,2,4,3,1,3,2,3,3,3,2,5,5,5,5,3,5,2,5,7,5,4),(124,124,7,4,4,5,1,1,2,1,2,3,2,5,4,5,5,5,6,1,1,5,1,4),(125,125,1,1,4,5,2,4,4,4,4,3,4,5,5,5,5,4,5,4,5,6,6,4),(126,126,1,5,4,3,1,4,2,3,4,3,3,3,5,5,2,4,5,3,5,6,5,4),(127,127,1,4,4,1,1,4,2,3,3,3,2,2,3,5,1,5,5,2,3,7,4,4),(128,128,9,2,3,3,1,4,4,3,4,3,3,5,5,5,4,4,5,4,2,7,4,4),(129,129,9,4,1,3,1,3,1,4,2,4,2,5,5,5,3,5,6,2,6,3,1,4),(130,130,1,3,4,3,1,3,2,4,3,4,3,5,5,5,4,5,5,4,5,3,1,4),(131,131,1,4,4,3,1,3,3,4,2,4,2,4,4,4,1,5,4,2,2,7,3,4),(132,132,5,4,3,3,1,4,4,4,3,4,3,2,4,5,4,5,6,2,6,7,1,4),(133,133,8,3,4,3,1,4,3,4,4,4,2,4,4,4,1,5,6,4,3,6,1,4),(134,134,5,4,3,3,1,3,2,4,3,4,2,4,4,4,1,5,5,3,5,4,5,4),(135,135,1,5,4,3,1,3,3,4,3,4,2,4,4,4,1,5,6,2,6,3,1,4),(136,136,1,3,4,3,1,3,3,4,4,4,3,4,3,5,4,5,5,4,5,7,1,4),(137,137,1,4,4,5,1,3,3,3,4,3,2,5,5,5,5,5,5,1,4,6,5,4),(138,138,1,2,4,3,1,3,2,3,2,2,2,5,5,5,3,5,6,3,5,5,5,3),(139,139,1,4,4,3,1,5,5,4,4,3,3,5,5,5,3,5,5,1,5,5,5,4),(140,140,1,4,4,3,1,5,5,4,4,3,3,1,1,5,1,5,4,1,5,5,1,4),(141,141,1,4,3,3,1,5,3,4,4,2,2,3,3,5,4,5,4,2,2,4,1,4),(142,142,1,4,3,3,1,3,2,2,2,3,2,5,5,5,5,4,5,2,4,6,5,2),(143,143,1,4,3,3,1,3,2,3,2,3,2,3,5,5,4,4,5,1,4,7,3,2),(144,144,1,3,4,3,1,6,5,5,5,3,4,1,1,5,1,4,5,5,5,3,1,4),(145,145,1,3,3,3,1,3,4,3,3,2,3,3,1,5,5,4,5,3,3,6,6,5),(146,146,1,2,3,3,1,4,5,4,4,4,3,3,3,5,5,4,5,4,5,3,1,4),(147,147,1,4,3,5,1,5,5,6,5,4,3,3,3,3,1,3,5,4,3,3,1,4),(148,148,1,4,3,5,1,4,5,5,4,4,3,4,5,3,1,4,5,4,5,3,5,3),(149,149,1,3,3,3,1,3,2,2,3,3,2,4,4,5,5,4,4,2,4,7,3,4),(150,150,1,4,1,4,1,5,6,5,4,2,4,3,5,5,3,4,5,5,4,7,5,4),(151,151,1,6,5,3,1,1,1,1,2,3,2,5,5,5,3,4,6,1,6,7,5,4),(152,152,1,6,4,3,1,1,1,1,2,2,2,5,5,5,3,5,5,1,5,7,1,4),(153,153,1,2,3,1,1,6,6,6,6,2,4,5,5,5,1,4,4,5,5,6,5,4),(154,154,1,2,3,1,1,6,6,6,6,2,4,5,5,5,1,4,5,5,5,7,5,2),(155,155,1,5,4,3,1,1,1,1,1,1,2,3,3,5,1,4,5,1,5,7,1,5),(156,156,1,4,4,3,1,1,1,1,2,1,2,1,3,1,1,1,2,1,2,7,5,4),(157,157,9,6,4,3,1,3,2,3,3,5,2,5,5,5,5,5,5,1,2,6,1,4),(158,158,1,2,3,1,1,6,6,6,6,2,4,5,5,4,1,4,5,5,3,6,5,4),(159,159,1,2,3,1,1,6,6,6,6,3,4,3,4,5,1,1,5,5,5,7,1,3),(160,160,1,6,3,3,1,4,4,4,4,5,4,3,3,3,2,3,5,4,3,7,6,5),(161,161,1,5,3,3,1,4,4,4,4,5,4,5,5,4,1,4,4,4,3,6,6,4),(162,162,1,6,1,3,1,5,2,4,4,5,2,3,3,5,3,3,5,4,5,7,5,5),(163,163,2,5,1,1,1,4,2,4,3,5,2,5,5,5,1,3,5,4,5,7,6,4),(164,164,1,2,3,1,1,4,4,4,4,2,3,1,5,5,1,4,6,3,3,6,1,4),(165,165,1,2,3,1,1,3,3,4,3,2,2,3,3,4,1,4,4,3,5,4,5,4),(166,166,1,5,4,5,1,1,1,1,1,1,2,5,5,5,3,3,4,1,5,7,5,1),(167,167,1,4,3,1,1,6,6,6,6,2,4,1,3,2,1,3,6,5,3,7,5,4),(168,168,1,3,3,5,1,6,6,6,6,3,4,1,5,2,1,3,6,4,3,7,5,3),(169,169,1,3,3,3,1,3,3,3,3,5,2,5,5,5,1,5,6,2,4,6,5,4),(170,170,1,2,1,1,1,5,2,3,5,2,3,4,1,5,3,4,4,4,4,4,5,5),(171,171,1,4,2,5,1,5,2,2,3,2,2,1,1,1,3,4,4,3,3,6,5,4),(172,172,1,4,4,5,1,3,2,2,3,2,2,5,5,5,2,4,4,1,3,6,5,4),(173,173,1,4,4,3,1,3,2,2,3,4,2,5,5,5,2,4,6,1,2,3,4,4),(174,174,1,2,4,5,2,3,2,1,3,3,2,5,5,5,3,4,4,1,5,6,1,4),(175,175,1,3,3,2,1,1,1,1,1,1,2,4,5,5,5,4,1,1,1,1,3,5),(176,176,1,3,3,5,1,1,1,1,1,1,2,5,1,1,5,4,1,1,4,5,3,4),(177,177,1,3,4,4,1,1,1,1,1,1,2,5,5,5,5,4,2,1,6,5,3,5),(178,178,1,5,1,5,1,4,4,4,4,3,4,1,3,1,1,4,2,3,2,4,5,4),(179,179,1,3,4,3,1,1,1,1,1,3,2,1,5,2,5,5,2,1,1,1,2,5),(180,180,1,3,4,3,1,3,1,1,1,3,2,5,5,5,4,5,2,1,1,1,2,5),(181,181,1,6,4,3,1,2,1,1,1,3,2,5,1,5,5,5,2,1,1,1,3,2),(182,182,7,1,4,5,2,3,1,2,3,2,2,5,3,1,3,3,6,1,4,6,1,5),(183,183,1,1,4,5,2,3,1,2,3,2,2,4,1,1,4,3,6,1,4,6,1,5),(184,184,1,4,1,3,2,4,2,4,3,5,4,5,5,5,2,3,5,4,5,4,5,5),(185,185,1,4,4,1,2,3,1,2,2,5,2,5,5,5,3,4,6,1,5,6,1,4),(186,186,1,1,3,3,2,5,2,4,5,5,4,1,5,3,1,4,6,4,3,6,1,4),(187,187,1,2,3,5,1,1,1,1,1,4,2,5,3,5,5,5,6,1,6,5,6,4),(188,188,1,2,5,3,1,3,2,3,3,2,2,2,5,4,1,4,4,4,2,4,1,4),(189,189,1,4,3,5,1,1,1,1,1,3,2,3,1,5,5,5,6,1,6,5,1,5),(190,190,5,6,4,4,1,3,2,2,2,3,2,5,4,5,1,4,6,2,5,6,1,4),(191,191,1,2,3,3,1,3,2,2,1,3,2,1,5,4,5,4,2,1,1,1,2,1),(192,192,5,2,5,5,3,1,1,1,1,1,2,5,5,5,3,4,4,1,4,1,3,1),(193,193,1,6,1,5,1,3,3,4,3,2,2,3,3,3,1,5,5,2,5,7,5,2),(194,194,2,6,1,5,1,3,2,3,3,2,2,3,4,5,5,5,5,2,5,7,1,5),(195,195,1,4,3,3,1,5,6,6,5,4,4,4,2,4,3,4,6,5,4,3,6,3);
/*!40000 ALTER TABLE `plantattribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantdetail`
--

DROP TABLE IF EXISTS `plantdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantdetail` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BotanicalName` varchar(255) NOT NULL,
  `CommonName` varchar(255) NOT NULL,
  `Family` varchar(255) NOT NULL,
  `Distribution` varchar(1000) DEFAULT NULL,
  `Habitat` varchar(1000) DEFAULT NULL,
  `Note` varchar(1000) DEFAULT NULL,
  `Image` varchar(255) DEFAULT NULL,
  `is_delete` TINYINT(1) DEFAULT 0, 
  `reference` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantdetail`
--

LOCK TABLES `plantdetail` WRITE;
/*!40000 ALTER TABLE `plantdetail` DISABLE KEYS */;
INSERT INTO `plantdetail` (`ID`, `BotanicalName`, `CommonName`, `Family`, `Distribution`, `Habitat`, `Note`, `Image`)
VALUES (195,'Vitex lucens','pūriri','Lamiaceae','Endemic. New Zealand: Three Kings Islands and North Island from Te Paki to Taranaki, Mahia Peninsula and the northern Hawkes Bay. Puriri is, as a rule, scarce south of about Opotiki and Kawhia.','In the northern part of its range Puriri is a common co-dominant with Taraire (Beilschmiedia tarairi) and karaka (Corynocarpus laevigatus) especially on rich fertile soils derived from basaltic and basaltic-andesitic igneous rocks. South of the northern Bay of Plenty and Raglan Harbours it is rarely found inland and is more commonly found in coastal forest where it co-habits with pohutukawa (Metrosideros excelsa) and karaka. Puriri is also an important forest tree on many of the smaller islands of the Hauraki Gulf, where it may at times be the canopy dominant.',NULL,'Vitex lucens.jpg'),(194,'Veronica strictissima','Banks Peninsula hebe','Plantaginaceae','Endemic, South Island. Banks Peninsula and the Port Hills.','Grows mostly in open areas on banks and bluffs, or in scrub.',NULL,'Veronica strictissima.jpg'),(193,'Veronica salicifolia/stricta','koromiko','Plantaginaceae','Throughout South Island (except for Marlborough Sounds) and Stewart Island.','Occurs from sea-level to close to the treeline, mostly in open sites, and in forest.',NULL,'Veronica salicifolia.jpg'),(192,'Urtica linearifolia','swamp nettle, narrow-leafed ongaonga ','Urticaceae','Endemic. New Zealand - and North and South Island s from the Central North Island south.','Fertile, lowland swamps, lakes and river margins, swampy shrubland and forest, often growing over tree stumps and rushes or through dense sedges such as swards of Carex secta.',NULL,'Urtica linearifolia.jpg'),(191,'Typha orientalis','raupō, bulrush ','Typhaceae','Indigenous. Kermadec Islands group (Raoul Island only), North and South Islands. Deliberately naturalised on the Chatham Islands by Maori. Present also in Australia, Malaysia, Indonesia and the wider western Pacific','Coastal to lowland in fertile wetlands, on the margins of ponds, lakes, slow flowing streams, and rivers. Less frequently found on the margins of low moor bogs. Occasionally found in muddy ground within industrial areas.',NULL,'Typha orientalis.jpg'),(190,'Teucridium parvifolium','teucridium','Lamiaceae','Endemic to New Zealand, occurring sporadically from Northland to Southland, but commoner in the east of both islands.','Along fertile stream sides and river terraces in lowland dry forest and podocarp-hardwood forest; occasionally on forest margins, clearings and amongst scrub.',NULL,'Teucridium parvifolium.jpg'),(189,'Tetragonia trigyna ','New Zealand spinach/kokihi ','Aizoaceae','Indigenous. New Zealand: Kermadec Islands (Herald Islets, Raoul, Macauley Islands), Three Kings, North, South and Chatham Islands. Also Norfolk and Lord Howe Islands.','Coastal to montane. Mostly found in coastal areas occupying a variety of habitats from cobble and sand beaches through coastal forest and shrubland, also found in exposed windshorn vegetation on cliffs and rock stacks. Occasionally found growing well inland, sometimes in farmland where it grows in barberry (Berberis spp.) hedges or on limestone and calcareous sandstone outcrops in otherwise dense forest.',NULL,'Tetragonia trigyna.jpg'),(188,'Streblus heterophyllus ','tūrepo, small-leaved milk tree','Moraceae','Endemic. Widespread throughout New Zealand.','Lowland forest throughout New Zealand.',NULL,'Streblus heterophyllus.jpg '),(187,'Spinifex hirsutus/Spinifex sericeus','spinifex ','Poaceae','Indigenous. Common throughout New Zealand. Also present in Australia','Strictly coastal where it is confined to sandy beaches. This is the main dune forming indigenous plant in New Zealand. It is usually found at the front of actively accumulating foredunes. Its does not tolerate stable dune systems and does not compete well with other introduced dune plants.',NULL,'Spinifex hirsutus.jpg'),(186,'Sophora tetraptera**','large-leaved kōwhai','Fabaceae','Endemic. Known in a natural state only from the eastern portion of the the North Island from East Cape south to the Wairarapa, extending west toward Taihape, Lake Taupo and along the Waikato River to about Lake Karapiro. However, extensively planted outside this range and often naturalising.','Widespread and common from coastal forested habitats inland along rivers and within associated low scrub and forest. Common around lake margins (especially Lake Taupo) and on ignimbrite cliffs bordering the upper Waikato River. Although a primarily lowland species it can occur in montane riparian forest.','Species contain toxic parts ','Sophora tetraptera.jpg'),(185,'Sophora prostrata**','prostrate kōwhai','Fabaceae','Endemic. Confined to the eastern South Island from Marlborough to the Waitaki Valley','South Island grassland and rocky places, lowland to montane, east of divide from lat. 41° to 45°.','Species contain toxic parts ','Sophora prostrata.jpg'),(184,'Sophora microphylla**','kōwhai, small-leaved kōwhai','Fabaceae','Endemic. Throughout the main islands of New Zealand but scarce in parts of Northland.','In the North Island, especially the northern half this is a species of mainly riparian forest. South of about Hamilton it can be found in a diverse range of habitats from coastal cliff faces and associated wetlands to inland grey scrub communities. Scarce to absent over L parts of the eastern North Island from about East Cape south to the northern Wairarapa.','Species contain toxic parts ','Sophora microphylla.jpg'),(183,'Solanum laciniatum**','poroporo, bullibulli','Solanaceae','Indigenous. North, South, Stewart and Chatham Islands. Widespread from the Hauraki Gulf Islands and Auckland south.','Coastal to montane (0-400 m a.s.l.). usually in disturbed successional habitats, in Slands, gullies, alongside riversides, on forested margins and in reverting pasture. Often appears following fires. A common urban weed in many parts of the country.','Species contain toxic parts ','Solanum laciniatum.jpg'),(182,'Solanum aviculare var. aviculare**','poroporo','Solanaceae','Indigenous. Kermadec, North, South and Chatham Islands. In the South Island south to about Banks Peninsula and Westland.','Coastal to lowland (0-400 m a.s.l.). Usually in open Sland, in and around sea bird nesting grounds, seal haul outs, or along forest margins. Sometimes an urban weed.','Species contain toxic parts ','Solanum aviculare var. aviculare.jpg'),(181,'Schoenus pauciflorus','sedge tussock, bog rush ','Cyperaceae','Endemic. North, South, Stewart, Chatham and Auckland Islands. Uncommon north of Rotorua.','Coastal to alpine (up to 1800 m a.s.l.). However, mostly montane to alpine in northern two-thirds of its range. Common in damp seepages along cliff faces, in swamps, in seepages within forest, within mires and around lake tarn and stream sides. Sometimes colonises poorly drained pasture.',NULL,'Schoenus pauciflorus.jpg'),(180,'Schoenoplectus tabernaemontani','lake clubrush','Cyperaceae','Indigenous. North, South and Chatham Islands. Throughout the North Island, In the South Island present in Nelson, Marlborough, Westland otherwise only around Christchurch and Lake Ellesmere. On the Chatham Islands known from one place - where it is possibly introduced. Otherwise found throughout the world.','Coastal to montane (up to 300 m a.s.l.). Mostly in standing water, growing in brackish or freshwater systems such as lakes, ponds, lagoons, river and stream margins. Also found well inland around geothermal systems.',NULL,'Schoenoplectus tabernaemontani.jpg'),(179,'Schoenoplectus pungens','three-square ','Cyperaceae','Indigenous. North, South and Chatham Islands. In the North Island found from West Auckland and Coromandel south, often scattered and apparently absent from Taranaki, extending inland along the Waikato River. In the South Island scattered and uncommon in Westland and Fiordland - found inland at Pareora Gorge (Canterbury) and Central Otago. Common on Chatham Island. Widespread in western Europe, America and Australia.','Coastal to montane (up to 400 m a.s.l.). Usually not far from the sea in saltmarshes, brackish swamps and estuaries. Also more rarely found inland around freshwater lakes and ponds, and in damp saline slacks. Also recorded from waters draining geothermal sites along the Waikato River.',NULL,'Schoenoplectus pungens.jpg'),(178,'Schefflera digitata* ','patē, seven-finger','Araliaceae','Endemic. Widespread. North, South and Stewart Islands.','Lowland to montane forest (sealevel to 1000 m a.s.l.).','Species may require planting of multiple individuals to ensure fruiting (Forest and Bird, 2018).','Schefflera digitata.jpg'),(177,'Selliera radicans','remuremu ','Goodeniaceae','Endemic. New Zealand: Three Kings, North, South, Stewart and Chatham Islands.','Coastal to alpine. In permanently to seasonally damp, open sites and depressions such as in sand swales, on cliff tops and on talus slopes below these, in coastal turf, in the marginal turf of lake and ponds, in salt pans. Mostly coastal but also recorded from well inland in the South Island and parts of the Central North Island (such as along the shores of Lake Taupo)',NULL,'Selliera radicans.jpg'),(176,'Sarcocornia quinqueflora','glasswort ','Amaranthaceae',NULL,NULL,NULL,'Sarcocornia quinqueflora.jpg'),(175,'Samolus repens var. Repens','sea primrose, shore pimpernel ','Primulaceae',NULL,NULL,NULL,'Samolus repens var. Repens.jpg'),(174,'Rubus squarrosus','yellow-prickled lawyer','Rosaceae','Endemic. New Zealand: North and South Islands, from Ahipara south (scarce north of the Manawatu) and with the exception of Northland mainly easterly.','Coastal to montane. Usually in open areas, particularly in dune-field, grey scrub and other Sland; open forest, river beds, cliff faces, or on talus and boulder slopes.',NULL,'Rubus squarrosus.jpg'),(173,'Rubus schmidelioides var. Schmidelioides','bush lawyer, white-leaved lawyer','Rosaceae','Endemic. New Zealand: North Island (from about Hikurangi - Dargaville South), South and Stewart Islands','Coastal to montane in scrub and forest.',NULL,'Rubus schmidelioides var. Schmidelioides.jpg'),(172,'Rubus cissoides','bush lawyer, tātarāmoa','Rosaceae','Endemic. New Zealand: North, South, Stewart Islands','Coastal to montane. Usually in forest but also found in scrub, and on the margins of wetlands.',NULL,'Rubus cissoides.jpg'),(171,'Ripogonum scandens','supplejack','Ripogonaceae','Endemic. North, South, Stewart and Chatham Islands','Coastal to montane. Usually in forest but occasionally in swamps (where it sprawls through flax and fern), and common in karst country where it often grows in doline, tomo and cave entrances',NULL,'Ripogonum scandens.jpg'),(170,'Rhopalostylis sapida ','nīkau ','Arecaceae','Endemic. North Island, South Island from Marlborough Sounds and Nelson south to Okarito in the west and Banks Peninsula in the east. Also on Chatham and Pitt Islands. However Chatham Islands plants have adistinct juveniel form, Lr fruits, and thicker indumentum on the fronds.','Primarily a species of coastal to lowland forest in the warmer parts of New Zealand.',NULL,'Rhopalostylis sapida.jpg '),(169,'Raukaua anomalus','whauwhaupaku','Araliaceae','Endemic. North, South and Stewart Island. Widespread, but often localised','Lowland to montane forest margins and shrubland. Near sea level to 900 m.',NULL,'Raukaua anomalus.jpg'),(168,'Pterophylla silvicola','Towai, tawhero','Cunoniaceae',NULL,'Occurs from Te Paki as far as the Waitakere Ranges and Kaimai Range.',NULL,'Pterophylla silvicola.jpg'),(167,'Pterophylla racemosa/Weinmannia racemosa','kamaha','Cunoniaceae','Endemic. North, South, Stewart Island. The exact northern limits of Pterophylla racemosa are uncertain but probably lie somewhere along the Manukau Harbour and Hunua Ranges across the Kamai Range. North of here the distinction between P. racemosa and P. sylvicola is often confused. This needs further study.','Coastal to subalpine. A widespread and common tree of disturbed habitats in coastal and lowland to montane forest, often becoming locally dominant in higher altitude montane forest in the higher ranges of the North Island and western South Island.',NULL,'Pterophylla racemosa.jpg'),(166,'Pteridium esculentum','bracken fern/rahurahu','Dennstaedtiaceae','Indigenous: New Zealand: Kermadec (Raoul Island only), North Island, South Island, Stewart Island/Rakiura, Chatham Islands and Antipodes Islands. Also South East Asia, Australia, Lord Howe, Norfolk Islands extending into western Oceania.','Common in mainly seral habitats from the coast to the low alpine zone.',NULL,'Pteridium esculentum.jpg'),(165,'Pseudowintera colorata','horopito, pepperwood','Winteraceae','Endemic. North, South and Stewart Islands','Coastal, lowland, or montane forest margins and Sland',NULL,'Pseudowintera colorata.jpg'),(164,'Pseudowintera axillaris','lowland horopito','Winteraceae','Endemic. North and South Islands. Scarce north of Auckland, extending to near Westport on the west of the South Island','Lowland to montane forest. From near sea level.',NULL,'Pseudowintera axillaris.jpg'),(163,'Pseudopanax ferox','fierce lancewood','Araliaceae','Endemic. North and South Islands. In the North rather patchy, known from Ahipara, Woodhill Forest (South Kaipara), the Moawhango and southern Rimutaka Range. In the S. Island more widespread but easterly from the Marlborough Sounds to Southland.','Coastal to subalpine (10-800 m a.s.l.) on consolidated sand dunes (dune forest), in grey scrub overlying pumice, on recent alluvial (coarse gravels), limestone outcrops, boulder fall, cliff faces, talus slopes and scarps. Also found as a sparse component of seasonally drought-prone but otherwise cold and wet alluvial forests. This species prefers drier habitats and conditions than P. crassifolius (Sol. ex A.Cunn.) C.Koch.',NULL,'Pseudopanax ferox.jpg'),(162,'Pseudopanax crassifolius ','lancewood, horoeka','Araliaceae','Endemic. North, South and Stewart Islands. Widespread and common','Lowland to montane forest. Sealevel to c. 750 m a.s.l.',NULL,'Pseudopanax crassifolius.jpg'),(161,'Pseudopanax colensoi var. Colensoi','mountain five-finger','Araliaceae','Endemic. Central North Island and Coromandel Range south to Banks Peninsula (and possibly Dunedin) on South Island east coast. Apparently absent from South Island West Coast. Plants with sessile leaflets from the Fiordland-Stewart Island area are often referred to Pseudopanax colensoi var. fiordensis Wardle','Montane to low alpine forest and scrub',NULL,'Pseudopanax colensoi var. Colensoi.jpg'),(160,'Pseudopanax arboreus','five-finger, whauwhaupaku','Araliaceae','Endemic. Widespread (though rare in Central Otago). North and South Islands','Coastal to montane (10-750 m a.s.l.). Moist broadleaf forest. Frequently epiphytic. A frequent component of secondary forest. Streamsides and forest margins.',NULL,'Pseudopanax arboreus.jpg'),(159,'Prumnopitys taxifolia ','mataī, black pine','Podocarpaceae','Endemic. North, South and Stewart Islands. Uncommon on Stewart Island.','Lowland forest. Often in drier climates, where it can dominate alluvial soils which are waterlogged/flooded in winter and dry in summer. Seems to prefer base-rich substrates and soils.',NULL,'Prumnopitys taxifolia.jpg'),(158,'Prumnopitys ferruginea','miro, brown pine ','Podocarpaceae','Endemic. North, South and Stewart Islands.','Common tree of lowland to montane forest.',NULL,'Prumnopitys ferruginea.jpg'),(157,'Pomaderris phylicifolia var. Ericifolia','tauhinu','Rhamnaceae','Indigenous. North Island. Historically known from Northland to the northern Waikato. Still present in Te Paki, near Te Kao and in scattered sites south to near Orewa. In Australia known from Victoria and southern New South Wales.','Mainly coastal, nutrient poor, open sites amongst manuka and sedges, clay banks and roadsides. This plant is a naturally short-lived, early coloniser of slips and disturbed areas.',NULL,'Pomaderris phylicifolia var. Ericifolia.jpg'),(156,'Polystichum vestitum','prickly shield fern','Dryopteridaceae','Endemic. New Zealand: North, South, Stewart, Chatham, Snares, Antipodes, Campbell, Auckland, Macquarie Islands. In the North Island scarce north of Auckland and the Coromandel Peninsula.','Coastal to alpine. In the northern part of its range P. vestitum is confined to montane regions or cold (‘temperature inversion’) situations, further south it progressively extends to lower altitudes; in the South Island it ranges from coastal to alpine regions. Polystichum vestitum is a species of exposed habitats, such as forest margins, gulley floors and tussock grasslands, but it also commonly extends into forest in colder, wetter parts of New Zealand.',NULL,'Polystichum vestitum.jpg'),(155,'Polystichum neozelandicum subsp. Neozelandicum','common shield fern ','Dryopteridaceae','Indigenous: New Zealand: Kermadec (Raoul Island only), North, South, Stewart, Chatham and Antipodes Islands. Also South East Asia, Australia, Lord Howe, Norfolk Islands extending into western Oceania.','Common in mainly seral habitats from the coast to the low alpine zone.',NULL,'Polystichum neozelandicum subsp. Neozelandicum.jpg'),(154,'Podocarpus totara var. Totara','tōtara','Podocarpaceae','Endemic. Common throughout most of the North and South Islands. Present but extremely scarce on Stewart Island (Freshwater River).','Widespread and at times abundant tree of lowland, montane and lower subalpine forest. May also form a vegetation type in which it is the dominant species.',NULL,'Podocarpus totara var. Totara.jpg'),(153,'Podocarpus laetus','mountain tōtara ','Podocarpaceae','Endemic. North, South and Stewart Islands.','Lowland, montane to lower subalpine forest (but notably more common in montane forest). Often found on impoverished soils, immature (skeletal) soils, or sites that are naturally stressed by drought or extreme temperature fluctuations.',NULL,'Podocarpus laetus.jpg'),(152,'Poa colensoi ','blue tussock','Poaceae',NULL,'Widespread',NULL,'Poa colensoi.jpg '),(151,'Poa cita****','silver tussock','Poaceae',NULL,'Widespread','Nesting sites based on communications with Meurk 2022','Poa cita.jpg'),(150,'Plagianthus regius subsp. Regius','mānatu, lowland ribbonwood','Malvaceae','Endemic. New Zealand: North, South and Stewart Islands','Coastal to lower montane. Often a prominent tree in lowland alluvial forest.',NULL,'Plagianthus regius subsp. Regius.jpg'),(149,'Plagianthus divaricatus','marsh ribbonwood','Malvaceae','Endemic. New Zealand, North, South, Stewart and Chatham Islands.','Dense tangled shrub with silvery stems and small green leaves. Salt and wind resistant & tolerant of wet, swampy soils. Small cream flowers are very sweetly scented. Great trimmed hedge or low shelter. Semi-deciduous. Hardy.',NULL,'Plagianthus divaricatus.jpg'),(148,'Pittosporum tenuifolium','black matipo, kōhūhū','Pittosporaceae','Endemic and widespread throughout country.','A ST of coastal to montane Sland and forested habitats. Preferring successional habitats.',NULL,'Pittosporum tenuifolium.jpg'),(147,'Pittosporum eugenioides','lemonwood, tarata','Pittosporaceae','Endemic. Common in the North and South Islands.','Common tree of regenerating and mature forest in coastal to montane situations.',NULL,'Pittosporum eugenioides.jpg'),(146,'Pittosporum crassifolium','karo','Pittosporaceae','Endemic. New Zealand, Great Barrier and North Island. In the North indigenous from Te Paki south to about White Cliffs, and East Cape. Widely naturalised further south to Wellington. Naturalised in the South, Stewart and Chatham Islands.','Coastal and offshore islands. Favouring steep slopes, cliff faces, boudler beaches, rock stacks and the margins of petrel burrowed land. Sometimes forms major canopy dominant on offshore islands, and on occasion can be a significant component of dune forest. Often an urban weed because its fruits/seeds are avidly taken by indigenous and exotic birds and dispersed widely.',NULL,'Pittosporum crassifolium.jpg'),(145,'Piper excelsum subsp. excelsum*','kawakawa ','Piperaceae','Endemic. North and South Islands. Common from te Paki south to about Okarito, North Canterbury and Banks Peninsula.','Coastal to lowland (extending up 500 m a.s.l. in warmer parts of the country). Usually an important understorey species in coastal forest.','Species may require planting of multiple individuals to ensure fruiting (Forest and Bird, 2018).','Piper excelsum subsp. excelsum.jpg'),(144,'Phyllocladus glaucus/toatoa','toatoa','Phyllocladaceae','Endemic. New Zealand: North Island from about Awakino (in the west) and Lake Waikaremoana (in the east) north to Ahipara and Mangonui. There is an outlier population in the northern Kaimanawa Range. Somewhat uncommon and often absent over large parts of this range.','Found from sea level to c.1000 m a.s.l. Toatoa is generally associated with relatively infertile soils on exposed ridges, around bog margins, and on other poorly drained land.',NULL,'Phyllocladus glaucus.jpg'),(143,'Phormium tenax','flax, harakeke','Xanthorrhoeaceae','Indigenous to New Zealand. ','Common from lowland and coastal areas to montane forest, usually but not exclusively, in wetlands and in open ground along riversides.',NULL,'Phormium tenax.jpg'),(142,'Phormium cookianum subsp. Cookianum','mountain flax, wharariki','Xanthorrhoeaceae','Endemic. Scarce in North Island where only known from high alpine situations in the Tararua Ranges, and possible elsewhere within the central axial ranges. Common in the South Island, in subalpine/alpine situations.','Strictly confined to subalpine, alpine situations.',NULL,'Phormium cookianum subsp. Cookianum.jpg'),(141,'Pennantia corymbosa ','kaikōmako','Pennantiaceae','Endemic. Found throughout the North, South and Stewart Islands. Uncommon north of Auckland and on Stewart Island','North and South Islands. Lowland forest from lat. 35° southwards.',NULL,'Pennantia corymbosa.jpg '),(140,'Passiflora tetrandra','native passion flower/kōhia','Passifloraceae',NULL,NULL,NULL,'Passiflora tetrandra.jpg'),(139,'Parsonsia heterophylla','native jasmine/kaihua ','Apocynaceae',NULL,NULL,NULL,'Parsonsia heterophylla.jpg'),(138,'Ozothamnus leptophyllus ','tauhinu/golden cottonwood','Asteraceae','Endemic. New Zealand,North Island, South Island, Stewart Island and the Auckland Islands. ','Coastal to lower montane shrublands, grassland, dunes, open areas and disturbed land.',NULL,'Ozothamnus leptophyllus.jpg'),(137,'Olearia solandri','coastal shrub daisy','Asteraceae','Endemic. North and the northern South Island.',NULL,NULL,'Olearia solandri.jpg'),(136,'Olearia paniculata','akiraho, golden akeake','Asteraceae','North and South Islands.','Lowland to lower montane Sland and forest margins from lat. 37° 30\' to Greymouth and Oamaru.',NULL,'Olearia paniculata.jpg'),(135,'Olearia odorata','scented tree daisy','Asteraceae','Inhabiting open areas east of Main Divide.',NULL,NULL,'Olearia odorata.jpg'),(134,'Olearia lineata','shrub daisy','Asteraceae','Endemic. South Island, easterly from north Canterbury south to Southland and Stewart Island.','Lowland to montane (10-300 m a.s.l.) grey scrub, tussock grassland and forest margins. Often on river terraces in or near seepages and ephemeral wetlands, on occasion even growing in shallow water. Also found on the margins of steep river gorges, and in and amongst rock outcrops, boulder field and at the toe of alluvial fans.',NULL,'Olearia lineata.jpg'),(133,'Olearia hectorii','Hector\'s tree daisy','Asteraceae','Endemic. Eastern South Island.','Lowland to subalpine often at the base of steep hills on colluvium, or on alluvium in situations affected by flooding, debris avalanching, water-logging, drought and/or frost.',NULL,'Olearia hectorii.jpg'),(132,'Olearia fragrantissima','fragrant tree daisy','Asteraceae','Endemic, eastern and south-eastern South Island from Banks Peninsula to Southland.','Coastal to lower montane (0-300 m a.s.l.) usually in grey scrub, on forest margins or Slands. Sometimes on the margins of estuarine or saltmarsh vegetation in places which would be subject to saline water in extremes of tide, also found on gravelly soils often on the margins of steep gullies, gorges and in boulder field.',NULL,'Olearia fragrantissima.jpg'),(131,'Olearia bullata','shrub daisy','Asteraceae','Endemic to the South Island east of the main divide from Southland to North Canterbury and found locally in South and North Westland and on Stewart Island. ','No accurate census of sites has been made but the total population is likely to exceed 10,000 plants.',NULL,'Olearia bullata.jpg'),(130,'Olearia avicenniifolia','mountain akeake','Asteraceae','Endemic to New Zealand where it is found on the southern coastlines of the South Island and on Stewart Island','Scrub from sea-level to 900m.',NULL,'Olearia avicenniifolia.jpg'),(129,'Olearia adenocarpa','Canterbury shrub daisy','Asteraceae','Endemic. South Island, Canterbury Plains. Known only from the vicinity of Christchurch.','A lowland species of recently deposited alluvial gravels and sands.',NULL,'Olearia adenocarpa.jpg'),(128,'Neomyrtus pedunculata','NZ Myrtle, rōhutu','Myrtaceae','Endemic. North, South and Stewart Islands from near Kaitaia (Mangamuka) south but generally scarce in Northland and Auckland.','Coastal to montane forest and shrubland. Often a conspicuous component of the understorey of lowland Podocarp riparian forest but also an frequent component of grey scrub in some parts of the South Island. Unless flowering or fruiting Neomyrtus is often overlooked or mistaken for the superficially similar Lophomyrtus obcordata with which it often grows.',NULL,'Neomyrtus pedunculata.jpg'),(127,'Myrsine divaricata','weeping matipo, māpou','Primulaceae','Endemic. North, South, Stewart and Auckland Islands. Uncommon north of the Waikato.',NULL,NULL,'Myrsine divaricata.jpg'),(126,'Myrsine australis ','red māpou','Primulaceae','Endemic. Three Kings, North, South and Stewart Islands.','Common tree of regenerating and mature forest in coastal to montane situations. Often common on northern offshore islands.',NULL,'Myrsine australis.jpg'),(125,'Myoporum laetum**','ngaio','Scrophulariaceae','Endemic. Three Kings, North and South Islands. Also on the Chatham Islands where scarce and probably naturalised.','Coastal to lowland forest, sometimes well inland (in Hawkes Bay, Rangataiki and Wairarapa). Often uncommon over L parts of its range.','Species contain toxic parts','Myoporum laetum.jpg'),(124,'Muehlenbeckia ephedroides  ','leafless pōhuehue ','Polygonaceae','Endemic. North and South Islands. In the North Island mainly eastern from Lake Taupo (Acacia Bay) and the northern Hawkes Bay south to Wellington and Cape Palliser. In the South Island eastern from Marlborough to Southland.','Coastal to subalpine (0-1200 m a.s.l.). A species of river flats, beaches, sand spits, alluvial fans, outwash gravels and river terraces, also found in grey scrub. Favouring open, dry, free draining but fertile sites, usually on gravel and sandy soils, in habitats naturally free from other taller plants. Sometimes found on gravel roads.',NULL,'Muehlenbeckia ephedroides.jpg'),(123,'Muehlenbeckia complexa var. Complexa','small-leaved pōhuehue','Polygonaceae','Native to New Zealand.',' Grows in a variety of habitats, occurring in coastal, lowland and montane regions',NULL,'Muehlenbeckia complexa var. Complexa.jpg'),(122,'Muehlenbeckia axillaris','creeping pōhuehue','Polygonaceae','Native to New Zealand and Tasmania, New South Wales and Victoria in Australia.','Montane shrub, found at a wide range of altitudes up to 1200m and is distributed along the length of the Australian Alps, through New South Wales, the ACT and Victoria. It is also found in the central highlands of Tasmania and in the Southern Alps of New Zealand\'s South Island.',NULL,'Muehlenbeckia axillaris.jpg'),(121,'Muehlenbeckia astonii','shrubby tororaro, mingimingi','Polygonaceae','Endemic. North and South Islands. In the North Island known from Honeycomb Light (Eastern Wairarapa) south to Cape Palliser and just west of Sinclair Head. In the South Island in Marlborough formerly present on the Wairau Bar and Wither Hills, now known only from Clifford Bay, the lower Awatere Catchment to Cape Campbell and Kekerengu. Also in North Canterbury, on Banks Peninsula near Lake Forsyth and on Kaitorete Spit. An old herbarium specimen in Kew suggests it may have once been in the lower Waitaki Valley, South Canterbury.','Coastal to lowland. This species is associated with “grey” scrub communities, Lly confined to drier lowland parts of eastern New Zealand. It is found on moderate to high fertility soils. The plant is often found in association with Coprosma crassifolia Colenso, Coprosma propinqua A,Cunn., Muehlenbeckia complexa (A.Cunn.) Messn. (small-leaved pohuehue), Discaria toumatou Raoul (matagouri), Olearia solandri Hook.f. (coastal tree daisy), Ozothamnus leptophyllus (G.Forst.) I.Breitwieser et J.M.Ward (tauhinu) and Rubus squarrosus Fritsch (leafless lawyer).',NULL,'Muehlenbeckia astonii.jpg'),(120,'Mimulus repens/Thyridia repens','Māori musk ','Phrymaceae','Indigenous. New Zealand: North and South Islands. Also Australia','Strictly coastal. Usually at the back of salt marshes and estuaries, in permanently damp or soggy, saline mud or silt soils in locations that are periodically flooded during high, spring or King tides. Sometimes in dune swales. Intolerant of much competition from taller plants or faster growing mat-forming species.',NULL,'Mimulus repens.jpg'),(119,'Microsorum pustulatum/Zealandia pustulata subsp. Pustulata','hounds tongue fern/kōwaowao, maratata','Polypodiaceae','Indigenous. New Zealand: Kermadec Islands (Raoul, Meyers only), Three Kings, North, South, Stewart, Chatham, Auckland and Antipodes Islands. Also Australia. Abundant throughout main islands of New Zealand except for Central Otago.','A common fern of coastal to montane area, growing either on the ground, over rocks or on tree trunks and branches. Although widespread and often found growing admixed with Dendroconche scandens, Zealandia pustulata is more drought tolerant and seems to prefer more open, drier habitats.',NULL,'Microsorum pustulatum.jpg'),(118,'Microlaena avenacea','bush rice grass','Poaceae',NULL,NULL,NULL,'Microlaena avenacea.jpg'),(117,'Metrosideros umbellata','southern rātā','Myrtaceae','Endemic. North, South, Stewart and Auckland Islands. In the North Island locally present from Te Paki south to Mt Pirongia, the northern Kaimai Ranges (Ngatamahinerua) and Mt Manuoha (Te Urewera National Park). In the South Island from Durville Island south and to Fiordland, with a mainly westerly distribution (absent from Marlbrough), most of Canterbury and northern Otago. Common on Stewart and the Auckland Islands.',NULL,NULL,'Metrosideros umbellata.jpg'),(116,'Metrosideros excelsa','pōhutukawa ','Myrtaceae','Endemic. New Zealand: Three Kings Islands and North Island from North Cape to about Pukearuhe, (northern Taranaki) in the west and near Mahia Peninsula (in the east). However, exact southern limit is difficult to ascertain as it has been widely planted and there is evidence that old time Maori cultivated the tree in some southerly areas. ','Coastal forest and on occasion inland around lake margins. Also in the far north occasionally an associate of kauri forest. In some northerly locations it forms forest type in its own right - this forest is dominated by pohutukawa, other associates often include tawapou (Pouteria costata), kohekohe (Dysoxylum spectabile), puriri (Vitex lucens), karaka (Corynocarpus laevigatus), and on rodent-free offshore islands the frequent presence of coastal maire (Nestegis apetala), and milk tree (Streblus banksii) suggests these species too may once have been important in mainland examples of pohutukawa forest.',NULL,'Metrosideros excelsa.jpg'),(115,'Melicytus ramiflorus*','māhoe, whiteywood','Violaceae','Endemic subspecies. ','Abundant ST of coastal, lowland, and lower montane forests throughout the country.','Species may require planting of multiple individuals to ensure fruiting (Forest and Bird, 2018).','Melicytus ramiflorus.jpg'),(114,'Melicytus lanceolatus','narrow-leaved māhoe','Violaceae','Endemic. North and South Islands. ','Found at higher elevations on the North Island but descending to lowlands on the South Island',NULL,'Melicytus lanceolatus.jpg'),(113,'Melicytus alpinus','porcupine shrub','Violaceae','Endemic. New Zealand. ','Coastal and/or dry alpine areas. It is most common in the South Island high country.',NULL,'Melicytus alpinus.jpg'),(112,'Melicope ternata','whārangi','Rutaceae','EndemicNorth and South Island between the North Cape down to Nelson','Coastal to lowland forest, especially marginal, North and South Islands south to latitude 41° 30\' south.',NULL,'Melicope ternata.jpg'),(111,'Melicope simplex','poataniwha','Rutaceae','Endemic. New Zealand.  ','Coastal and lowland forests throughout New Zealand.',NULL,'Melicope simplex.jpg'),(110,'Mazus novaezeelandiae subsp. impolitus','carpet musk','Mazaceae','Endemic to New Zealand. North and South Island, Marlborough, Canterbury and Otago.','Prefers coastal sites, particularly damp hollows and sand flats, amongst sandy turf and coastal pasture species; but has also been found inland on river gravels in Otago. Swamp and stream margins, soggy ground, river flats beneath tawa and kahikatea.',NULL,'Mazus novaezeelandiae subsp. impolitus.jpg'),(109,'Lophozonia menziesii','silver beech','Nothofagaceae','North and South Islands - from latitude 37° southwards, except Mount Egmont.','Lowland to montane forest or as shrub in subalpine scrub',NULL,'Lophozonia menziesii.jpg'),(108,'Lophomyrtus obcordata','rōhutu','Myrtaceae','Endemic. North and South Islands. Patchy and often absent over L parts of the country. More common in the eastern North and South island though locally prominent in some parts of western Northland and Auckland.','Coastal to montane in forest - though mostly found in coastal and lowland forested habitats. ',NULL,'Lophomyrtus obcordata.jpg'),(107,'Limosella lineata/Limosella australis','New Zealand mudwort','Plantaginaceae',NULL,NULL,NULL,'Limosella lineata.jpg'),(106,'Leptospermum scoparium var. Scoparium','mānuka','Myrtaceae','Indigenous to New Zealand and Australia. ','Abundant from coastal situations to low alpine habitats.',NULL,'Leptospermum scoparium var. Scoparium.jpg'),(105,'Leptinella squalida','brass button','Asteraceae','Endemic. North, South (North-West Nelson only) and Chatham Islands. In North Island uncommon north of the Waikato.','Mostly coastal or inland (0-300 m a.s.l.), in open turf, on coastal cliffs, in coastal turf, along river beds or in open grassland and open, damp places within shrubland and lowland forest. In some urban areas reported as as a lawn weed. Often found growing with Hydrocotyle heteromeria A.Rich. and H. microphylla A.Cunn. Some forms of L. squalida subsp. squalida have also been gathered from subalpine to alpine habitats in the central North Island.',NULL,'Leptinella squalida.jpg'),(104,'Leptinella serrulata','dryland button daisy ','Asteraceae',NULL,NULL,NULL,'Leptinella serrulata.jpg'),(103,'Leptinella filiformis','slender button daisy ','Asteraceae',NULL,NULL,NULL,'Leptinella filiformis.jpg'),(102,'Leptinella dioica ','shore cotula','Asteraceae','Endemic. North, South and Stewart Islands. Not known from Northland or Fiordland.','Coastal and inland up to 1000 m a.s.l.. In the northern part of its range usually on the margins of saltmarshes but further south extending well inland in seepages and permanently open, damp turfs.',NULL,'Leptinella dioica.jpg '),(101,'Kunzea serotina','kānuka','Myrtaceae','Endemic. New Zealand. North and South Islands from Central Volcanic Plateau south through central North Island and east to the southern Wairarapa, thence easterly from Marlborough to Central Otago','Kunzea serotina, in the North Island part of its range is mostly a montane to subalpine species, extending into lowland sites in forest flats and other places where temperature inversions occur. In the South Island it is more wide ranging but still most confined to mountain areas and intermontane basins.',NULL,'Kunzea serotina.jpg'),(100,'Kunzea ericoides','kānuka','Myrtaceae','Endemic. New Zealand: Northern South Island only - north of the Buller and Wairau Rivers. Most common in North West Nelson.','Coastal to lowland Sland, regenerating forest and forest margins, also present in montane forest, ultramafic Sland and very occasionally present in subalpine Sland.',NULL,'Kunzea ericoides.jpg'),(99,'Knightia excelsa','rewarewa','Proteaceae','Endemic monotypic genus. North and South Islands. Common in the North Island, but confined to the Marlborough Sounds in the South Island.','A common tree of coastal, lowland and lower montane Sland, secondary regrowth, and on occasion mature forest. Frost-tender when young so generally scarce from cooler, frost-prone habitats - nevertheless it can be very common in suitable sites on the Central Volcanic Plateau of the North Island.',NULL,'Knightia excelsa.jpg'),(98,'Juncus pallidus','giant rush','Juncaceae','Indigenous. North, South, and Stewart Islands. Present in Australia and naturalised on Norfolk, Lord Howe and the Chatham Islands','Coastal to lowland. Often in pastures where it can be as major weed. Usually in damp swampy hollows, on the margins of wetlands and lakes, in open shrubland on damp ground, or near saltmarshes in places that can be flooded by King tides.',NULL,'Juncus pallidus.jpg'),(97,'Juncus kraussii subsp. Australiensis','wïwï/sea rush ','Juncaceae','Indigenous. North, South and Chatham Islands. From Te Paki to the Okarito in the west and Dunedin in the South. Inland in the North Island at Lake Rotorua, at Orakeikorako, and in the South Island at Mesopotamia, Rangitata River','Primarily coastal where it is found in salt marshes, brackish stream, lagoon and river margins, estuaries. Also inland around geothermal vents at Lake Rotorua and Orakeikorako, and inland at the headwaters of the Rangitata River.',NULL,'Juncus kraussii subsp. Australiensis.jpg'),(96,'Juncus gregiflorus/Juncus edgariae','tussock rushes, wiwi','Juncaceae','Endemic. Kermadec, North, South, Stewart and Chatham Islands. Naturalised in Britain','Easily the most common indigenous species. Coastal to alpine (1600 m a.s.l.) but mainly coastal to montane. Usually in open shrubland, fringing wetlands, and in seasonally damp sites. Often found invading pasture and in urban areas.',NULL,'Juncus gregiflorus.jpg'),(95,'Hypolepis ambigua','thousand-leaved fern ','Dennstaedtiaceae','Endemic. New Zealand: Three Kings, North, South, Stewart and Chatham Islands.','Coastal to montane. A ‘weedy’ species of disturbed sites in open forest, forest clearings, forest margins, in scrub, and in open grassland. It is often a component of brackenfield and as with H. dicksonioides, H. ambigua frequently colonises urban areas, where at times it can become a troublesome ‘weed’.',NULL,'Hypolepis ambigua.jpg'),(94,'Hoheria sexstylosa','houhere, lacebark','Malvaceae','Endemic. North Island from the northern Waikato and Coromandel Peninsula south to the south Wellington Coast and Wairarapa. South Island rather local and wild populations are now hard to recognise from naturalised ones. Those from North West Nelson, inland Marlborough and Banks Peninsula are probably natural.','Coastal, lowland to montane riparian forest.',NULL,'Hoheria sexstylosa.jpg'),(93,'Hoheria populnea','lacebark, ribbonwood','Malvaceae','Endemic. North Island only from North Cape (Pararaki Stream) south to the northern Waikato and Coromandel. However widely planted and often found naturalising throughout the southern North Island, South, Stewart and Chatham Islands.','Coastal to montane usually in Kauri (Agathis australis) forest but also in successional forest associated with kauri. Also common in pohutukawa (Metrosideros excelsa) dominated coastal forest.',NULL,'Hoheria populnea.jpg'),(92,'Hoheria angustifolia','narrow-leaved lacebark','Malvaceae','Endemic. New Zealand: North and South Islands - mostly easterly from the Wairoa River Northland south to Southland. In the North Island scarce north of the Hawkes Bay, absent from Taranaki, Bay of Plenty and Auckland areas and from most of the Waikato. In the South Island absent from Westland and Fiordland.','A common mostly lowland forest species frequenting alluvial forest where it may at times be dominant. Hoheria angustifolia is often an important host for taapia (Tupeia antarctica).',NULL,'Hoheria angustifolia.jpg'),(91,'Histiopteris incisa','water fern ','Dennstaedtiaceae','Indigenous. New Zealand: Also eastern and south-eastern Australia and Tasmania, Lord Howe and Norfolk and throughout the tropics and southern temperate regions.','Coastal to subalpine. Usually in open sites. Histiopteris is typically a primary colonizer of disturbed ground such as in clearings caused by tree falls, or in forest that has been seriously damaged by browsing animals. It is often common in pine forest, on roadside cuttings, and sometimes may be found in urban areas.',NULL,'Histiopteris incisa.jpg'),(90,'Helichrysum lanceolatum','niniao','Asteraceae','Endemic. Widespread throughout North and South Islands.','This variable shrub occurs throughout the North and South Islands, especially in dry forest edge and scrub habitats.',NULL,'Helichrysum lanceolatum.jpg'),(89,'Hedycarya arborea*','porokaiwhiri, pigeonwood','Monimiaceae','Endemic. Three Kings, North and South Islands. In the South island uncommon in the east south of Kaikoura reaching its southern limit on that coastline on Banks Peninsula, iit is more ranging in the west reaching northern Fiordland at least.','A common forest tree of coastal and lowland forest, extending into montane areas in the warmer parts of the North Island','Species may require planting of multiple individuals to ensure fruiting (Forest and Bird, 2018).','Hedycarya arborea.jpg'),(88,'Griselinia lucida','shining broadleaf, puka','Griseliniaceae','North and South Islands, but is much more common in the north. The other New Zealand species of the genus—Griselinia littoralis—has a similar distribution, with the addition of Stewart Island, but is more common in the south and at higher altitudes','Hemiepiphyte that grows primarily in trees of wet, lowland forests and also in open coastal and rocky outcrop habitats.',NULL,'Griselinia lucida.jpg'),(87,'Griselinia littoralis','broadleaf, kāpuka','Griseliniaceae','Endemic. Widespread from sea level up to 900 m altitude and ranges from far north to Stewart Island geographically. It is most commonly found in coastal areas as it is a hardy plant.','Found throughout the country particularly in coastal exposed areas, as it is a hardy plant that tolerates sea breeze and wind exposure.',NULL,'Griselinia littoralis.jpg'),(86,'Geniostoma ligustrifolium var. Ligustrifolium','hangehange','Loganiaceae',NULL,NULL,NULL,'Geniostoma ligustrifolium var. Ligustrifolium.jpg'),(85,'Fuscospora solandri','black beech/tawhairauriki','Nothofagaceae',NULL,NULL,NULL,'Fuscospora solandri.jpg'),(84,'Fuscospora fusca','red beech','Nothofagaceae','North and South Islands - 37° southwards, except Mount Egmont.','Lowland to montane forest.',NULL,'Fuscospora fusca.jpeg'),(83,'Fuscospora cliffortioides','mountain beech/tawhairauriki ','Nothofagaceae','Endemic. North, South Islands. Common from the Central Volcanic Plateau and adjacent main axial ranges of the North Island south.','Montane forest and subalpine forest and scrub. Often forming a dense, almost monospecific forest especially along the main North Island axial ranges and along the drier, eastern side of the South Island.',NULL,'Fuscospora cliffortioides.jpeg'),(82,'Fuchsia excorticata* ','tree fuchsia/kōtukutuku ','Onagraceae','Endemic.Widespread thoughtout New Zealand.','Common in lowland and lower mountainous forest areas, especially on the forest margins, in clearings, and by streams.','Species may require planting of multiple individuals to ensure fruiting (Forest and Bird, 2018).','Fuchsia excorticata.jpg'),(81,'Festuca novae-zelandiae','hard tussock, fescue tussock','Poaceae',NULL,NULL,NULL,'Festuca novae-zelandiae.jpg'),(80,'Fern spp. ****','various','Aspleniaceae',NULL,'Various','Nesting sites based on communications with Meurk 2022','Fern spp..jpeg'),(79,'Euphorbia glauca','shore spurge/waiū-o-kahukura ','Euphorbiaceae','Endemic to New Zealand and the Chatham Islands.','Coastal cliffs, banks and talus slopes, sand dunes and rocky lake shore scarps.',NULL,'Euphorbia glauca.jpg'),(78,'Elymus solandri/Anthosachne solandri  ','blue wheat grass ','Poaceae','Endemic to New Zealand. North and South Islands. Uncommon north of the Waikato.','Coastal to alpine (1 to 1500 m), often on rocky ground such as talus slopes, cliff faces and scree, but also a component of tussock grassland.',NULL,'Elymus solandri.jpg'),(77,'Elaeocarpus hookerianus','pōkākā','Elaeocarpaceae','Endemic. North, South and Stewart Islands - uncommon from Auckland north.','Common tree of lowland to montane forests.',NULL,'Elaeocarpus hookerianus.jpg'),(76,'Elaeocarpus dentatus','hīnau','Elaeocarpaceae','Endemic. North, and South Island as far South Westland in the west and Christchurch in the east.','Common tree of mainly coastal and lowland forest though occasionally extending into montane forest.',NULL,'Elaeocarpus dentatus.jpg'),(75,'Dysoxylum spectabile','kohekohe, New Zealand mahogany','Meliaceae','Endemic. North and South Islands. In the South Island not extending much beyond the Marlborough Sounds, reaching a southern limit near the Hurunui River (Napenape).','Common and sometimes dominant or co-dominant tree of coastal to lowland forest.',NULL,'Dysoxylum spectabile.jpg'),(74,'Drosera binata','sundew ','Droseraceae','Indigenous. North, South, Stewart and Chatham islands. Present in Australia','Coastal to subalpine in bogs and poorly drained pasture overlying acid soils. More common in coastal to lowland situations. Often abundant following fires',NULL,'Drosera binata.jpg'),(73,'Dodonaea viscosa','akeake','Sapindaceae','Indigenous. New Zealand: Three Kings, North, South and Chatham Islands.','Coastal to lowland forest, occupying a range of habitats from dunefields and boulder beaches through coastal scrub to lowland forest. Rarely forming a dominant tree in coastal forest and especially on offshore islands',NULL,'Dodonaea viscosa.jpeg'),(72,'Disphyma australe subsp. Australe','horokaka, native ice plant, New Zealand ice plant','Aizoaceae','Endemic. New Zealand: Three Kings, North, South, Stewart and Chatham Islands','Coastal (rarely inland). Mostly on cliff faces, rock stacks, and boulder/cobble beaches, more rarely in saltmarsh and estuaries. Often in petrel scrub on offshore islands, and extending into coastal forest around petrel burrows. Occasionally on limestone or sandstone cliffs in lowland forest (Western Waikato).',NULL,'Disphyma australe subsp. Australe.jpg'),(71,'Discaria toumatou','matagouri, tūmatakuru','Rhamnaceae','Endemic. North and South Islands. In the North Island known from near Waiuku south to the southern Wairarapa and Wellington coastline. Very uncommon in the North Island. In the South Island mainly east of the main divide, appearing to avoid areas of high rainfall',NULL,NULL,'Discaria toumatou.jpg'),(70,'Desmoschoenus spiralis/Ficinia spiralis ','pïngao/golden sand sedge ','Cyperaceae','Endemic. New Zealand: North, South, Stewart and Chatham Islands.','Coastal sand dune systems. It favours sloping and more or less unstable surfaces, growing mostly on the front face of active dunes but also on the rear face and rear dunes, provided that there is wind-blown sand. It can also grow on the top of sand hills. It is effective at trapping sand.',NULL,'Desmoschoenus spiralis.jpg'),(69,'Dacrydium cupressinum*','rimu, red pine','Podocarpaceae','Endemic. North, South and Stewart Islands from North Cape south. Uncommon in L parts of the eastern South Island. Facultatively extinct on Banks Peninsula','Lowland to montane forest - occasionally ascending to subalpine scrub.','Species may require planting of multiple individuals to ensure fruiting (Forest and Bird, 2018).','Dacrydium cupressinum.jpg'),(68,'Dacrycarpus dacrydioides','kahikatea','Podocarpaceae','Endemic.','North, South and Stewart Islands',NULL,'Dacrycarpus dacrydioides.jpg'),(67,'Cyperus ustulatus','giant umbrella sedge/upokotangata ','Cyperaceae','Abundant in the North Island and northern South Island, west to Fiordland, and not threatened. Naturally uncommon at its eastern South Island limit, where it is known only from Tai Tapu, Motukarara, Banks Peninsula and the Rakaia River mouth. Also on the Chatham Islands, where it is not very common.','Coastal to lowland sites in open ground. Tolerant of a wide range of habitats and conditions but evidently preferring wetland margins, seepages, streamsides, lagoon and estuary margins.',NULL,'Cyperus ustulatus.jpg'),(66,'Cyathodes fasciculata/Leucopogon fasciculatus','mingimingi','Ericaceae',NULL,NULL,NULL,'Cyathodes fasciculata.jpg'),(65,'Cyathodes juniperina ','mingimingi','Ericaceae','Indigenous. New Zealand (North, South and Stewart Islands), also Australia (Tasmania only)','Coastal to montane, in scrub and forest.',NULL,'Cyathodes juniperina.jpg '),(64,'Cotula coronopifolia','batchelor’s button ','Asteraceae',NULL,NULL,NULL,'Cotula coronopifolia.jpg'),(63,'Corynocarpus laevigatus**','karaka','Corynocarpaceae','Endemic. Common from Raoul and the Three Kings Islands, throughout the North and South Islands to Banks Peninsula and Okarito.','Common in mainly coastal situations, often a major component of coastal forest, rarely dominant. Occasionally found inland, and then often in association with Maori cultural deposits.','Species contain toxic parts','Corynocarpus laevigatus.jpg'),(62,'Corokia cotoneaster','korokio, wire-netting bush','Argophyllaceae','North, South and Three Kings Islands.','Lowland Sland, river-flats and rocky places throughout.',NULL,'Corokia cotoneaster.jpg'),(61,'Coriaria arborea','tutu','Coriariaceae',NULL,NULL,NULL,'Coriaria arborea.jpg'),(60,'Cordyline australis','cabbage tree, ti kōuka  ','Asparagaceae','Endemic. Common in the North, South and Stewart Islands.','Widespread and common from coastal to montane forest. Most commonly encountered on alluvial terraces within riparian forest.',NULL,'Cordyline australis.jpeg'),(59,'Coprosma wallii','mikimiki','Rubiaceae','Endemic. North, South and Stewart Islands. In the North Island, rather local and with a predominantly eastern distribution from the Ripia River Headwaters to Wairarapa, with only two western populations at Erua and Paengaroa In in the South Island much more widespread in both the east and west (with new populations still being discovered mainly in the west and south). On Stewart Island, only recently (2000) discovered and still only known from one location.','Occupies a range of habitats from seasonally flooded, alluvial forest prone to very cold winters and dry summers, to riparian forest and subalpine scrub, or as a component of grey scrub or mixed Podocarp forest developed on steeply sloping basaltic or andesitic rock. The key feature of the majority of C. wallii habitat is that the substrates are rather fertile and the vegetation is limited by frost, water logging, or severe summer drought. Never associated with broad-leaved canopy trees.',NULL,'Coprosma wallii.jpg'),(58,'Coprosma virescens ','pale green Coprosma/mikimiki','Rubiaceae','Endemic. North and South Islands from the ranges east of Gisborne, and especially around Taihape south. Scarce in Nelson and apparently absent from Marlborough and absent from Westland, common in Canterbury south to Southland. Throughout its range it is mainly eastern and often very uncommon or absent from L parts of its range','Lowland to lower montane. On well drained to poorly draining fertile soils (often overlying calcareous or base-rich igneous rocks). In forest and Sland.',NULL,'Coprosma virescens.jpg '),(57,'Coprosma rugosa','coprosma','Rubiaceae',NULL,NULL,NULL,'Coprosma rugosa.jpg'),(56,'Coprosma rubra','mikimiki','Rubiaceae','Endemic. North and South Islands: Mostly eastern. Sporadic in Northland around the upper Wairoa River and Pipwai, more common from the Hawkes Bay and Taihape south but often absent or very uncommon over L parts of its range','Lowland to montane. Usually in riparian forest and Sland, especially on alluvial soils or those derived from calcareous parent materials.',NULL,'Coprosma rubra.jpg'),(55,'Coprosma rotundifolia','round-leaved coprosma','Rubiaceae','Endemic. North, South and Stewart Islands','Lowland to montane. Usually in riparian forest and Sland, especially on alluvial soils or those derived from calcareous parent materials.',NULL,'Coprosma rotundifolia.jpg'),(54,'Coprosma robusta','karamū','Rubiaceae','Endemic. North and South Islands. ','Common throughout coastal, lowland and lower montane habitats within Slands and open sites within forest.',NULL,'Coprosma robusta.jpg'),(53,'Coprosma rigida','rigid mikimiki','Rubiaceae','Endemic. Widespread throughout New Zealand.','Often found on the edges of lowland forest remnants, associated scrublands and river terraces.',NULL,'Coprosma rigida.jpg'),(52,'Coprosma rhamnoides ','mikimiki ','Rubiaceae',NULL,NULL,NULL,'Coprosma rhamnoides.jpg '),(51,'Coprosma repens','taupata, mirror bush','Rubiaceae','Endemic. Three Kings, North and South Islands as far south as Greymouth in the west and Rarangi in the east but now extensively naturalised throughout the South Island, Stewart and Chatham Islands. Also naturalised on Norfolk Island and in Hawaii, in Australia, California and South Africa.','Coastal (rarely inland: Kaitaia – Awanui River, Huntly Basin and in the Manawatu – especially the upper Rangitikei River). A common species of rock stacks, islets, islands coastal cliffs, talus slopes and boulder field. Also a common component of petrel scrub on northern offshore islands, and in coastal forest where it often forms the main understorey and rarely is co-dominant in the canopy. Frequently associated with other coastal Coprosma, especially C. crassifolia, C. macrocarpa subsp. macrocarpa and subsp. minor, C. rhamnoides, C. neglecta, and members of the C. acerosa complex. Hybrids between C. repens and C. acerosa are common and are known as C. xkirkii, less frequently hybrids between it and C. crassifolia are found (C. xbuchananii) and with both C. rhamnoides and C. neglecta.',NULL,'Coprosma repens.jpg'),(50,'Coprosma propinqua var. Propinqua','mikimiki','Rubiaceae','Endemic. New Zealand. It has a wide distribution, ranging from Mangonui in the North Island as far south as Stewart Island. It grows from sea level to 460 metres.','Found widely throughout New Zealand, although absent from a number of significant areas including parts of Canterbury and Northland, Taranaki and the Waitakere Ranges.',NULL,'Coprosma propinqua var. Propinqua.jpg'),(49,'Coprosma pedicellata','mikimiki','Rubiaceae','Endemic. Lly confined to the eastern portion of the North and South Islands. In the North Island from Pehiri, near Gisborne to the Wairarapa, in the South Island from North Canterbury south to the Catlins and western portion of Southland.','Kahikatea (Dacrycarpus dacrydioides) dominated lowland alluvial forest. Often restricted to the margins of small oxbow lakes and ponds, or former stream/river channels. Very tolerant of waterlogging and plants may be found growing within water.',NULL,'Coprosma pedicellata.jpg'),(48,'Coprosma obconica ','coprosma','Rubiaceae','Endemic. North Island: scattered populations near Taihape and one near Masterton. South Island: From DUrville Island and north west Nelson south to Southland and Otago, being apparently absent only from Westland and Stewart Island.','Occupying a wide range of habitats, from estuarine shrublands, braided river bars, lowland podocarp forest to montane marble/limestone/dolomite karstfield, and very occasionally ultramafic boulderfields. The species is a basicole preferring to grow on base-rich substrates (limestone, marble, calcareous mudstone, recent alluvium) but typically in those habitats prone to physiological (e.g., ultramafic, dolomite, or estuarine) or climatic (e.g., drought prone, frost hollows, or with a seasonally high water table) stress.',NULL,'Coprosma obconica.jpg '),(47,'Coprosma microcarpa','mikimiki/small-seeded Coprosma','Rubiaceae',NULL,NULL,NULL,'Coprosma microcarpa.jpg'),(46,'Coprosma lucida','karangu, shining karamū','Rubiaceae','Endemic. New Zealand. The shrub is found throughout the North and South Island.','Can survive in many climates, but is most commonly found in coastal areas, lowland forests, or shrublands.',NULL,'Coprosma lucida.jpg'),(45,'Coprosma linariifolia','yellow wood','Rubiaceae','Endemic. North and South Islands, from the Hawkes Bay and Manawatu south','Lowland to montane forest, scrub, and sometimes shrubland.',NULL,'Coprosma linariifolia.jpg'),(44,'Coprosma intertexta','mikimiki','Rubiaceae','Endemic. South Island, eastern from the Saxton River (Marlborough) south to Otago','A species of the eastern South Island dry intermontane basins where it usually grows in grey scrub overlying old moraines, coarse alluvium, boulder piles and or rock outcrops.',NULL,'Coprosma intertexta.jpg'),(43,'Coprosma grandifolia/autumnalis','kanono','Rubiaceae','Endemic. North to South Islands. In the South Island extending to Lake Ianthe in the west and the Marlborough Sounds in the east.','Common in the understorey of forest, and in sheltered shady sites from the coast to montane and cloud forest. In areas of high rainfall can be a major component of shrublands, and within regenerating forest. Often common along the margins of logging tracks and roads.',NULL,'Coprosma grandifolia.jpg'),(42,'Coprosma dumosa/tayloriae','coprosma','Rubiaceae','Endemic. North Island from Kaimai Range south; South Island (rare in Fiordland), Stewart Island.',NULL,NULL,'Coprosma dumosa.jpg'),(41,'Coprosma crassifolia','thick-leaved mikimiki','Rubiaceae','North and South Islands. Often east of main ranges in both islands except in Northland where found anywhere with suitable habitat.','Coastal rocky and sandy lowland to lower montane Shrubland and forest, up to 600 m.',NULL,'Coprosma crassifolia.jpg'),(40,'Coprosma areolata','thin-leaved coprosma','Rubiaceae','Native. North, South and Stewart Islands.','Lowland to lower montane forest.',NULL,'Coprosma areolata.jpg'),(39,'Coprosma acerosa','sand coprosma','Rubiaceae','Endemic. North, South, Stewart and Chatham Islands','Coastal sands throughout distribution.',NULL,'Coprosma acerosa.jpeg'),(38,'Clianthus puniceus','kaka beak','Fabaceae','Endemic. North Island. Exact historic range is unclear because Maori planted this species around their settlements. Indeed it has even been suggested that none of the historic sites, or the sole existing one are natural but stem from past Maori plantings. Whatever the case, the few herbarium specimens and historical writings suggest this species might have been endemic to Northland and the eastern Auckland portion of the Hauraki Gulf.','Exact habitat preferences are uncertain. Historic records rarely provide any habitat details, and with many it is difficult to determine if the specimens come from Maori plantings. The only known wild population grows in short coastal scrub on talus at the base of eroding mudstone (turbidite) cliffs. Some old herbarium specimens and visits to locations where kakabeak had once been recorded from suggest that the type of habitat the species occupies now is probably indicative of its former habitat preferences.',NULL,'Clianthus puniceus.jpg'),(37,'Clematis paniculata','clematis/puawānanga ','Ranunculaceae','Endemic. North, South and Stewart Islands. Naturalised on Chatham Island.','Coastal to montane in shrubland or tall forest (up to 1000 m a.s.l.).',NULL,'Clematis paniculata.jpg'),(36,'Clematis marata ','small scrambling clematis ','Ranunculaceae','Endemic to South Island. Found in Marlborough (upper Awatere Valley), Canterbury, Otago, Southland (Te Anau Downs) and Stewart Island.','Apparently restricted to river terraces, rock outcrops and dry hillsides and scrub habitats.',NULL,'Clematis marata.jpg '),(35,'Chionochloa conspicua subsp. conspicua','hunagamoho','Poaceae','Endemic. New Zealand to the North Island this grass is found in the Coromandel Peninsula and also can be found from the East Cape to Hawke\'s Bay.','Alpine, open habitats, such as tussock and shrublands. ',NULL,'Chionochloa conspicua subsp. conspicua.jpg'),(34,'Carpodetus serratus ','marbleleaf, putaputāwētā ','Rousseaceae','Endemic. Widespread. North, South and Stewart Islands.','Coastal to montane (10-1000 m a.s.l.). Moist broadleaf forest, locally common in beech forest. A frequent component of secondary forest. Streamsides and forest margins.',NULL,'Carpodetus serratus.jpg '),(33,'Carmichaelia torulosa','Canterbury broom','Fabaceae','Endemic. New Zealand: South Island (Canterbury (Amuri Range (North Canterbury) to Te Ngawai River (South Canterbury))','A plant of forest margins, especially riparian Sland and low forest, and on rock bluffs. It has also been found within a wetland. Plants grow in a range of vegetation types from grassland and open Sland to closed Sland and low forest, though it is most commonly an emergent within open to dense Sland.',NULL,'Carmichaelia torulosa.jpg'),(32,'Carmichaelia kirkii','climbing broom, Kirk’s broom','Fabaceae','Endemic. Eastern South Island, from the Awatere River south to Otago',NULL,NULL,'Carmichaelia kirkii.jpg'),(31,'Carmichaelia corrugata','common dwarf broom','Fabaceae','Endemic. New Zealand: South Island (Marlborough, Canterbury (including Banks Peninsula), and Otago.','A plant of moderate to high fertility sites. Usually associated with grey scrub communities particularly those along riverbanks and gorges, or on poorly drained river terraces. It is often associated with totara (Podocarpus totara var. totara) forest, and has also been found in carex dominated wetlands, or within kahikatea (Dacrycarpus dacrydioides ) dominated forest.',NULL,'Carmichaelia corrugata.jpg'),(30,'Carmichaelia australis','common broom','Fabaceae','Endemic. New Zealand: North and South Islands (except southern South Island)','Coastal to montane, on river terraces, stream banks, colluvium, rock outcrops, talus and fan toe slopes, among tussock grassland and grey scrub, on the edge and margins of dense bush, forest, and in swamps',NULL,'Carmichaelia australis.jpg'),(29,'Carmichaelia arborea/Carmichaelia grandiflora','South Island broom, tree broom, swamp broom','Fabaceae','Native','Endemic. New Zealand: South Island (west of the Main Divide in Westland, Canterbury, Otago, and Southland; uncommon to the east of the Main Divide in Canterbury',NULL,'Carmichaelia arborea.jpg'),(28,'Carex virgata','swamp sedge, pukio','Cyperaceae','Indigenous. New Zealand: North, South, Stewart and Chatham Islands.','Widespread from sea level to about 1000 m a.s.l. in open, swampy conditions and also in damp sites within lowland forest. In parts of the country this sedge is often the dominant carice of lowland alluvial forest.',NULL,'Carex virgata.jpg'),(27,'Carex secta','tussock sedges, pukio ','Cyperaceae','Endemic. Found throughout the North, South and Stewart Islands. Also on the main Chatham Island, though scarce.','Widespread in suitable wetlands from coastal to montane wetlands.',NULL,'Carex secta.jpg'),(26,'Carex maorica','Māori sedge','Cyperaceae','Endemic. New Zealand: North and South Islands. In the North Island uncommon in the east from East Cape to the Wairarapa otherwise widespread. In the South Island apparently absent from Southland and Fiordland','Coastal to lowland in freshwater wetlands, under willow in gully systems, along river and stream banks, lake margins, and in damp seepages, pond margins and clearings within forest. Preferring fertile to mid-fertile wetlands.',NULL,'Carex maorica.jpg'),(25,'Carex litorosa','sea sedge, delta sedge ','Cyperaceae','Endemic to North, South and Stewart Islands.','Coastal in salty, brackish marshes and on sandy, tidal river banks.',NULL,'Carex litorosa.jpg'),(24,'Carex geminata','tussock/cutty grass ','Cyperaceae','Endemic. Found throughout the North, South and Stewart Islands.','Coastal to lower montane in freshwater wetlands, along river and stream banks, lake margins, and in damp seepages, pond margins and clearings within forest. Preferring fertile to mid-fertile wetlands.',NULL,'Carex geminata.jpg'),(23,'Carex flagellifera','tussock/cutty grass ','Cyperaceae','Endemic. New Zealand: North, South, Stewart and Chatham Islands.','Coastal to montane. Usually in free draining soils under scrub or open forest. Rarely in wetlands or in permanently damp, shaded sites.',NULL,'Carex flagellifera.jpg'),(22,'Carex comans','tussock sedge/maurea ','Cyperaceae','Endemic. New Zealand: North, South and Stewart Islands.','Coastal to subalpine. Usually in free draining soils either in the open or under scrub or tall forest in relatively open sparsely vegetated situations. It often naturalises in urban areas.',NULL,'Carex comans.jpg'),(21,'Carex buchananii','matirewa, cutty grass','Cyperaceae','Endemic. New Zealand: North and South Islands. In the North Island uncommon. Known there only from scattered sites south of the Manawatu. In the South Island more widespread and at times locally common, though often sporadically distributed, and apparently absent from Westland and Fiordland. Scarce in Southland. Naturalised in Auckland City.Recorded as naturalised in the United Kingdom.','Coastal to montane (up to 1000 m a.s.l.). On beaches, lagoon, lake and stream margins, or in damp ground within open forest or short tussock grassland.',NULL,'Carex buchananii.jpg'),(20,'Carex breviculmis','grassland sedge','Cyperaceae','Indigenous, North and South Islands. Also Australia, New Guinea, Lord Howe and Norfolk Islands','Coastal to montane. Usually in open grassland, gum land scrub, clay pans, on rock stacks, and talus slopes and other similar sparsely vegetated sites.',NULL,'Carex breviculmis.jpg'),(19,'Calystegia soldanella','sand convolvulus/wihiwihi ','Convolvulaceae','Indigenous. Kermadec, Three Kings, North, South, Stewart and Chatham Islands. Indigenous to both Northern and Southern Hemisphere temperate regions.','Coastal or inland along lake shorelines. Usually in sand or shell banks but also grows in fine gravel or pumice, talus slopes and on occasion in coastal turf or on cliff faces.',NULL,'Calystegia soldanella.jpg'),(18,'Bulbinella angustifolia','Māori onion/bog lily','Asphodelaceae',NULL,NULL,NULL,'Bulbinella angustifolia.jpg'),(17,'Brachyscome pinnata','Lees Valley daisy','Asteraceae','Endemic. South Island, Canterbury only. Allan (1961) (as. B. sinclairii var. pinnata (Hook.f.) Allan) considered this plant to be widespread throughout the eastern South Island and Stewart Island. However, herbarium evidence suggests it has always been a Canterbury endemic.','Exact habitat preferences are uncertain. This species has been recently gathered from only one location. Here it grows amongst short grasses (mainly Rytidosperma spp.), small, annual weeds and mosses or at the base of k?nuka (Kunzea robusta de Lange et Toelken) shrubs on stony alluvium shrubland. Old herbarium specimens provide few if any useful habitat details.',NULL,'Brachyscome pinnata.jpg'),(16,'Blechnum penna-marina subsp. Alpina','hard fern ','Blechnaceae','Indigenous. New Zealand: North, South, Stewart, Chatham, Antipodes, Auckland, Campebll Islands. Also Macaquarie Island, Australia, South America and several other circum-Antarctic islands.','Coastal to alpine (mostly montane to alpine in the northern part of range, and scarce north of the Bay of Plenty and the Waikato) in open forest, subalpine scrub, grassland, alpine herbfield, turf (including coastal turf) and in moss field on the shaded sites of rock outcrops.',NULL,'Blechnum penna-marina subsp. Alpina.jpg'),(15,'Blechnum minus/Parablechnum minus','swamp kiokio (fern) ','Blechnaceae','Indigenous. New Zealand: North, South, Chatham Islands. Also Australia from where it was first described.','Coastal to lower montane in swampy ground within swamp forest, wetlands and along the margins of freshwater lakes, streams and rivers.',NULL,'Blechnum minus.jpg'),(14,'Blechnum discolor ','crown fern ','Blechnaceae',NULL,NULL,NULL,'Blechnum discolor.jpg '),(13,'Beilschmiedia tawa ','tawa','Lauraceae','Endemic. Common throughout the North Island. In the South Island common from Cape Farewell east through the Marlborough Sounds. Extending south of there only in the east where it almost reaches Kaikoura (the southern limit is just north of the main town).','Major canopy dominant in the lowland and lower montane forests of the North Island and northern South island. May form pure stands but usually occurs in close association with podocarps such as rimu (Dacrydium cupressinum).',NULL,'Beilschmiedia tawa.jpg '),(12,'Baumea rubiginosa','twig rush/baumea ','Cyperaceae','Indigenous. New Zealand: North, South, Stewart and Chatham Islands. Also New Guinea, New Caledonia and Australia','Coastal to montane (up to 900 m a.s.l.) in most freshwater wetlands; especially favouring low moor peat bogs, the margins of restiad bogs and their burn pools, more rarely on the margins of lakes, tarns and slow-flowing streams where it may grow with Machaerina arthrophylla.',NULL,'Baumea rubiginosa.jpg'),(11,'Austroderia richardii','toetoe','Poaceae','Endemic. Confined to the South Island. Possibly in the North Island, east of Cape Palliser.','Abundant, from the coast to subalpine areas. Common along stream banks, river beds, around lake margins, and in other wet places. Also found in sand dunes, especially along the Foveaux Strait.',NULL,'Austroderia richardii.jpeg'),(10,'Astelia fragrans****','bush lily','Asteliaceae','North and South Islands','Coastal to montane','Nesting sites based on communications with Meurk 2022','Astelia fragrans.jpg'),(9,'Asplenium bulbiferum','hen and chicken fern','Aspleniaceae',NULL,NULL,NULL,'Asplenium bulbiferum.jpg'),(8,'Aristotelia serrata','wineberry, makomako','Elaeocarpaceae','Endemic. North, South and Stewart Islands. Throughout, but less common in drier areas.','Lowland to montane forests. Often forming dense thickets following disturbance.',NULL,'Aristotelia serrata.jpg'),(7,'Aristotelia fruticosa','mountain wineberry','Elaeocarpaceae','Endemic. North, South and Stewart Islands. Throughout, but often localised in occurrence','Lowland to subalpine forest understory and Shrubland, commoner at higher altitudes',NULL,'Aristotelia fruticosa.jpg'),(6,'Apodasmia similis','jointed wire rush/oioi','Restionaceae','Endemic. Three Kings, North, South, Stewart and Chatham Islands.','Mostly coastal in estuaries, saltmarshes, dunes and sandy flats and hollows. Occasionally inland in gumland scrub, along lake margins, fringing peat bogs or surrounding hot springs.',NULL,'Apodasmia similis.jpg'),(5,'Anemanthele lessoniana****','wind grass','Poaceae','Endemic. North Island, North Auckland, Waikato and southern third of the island. South Island from Nelson and Marlborough south, mainly in the east. Also occurs as a cultivation escape in some places, e.g., Auckland City.','Sea level to montane forest, forest margins, scrub and on cliff faces and associated talus.','Nesting sites based on communications with Meurk 2022','Anemanthele lessoniana.jpg'),(4,'Alectryon excelsus**','NZ oak, tītoki','Sapindaceae','Endemic. North and South Islands from Te Paki to Banks Peninsula','A widespread coastal to lowland forest tree. Often favouring well drained, fertile, alluvial soils along river banks and associated terraces. It is also a major component of coastal forests, particularly those developed within exposed situations or on basaltic or andesite volcanics. It is a common offshore island tree within the Hauraki Gulf. The L fruits are bird dispersed and so titoki trees often occur as a sparse components of most lowland forest types, throughout the North Island.','Species contain toxic parts','Alectryon excelsus.jpg'),(3,'Agathis australis','kauri ','Araucariaceae','Endemic. Occurring from Te Paki south to Pukenui (near Kawhia) in the West and near Te Puke in the East. Over much of its former range it has been heavily logged, such that the best stands now only occur in the Coromandel and Waitakere Ranges, on Great and little Barrier Islands, and in Northland at Waipoua, Trounson, Omahuta, Puketi, Herekino, Warawara and Radar Bush forests. Despite its northerly limit this species has been successfully grown as far south as Oban, Stewart Island, and seedlings have been observed near planted adults in Wellington, Nelson and Christchurch.','The species forms its own forest type - Kauri forest - which is typified by dense canopies of kauri. Common associates in the northern half of its range may include taraire (Beilschmiedia tarairi), northern rata (Metrosideros robusta), rimu (Dacrydium cupressinum), towai (Weinmannia silvicola), and makamaka (Ackama rosifolia). Historically kauri forest seems to have been best developed on river terraces, coastal plains and the generally flat flood basalts of the Tangihua complex, which make the dominant geology of Waipoua, Omahuta, Puketi, Trounson. Some people believe that the hill and range occurrences, which is where most stands can now be seen, are relictual stands not truly favoured by the species, but merely examples of where it can grow, and of course locations where it was usually left because log extraction was less feasible.',NULL,'Agathis australis.jpg'),(2,'Aciphylla subflabellata','fine speargrass/taramea ','Apiaceae','Endemic. South Island in the east from south-eastern Marlborough to Southland','Montane to subalpine (300-1400 m a.s.l.). Usually in dry sites on alluvial terraces, gentle rolling slopes and colluvium, intermontane basins amongst short or tall tussocks and on the margins of grey scrub. Sometimes on or near rock outcrops or amongst boulders.',NULL,'Aciphylla subflabellata.jpg'),(1,'Acaena novae-zealandiae','bidibidi/piripiri','Rosaceae',NULL,NULL,NULL,'Acaena novae-zealandiae.jpg');
/*!40000 ALTER TABLE `plantdetail` ENABLE KEYS */;
UNLOCK TABLES;

SET SQL_SAFE_UPDATES = 0;
UPDATE plantdetail 
SET reference = 'Image courtesy of the New Zealand Plant Conservation Network' 
WHERE reference IS NULL;
SET SQL_SAFE_UPDATES = 1;


--
-- Table structure for table `salttolerance`
--

DROP TABLE IF EXISTS `salttolerance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salttolerance` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SaltTolerance` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salttolerance`
--

LOCK TABLES `salttolerance` WRITE;
/*!40000 ALTER TABLE `salttolerance` DISABLE KEYS */;
INSERT INTO `salttolerance` VALUES (1,'Low',1),(2,'Low/Mod',2),(3,'Moderate',3),(4,'Mod/High',4),(5,'High',5);
/*!40000 ALTER TABLE `salttolerance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shade`
--

DROP TABLE IF EXISTS `shade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shade` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShadeClass` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shade`
--

LOCK TABLES `shade` WRITE;
/*!40000 ALTER TABLE `shade` DISABLE KEYS */;
INSERT INTO `shade` VALUES (1,'None',0),(2,'Low',1),(3,'Low/Med',2),(4,'Med',3),(5,'Med/High',4),(6,'High',5);
/*!40000 ALTER TABLE `shade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shelter`
--

DROP TABLE IF EXISTS `shelter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shelter` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ShelterClass` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shelter`
--

LOCK TABLES `shelter` WRITE;
/*!40000 ALTER TABLE `shelter` DISABLE KEYS */;
INSERT INTO `shelter` VALUES (1,'None',0),(2,'Low',1),(3,'Low/Med',2),(4,'Med',3),(5,'Med/High',4),(6,'High',5);
/*!40000 ALTER TABLE `shelter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soildepth`
--

DROP TABLE IF EXISTS `soildepth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soildepth` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SoilDepth` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soildepth`
--

LOCK TABLES `soildepth` WRITE;
/*!40000 ALTER TABLE `soildepth` DISABLE KEYS */;
INSERT INTO `soildepth` VALUES (1,'Shallow',1),(2,'Moderately Shallow',2),(3,'Moderate',3),(4,'Moderately Deep',4),(5,'Deep',5);
/*!40000 ALTER TABLE `soildepth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soildrainage`
--

DROP TABLE IF EXISTS `soildrainage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soildrainage` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SoilDrainage` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soildrainage`
--

LOCK TABLES `soildrainage` WRITE;
/*!40000 ALTER TABLE `soildrainage` DISABLE KEYS */;
INSERT INTO `soildrainage` VALUES (1,'Wet',0),(2,'Poor drainage/Damp',1),(3,'Imperfectly/Poorly drained',2),(4,'Well Drained/Damp/Wet',3),(5,'Dry/Well Drained/Damp ',4),(6,'Dry/Well Drained ',5);
/*!40000 ALTER TABLE `soildrainage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soilmoisture`
--

DROP TABLE IF EXISTS `soilmoisture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soilmoisture` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SoilMoisture` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soilmoisture`
--

LOCK TABLES `soilmoisture` WRITE;
/*!40000 ALTER TABLE `soilmoisture` DISABLE KEYS */;
INSERT INTO `soilmoisture` VALUES (1,'Wet',0),(2,'Moist to Wet/Damp',1),(3,'Moist',2),(4,'Dry to Wet',3),(5,'Dry - Moist ',4),(6,'Dry',5);
/*!40000 ALTER TABLE `soilmoisture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soiltype`
--

DROP TABLE IF EXISTS `soiltype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soiltype` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SoilType` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soiltype`
--

LOCK TABLES `soiltype` WRITE;
/*!40000 ALTER TABLE `soiltype` DISABLE KEYS */;
INSERT INTO `soiltype` VALUES (1,'Wetland',0),(2,'Loam ',2),(3,'Loam/Sandy',2),(4,'Clay/Loam',2),(5,'Sandy',3),(6,'Clay/Loam/Sandy',4),(7,'Clay/Loam/Sand/Silt',5);
/*!40000 ALTER TABLE `soiltype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sunpreference`
--

DROP TABLE IF EXISTS `sunpreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sunpreference` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SunPreferences` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sunpreference`
--

LOCK TABLES `sunpreference` WRITE;
/*!40000 ALTER TABLE `sunpreference` DISABLE KEYS */;
INSERT INTO `sunpreference` VALUES (1,'PSh/FSh',2),(2,'PSh',3),(3,'FS/PSh/FSh',4),(4,'FS/PSh',5),(5,'FS ',5);
/*!40000 ALTER TABLE `sunpreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toxicparts`
--

DROP TABLE IF EXISTS `toxicparts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toxicparts` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ToxicParts` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toxicparts`
--

LOCK TABLES `toxicparts` WRITE;
/*!40000 ALTER TABLE `toxicparts` DISABLE KEYS */;
INSERT INTO `toxicparts` VALUES (1,'Zero',0),(2,'One',-1),(3,'Five',-5);
/*!40000 ALTER TABLE `toxicparts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` varchar(255) NOT NULL,
  `Image` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`ID`, `Email`, `Password`, `Role`) VALUES  (1,'james@gmail.com','$2b$12$ylOkGroaLh9fSHkD5hW7n.WQAnqAzkFiDmgFfmPzC0k4vMG/klRQi','Admin'),(2,'irisgao@gmail.com','$2b$12$ylOkGroaLh9fSHkD5hW7n.WQAnqAzkFiDmgFfmPzC0k4vMG/klRQi','User');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wetland`
--

DROP TABLE IF EXISTS `wetland`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wetland` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `WetlandType` varchar(255) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wetland`
--

LOCK TABLES `wetland` WRITE;
/*!40000 ALTER TABLE `wetland` DISABLE KEYS */;
INSERT INTO `wetland` VALUES (1,'Not applicable/available',0),(2,'OBL (obligate wetland)',1),(3,'FACW (facultative wetland)',2),(4,'FAC (facultative)',3),(5,'FACU (facultative upland)',4),(6,'UPL (obligate upland)',5);
/*!40000 ALTER TABLE `wetland` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `windtolerance`
--

DROP TABLE IF EXISTS `windtolerance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `windtolerance` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `WindTolerance` varchar(45) NOT NULL,
  `Score` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `windtolerance`
--

LOCK TABLES `windtolerance` WRITE;
/*!40000 ALTER TABLE `windtolerance` DISABLE KEYS */;
INSERT INTO `windtolerance` VALUES (1,'Low',1),(2,'Low/Med',2),(3,'Med',3),(4,'Med/High',4),(5,'High',5);
/*!40000 ALTER TABLE `windtolerance` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-07 22:02:44

DROP TABLE IF EXISTS `filter_result`;
CREATE TABLE `filter_result` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `filter_name` varchar(255) NOT NULL,
  `UserID` int NOT NULL, 
  `ConservationThreatScore` int NOT NULL,
  `PalatabilityScore` int NOT NULL,
  `DefoliationScore` int NOT NULL,
  `GrowthRateScore` int NOT NULL,
  `ToxicPartsScore` int NOT NULL,
  `HeightScore` int NOT NULL,
  `ShadeScore` int NOT NULL,
  `ShelterScore` int NOT NULL,
  `CanopyScore` int NOT NULL,
  `FoodSourcesScore` int NOT NULL,
  `BirdNestingSitesScore` int NOT NULL,
  `DroughtToleranceScore` int NOT NULL,
  `FrostToleranceScore` int NOT NULL,
  `WindToleranceScore` int NOT NULL,
  `SaltToleranceScore` int NOT NULL,
  `SunPreferencesScore` int NOT NULL,
  `SoilDrainageScore` int NOT NULL,
  `SoilDepthScore` int NOT NULL,
  `SoilMoistureScore` int NOT NULL,
  `SoilTypeScore` int NOT NULL,
  `WetlandScore` int NOT NULL,
  `FlammabilityScore` int NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  FOREIGN KEY (`UserID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

