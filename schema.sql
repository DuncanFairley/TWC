CREATE DATABASE  IF NOT EXISTS `oldTWC` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `oldTWC`;
-- MySQL dump 10.13  Distrib 5.6.11, for Win32 (x86)
--
-- Host: localhost    Database: oldTWC
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.13.04.1

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
-- Table structure for table `tblMultikey`
--

DROP TABLE IF EXISTS `tblMultikey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblMultikey` (
  `ckey` varchar(45) NOT NULL,
  `IP` int(10) unsigned NOT NULL,
  `ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ckey`,`IP`,`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblReferralAmounts`
--

DROP TABLE IF EXISTS `tblReferralAmounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblReferralAmounts` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `EarnerCkey` varchar(50) NOT NULL,
  `RefererCkey` varchar(50) NOT NULL,
  `Amount` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=1549 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAlerts`
--

DROP TABLE IF EXISTS `tblAlerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAlerts` (
  `ckey` varchar(50) NOT NULL,
  `type` tinyint(3) NOT NULL,
  KEY `ckey` (`ckey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblWarnings`
--

DROP TABLE IF EXISTS `tblWarnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblWarnings` (
  `ID` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(40) NOT NULL,
  `code` char(2) NOT NULL,
  `msg` text,
  `timestamp` bigint(20) unsigned NOT NULL,
  `length` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ckey` (`ckey`)
) ENGINE=MyISAM AUTO_INCREMENT=11394 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPosts`
--

DROP TABLE IF EXISTS `tblPosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPosts` (
  `id` tinyint(4) NOT NULL,
  `body` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPlayers`
--

DROP TABLE IF EXISTS `tblPlayers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPlayers` (
  `ckey` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `level` smallint(6) NOT NULL,
  `house` varchar(10) NOT NULL,
  `rank` tinytext NOT NULL,
  `IP` int(10) unsigned DEFAULT NULL,
  `timeloggedin` int(10) unsigned NOT NULL,
  `dateRegistered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastLoggedIn` date NOT NULL,
  `isAuror` tinyint(1) NOT NULL,
  `isDE` tinyint(1) NOT NULL,
  `Ccanadd` tinyint(1) NOT NULL,
  `Ccanfire` tinyint(1) NOT NULL,
  `Ccanedit` tinyint(1) NOT NULL,
  `Ccanpost` tinyint(1) NOT NULL,
  `Ccanview` tinyint(1) NOT NULL,
  `Cstore` tinyint(1) NOT NULL,
  `Cspecverb` tinyint(1) NOT NULL,
  `clanRank` varchar(50) DEFAULT NULL,
  `refererckey` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ckey`),
  KEY `ckey` (`ckey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPlayinglogs`
--

DROP TABLE IF EXISTS `tblPlayinglogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPlayinglogs` (
  `ckey` varchar(45) NOT NULL,
  `day` tinyint(3) unsigned NOT NULL,
  `month` tinyint(3) unsigned NOT NULL,
  `year` tinyint(3) unsigned NOT NULL,
  `00` tinyint(1) NOT NULL,
  `01` tinyint(1) NOT NULL,
  `02` tinyint(1) NOT NULL,
  `03` tinyint(1) NOT NULL,
  `04` tinyint(1) NOT NULL,
  `05` tinyint(1) NOT NULL,
  `06` tinyint(1) NOT NULL,
  `07` tinyint(1) NOT NULL,
  `08` tinyint(1) NOT NULL,
  `09` tinyint(1) NOT NULL,
  `10` tinyint(1) NOT NULL,
  `11` tinyint(1) NOT NULL,
  `12` tinyint(1) NOT NULL,
  `13` tinyint(1) NOT NULL,
  `14` tinyint(1) NOT NULL,
  `15` tinyint(1) NOT NULL,
  `16` tinyint(1) NOT NULL,
  `17` tinyint(1) NOT NULL,
  `18` tinyint(1) NOT NULL,
  `19` tinyint(1) NOT NULL,
  `20` tinyint(1) NOT NULL,
  `21` tinyint(1) NOT NULL,
  `22` tinyint(1) NOT NULL,
  `23` tinyint(1) NOT NULL,
  UNIQUE KEY `ckey` (`ckey`,`day`,`month`,`year`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblClients`
--

DROP TABLE IF EXISTS `tblClients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblClients` (
  `client_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_address` varchar(100) CHARACTER SET latin1 NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `password_salt` char(12) NOT NULL,
  `password_hash` char(64) CHARACTER SET latin1 NOT NULL,
  `email_verified` tinyint(1) NOT NULL,
  `date_registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`client_id`),
  UNIQUE KEY `email_address_UNIQUE` (`email_address`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='		';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblEventLogs`
--

DROP TABLE IF EXISTS `tblEventLogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblEventLogs` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblReferrals`
--

DROP TABLE IF EXISTS `tblReferrals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblReferrals` (
  `ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `RefererCkey` varchar(50) NOT NULL,
  `IPAddress` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IPAddress` (`IPAddress`)
) ENGINE=MyISAM AUTO_INCREMENT=11842 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-26  5:26:48
