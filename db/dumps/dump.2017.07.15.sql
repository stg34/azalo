-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: azalo
-- ------------------------------------------------------
-- Server version	5.7.18-0ubuntu0.17.04.1

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
-- Table structure for table `az_activities`
--

DROP TABLE IF EXISTS `az_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(255) NOT NULL,
  `model_name` varchar(255) NOT NULL,
  `object_name` varchar(255) DEFAULT NULL,
  `model_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_activities_on_owner_id` (`owner_id`),
  KEY `index_az_activities_on_user_id` (`user_id`),
  KEY `index_az_activities_on_project_id` (`project_id`),
  KEY `index_az_activities_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_activities`
--

LOCK TABLES `az_activities` WRITE;
/*!40000 ALTER TABLE `az_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_activity_fields`
--

DROP TABLE IF EXISTS `az_activity_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_activity_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_activity_id` int(11) NOT NULL,
  `field` varchar(255) NOT NULL,
  `old_value` text,
  `new_value` text,
  PRIMARY KEY (`id`),
  KEY `index_az_activity_fields_on_az_activity_id` (`az_activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_activity_fields`
--

LOCK TABLES `az_activity_fields` WRITE;
/*!40000 ALTER TABLE `az_activity_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_activity_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_allowed_operations`
--

DROP TABLE IF EXISTS `az_allowed_operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_allowed_operations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_typed_page_id` int(11) DEFAULT NULL,
  `az_operation_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `copy_of` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_allowed_operations_on_copy_of` (`copy_of`)
) ENGINE=InnoDB AUTO_INCREMENT=41813 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_allowed_operations`
--

LOCK TABLES `az_allowed_operations` WRITE;
/*!40000 ALTER TABLE `az_allowed_operations` DISABLE KEYS */;
INSERT INTO `az_allowed_operations` VALUES (1077,811,1,'2011-02-21 15:50:56','2011-02-21 15:50:56',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1078,811,3,'2011-02-21 15:51:01','2011-02-21 15:51:01',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1079,814,2,'2011-02-21 16:10:58','2011-02-21 16:10:58',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1080,813,2,'2011-02-21 16:11:04','2011-02-21 16:11:04',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1081,812,2,'2011-02-21 16:11:58','2011-02-21 16:11:58',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1082,810,2,'2011-02-21 16:12:05','2011-02-21 16:12:05',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1083,809,1,'2011-02-21 16:12:11','2011-02-21 16:12:11',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1084,809,3,'2011-02-21 16:12:18','2011-02-21 16:12:18',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1085,815,2,'2011-02-21 16:12:56','2011-02-21 16:12:56',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1086,816,1,'2011-02-21 16:13:05','2011-02-21 16:13:05',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1087,816,3,'2011-02-21 16:13:09','2011-02-21 16:13:09',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1088,817,2,'2011-02-21 16:13:38','2011-02-21 16:13:38',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1089,818,2,'2011-02-21 16:13:47','2011-02-21 16:13:47',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1091,819,1,'2011-02-22 08:57:40','2011-02-22 08:57:40',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1092,820,1,'2011-02-22 08:57:40','2011-02-22 08:57:40',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1093,821,2,'2011-02-22 08:57:41','2011-02-22 08:57:41',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1094,822,2,'2011-02-22 08:57:41','2011-02-22 08:57:41',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (1095,822,4,'2011-02-22 08:57:41','2011-02-22 08:57:41',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (41808,34714,1,'2011-10-09 15:31:25','2011-10-09 15:31:25',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (41809,34715,1,'2011-10-09 15:31:25','2011-10-09 15:31:25',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (41810,34716,2,'2011-10-09 15:31:26','2011-10-09 15:31:26',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (41811,34717,2,'2011-10-09 15:31:26','2011-10-09 15:31:26',2,NULL);
INSERT INTO `az_allowed_operations` VALUES (41812,34717,4,'2011-10-09 15:31:26','2011-10-09 15:31:26',2,NULL);
/*!40000 ALTER TABLE `az_allowed_operations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_articles`
--

DROP TABLE IF EXISTS `az_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `announce` text,
  `text` text,
  `visible` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_articles`
--

LOCK TABLES `az_articles` WRITE;
/*!40000 ALTER TABLE `az_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_balance_transactions`
--

DROP TABLE IF EXISTS `az_balance_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_balance_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_company_id` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `amount` decimal(20,2) NOT NULL,
  `az_invoice_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_balance_transactions_on_az_company_id` (`az_company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_balance_transactions`
--

LOCK TABLES `az_balance_transactions` WRITE;
/*!40000 ALTER TABLE `az_balance_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_balance_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_base_data_types`
--

DROP TABLE IF EXISTS `az_base_data_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_base_data_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `az_base_data_type_id` int(11) DEFAULT NULL,
  `az_collection_template_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `seed` tinyint(1) DEFAULT NULL,
  `az_base_project_id` int(11) DEFAULT NULL,
  `description` text NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL,
  `tr_position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_base_data_types_on_copy_of` (`copy_of`),
  KEY `index_az_base_data_types_on_owner_id` (`owner_id`),
  KEY `index_az_base_data_types_on_az_base_project_id` (`az_base_project_id`),
  KEY `az_base_data_type_id` (`az_base_data_type_id`),
  KEY `index_az_base_data_types_on_az_base_data_type_id` (`az_base_data_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30492 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_base_data_types`
--

LOCK TABLES `az_base_data_types` WRITE;
/*!40000 ALTER TABLE `az_base_data_types` DISABLE KEYS */;
INSERT INTO `az_base_data_types` VALUES (1,'Строка','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,1,NULL);
INSERT INTO `az_base_data_types` VALUES (2,'Текст','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,2,NULL);
INSERT INTO `az_base_data_types` VALUES (3,'Целое','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,3,NULL);
INSERT INTO `az_base_data_types` VALUES (4,'Вещественное','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,4,NULL);
INSERT INTO `az_base_data_types` VALUES (5,'Логическое','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,5,NULL);
INSERT INTO `az_base_data_types` VALUES (6,'Дата','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,6,NULL);
INSERT INTO `az_base_data_types` VALUES (7,'Время','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,7,NULL);
INSERT INTO `az_base_data_types` VALUES (8,'Дата и время','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,8,NULL);
INSERT INTO `az_base_data_types` VALUES (9,'Атачмент','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,9,NULL);
INSERT INTO `az_base_data_types` VALUES (10,'Двоичные данные','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,10,NULL);
INSERT INTO `az_base_data_types` VALUES (11,'Timestamp','AzSimpleDataType',NULL,NULL,'2010-12-22 12:09:17','2010-12-22 12:09:17',NULL,2,NULL,NULL,'',0,11,NULL);
INSERT INTO `az_base_data_types` VALUES (1000,'Типы работы','AzStructDataType',NULL,NULL,'2011-02-21 15:20:53','2011-03-19 11:57:25',NULL,2,0,355,'',2,1000,NULL);
INSERT INTO `az_base_data_types` VALUES (1001,'Список типов работы','AzCollectionDataType',1000,1,'2011-02-21 15:43:51','2011-02-21 15:43:51',NULL,2,NULL,355,'',0,1001,NULL);
INSERT INTO `az_base_data_types` VALUES (1002,'Категория','AzStructDataType',NULL,NULL,'2011-02-21 15:45:10','2011-03-19 11:58:34',NULL,2,0,355,'',2,1002,NULL);
INSERT INTO `az_base_data_types` VALUES (1003,'Категории','AzCollectionDataType',1002,1,'2011-02-21 15:50:20','2011-02-21 15:50:20',NULL,2,NULL,355,'',0,1003,NULL);
INSERT INTO `az_base_data_types` VALUES (1004,'Изображение','AzStructDataType',NULL,NULL,'2011-02-21 15:56:24','2011-03-19 12:00:13',NULL,2,0,355,'',2,1004,NULL);
INSERT INTO `az_base_data_types` VALUES (1005,'Изображения','AzCollectionDataType',1004,1,'2011-02-21 16:03:07','2011-02-21 16:03:07',NULL,2,NULL,355,'',0,1005,NULL);
INSERT INTO `az_base_data_types` VALUES (1006,'Работа','AzStructDataType',NULL,NULL,'2011-02-21 16:03:17','2011-03-19 12:05:09',NULL,2,0,355,'',2,1006,NULL);
INSERT INTO `az_base_data_types` VALUES (1007,'Работы','AzCollectionDataType',1006,1,'2011-02-21 16:10:44','2011-02-21 16:10:44',NULL,2,NULL,355,'',0,1007,NULL);
INSERT INTO `az_base_data_types` VALUES (1008,'Сообщение','AzStructDataType',NULL,NULL,'2010-12-23 09:01:31','2011-03-19 12:05:51',12,2,0,356,'',2,1008,NULL);
INSERT INTO `az_base_data_types` VALUES (1009,'Список сообщений','AzCollectionDataType',1008,1,'2010-12-23 09:25:41','2011-01-23 16:25:59',13,2,NULL,356,'',0,1009,NULL);
INSERT INTO `az_base_data_types` VALUES (1893,'Фото товара','AzStructDataType',NULL,NULL,'2011-06-17 09:07:15','2011-06-17 09:17:27',NULL,2,1,NULL,'Фотография товара с описанием',0,1893,NULL);
INSERT INTO `az_base_data_types` VALUES (25107,'Сообщение','AzStructDataType',NULL,NULL,'2010-12-23 09:01:31','2011-10-11 06:45:20',12,2,0,5602,'Поле _дата_ должно заполняться автоматически в момент создания сообщения, и содержать текущее время.\r\n\r\nПоле _статус_ имеет два состояния:\r\n* Не обработано (Открыто)\r\n* Обработано (Закрыто)',0,5143,NULL);
INSERT INTO `az_base_data_types` VALUES (25108,'Список сообщений','AzCollectionDataType',25107,1,'2010-12-23 09:25:41','2011-01-23 16:25:59',13,2,NULL,5602,'',0,5143,NULL);
INSERT INTO `az_base_data_types` VALUES (30491,'Неопределенный','AzSimpleDataType',NULL,NULL,'2012-03-07 13:27:52','2012-03-07 13:27:52',NULL,2,NULL,NULL,'',0,6074,NULL);
/*!40000 ALTER TABLE `az_base_data_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_base_project_stats`
--

DROP TABLE IF EXISTS `az_base_project_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_base_project_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_base_project_id` int(11) DEFAULT NULL,
  `components_num` int(11) DEFAULT NULL,
  `pages_num` int(11) DEFAULT NULL,
  `pages_words_num` int(11) DEFAULT NULL,
  `commons_num` int(11) DEFAULT NULL,
  `commons_words_num` int(11) DEFAULT NULL,
  `definitions_num` int(11) DEFAULT NULL,
  `definitions_words_num` int(11) DEFAULT NULL,
  `structs_num` int(11) DEFAULT NULL,
  `structs_variables_num` int(11) DEFAULT NULL,
  `design_sources_num` int(11) DEFAULT NULL,
  `designs_num` int(11) DEFAULT NULL,
  `images_num` int(11) DEFAULT NULL,
  `words_num` int(11) DEFAULT NULL,
  `disk_usage` int(11) DEFAULT NULL,
  `quality` float DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `commons_common_num` int(11) DEFAULT NULL,
  `commons_acceptance_condition_num` int(11) DEFAULT NULL,
  `commons_content_creation_num` int(11) DEFAULT NULL,
  `commons_purpose_exploitation_num` int(11) DEFAULT NULL,
  `commons_purpose_functional_num` int(11) DEFAULT NULL,
  `commons_requirements_hosting_num` int(11) DEFAULT NULL,
  `commons_requirements_reliability_num` int(11) DEFAULT NULL,
  `commons_functionality_num` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_base_project_stats_on_az_base_project_id` (`az_base_project_id`),
  KEY `index_az_base_project_stats_on_components_num` (`components_num`),
  KEY `index_az_base_project_stats_on_pages_num` (`pages_num`),
  KEY `index_az_base_project_stats_on_commons_num` (`commons_num`),
  KEY `index_az_base_project_stats_on_definitions_num` (`definitions_num`),
  KEY `index_az_base_project_stats_on_structs_num` (`structs_num`),
  KEY `index_az_base_project_stats_on_structs_variables_num` (`structs_variables_num`),
  KEY `index_az_base_project_stats_on_design_sources_num` (`design_sources_num`),
  KEY `index_az_base_project_stats_on_designs_num` (`designs_num`),
  KEY `index_az_base_project_stats_on_images_num` (`images_num`),
  KEY `index_az_base_project_stats_on_words_num` (`words_num`),
  KEY `index_az_base_project_stats_on_disk_usage` (`disk_usage`),
  KEY `index_az_base_project_stats_on_quality` (`quality`)
) ENGINE=InnoDB AUTO_INCREMENT=488420 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_base_project_stats`
--

LOCK TABLES `az_base_project_stats` WRITE;
/*!40000 ALTER TABLE `az_base_project_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_base_project_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_base_projects`
--

DROP TABLE IF EXISTS `az_base_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_base_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `customer` varchar(255) DEFAULT NULL,
  `favicon_file_name` varchar(255) DEFAULT NULL,
  `favicon_content_type` varchar(255) DEFAULT NULL,
  `favicon_file_size` int(11) DEFAULT NULL,
  `favicon_updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `rm_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `layout_time` float DEFAULT '0',
  `copy_of` int(11) DEFAULT NULL,
  `percent_complete` float NOT NULL DEFAULT '0',
  `az_project_status_id` int(11) NOT NULL DEFAULT '1',
  `disk_usage` int(11) NOT NULL DEFAULT '0',
  `seed` tinyint(1) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `public_access` tinyint(1) NOT NULL DEFAULT '0',
  `parent_project_id` int(11) DEFAULT NULL,
  `deleting` tinyint(1) DEFAULT '0',
  `cache` tinyint(1) NOT NULL DEFAULT '0',
  `explorable` tinyint(1) DEFAULT '1',
  `forkable` tinyint(1) DEFAULT '1',
  `quality_correction` float DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_az_base_projects_on_owner_id` (`owner_id`),
  KEY `index_az_base_projects_on_parent_project_id` (`parent_project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5603 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_base_projects`
--

LOCK TABLES `az_base_projects` WRITE;
/*!40000 ALTER TABLE `az_base_projects` DISABLE KEYS */;
INSERT INTO `az_base_projects` VALUES (355,'Сайт дизайн-студии',NULL,NULL,NULL,NULL,NULL,'2011-02-21 12:18:34','2017-06-20 00:31:14',2,2,106,'AzProject',1,NULL,0,8,3937884,1,1,0,NULL,0,0,1,1,1);
INSERT INTO `az_base_projects` VALUES (356,'Форма обратной связи',NULL,NULL,NULL,NULL,NULL,'2010-12-23 08:50:47','2012-01-14 08:10:47',2,2,NULL,'AzProjectBlock',0,2,0,1,0,0,0,0,355,0,0,1,1,1);
INSERT INTO `az_base_projects` VALUES (5602,'Форма обратной связи',NULL,NULL,NULL,NULL,NULL,'2010-12-23 08:50:47','2011-10-11 06:56:27',2,2,NULL,'AzProjectBlock',0,2,0,1,0,1,8,0,NULL,0,0,1,1,1);
/*!40000 ALTER TABLE `az_base_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_base_projects_az_definitions`
--

DROP TABLE IF EXISTS `az_base_projects_az_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_base_projects_az_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_base_project_id` int(11) DEFAULT NULL,
  `az_definition_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_base_projects_az_definitions`
--

LOCK TABLES `az_base_projects_az_definitions` WRITE;
/*!40000 ALTER TABLE `az_base_projects_az_definitions` DISABLE KEYS */;
INSERT INTO `az_base_projects_az_definitions` VALUES (1,1,1,'2010-12-23 18:46:55','2010-12-23 18:46:55',2);
INSERT INTO `az_base_projects_az_definitions` VALUES (2,1,2,'2010-12-23 18:46:55','2010-12-23 18:46:55',2);
/*!40000 ALTER TABLE `az_base_projects_az_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_bills`
--

DROP TABLE IF EXISTS `az_bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_invoice_id` int(11) NOT NULL,
  `description` text,
  `date_from` datetime DEFAULT NULL,
  `date_till` datetime DEFAULT NULL,
  `fee` decimal(20,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_bills_on_az_invoice_id` (`az_invoice_id`),
  KEY `index_az_bills_on_date_from` (`date_from`),
  KEY `index_az_bills_on_date_till` (`date_till`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_bills`
--

LOCK TABLES `az_bills` WRITE;
/*!40000 ALTER TABLE `az_bills` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_c_images`
--

DROP TABLE IF EXISTS `az_c_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_c_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `az_c_image_category` int(11) DEFAULT NULL,
  `c_image_file_name` varchar(255) NOT NULL,
  `c_image_content_type` varchar(255) NOT NULL,
  `c_image_file_size` int(11) NOT NULL,
  `c_image_updated_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `item_type` varchar(255) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_c_images_on_owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_c_images`
--

LOCK TABLES `az_c_images` WRITE;
/*!40000 ALTER TABLE `az_c_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_c_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_collection_templates`
--

DROP TABLE IF EXISTS `az_collection_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_collection_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_collection_templates`
--

LOCK TABLES `az_collection_templates` WRITE;
/*!40000 ALTER TABLE `az_collection_templates` DISABLE KEYS */;
INSERT INTO `az_collection_templates` VALUES (1,'Список','2010-12-23 09:24:46','2010-12-23 09:24:46',2);
/*!40000 ALTER TABLE `az_collection_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_commons`
--

DROP TABLE IF EXISTS `az_commons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_commons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `az_base_project_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `comment` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `seed` tinyint(1) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_commons_on_az_base_project_id` (`az_base_project_id`),
  KEY `index_az_commons_on_owner_id` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25585 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_commons`
--

LOCK TABLES `az_commons` WRITE;
/*!40000 ALTER TABLE `az_commons` DISABLE KEYS */;
INSERT INTO `az_commons` VALUES (1,2,NULL,'Как обычно','Все страницы сайта содержат «шапку», которая состоит из названия сайта, анимированного блока, текстового блока, меню. Подвал, состоит из счетчиков, копирайта и дублированного меню. ','','AzCommonsCommon',NULL,'2010-12-22 18:55:16','2011-02-22 10:52:44',1,0,1);
INSERT INTO `az_commons` VALUES (2,2,NULL,'Каталог','Эксплуатационным назначением сайта является продажа товаров, привлечение дилеров. ','','AzCommonsPurposeExploitation',NULL,'2010-12-22 19:01:07','2010-12-22 19:01:07',1,0,2);
INSERT INTO `az_commons` VALUES (3,2,NULL,'Каталог','Разрабатываемый сайт должен предоставлять возможность посетителю ознакомиться с перечнем товаров, имеющихся в магазине, перечнем производимых услуг; просмотреть детальное описание товаров (услуг). Также на сайте должна быть вспомогательная информация: информация о компании, дилерам и т.д. ','','AzCommonsPurposeFunctional',NULL,'2010-12-22 19:02:13','2012-03-26 19:51:56',1,0,3);
INSERT INTO `az_commons` VALUES (4,2,NULL,'PHP, MySQL (маленький)','Минимальная конфигурация хостинга необходимая для функционирования сайта следующая:\r\n* Хостинг с дисковой квотой не менее 50 Мб\r\n* Хостинг с PHP5 и установленным модулем Rewrite\r\n* База данных MySQL версии 5 и выше с модулем InnoDB\r\n* Наличие зарегистрированного и корректно настроенного домена','','AzCommonsRequirementsHosting',NULL,'2010-12-22 19:03:48','2012-03-26 19:57:17',1,0,4);
INSERT INTO `az_commons` VALUES (5,2,NULL,'Копия и бэкап','Рекомендуется хранить одну копию программного обеспечения на внешнем носителе. Также рекомендуется регулярно копировать файл базы данных на внешний носитель, если такую услугу не предоставляет хостинговая компания.','','AzCommonsRequirementsReliability',NULL,'2010-12-22 19:04:52','2012-03-27 12:58:12',1,0,5);
INSERT INTO `az_commons` VALUES (6,2,NULL,'7+30','Приемка программы осуществляется после периода опытной эксплуатации программы. Если сайт работает корректно и устойчиво в течение 7-х календарных дней, период опытной эксплуатации считается завершенным. Исполнитель обязуется сопровождать программный продукт в течение 1-го месяца с начала периода эксплуатации, устранять все недоработки и несоответствия техническому заданию (без изменения состава функций программы).','','AzCommonsAcceptanceCondition',NULL,'2010-12-22 19:05:51','2011-02-22 10:54:41',1,0,6);
INSERT INTO `az_commons` VALUES (7,2,NULL,'Минимальное наполнение','Исполнитель обязуется выполнить минимальное наполнение сайта, которое позволит начать эксплуатацию сайта заказчиком. Исполнитель должен создать описанные в настоящем ТЗ категории товаров, создать супер-пользователя. В обязанности исполнителя не входит наполнение таких разделов как «каталог товаров», «FAQ», «статьи», и т. п.','','AzCommonsContentCreation',NULL,'2010-12-22 19:07:50','2012-03-26 20:06:24',1,0,7);
INSERT INTO `az_commons` VALUES (15,2,NULL,'Визитка','Разрабатываемый сайт должен предоставлять возможность посетителю ознакомиться с перечнем производимых услуг; просмотреть детальное описание услуг, условия работы. Также на сайте должна быть информация о местоположении фирмы, и должна быть предусмотрена возможность отправки пользователем сообщений.','','AzCommonsPurposeFunctional',NULL,'2010-12-23 16:45:37','2012-03-26 19:54:03',1,0,15);
INSERT INTO `az_commons` VALUES (17,2,NULL,'Визитка','Эксплуатационным назначением сайта является привлечение новых клиентов. ','','AzCommonsPurposeExploitation',NULL,'2010-12-23 16:48:02','2012-03-26 19:46:33',1,0,17);
INSERT INTO `az_commons` VALUES (1348,2,355,'Как обычно','Все страницы сайта содержат «шапку», которая состоит из названия сайта, анимированного блока, текстового блока, меню. Подвал, состоит из счетчиков, копирайта и дублированного меню. ','','AzCommonsCommon',1,'2010-12-22 18:55:16','2011-03-19 11:54:18',0,2,1348);
INSERT INTO `az_commons` VALUES (1349,2,355,'7+30','Приемка программы осуществляется после периода опытной эксплуатации программы. Если сайт работает корректно и устойчиво в течение 7-х календарных дней, период опытной эксплуатации считается завершенным. Исполнитель обязуется сопровождать программный продукт в течение 1-го месяца с начала периода эксплуатации, устранять все недоработки и несоответствия техническому заданию (без изменения состава функций программы).','','AzCommonsAcceptanceCondition',6,'2010-12-22 19:05:51','2011-03-19 18:53:53',0,2,1349);
INSERT INTO `az_commons` VALUES (1354,2,355,'Копия и бэкап','Рекомендуется хранить одну копию программного обеспечения на внешнем носителе. Также рекомендуется регулярно копировать файл базы данных на внешний носитель, если такую услугу не предоставляет хостинговая компания.','','AzCommonsRequirementsReliability',5,'2010-12-22 19:04:52','2011-03-19 18:54:42',0,2,1354);
INSERT INTO `az_commons` VALUES (1355,2,355,'Эксп. назначение сайта дизайн-студии','Назначение сайта - быть витриной студии в Интернете.','','AzCommonsPurposeExploitation',NULL,'2011-02-22 09:58:23','2011-03-19 11:54:57',0,2,1355);
INSERT INTO `az_commons` VALUES (1356,2,355,'Функц. назначение сайта','Сайт должен предоставлять возможность посетеителю ознакомиться с портфолио студии, предоставить немного текстовой информации о студии и возможность отправить сообщение.','','AzCommonsPurposeFunctional',NULL,'2011-02-22 10:00:21','2011-03-19 11:55:29',0,2,1356);
INSERT INTO `az_commons` VALUES (1357,2,NULL,'Без наполнения','Наполнением сайта исполнитель не занимается.','','AzCommonsContentCreation',NULL,'2011-02-22 10:42:23','2011-02-22 10:47:45',1,0,1357);
INSERT INTO `az_commons` VALUES (1358,2,355,'Без наполнения','Наполнением сайта исполнитель не занимается.','','AzCommonsContentCreation',1357,'2011-02-22 10:42:23','2011-03-19 18:56:16',0,2,1358);
INSERT INTO `az_commons` VALUES (1359,2,NULL,'PHP, MySQL (средний)','Минимальная конфигурация хостинга необходимая для функционирования сайта следующая:\r\n* Хостинг с дисковой квотой не менее 250 Мб\r\n* Хостинг с PHP5 и установленным модулем Rewrite\r\n* База данных MySQL версии 5 и выше с модулем InnoDB\r\n* Наличие зарегистрированного и корректно настроенного домена','','AzCommonsRequirementsHosting',NULL,'2011-02-22 10:45:50','2012-03-26 19:57:55',1,0,1359);
INSERT INTO `az_commons` VALUES (1360,2,355,'PHP, MySQL (средний)','Минимальная конфигурация хостинга необходимая для функционирования сайта следующая:\r\n* Хостинг с дисковой квотой не менее 250 Мб\r\n* Хостинг с PHP5 и установленным модулем Rewrite\r\n* База данных MySQL версии 5 и выше с модулем InnoDB\r\n* Наличие зарегистрированного и корректно настроенного домена','','AzCommonsRequirementsHosting',1359,'2011-02-22 10:45:50','2011-03-19 18:56:01',0,2,1360);
INSERT INTO `az_commons` VALUES (1627,2,NULL,'Скопировать с сайта','Наполнение необходимо сграбить с сайта http://www.example.com и разместить на этом сайте. Вопросы копирайта заказчик берет на себя.','','AzCommonsContentCreation',NULL,'2011-02-22 11:58:16','2011-02-22 11:58:16',1,0,1627);
INSERT INTO `az_commons` VALUES (2318,2,NULL,'Магазин одежды','h3. Сфера деятельности компании\r\n\r\nИнтернет-магазин бутик одежды, обуви и аксессуаров от различных производителей. В ассортименте более +NNN+ французских и итальянских брендов. Вся продукция имеющаяся на сайте является исключительно оригинальной.\r\n\r\nh3. Целевая аудитория\r\n\r\nАудитория сайта, и мужская и женская, т.к. на сайте представлена одежа для обоих полов. Возраст, преимущественно, от 30 лет. Место жительства - Москва и область, другие города интересуют в меньшей степени. Финансовое положение - выше среднего.\r\n\r\nh3. Конкуренты и их сайты\r\n\r\nwww.example.com - основной конкурент\r\nwww.example.com - еще один, не столь значимый конкурент\r\n\r\nh3. Подобные сайты\r\n\r\nwww.example.com - сайт с отлично продуманной структурой\r\nwww.example.com - большой выбор одежды\r\n','','AzCommonsCommon',NULL,'2011-03-08 11:55:06','2011-03-08 12:15:11',1,0,2318);
INSERT INTO `az_commons` VALUES (2320,2,NULL,'Магазин','Эксплуатационным назначением сайта является продажа товаров через интернет.','','AzCommonsPurposeExploitation',NULL,'2011-03-08 12:30:00','2011-03-08 12:30:00',1,0,2320);
INSERT INTO `az_commons` VALUES (2322,2,NULL,'Магазин','Разрабатываемый сайт должен предоставлять возможность посетителю ознакомиться с перечнем товаров, имеющихся в магазине, просмотреть детальное описание товаров и выполнить покупку понравившихся вещей. Также на сайте должна быть вспомогательная информация: информация о компании, условия доставки и возврата и т.д.','','AzCommonsPurposeFunctional',NULL,'2011-03-08 12:32:23','2012-03-26 19:55:30',1,0,2322);
INSERT INTO `az_commons` VALUES (18158,2,NULL,'Chrome, FF, Safari, Opera, IE','Сайт должен корректно отображаться в следующих браузерах:\r\n* Chrome 13\r\n* FireFox 4\r\n* Safari 5\r\n* Opera 11\r\n* Internet Explorer 8 и 9','','AzCommonsAcceptanceCondition',NULL,'2011-09-30 10:04:02','2011-09-30 10:04:02',1,0,18154);
INSERT INTO `az_commons` VALUES (18738,2,NULL,'Функционал по умолчанию','Не описанный явно в этом техническом задании функционал, так же как и дизайн страниц, которые не были предоставлены дизайнером, остается на усмотрение разработчиков.','','AzCommonsAcceptanceCondition',NULL,'2011-09-30 10:07:10','2011-09-30 10:07:10',1,0,18738);
INSERT INTO `az_commons` VALUES (19318,2,NULL,'Cron','На хостинге должна быть возможность выполнять скрипты по расписанию, например, с помощью cron-а.','','AzCommonsRequirementsHosting',NULL,'2011-09-30 10:18:06','2012-03-26 19:58:26',1,0,19318);
INSERT INTO `az_commons` VALUES (25584,2,NULL,'XSS, SQL-инъекции, CSRF-уязвимости','Сайт должен предусматривать базовую защиту от основных видов атак: межсайтового скриптинга (XSS), SQL-инъекций, CSRF-уязвимостей.',NULL,'AzCommonsRequirementsReliability',NULL,'2012-03-26 09:52:04','2012-03-26 20:01:18',1,0,25584);
/*!40000 ALTER TABLE `az_commons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_companies`
--

DROP TABLE IF EXISTS `az_companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `ceo_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_from_seeds` datetime DEFAULT NULL,
  `az_tariff_id` int(11) DEFAULT NULL,
  `logo_file_name` varchar(255) DEFAULT NULL,
  `logo_content_type` varchar(255) DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  `site` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_companies`
--

LOCK TABLES `az_companies` WRITE;
/*!40000 ALTER TABLE `az_companies` DISABLE KEYS */;
INSERT INTO `az_companies` VALUES (1,'Студия имени admin',1,'2010-12-22 10:09:19','2017-06-28 14:40:47','2011-08-26 07:01:28',9,NULL,NULL,NULL,NULL,'');
INSERT INTO `az_companies` VALUES (2,'Студия имени seeder',2,'2010-12-22 10:09:19','2017-06-28 15:01:57','2010-12-22 10:23:30',9,NULL,NULL,NULL,NULL,'');
/*!40000 ALTER TABLE `az_companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_contacts`
--

DROP TABLE IF EXISTS `az_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `my_id` int(11) NOT NULL,
  `az_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_contacts`
--

LOCK TABLES `az_contacts` WRITE;
/*!40000 ALTER TABLE `az_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_definitions`
--

DROP TABLE IF EXISTS `az_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `definition` text,
  `az_user_id` int(11) DEFAULT NULL,
  `az_base_project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `seed` tinyint(1) DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_definitions_on_owner_id` (`owner_id`),
  KEY `index_az_definitions_on_copy_of` (`copy_of`),
  KEY `index_az_definitions_on_az_base_project_id` (`az_base_project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=427 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_definitions`
--

LOCK TABLES `az_definitions` WRITE;
/*!40000 ALTER TABLE `az_definitions` DISABLE KEYS */;
INSERT INTO `az_definitions` VALUES (1,'Сайт','Сайт — совокупность электронных документов (файлов) частного лица или организации в компьютерной сети, объединённых под одним адресом (доменным именем или IP-адресом). По умолчанию подразумевается, что сайт располагается в сети Интернет. (с) wikipedia http://ru.wikipedia.org/wiki/Сайт',NULL,NULL,'2010-12-22 17:32:01','2012-03-26 19:40:51',2,1,NULL,0,1);
INSERT INTO `az_definitions` VALUES (2,'Хостинг','Хостинг (англ. hosting) — услуга по предоставлению вычислительных мощностей для физического размещения информации на сервере, постоянно находящемся в сети (обычно Интернет). (с) wikipedia http://ru.wikipedia.org/wiki/Хостинг',NULL,NULL,'2010-12-22 18:26:44','2010-12-22 18:26:44',2,1,NULL,0,2);
INSERT INTO `az_definitions` VALUES (284,'Тип работы','Разделение работ в портфолио на на типы: сайт, логотип, полиграфия, и т.д. Одна работа принадлежит одному типу.',NULL,355,'2011-02-22 09:38:44','2011-03-19 11:56:09',2,0,NULL,2,284);
INSERT INTO `az_definitions` VALUES (285,'Категория','Подразделение \"типа работ\" на \"категории\". Например тип работы \"сайт\" может включать такие категории выполненных работ: \"дизайн\", \"верстка\" и \"программирование\". Это необходимо, что бы отметить, что студия выполнила для сайта только часть работ, например только дизайн.',NULL,355,'2011-02-22 09:41:28','2011-03-19 11:56:23',2,0,NULL,2,285);
INSERT INTO `az_definitions` VALUES (422,'Целевая аудитория сайта','Целевая аудитория сайта, целевая посещаемость, целевые посетители сайта — группа интернет-пользователей, на которую сфокусировано содержание сайта; круг посетителей, заинтересованных в информации, товарах или услугах, представленных на сайте. Целевые посетители точно знают в получении какой информации они заинтересованы и какой именно товар или услугу желают приобрести.\r\n\r\nВыделение целевой аудитории позволяет точнее направить информационное или рекламное воздействие и, как следствие, ведет к развитию бизнеса (увеличению продаж товаров или услуг).\r\n\r\n(с) wikipedia.org',NULL,NULL,'2011-03-08 12:07:37','2011-03-08 12:07:37',2,1,NULL,0,422);
INSERT INTO `az_definitions` VALUES (426,'Валидатор','Валидатор, валидатор формата (калька с англ. validator) — компьютерная подпрограмма, которая проверяет соответствие каких-либо данных определённому формату — то есть, производит валидацию. \r\n\r\nПример. Соответсвие формата телефонного номера: строка \"123-45-67\" - валидный телефонный номер, строка \"позвони мне, позвони\" - не соответсвует формату телефонного номера.\r\n\r\nВ компьютерном сленге слово валидный является синонимом слова корректный.',NULL,NULL,'2011-03-10 13:12:11','2011-03-10 13:12:11',2,1,NULL,0,426);
/*!40000 ALTER TABLE `az_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_design_sources`
--

DROP TABLE IF EXISTS `az_design_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_design_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_design_id` int(11) NOT NULL,
  `source_file_name` varchar(255) NOT NULL,
  `source_content_type` varchar(255) NOT NULL,
  `source_file_size` int(11) NOT NULL,
  `source_updated_at` datetime NOT NULL,
  `owner_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `az_design_id` (`az_design_id`),
  KEY `index_az_design_sources_on_az_design_id` (`az_design_id`),
  KEY `index_az_design_sources_on_copy_of` (`copy_of`)
) ENGINE=InnoDB AUTO_INCREMENT=1484 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_design_sources`
--

LOCK TABLES `az_design_sources` WRITE;
/*!40000 ALTER TABLE `az_design_sources` DISABLE KEYS */;
INSERT INTO `az_design_sources` VALUES (2,148,'main-page.psd','image/vnd.adobe.photoshop',1641329,'2011-06-22 09:16:59',2,'2011-06-22 09:16:59','2011-06-22 09:16:59',NULL);
INSERT INTO `az_design_sources` VALUES (3,149,'main-page-shaded.psd','image/vnd.adobe.photoshop',1575033,'2011-06-22 09:16:59',2,'2011-06-22 09:16:59','2011-06-22 09:16:59',NULL);
INSERT INTO `az_design_sources` VALUES (1471,1872,'message_error.ep','application/octet-stream',33706,'2011-10-09 20:27:28',2,'2011-10-09 20:27:28','2011-10-09 20:27:31',NULL);
INSERT INTO `az_design_sources` VALUES (1472,1873,'message.ep','application/octet-stream',22733,'2011-10-09 20:30:06',2,'2011-10-09 20:30:06','2011-10-09 20:30:07',NULL);
INSERT INTO `az_design_sources` VALUES (1478,1879,'message_sent.ep','application/octet-stream',14671,'2011-10-09 20:37:47',2,'2011-10-09 20:37:47','2011-10-09 20:37:48',NULL);
INSERT INTO `az_design_sources` VALUES (1483,1884,'message_view.ep','application/octet-stream',26064,'2011-10-10 08:05:49',2,'2011-10-10 08:05:49','2011-10-10 08:05:51',NULL);
/*!40000 ALTER TABLE `az_design_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_designs`
--

DROP TABLE IF EXISTS `az_designs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_designs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `az_page_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `copy_of` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_designs_on_az_page_id` (`az_page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1885 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_designs`
--

LOCK TABLES `az_designs` WRITE;
/*!40000 ALTER TABLE `az_designs` DISABLE KEYS */;
INSERT INTO `az_designs` VALUES (148,'Основной дизайн',1913,'2011-02-22 12:47:44','2011-06-22 09:16:59',2,NULL);
INSERT INTO `az_designs` VALUES (149,'Затенённые работы',1913,'2011-02-22 12:48:02','2011-06-22 09:16:59',2,NULL);
INSERT INTO `az_designs` VALUES (1872,'Основной дизайн',46222,'2011-10-09 20:27:31','2011-10-09 20:27:31',2,NULL);
INSERT INTO `az_designs` VALUES (1873,'Основной дизайн',46220,'2011-10-09 20:30:07','2011-10-09 20:30:07',2,NULL);
INSERT INTO `az_designs` VALUES (1879,'Основной дизайн',46221,'2011-10-09 20:37:48','2011-10-09 20:37:48',2,NULL);
INSERT INTO `az_designs` VALUES (1882,'Основной дизайн',46223,'2011-10-09 21:50:19','2011-10-09 21:50:19',2,NULL);
INSERT INTO `az_designs` VALUES (1883,'Удаление сообщения',46223,'2011-10-09 21:50:34','2011-10-09 21:50:34',2,NULL);
INSERT INTO `az_designs` VALUES (1884,'Основной дизайн',46224,'2011-10-10 08:05:51','2011-10-10 08:05:51',2,NULL);
/*!40000 ALTER TABLE `az_designs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_employees`
--

DROP TABLE IF EXISTS `az_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_user_id` int(11) DEFAULT NULL,
  `az_company_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_employees`
--

LOCK TABLES `az_employees` WRITE;
/*!40000 ALTER TABLE `az_employees` DISABLE KEYS */;
INSERT INTO `az_employees` VALUES (1,1,1,'2010-12-22 10:09:19','2010-12-22 10:09:19',2,0);
INSERT INTO `az_employees` VALUES (2,2,2,'2010-12-22 10:09:19','2010-12-22 10:09:19',2,0);
/*!40000 ALTER TABLE `az_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_guest_links`
--

DROP TABLE IF EXISTS `az_guest_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_guest_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash_str` varchar(255) NOT NULL,
  `az_base_project_id` int(11) NOT NULL,
  `expired_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `az_user_id` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_guest_links`
--

LOCK TABLES `az_guest_links` WRITE;
/*!40000 ALTER TABLE `az_guest_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_guest_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_images`
--

DROP TABLE IF EXISTS `az_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_design_id` int(11) NOT NULL,
  `image_file_name` varchar(255) NOT NULL,
  `image_content_type` varchar(255) NOT NULL,
  `image_file_size` int(11) NOT NULL,
  `image_updated_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `tiny_image_width` int(11) NOT NULL DEFAULT '50',
  `tiny_image_height` int(11) NOT NULL DEFAULT '75',
  PRIMARY KEY (`id`),
  KEY `index_az_images_on_az_design_id` (`az_design_id`),
  KEY `index_az_images_on_owner_id` (`owner_id`),
  KEY `index_az_images_on_copy_of` (`copy_of`)
) ENGINE=InnoDB AUTO_INCREMENT=1932 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_images`
--

LOCK TABLES `az_images` WRITE;
/*!40000 ALTER TABLE `az_images` DISABLE KEYS */;
INSERT INTO `az_images` VALUES (158,148,'main-page.png','image/png',391782,'2011-02-22 13:25:52','2011-02-22 13:25:53','2011-09-30 10:22:25',2,NULL,50,39);
INSERT INTO `az_images` VALUES (159,149,'main-page-shaded.png','image/png',329740,'2011-02-22 13:26:55','2011-02-22 13:26:57','2011-09-30 10:22:25',2,NULL,50,39);
INSERT INTO `az_images` VALUES (1919,1872,'message_error.png','image/png',23108,'2011-10-09 20:27:20','2011-10-09 20:27:21','2011-10-09 20:27:31',2,NULL,50,38);
INSERT INTO `az_images` VALUES (1920,1873,'message.png','image/png',15770,'2011-10-09 20:29:19','2011-10-09 20:29:19','2011-10-09 20:30:07',2,NULL,50,32);
INSERT INTO `az_images` VALUES (1926,1879,'message_sent.png','image/png',15352,'2011-10-09 20:37:41','2011-10-09 20:37:42','2011-10-09 20:37:48',2,NULL,50,38);
INSERT INTO `az_images` VALUES (1929,1882,'message_list.png','image/png',41801,'2011-10-09 21:50:17','2011-10-09 21:50:17','2011-10-09 21:50:19',2,NULL,50,47);
INSERT INTO `az_images` VALUES (1930,1883,'message_list_delete.png','image/png',45100,'2011-10-09 21:50:33','2011-10-09 21:50:33','2011-10-09 21:50:34',2,NULL,50,47);
INSERT INTO `az_images` VALUES (1931,1884,'message_view.png','image/png',4810,'2011-10-10 08:05:48','2011-10-10 08:05:49','2011-10-10 08:05:51',2,NULL,50,32);
/*!40000 ALTER TABLE `az_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_invitations`
--

DROP TABLE IF EXISTS `az_invitations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash_str` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `invitation_type` varchar(255) NOT NULL,
  `invitation_data` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `rejected` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_invitations`
--

LOCK TABLES `az_invitations` WRITE;
/*!40000 ALTER TABLE `az_invitations` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_invoices`
--

DROP TABLE IF EXISTS `az_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_balance_transaction_id` int(11) DEFAULT NULL,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_az_invoices_on_az_balance_transaction_id` (`az_balance_transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_invoices`
--

LOCK TABLES `az_invoices` WRITE;
/*!40000 ALTER TABLE `az_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_languages`
--

DROP TABLE IF EXISTS `az_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `english_name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `lang_icon_file_name` varchar(255) NOT NULL,
  `lang_icon_content_type` varchar(255) NOT NULL,
  `lang_icon_file_size` int(11) NOT NULL,
  `lang_icon_updated_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_languages`
--

LOCK TABLES `az_languages` WRITE;
/*!40000 ALTER TABLE `az_languages` DISABLE KEYS */;
INSERT INTO `az_languages` VALUES (1,'Русский','Russian','rus','ru.png','image/png',741,'2012-02-11 15:06:51','2012-02-11 15:06:52','2012-02-11 15:06:52');
/*!40000 ALTER TABLE `az_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_mailing_header_footer`
--

DROP TABLE IF EXISTS `az_mailing_header_footer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_mailing_header_footer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `header` text NOT NULL,
  `footer` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_mailing_header_footer`
--

LOCK TABLES `az_mailing_header_footer` WRITE;
/*!40000 ALTER TABLE `az_mailing_header_footer` DISABLE KEYS */;
INSERT INTO `az_mailing_header_footer` VALUES (1,'<p>azalo.net</p>\r\n<hr />','<p><a href=\"https://azalo.net/unsubscribe/%user_id%\">Отписаться от рассылки</a></p>\r\n<hr />\r\n<p>azalo.net</p>');
/*!40000 ALTER TABLE `az_mailing_header_footer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_mailing_messages`
--

DROP TABLE IF EXISTS `az_mailing_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_mailing_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `text` text,
  `active` tinyint(1) DEFAULT NULL,
  `force` tinyint(1) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_mailing_messages`
--

LOCK TABLES `az_mailing_messages` WRITE;
/*!40000 ALTER TABLE `az_mailing_messages` DISABLE KEYS */;
INSERT INTO `az_mailing_messages` VALUES (1,'Запуск сервиса azalo.net','Окончание тестирования azalo.net','<p>Приветствуем, %user_name%,</p>\r\n<p>Рады сообщить, что тестовый период работы сервиса azalo.net подошел к концу. Благодарим всех пользователей, которые принимали непосредственное участие в тестировании и развитии сервиса.</p>\r\n<p>С 26 февраля azalo.net переходит в режим эксплуатации. С этого момента установлены тарифы для пользователей, с которыми Вы можете подробно <a href=\"https://azalo.net/tariffs\">ознакомиться здесь</a></p>\r\n<p>Все зарегистрированные на сегодня пользователи переведены на бесплатный тариф. Если в Вашем аккаунте было создано несколько проектов, то активным оставлен последний рабочий проект, но Вы можете сделать активным любой другой.</p>\r\n<p>Если Вы желаете перейти на один из платных тарифов, зайдите в раздел <a href=\"https://azalo.net/profile\">Мои данные</a> и пройдите по ссылке Сменить тариф. Причем для Вас любой из платных тарифов будет действовать бесплатно в течение первых 30 дней.</p>\r\n<p>Оплатить услуги сервиса azalo.net пока можно картами Visa/Master Card. В дальнейшем будут подключены другие способы оплаты.</p>\r\n<p>Администрация azalo.net</p>\r\n<p>По всем вопросам обращайтесь по адресу support@azalo.net</p>',NULL,0,'2012-02-25 13:00:59');
/*!40000 ALTER TABLE `az_mailing_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_mailing_messages_categories`
--

DROP TABLE IF EXISTS `az_mailing_messages_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_mailing_messages_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_mailing_message_id` int(11) DEFAULT NULL,
  `az_subscribtion_category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_mailing_messages_categories`
--

LOCK TABLES `az_mailing_messages_categories` WRITE;
/*!40000 ALTER TABLE `az_mailing_messages_categories` DISABLE KEYS */;
INSERT INTO `az_mailing_messages_categories` VALUES (3,1,1);
/*!40000 ALTER TABLE `az_mailing_messages_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_mailings`
--

DROP TABLE IF EXISTS `az_mailings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_mailings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_mailing_message_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '1',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_mailings`
--

LOCK TABLES `az_mailings` WRITE;
/*!40000 ALTER TABLE `az_mailings` DISABLE KEYS */;
INSERT INTO `az_mailings` VALUES (1,1,'',0,3,'2012-02-25 13:02:23');
INSERT INTO `az_mailings` VALUES (2,1,'',0,3,'2012-02-26 18:18:24');
INSERT INTO `az_mailings` VALUES (3,1,'',0,3,'2012-02-26 18:29:18');
INSERT INTO `az_mailings` VALUES (4,1,'',0,3,'2012-02-26 18:34:21');
/*!40000 ALTER TABLE `az_mailings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_messages`
--

DROP TABLE IF EXISTS `az_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_type` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `note` text NOT NULL,
  `status1` int(11) NOT NULL DEFAULT '0',
  `status2` int(11) NOT NULL DEFAULT '0',
  `status3` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_messages`
--

LOCK TABLES `az_messages` WRITE;
/*!40000 ALTER TABLE `az_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_news`
--

DROP TABLE IF EXISTS `az_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `announce` text NOT NULL,
  `body` text NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '0',
  `az_user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_news`
--

LOCK TABLES `az_news` WRITE;
/*!40000 ALTER TABLE `az_news` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_operation_times`
--

DROP TABLE IF EXISTS `az_operation_times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_operation_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_base_data_type_id` int(11) NOT NULL,
  `az_operation_id` int(11) NOT NULL,
  `operation_time` float DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `seed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_operation_times`
--

LOCK TABLES `az_operation_times` WRITE;
/*!40000 ALTER TABLE `az_operation_times` DISABLE KEYS */;
INSERT INTO `az_operation_times` VALUES (1,1,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (2,2,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (3,3,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (4,4,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (5,5,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (6,6,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (7,7,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (8,8,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (9,9,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (10,10,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (11,11,1,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (12,1,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (13,2,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (14,3,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (15,4,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (16,5,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (17,6,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (18,7,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (19,8,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (20,9,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (21,10,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (22,11,2,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (23,1,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (24,2,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (25,3,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (26,4,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (27,5,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (28,6,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (29,7,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (30,8,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (31,9,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (32,10,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (33,11,3,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (34,1,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (35,2,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (36,3,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (37,4,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (38,5,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (39,6,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (40,7,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (41,8,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (42,9,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (43,10,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (44,11,4,1,NULL,'2010-12-22 12:09:19','2010-12-22 12:09:19',2,NULL);
INSERT INTO `az_operation_times` VALUES (45,30491,1,1,NULL,'2012-03-07 13:39:34','2012-03-07 13:39:34',2,NULL);
INSERT INTO `az_operation_times` VALUES (46,30491,2,1,NULL,'2012-03-07 13:39:39','2012-03-07 13:39:39',2,NULL);
INSERT INTO `az_operation_times` VALUES (47,30491,3,1,NULL,'2012-03-07 13:39:42','2012-03-07 13:39:42',2,NULL);
INSERT INTO `az_operation_times` VALUES (48,30491,4,1,NULL,'2012-03-07 13:39:45','2012-03-07 13:39:45',2,NULL);
/*!40000 ALTER TABLE `az_operation_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_operations`
--

DROP TABLE IF EXISTS `az_operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_operations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `crud_name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `complexity` decimal(10,0) NOT NULL DEFAULT '1',
  `float` decimal(10,0) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_operations`
--

LOCK TABLES `az_operations` WRITE;
/*!40000 ALTER TABLE `az_operations` DISABLE KEYS */;
INSERT INTO `az_operations` VALUES (1,'Создание','new','2010-12-22 12:09:18','2010-12-22 12:09:18',1,1);
INSERT INTO `az_operations` VALUES (2,'Отображение','show','2010-12-22 12:09:18','2010-12-22 12:09:18',1,1);
INSERT INTO `az_operations` VALUES (3,'Редактирование','edit','2010-12-22 12:09:18','2010-12-22 12:09:18',1,1);
INSERT INTO `az_operations` VALUES (4,'Удаление','delete','2010-12-22 12:09:18','2010-12-22 12:09:18',1,1);
/*!40000 ALTER TABLE `az_operations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_outboxes`
--

DROP TABLE IF EXISTS `az_outboxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_outboxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mailing_id` int(11) DEFAULT NULL,
  `az_user_id` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `e_message` text NOT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_outboxes`
--

LOCK TABLES `az_outboxes` WRITE;
/*!40000 ALTER TABLE `az_outboxes` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_outboxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_page_az_page_types`
--

DROP TABLE IF EXISTS `az_page_az_page_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_page_az_page_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_page` int(11) DEFAULT NULL,
  `az_page_type` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_page_az_page_types`
--

LOCK TABLES `az_page_az_page_types` WRITE;
/*!40000 ALTER TABLE `az_page_az_page_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_page_az_page_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_page_az_pages`
--

DROP TABLE IF EXISTS `az_page_az_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_page_az_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_page_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_page_az_pages_on_page_id` (`page_id`),
  KEY `index_az_page_az_pages_on_parent_page_id` (`parent_page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42786 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_page_az_pages`
--

LOCK TABLES `az_page_az_pages` WRITE;
/*!40000 ALTER TABLE `az_page_az_pages` DISABLE KEYS */;
INSERT INTO `az_page_az_pages` VALUES (501,1913,1915,1,'2011-02-21 14:31:26','2011-03-20 13:12:55');
INSERT INTO `az_page_az_pages` VALUES (502,1913,1916,2,'2011-02-21 14:31:52','2011-02-21 16:11:14');
INSERT INTO `az_page_az_pages` VALUES (503,1913,1917,3,'2011-02-21 14:32:09','2011-03-21 09:12:41');
INSERT INTO `az_page_az_pages` VALUES (504,1913,1918,4,'2011-02-21 14:32:17','2011-03-20 13:42:50');
INSERT INTO `az_page_az_pages` VALUES (505,1914,1919,1,'2011-02-21 14:32:32','2011-02-22 10:30:04');
INSERT INTO `az_page_az_pages` VALUES (506,1919,1920,1,'2011-02-21 14:32:41','2011-02-22 10:26:12');
INSERT INTO `az_page_az_pages` VALUES (507,1920,1921,1,'2011-02-21 14:32:54','2011-02-21 14:32:54');
INSERT INTO `az_page_az_pages` VALUES (508,1914,1922,2,'2011-02-21 14:33:05','2011-02-21 14:33:05');
INSERT INTO `az_page_az_pages` VALUES (509,1914,1923,3,'2011-02-21 14:33:14','2011-02-21 14:33:14');
INSERT INTO `az_page_az_pages` VALUES (510,1922,1924,1,'2011-02-21 14:33:25','2011-02-21 14:33:25');
INSERT INTO `az_page_az_pages` VALUES (511,1923,1925,1,'2011-02-21 14:33:33','2011-02-22 10:28:30');
INSERT INTO `az_page_az_pages` VALUES (512,1926,1927,1,'2010-12-23 08:54:12','2011-03-20 14:01:20');
INSERT INTO `az_page_az_pages` VALUES (513,1926,1928,2,'2010-12-23 08:54:26','2011-03-20 14:01:32');
INSERT INTO `az_page_az_pages` VALUES (514,1929,1930,1,'2010-12-23 08:54:58','2010-12-23 08:54:58');
INSERT INTO `az_page_az_pages` VALUES (515,1914,1931,4,'2011-02-22 10:20:37','2011-02-22 10:27:56');
INSERT INTO `az_page_az_pages` VALUES (25534,46220,46221,1,'2010-12-23 08:54:12','2011-10-11 06:54:23');
INSERT INTO `az_page_az_pages` VALUES (25535,46220,46222,2,'2010-12-23 08:54:26','2011-02-22 08:55:55');
INSERT INTO `az_page_az_pages` VALUES (25536,46223,46224,1,'2010-12-23 08:54:58','2011-10-11 06:54:52');
INSERT INTO `az_page_az_pages` VALUES (32901,1918,1926,32901,'2012-01-14 08:16:24','2012-01-14 08:16:24');
INSERT INTO `az_page_az_pages` VALUES (32902,1914,1929,32902,'2012-01-14 08:16:24','2012-01-14 08:16:24');
INSERT INTO `az_page_az_pages` VALUES (34841,54634,1913,34841,'2012-01-14 08:17:31','2012-01-14 08:17:31');
INSERT INTO `az_page_az_pages` VALUES (34842,54634,1914,34842,'2012-01-14 08:17:31','2012-01-14 08:17:31');
INSERT INTO `az_page_az_pages` VALUES (34843,54635,1926,34843,'2012-01-14 08:17:31','2012-01-14 08:17:31');
INSERT INTO `az_page_az_pages` VALUES (34844,54635,1929,34844,'2012-01-14 08:17:31','2012-01-14 08:17:31');
INSERT INTO `az_page_az_pages` VALUES (42784,58333,46220,42784,'2012-01-14 08:20:53','2012-01-14 08:20:53');
INSERT INTO `az_page_az_pages` VALUES (42785,58333,46223,42785,'2012-01-14 08:20:53','2012-01-14 08:20:53');
/*!40000 ALTER TABLE `az_page_az_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_page_az_project_blocks`
--

DROP TABLE IF EXISTS `az_page_az_project_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_page_az_project_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_page_id` int(11) NOT NULL,
  `az_base_project_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_page_az_project_blocks`
--

LOCK TABLES `az_page_az_project_blocks` WRITE;
/*!40000 ALTER TABLE `az_page_az_project_blocks` DISABLE KEYS */;
INSERT INTO `az_page_az_project_blocks` VALUES (101,1918,356,NULL,'2011-03-08 07:59:09','2011-03-08 07:59:09');
/*!40000 ALTER TABLE `az_page_az_project_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_pages`
--

DROP TABLE IF EXISTS `az_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `az_base_project_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `estimated_time` decimal(8,1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `az_design_double_page_id` int(11) DEFAULT NULL,
  `az_functionality_double_page_id` int(11) DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `page_type` int(11) DEFAULT '0',
  `description` text,
  `title` varchar(255) DEFAULT '',
  `owner_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `tr_position` int(11) DEFAULT NULL,
  `embedded` tinyint(1) DEFAULT NULL,
  `root` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_pages_on_parent_id` (`parent_id`),
  KEY `index_az_pages_on_az_base_project_id` (`az_base_project_id`),
  KEY `index_az_pages_on_az_design_double_page_id` (`az_design_double_page_id`),
  KEY `index_az_pages_on_az_functionality_double_page_id` (`az_functionality_double_page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58334 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_pages`
--

LOCK TABLES `az_pages` WRITE;
/*!40000 ALTER TABLE `az_pages` DISABLE KEYS */;
INSERT INTO `az_pages` VALUES (1913,'Работы',355,1,NULL,NULL,'2011-02-21 12:18:34','2011-03-19 19:19:52',NULL,NULL,NULL,0,'Главная страница сайта является страницей каталога, открытого на списке сайтов. На странице находится выбор других пунктов (логотипы, полиграфия, и т.д.) Для работ отображается соответсвующий им список категорий. Для работы отображаются:\n\n* Название\n* URL\n* Клиент\n* Анонс\n* Дата сдачи проекта\n* Описание\n* Изображение-превью\n\nПри выборе категории, работы не входящие в данную категорию должны \"потухнуть\" (см. дизайн с потухшими дизайнами)\n\nСодержит ссылки на следующие страницы:\"_работа_\", \"_работы_\", \"_о нас_\" и \"_контакты_\".','%(Тип работы)',2,2,0,NULL,NULL);
INSERT INTO `az_pages` VALUES (1914,'Вход в админку',355,2,NULL,NULL,'2011-02-21 12:18:34','2011-02-22 10:24:27',NULL,NULL,NULL,1,'Страница с формой ввода для логина и пароля.\nВ случае успешного ввода логина и пароля пользователь попадает на страницу админки \"Работы\", иначе на страницу \"Неверный логин или пароль\"','Вход в админку',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1915,'Работа',355,1,1913,NULL,'2011-02-21 14:31:26','2011-03-20 13:12:55',NULL,NULL,NULL,0,'На  данной  странице необходимо  показать одну работу, причем должны быть отображены следующие поля:\n* Название\n* URL\n* Клиент\n* Дата сдачи проекта\n* Описание\n* Изображения с названием и описанием\n','%(Тип работы): %(название работы)',2,2,10,NULL,NULL);
INSERT INTO `az_pages` VALUES (1916,'Работы',355,2,1913,NULL,'2011-02-21 14:31:52','2011-02-21 16:11:14',1913,1913,NULL,0,NULL,'Работы',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1917,'О нас',355,3,1913,NULL,'2011-02-21 14:32:09','2011-03-21 09:12:41',NULL,NULL,NULL,0,'Текстовая страница с информацией о компании.','О нас',2,2,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1918,'Контакты',355,4,1913,NULL,'2011-02-21 14:32:17','2011-03-20 13:42:50',NULL,NULL,NULL,0,NULL,'Контакты',2,2,100,NULL,NULL);
INSERT INTO `az_pages` VALUES (1919,'Работы',355,1,1914,NULL,'2011-02-21 14:32:32','2011-02-22 10:30:04',NULL,NULL,NULL,1,'Страница содержит список работ с возможностью фильтрации по типам. При количестве работ более 20, должна выполняться разбивка таблицы на страницы.','Работы',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1920,'Работа',355,1,1919,NULL,'2011-02-21 14:32:41','2011-02-22 10:26:12',NULL,NULL,NULL,1,'Для работы необходимо указать тип работы, и для данного типа работ, указать категории. Т.е. для разных типов работ должны быть разные списки категорий.','Работа',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1921,'Изображение',355,1,1920,NULL,'2011-02-21 14:32:54','2011-02-21 14:32:54',NULL,NULL,NULL,1,NULL,'Изображение',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1922,'Категории',355,2,1914,NULL,'2011-02-21 14:33:05','2011-02-21 14:33:05',NULL,NULL,NULL,1,NULL,'Категории',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1923,'Типы работ',355,3,1914,NULL,'2011-02-21 14:33:14','2011-02-21 14:33:14',NULL,NULL,NULL,1,NULL,'Типы работ',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1924,'Категория',355,1,1922,NULL,'2011-02-21 14:33:25','2011-02-21 14:33:25',NULL,NULL,NULL,1,NULL,'Категория',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1925,'Тип работы',355,1,1923,NULL,'2011-02-21 14:33:33','2011-02-22 10:28:30',NULL,NULL,NULL,1,'Каждый тип работ должен быть связан со своим набором категорий.','Тип работы',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1926,'Сообщение',356,3,NULL,NULL,'2010-12-23 08:53:55','2012-01-14 08:15:23',NULL,NULL,6,0,'На этой странице пользователь может отправить сообщение администратору сайта. \nОтправленное пользователем сообщение должно отображаться в админке в списке сообщений, а также должно быть продублировано администратору на email.','Написать сообщение ',2,0,NULL,1,NULL);
INSERT INTO `az_pages` VALUES (1927,'Сообщение отправлено',356,1,1926,NULL,'2010-12-23 08:54:12','2011-03-20 14:01:20',NULL,NULL,7,0,'После успешной отправки сообщения пользователеем ему должно отобразиться сообщение об успешности проделанной операции.\n\nТакже на тут должна быть ссылка пердлагающая переход на главную страницу сайта.','Сообщение отправлено',2,2,110,NULL,NULL);
INSERT INTO `az_pages` VALUES (1928,'Сообщение не отправлено',356,2,1926,NULL,'2010-12-23 08:54:26','2011-03-20 14:01:32',NULL,NULL,8,0,'Если пользователь ввел в форму сообщения некорректные данные, сообщение не должно отправится и пользователю должна быть отображена эта страница.\n\nНа этой странице должна быть форма отправки сообщения, в которой сохранены введенные ранее пользователем данные, а также отмечены поля с некорректными данными и указание причин, почему данные не корректны.','Сообщение не отправлено',2,2,120,NULL,NULL);
INSERT INTO `az_pages` VALUES (1929,'Сообщения',356,3,NULL,NULL,'2010-12-23 08:54:45','2011-02-22 10:27:05',NULL,NULL,9,1,'Тут, также необходимо иметь возможность отметить сообщение, как прочитанное.','Сообщения',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1930,'Сообщение',356,1,1929,NULL,'2010-12-23 08:54:58','2010-12-23 08:54:58',NULL,NULL,10,1,NULL,'Сообщение',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (1931,'Неверный логин или пароль',355,4,1914,NULL,'2011-02-22 10:20:37','2011-02-22 10:27:56',NULL,NULL,NULL,1,'Страница с сообщением о неверном логине или пароле и форма для повторной попытки залогиниться.','Неверный логин или пароль',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (46220,'Сообщение',5602,3,NULL,NULL,'2010-12-23 08:53:55','2012-01-14 08:16:05',NULL,NULL,6,0,'На этой странице пользователь может отправить сообщение администратору сайта. \nОтправленное пользователем сообщение должно отображаться в админке в списке сообщений, а также должно быть продублировано администратору на email.','Написать сообщение ',2,0,NULL,1,NULL);
INSERT INTO `az_pages` VALUES (46221,'Сообщение отправлено',5602,1,46220,NULL,'2010-12-23 08:54:12','2011-10-11 06:54:23',NULL,NULL,7,0,'После успешной отправки сообщения пользователем ему должно отобразиться сообщение об успешности проделанной операции.\n\nТакже на тут должна быть ссылка предлагающая переход на главную страницу сайта.','Сообщение отправлено',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (46222,'Сообщение не отправлено',5602,2,46220,NULL,'2010-12-23 08:54:26','2011-02-22 08:55:55',NULL,NULL,8,0,'Если пользователь ввел в форму сообщения некорректные данные, сообщение не должно отправится и пользователю должна быть отображена эта страница.\n\nНа этой странице должна быть форма отправки сообщения, в которой сохранены введенные ранее пользователем данные, а также отмечены поля с некорректными данными и указание причин, почему данные не корректны.','Сообщение не отправлено',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (46223,'Сообщения',5602,3,NULL,NULL,'2010-12-23 08:54:45','2011-10-11 09:05:48',NULL,NULL,9,1,'На данной странице необходимо показать список сообщений, причем должны быть отображены следующие столбцы:\n* Имя \n* e-mail \n* Сообщение, ограниченное первыми N символами\n* Статус (Обработанные (закрытые) сообщения отмечаются галочкой)\nТакже должна быть возможность удалить сообщение из списка. При удалении должен быть выведен вопрос “Вы точно хотите удалить запись?”.\nСоответственно удаление должно произойти если пользователь выберет “Да”, при этом запись должна быть удалена и пользователь возвращен к списку сообщений.\nЕсли пользователь нажал “Нет”, он должен  вернуться к списку сообщений.\n\nЕсли в списке больше, чем N сообщений, на странице должно отображаться их не более N, и должен появится пагинатор.\n','Сообщения',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (46224,'Сообщение',5602,1,46223,NULL,'2010-12-23 08:54:58','2011-10-11 06:54:52',NULL,NULL,10,1,'На этой странице необходимо отобразить сообщение, причем должны быть отображены\nследующие поля:\n* Имя\n* e-mail\n* Сообщение\n\nЕсли статус сообщения \"Не обработано\" (\"Открыто\"), должна отображаться кнопка \"Обработать\" (\"Закрыть\"), при нажатии которой статус сообщения меняется на \"Обработано\".\n\n','Сообщение',2,0,NULL,NULL,NULL);
INSERT INTO `az_pages` VALUES (54634,'root',355,0,NULL,NULL,'2012-01-14 08:17:31','2012-01-14 08:17:31',NULL,NULL,NULL,0,NULL,'',2,0,NULL,NULL,1);
INSERT INTO `az_pages` VALUES (54635,'root',356,0,NULL,NULL,'2012-01-14 08:17:31','2012-01-14 08:17:31',NULL,NULL,NULL,0,NULL,'',2,0,NULL,NULL,1);
INSERT INTO `az_pages` VALUES (58333,'root',5602,0,NULL,NULL,'2012-01-14 08:20:53','2012-01-14 08:20:53',NULL,NULL,NULL,0,NULL,'',2,0,NULL,NULL,1);
/*!40000 ALTER TABLE `az_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_participants`
--

DROP TABLE IF EXISTS `az_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_project_id` int(11) DEFAULT NULL,
  `az_rm_role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `az_employee_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_participants_on_az_project_id` (`az_project_id`),
  KEY `index_az_participants_on_az_employee_id` (`az_employee_id`),
  KEY `index_az_participants_on_owner_id` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=422 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_participants`
--

LOCK TABLES `az_participants` WRITE;
/*!40000 ALTER TABLE `az_participants` DISABLE KEYS */;
INSERT INTO `az_participants` VALUES (418,355,1,'2011-02-21 12:18:34','2011-10-24 14:16:22',2,2);
INSERT INTO `az_participants` VALUES (419,355,2,'2011-02-21 12:18:34','2011-10-24 14:16:22',2,2);
INSERT INTO `az_participants` VALUES (420,355,3,'2011-02-21 12:18:34','2011-10-24 14:16:22',2,2);
INSERT INTO `az_participants` VALUES (421,355,4,'2011-02-21 12:18:34','2011-10-24 14:16:22',2,2);
/*!40000 ALTER TABLE `az_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_payment_responses`
--

DROP TABLE IF EXISTS `az_payment_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_payment_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_payment_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `response` text,
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_payment_responses_on_az_payment_id` (`az_payment_id`),
  KEY `index_az_payment_responses_on_transaction_id` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_payment_responses`
--

LOCK TABLES `az_payment_responses` WRITE;
/*!40000 ALTER TABLE `az_payment_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_payment_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_payments`
--

DROP TABLE IF EXISTS `az_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_company_id` int(11) DEFAULT NULL,
  `amount` decimal(20,2) NOT NULL,
  `started` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `comment` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_az_payments_on_az_company_id` (`az_company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_payments`
--

LOCK TABLES `az_payments` WRITE;
/*!40000 ALTER TABLE `az_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_project_definitions`
--

DROP TABLE IF EXISTS `az_project_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_project_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_base_project_id` int(11) DEFAULT NULL,
  `az_definition_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_project_definitions`
--

LOCK TABLES `az_project_definitions` WRITE;
/*!40000 ALTER TABLE `az_project_definitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_project_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_project_stat_updates`
--

DROP TABLE IF EXISTS `az_project_stat_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_project_stat_updates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_project_stat_updates`
--

LOCK TABLES `az_project_stat_updates` WRITE;
/*!40000 ALTER TABLE `az_project_stat_updates` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_project_stat_updates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_project_statuses`
--

DROP TABLE IF EXISTS `az_project_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_project_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_project_statuses`
--

LOCK TABLES `az_project_statuses` WRITE;
/*!40000 ALTER TABLE `az_project_statuses` DISABLE KEYS */;
INSERT INTO `az_project_statuses` VALUES (1,'Новый',1,1,'2010-12-22 10:09:20','2010-12-22 10:09:20',0,'');
INSERT INTO `az_project_statuses` VALUES (2,'Обсуждается',2,1,'2010-12-22 10:09:20','2011-09-25 10:34:32',0,'');
INSERT INTO `az_project_statuses` VALUES (3,'В процессе',3,1,'2010-12-22 10:09:20','2011-09-25 10:34:24',0,'');
INSERT INTO `az_project_statuses` VALUES (4,'Тестирование',4,1,'2010-12-22 10:09:20','2011-09-25 10:34:16',0,'');
INSERT INTO `az_project_statuses` VALUES (5,'Сдача',5,1,'2010-12-22 10:09:20','2011-09-25 10:34:08',0,'');
INSERT INTO `az_project_statuses` VALUES (6,'Сделан',6,1,'2010-12-22 10:09:20','2011-09-25 10:33:58',0,'');
INSERT INTO `az_project_statuses` VALUES (7,'Закрыт',7,1,'2011-09-25 10:33:35','2011-09-25 10:33:35',1,'');
INSERT INTO `az_project_statuses` VALUES (8,'Заморожен',8,1,'2011-09-25 10:33:48','2011-09-25 10:33:48',1,'');
/*!40000 ALTER TABLE `az_project_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_purchases`
--

DROP TABLE IF EXISTS `az_purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_company_id` int(11) NOT NULL,
  `az_store_item_id` int(11) NOT NULL,
  `az_bill_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_purchases_on_az_company_id` (`az_company_id`),
  KEY `index_az_purchases_on_az_store_item_id` (`az_store_item_id`),
  KEY `index_az_purchases_on_az_bill_id` (`az_bill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_purchases`
--

LOCK TABLES `az_purchases` WRITE;
/*!40000 ALTER TABLE `az_purchases` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_register_confirmations`
--

DROP TABLE IF EXISTS `az_register_confirmations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_register_confirmations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_user_id` int(11) DEFAULT NULL,
  `confirm_hash` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_register_confirmations`
--

LOCK TABLES `az_register_confirmations` WRITE;
/*!40000 ALTER TABLE `az_register_confirmations` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_register_confirmations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_reset_passwords`
--

DROP TABLE IF EXISTS `az_reset_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_reset_passwords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash_str` varchar(255) NOT NULL,
  `az_user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_reset_passwords`
--

LOCK TABLES `az_reset_passwords` WRITE;
/*!40000 ALTER TABLE `az_reset_passwords` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_reset_passwords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_rm_roles`
--

DROP TABLE IF EXISTS `az_rm_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_rm_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rm_role_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_rm_roles`
--

LOCK TABLES `az_rm_roles` WRITE;
/*!40000 ALTER TABLE `az_rm_roles` DISABLE KEYS */;
INSERT INTO `az_rm_roles` VALUES (1,3,'программист','2010-12-22 10:09:17','2010-12-22 10:25:44');
INSERT INTO `az_rm_roles` VALUES (2,4,'тестировщик','2010-12-22 10:09:17','2012-01-15 19:39:36');
INSERT INTO `az_rm_roles` VALUES (3,5,'верстальщик','2010-12-22 10:09:17','2010-12-22 10:26:39');
INSERT INTO `az_rm_roles` VALUES (4,6,'менеджер','2010-12-22 10:09:17','2010-12-22 10:27:05');
INSERT INTO `az_rm_roles` VALUES (5,8,'дизайнер','2012-02-17 09:19:47','2012-02-17 09:19:47');
/*!40000 ALTER TABLE `az_rm_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_scetch_programs`
--

DROP TABLE IF EXISTS `az_scetch_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_scetch_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` text,
  `sp_icon_file_name` varchar(255) NOT NULL,
  `sp_icon_content_type` varchar(255) NOT NULL,
  `sp_icon_file_size` int(11) NOT NULL,
  `sp_icon_updated_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_scetch_programs`
--

LOCK TABLES `az_scetch_programs` WRITE;
/*!40000 ALTER TABLE `az_scetch_programs` DISABLE KEYS */;
INSERT INTO `az_scetch_programs` VALUES (1,'Pencil Project','http://pencil.evolus.vn','The Pencil Project\'s unique mission is to build a free and opensource tool for making diagrams and GUI prototyping that everyone can use.','pencil_icon.png','image/png',1449,'2012-02-11 15:07:54','2012-02-11 15:07:54','2012-02-11 15:07:54');
/*!40000 ALTER TABLE `az_scetch_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_store_item_scetches`
--

DROP TABLE IF EXISTS `az_store_item_scetches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_store_item_scetches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scetch_file_name` varchar(255) NOT NULL,
  `scetch_content_type` varchar(255) NOT NULL,
  `scetch_file_size` int(11) NOT NULL,
  `scetch_updated_at` datetime NOT NULL,
  `az_store_item_id` int(11) DEFAULT NULL,
  `alt` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_store_item_scetches_on_az_store_item_id` (`az_store_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_store_item_scetches`
--

LOCK TABLES `az_store_item_scetches` WRITE;
/*!40000 ALTER TABLE `az_store_item_scetches` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_store_item_scetches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_store_items`
--

DROP TABLE IF EXISTS `az_store_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_store_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `visible` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` text NOT NULL,
  `announce` text NOT NULL,
  `manual` text NOT NULL,
  `az_language_id` int(11) DEFAULT NULL,
  `az_scetch_program_id` int(11) DEFAULT NULL,
  `scheme_file_name` varchar(255) DEFAULT NULL,
  `scheme_content_type` varchar(255) DEFAULT NULL,
  `scheme_file_size` int(11) DEFAULT NULL,
  `scheme_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_store_items`
--

LOCK TABLES `az_store_items` WRITE;
/*!40000 ALTER TABLE `az_store_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_store_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_subscribtion_categories`
--

DROP TABLE IF EXISTS `az_subscribtion_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_subscribtion_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_subscribtion_categories`
--

LOCK TABLES `az_subscribtion_categories` WRITE;
/*!40000 ALTER TABLE `az_subscribtion_categories` DISABLE KEYS */;
INSERT INTO `az_subscribtion_categories` VALUES (1,'Новости',NULL,NULL,NULL);
INSERT INTO `az_subscribtion_categories` VALUES (2,'Новинки магазина',NULL,NULL,NULL);
INSERT INTO `az_subscribtion_categories` VALUES (3,'Акции',NULL,NULL,NULL);
/*!40000 ALTER TABLE `az_subscribtion_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_subscribtions`
--

DROP TABLE IF EXISTS `az_subscribtions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_subscribtions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_user_id` int(11) DEFAULT NULL,
  `az_subscribtion_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_subscribtions`
--

LOCK TABLES `az_subscribtions` WRITE;
/*!40000 ALTER TABLE `az_subscribtions` DISABLE KEYS */;
INSERT INTO `az_subscribtions` VALUES (2,1,1,'2012-02-26 15:19:32','2012-02-26 15:19:32');
/*!40000 ALTER TABLE `az_subscribtions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_tariffs`
--

DROP TABLE IF EXISTS `az_tariffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_tariffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `price` decimal(9,2) NOT NULL DEFAULT '100.00',
  `quota_disk` int(11) NOT NULL DEFAULT '0',
  `quota_active_projects` int(11) NOT NULL DEFAULT '0',
  `quota_employees` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL,
  `tariff_type` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `optimal` tinyint(1) DEFAULT NULL,
  `show_logo_and_site` tinyint(1) DEFAULT NULL,
  `quota_public_projects` int(11) DEFAULT '0',
  `quota_private_projects` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_tariffs`
--

LOCK TABLES `az_tariffs` WRITE;
/*!40000 ALTER TABLE `az_tariffs` DISABLE KEYS */;
INSERT INTO `az_tariffs` VALUES (5,'Бесплатный',0.00,52428800,1,0,1,1,'2012-02-14 09:15:12','2012-04-17 07:04:49',0,1,0,0);
INSERT INTO `az_tariffs` VALUES (6,'Фрилансер',19.00,209715200,2,1,2,1,'2012-02-14 09:23:25','2012-02-25 09:58:33',0,NULL,0,0);
INSERT INTO `az_tariffs` VALUES (7,'Студия',29.00,524288000,3,3,3,1,'2012-02-15 11:45:18','2012-02-25 09:58:44',1,NULL,0,0);
INSERT INTO `az_tariffs` VALUES (8,'Хорошая студия',39.00,1048576000,5,5,4,1,'2012-02-15 11:46:02','2012-02-25 09:58:58',0,NULL,0,0);
INSERT INTO `az_tariffs` VALUES (9,'Очень хорошая студия',99.00,2097152000,10,10,5,1,'2012-02-15 11:46:34','2012-02-25 09:59:13',0,NULL,0,0);
/*!40000 ALTER TABLE `az_tariffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_tasks`
--

DROP TABLE IF EXISTS `az_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `estimated_time` decimal(24,2) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `task_type` int(11) NOT NULL DEFAULT '0',
  `az_rm_role_id` int(11) DEFAULT NULL,
  `role_user` tinyint(1) NOT NULL DEFAULT '0',
  `role_admin` tinyint(1) NOT NULL DEFAULT '0',
  `owner_id` int(11) NOT NULL,
  `seed` tinyint(1) DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `role_common` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_tasks`
--

LOCK TABLES `az_tasks` WRITE;
/*!40000 ALTER TABLE `az_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_tr_texts`
--

DROP TABLE IF EXISTS `az_tr_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_tr_texts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `az_operation_id` int(11) DEFAULT NULL,
  `data_type` int(11) DEFAULT NULL,
  `text` text,
  `copy_of` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `seed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_az_tr_texts_on_owner_id` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_tr_texts`
--

LOCK TABLES `az_tr_texts` WRITE;
/*!40000 ALTER TABLE `az_tr_texts` DISABLE KEYS */;
INSERT INTO `az_tr_texts` VALUES (15,'Создание структуры',2,1,0,'На данной странице должна быть возможность создать новую запись для %data_type_name%.\r\nДля ввода должны быть доступны следующие поля:\r\n\r\n%variable_list%\r\n\r\nЕсли введенные данные некорректны, или имеются незаполненные обязательные поля,\r\n%data_type_name% не должна создаться и сохраниться в базе данных.\r\nПри этом должен быть выполнен переход на эту же страницу с сохранением ранее\r\nвведенных данных и указанием полей, которые некорректно заполнены.\r\n\r\n%image_list%',NULL,'2012-01-20 13:15:57','2012-03-26 20:08:32',1);
INSERT INTO `az_tr_texts` VALUES (16,'Отображение структуры',2,2,0,'На  данной  странице необходимо  отобразить %data_type_name%, причем должны быть отображены следующие данные:\r\n\r\n%variable_list%',NULL,'2012-01-20 13:23:58','2012-02-01 08:51:59',1);
INSERT INTO `az_tr_texts` VALUES (17,'Ссылки со страницы',2,NULL,NULL,'Страница содержит ссылки на следующие страницы: \r\n%child_pages%',NULL,'2012-01-20 13:30:04','2012-02-01 10:18:52',1);
INSERT INTO `az_tr_texts` VALUES (18,'Редактирование структуры',2,3,0,'На этой странице должна быть возможность изменить следующие поля %data_type_name%:\r\n%variable_list% \r\nЕсли введенные данные некорректны, или имеются незаполненные обязательные поля,\r\n%data_type_name%  не должна сохраниться в базе данных.\r\nПри этом должен быть выполнен переход на эту же страницу с сохранением ранее\r\nвведенных данных и указанием полей, которые некорректно заполнены.',NULL,'2012-01-20 13:32:34','2012-03-26 20:10:12',1);
INSERT INTO `az_tr_texts` VALUES (19,'Удаление структуры',2,4,0,'На странице должен быть выведен вопрос: \"Вы точно хотите удалить новость?\".\r\nСоответственно, удаление должно произойти, если пользователь выберет \"Да\", при этом %data_type_name% должно быть удалено, и пользователь возвращен на список %data_type_name%.\r\nЕсли пользоватеь нажал \"Нет\", он должен просто вернуться к списку %data_type_name%.\r\n',NULL,'2012-01-20 13:33:28','2012-03-26 20:11:42',1);
INSERT INTO `az_tr_texts` VALUES (20,'Создание множества элементов',2,1,1,'Должна быть возможность создать одновременно множество %data_type_name%',NULL,'2012-01-21 08:42:07','2012-02-01 08:53:59',1);
INSERT INTO `az_tr_texts` VALUES (21,'Отображение списка',2,2,1,'На странице необходимо отобразить %collection_name%.\r\n\r\nОтображаться должны следующие данные:\r\n\r\n%variable_list%',NULL,'2012-01-21 08:42:31','2012-03-26 20:14:12',1);
INSERT INTO `az_tr_texts` VALUES (22,'Порядок следования',2,3,1,'Рядом с элементами должны располагаться стрелки \"вверх\" и \"вниз\", с помощью которых можно изменять порядок %data_type_name% в списке.',NULL,'2012-01-21 08:42:53','2012-02-01 08:55:29',1);
INSERT INTO `az_tr_texts` VALUES (23,'Удаление из списка',2,4,1,'Рядом с %data_type_name% должен находиться чекбокс и внизу под списком кнопка \"Удалить\", которая удалит отмеченные элементы. Перед удалением необходимо задать вопрос пользователю, действительно ли он хочет удалить выбранные элементы.',NULL,'2012-01-21 08:43:26','2012-03-26 20:17:07',1);
INSERT INTO `az_tr_texts` VALUES (24,'Пагинатор',2,2,1,'Если записей более чем N, должен осуществляться постраничный вывод записей.',NULL,'2012-01-21 08:44:17','2012-02-01 08:54:44',1);
INSERT INTO `az_tr_texts` VALUES (27,'Сортировка',2,2,1,'Должна быть предусмотрена сортировка по возрастанию и убыванию для следующих полей:\r\n\r\n%variable_list%',NULL,'2012-01-23 16:08:59','2012-03-26 20:15:19',1);
INSERT INTO `az_tr_texts` VALUES (28,'Порядок следования (dnd)',2,3,1,'Порядок %data_type_name% в списке должен задаваться с помощью перетаскивания мышью (drag-n-drop).',NULL,'2012-01-23 16:37:45','2012-02-01 08:56:12',1);
/*!40000 ALTER TABLE `az_tr_texts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_typed_pages`
--

DROP TABLE IF EXISTS `az_typed_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_typed_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_page_id` int(11) DEFAULT NULL,
  `az_base_data_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `copy_of` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_typed_pages_on_az_page_id` (`az_page_id`),
  KEY `index_az_typed_pages_on_az_base_data_type_id` (`az_base_data_type_id`),
  KEY `index_az_typed_pages_on_owner_id` (`owner_id`),
  KEY `index_az_typed_pages_on_copy_of` (`copy_of`)
) ENGINE=InnoDB AUTO_INCREMENT=34718 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_typed_pages`
--

LOCK TABLES `az_typed_pages` WRITE;
/*!40000 ALTER TABLE `az_typed_pages` DISABLE KEYS */;
INSERT INTO `az_typed_pages` VALUES (809,1925,1000,'2011-02-21 15:44:32','2011-02-21 15:44:32',2,NULL);
INSERT INTO `az_typed_pages` VALUES (810,1923,1001,'2011-02-21 15:44:34','2011-02-21 15:44:34',2,NULL);
INSERT INTO `az_typed_pages` VALUES (811,1924,1002,'2011-02-21 15:50:28','2011-02-21 15:50:28',2,NULL);
INSERT INTO `az_typed_pages` VALUES (812,1922,1003,'2011-02-21 15:50:31','2011-02-21 15:50:31',2,NULL);
INSERT INTO `az_typed_pages` VALUES (813,1915,1006,'2011-02-21 16:10:51','2011-02-21 16:10:51',2,NULL);
INSERT INTO `az_typed_pages` VALUES (814,1913,1007,'2011-02-21 16:10:54','2011-02-21 16:10:54',2,NULL);
INSERT INTO `az_typed_pages` VALUES (815,1919,1007,'2011-02-21 16:12:48','2011-02-21 16:12:48',2,NULL);
INSERT INTO `az_typed_pages` VALUES (816,1920,1006,'2011-02-21 16:13:01','2011-02-21 16:13:01',2,NULL);
INSERT INTO `az_typed_pages` VALUES (817,1915,1000,'2011-02-21 16:13:33','2011-02-21 16:13:33',2,NULL);
INSERT INTO `az_typed_pages` VALUES (818,1915,1003,'2011-02-21 16:13:43','2011-02-21 16:13:43',2,NULL);
INSERT INTO `az_typed_pages` VALUES (819,1926,1008,'2011-02-22 08:57:40','2011-02-22 08:57:40',2,NULL);
INSERT INTO `az_typed_pages` VALUES (820,1928,1008,'2011-02-22 08:57:40','2011-02-22 08:57:40',2,NULL);
INSERT INTO `az_typed_pages` VALUES (821,1929,1009,'2011-02-22 08:57:41','2011-02-22 08:57:41',2,NULL);
INSERT INTO `az_typed_pages` VALUES (822,1930,1008,'2011-02-22 08:57:41','2011-02-22 08:57:41',2,NULL);
INSERT INTO `az_typed_pages` VALUES (34714,46220,25107,'2011-10-09 15:31:25','2011-10-09 15:31:25',2,NULL);
INSERT INTO `az_typed_pages` VALUES (34715,46222,25107,'2011-10-09 15:31:25','2011-10-09 15:31:25',2,NULL);
INSERT INTO `az_typed_pages` VALUES (34716,46223,25108,'2011-10-09 15:31:26','2011-10-09 15:31:26',2,NULL);
INSERT INTO `az_typed_pages` VALUES (34717,46224,25107,'2011-10-09 15:31:26','2011-10-09 15:31:26',2,NULL);
/*!40000 ALTER TABLE `az_typed_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_user_logins`
--

DROP TABLE IF EXISTS `az_user_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_user_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_user_id` int(11) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `browser` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9156 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_user_logins`
--

LOCK TABLES `az_user_logins` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `az_users`
--

DROP TABLE IF EXISTS `az_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(40) DEFAULT NULL,
  `name` varchar(100) DEFAULT '',
  `lastname` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(40) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `roles` text,
  `disabled` tinyint(1) DEFAULT '1',
  `azalo_invitation_count` int(11) DEFAULT '0',
  `company_invitation_count` int(11) DEFAULT '0',
  `never_visited` tinyint(1) NOT NULL DEFAULT '1',
  `note` text NOT NULL,
  `la_accepted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_az_users_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_users`
--

LOCK TABLES `az_users` WRITE;
/*!40000 ALTER TABLE `az_users` DISABLE KEYS */;
INSERT INTO `az_users` VALUES (1,'admin','Admin','Pentiumov','admin@example.com','ad4fc1678a0e4a7631509e5a3045b0c3bf1f7109','a2a0d7708823951c976bbdbe277e4140be40d24d','2010-12-22 10:09:16','2017-07-15 13:07:53','','2012-07-29 12:11:29','--- \n- :admin\n',0,1000,1000,0,'',NULL);
INSERT INTO `az_users` VALUES (2,'seeder','Seeder','Karvololov','seeder@example.com','07b57f85a0d07b8b5d2e89636e1e75f77ba482c4','a2a0d7708823951c976bbdbe277e4140be40d24d','2010-12-22 10:09:16','2017-07-15 13:07:57','',NULL,'--- \n- :admin\n',0,0,0,0,'',NULL);
/*!40000 ALTER TABLE `az_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_using_periods`
--

DROP TABLE IF EXISTS `az_using_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_using_periods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `az_company_id` int(11) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `ends_at` datetime NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_using_periods_on_az_company_id_and_type` (`az_company_id`,`type`),
  KEY `index_az_using_periods_on_az_company_id` (`az_company_id`),
  KEY `index_az_using_periods_on_ends_at` (`ends_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_using_periods`
--

LOCK TABLES `az_using_periods` WRITE;
/*!40000 ALTER TABLE `az_using_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `az_using_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_validators`
--

DROP TABLE IF EXISTS `az_validators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_validators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `az_variable_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `condition` text,
  `message` text NOT NULL,
  `position` int(11) DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `seed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_az_validators_on_az_variable_id` (`az_variable_id`),
  KEY `owner_id` (`owner_id`),
  KEY `index_az_validators_on_owner_id` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51011 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_validators`
--

LOCK TABLES `az_validators` WRITE;
/*!40000 ALTER TABLE `az_validators` DISABLE KEYS */;
INSERT INTO `az_validators` VALUES (1,2,NULL,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,NULL,1,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (81,2,NULL,'Длина не более N','Длина строки должна быть не более, чем N символов',NULL,'Слишком длинная строка! Должна быть не длиннее N символов.',NULL,NULL,1,'2011-02-20 16:12:26','2011-02-20 16:12:26');
INSERT INTO `az_validators` VALUES (82,2,NULL,'Длина не менее M','Длина строки должна быть не менее, чем M символов',NULL,'Слишком короткая строка! Должна быть не менее M символов.',NULL,NULL,1,'2011-02-20 16:12:31','2011-02-20 16:12:31');
INSERT INTO `az_validators` VALUES (241,2,NULL,'Email','Строка должна соответствовать формату email. Например: foobar@example.com',NULL,'Это не похоже на email!',NULL,NULL,1,'2011-02-20 16:14:34','2011-10-11 06:50:50');
INSERT INTO `az_validators` VALUES (242,2,NULL,'Телефон','Строка должна соответствовать телефонному номеру. Например + 1 (23) 456-78-90 или 11-22-33',NULL,'Это не похоже на телефонный номер!',NULL,NULL,1,'2011-02-20 16:15:46','2011-02-20 16:15:46');
INSERT INTO `az_validators` VALUES (243,2,NULL,'Целое число','Строка должна соответствовать целому числу. Например: 123',NULL,'Укажите целое число!',NULL,NULL,1,'2011-02-20 16:16:29','2011-02-20 16:18:13');
INSERT INTO `az_validators` VALUES (244,2,NULL,'Вещественное число','Строка должна соответствовать вещественному числу. Например 123,45. Разделитель целой и дробной части - запятая.',NULL,'Укажите вещественное число!',NULL,NULL,1,'2011-02-20 16:18:01','2011-02-20 16:18:01');
INSERT INTO `az_validators` VALUES (561,2,3582,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (562,2,3581,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (563,2,3583,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (564,2,NULL,'URL','Строка должна соответствовать формату URL. Например: http://example.com',NULL,'Это не похоже на URL!',NULL,NULL,1,'2011-02-21 16:07:21','2012-03-27 08:30:49');
INSERT INTO `az_validators` VALUES (565,2,3591,'URL','Строка должна соответствовать формату URL. Например: http://example.com',NULL,'Это не похоже на URL!',NULL,564,0,'2011-02-21 16:07:21','2011-02-21 16:07:21');
INSERT INTO `az_validators` VALUES (566,2,3589,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (567,2,3593,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (568,2,3595,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (573,2,3598,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,569,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (574,2,3599,'Email','Строка должна соответствовать формату email. Например: foobar@example.com',NULL,'Это не похоже на email!',NULL,570,0,'2011-02-20 16:14:34','2011-02-20 16:14:34');
INSERT INTO `az_validators` VALUES (575,2,3599,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,571,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (576,2,3600,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,572,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (577,2,3601,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1372,2,3584,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1373,2,3586,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1374,2,3587,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1375,2,3588,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1376,2,3597,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1866,2,5666,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (1867,2,5667,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,1,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (39191,2,58676,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,569,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (39192,2,58677,'Email','Строка должна соответствовать формату email. Например: foobar@example.com',NULL,'Это не похоже на email!',NULL,570,0,'2011-02-20 16:14:34','2011-02-20 16:14:34');
INSERT INTO `az_validators` VALUES (39193,2,58677,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,571,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (39194,2,58678,'Обязательное','Поле обязательно должно быть заполнено',NULL,'Поле обязательно должно быть заполнено!',NULL,572,0,'2011-02-20 08:55:15','2011-02-20 08:55:15');
INSERT INTO `az_validators` VALUES (50225,2,NULL,'URI','Строка должна соответствовать формату URI. Например: http://example.com/foo/bar.html',NULL,'Это не похоже на URI!',NULL,NULL,1,'2012-03-27 08:30:09','2012-03-27 08:30:09');
INSERT INTO `az_validators` VALUES (51010,2,NULL,'Уникальное','Запись не должна повторяться',NULL,'Запись с таким значением уже существует',NULL,NULL,1,'2012-03-27 11:22:34','2012-03-27 11:22:34');
/*!40000 ALTER TABLE `az_validators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_variables`
--

DROP TABLE IF EXISTS `az_variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `az_base_data_type_id` int(11) DEFAULT NULL,
  `az_struct_data_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `copy_of` int(11) DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `position` int(11) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `index_az_variables_on_az_struct_data_type_id` (`az_struct_data_type_id`),
  KEY `index_az_variables_on_copy_of` (`copy_of`),
  KEY `index_az_variables_on_owner_id` (`owner_id`),
  KEY `az_base_data_type_id` (`az_base_data_type_id`),
  KEY `index_az_variables_on_az_base_data_type_id` (`az_base_data_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58933 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_variables`
--

LOCK TABLES `az_variables` WRITE;
/*!40000 ALTER TABLE `az_variables` DISABLE KEYS */;
INSERT INTO `az_variables` VALUES (459,'page_name',1,310,'2011-01-06 12:30:03','2011-01-06 12:30:03',NULL,55,NULL,'');
INSERT INTO `az_variables` VALUES (460,'Заголовок страницы',1,310,'2011-01-06 12:30:36','2011-01-06 12:30:36',NULL,55,NULL,'');
INSERT INTO `az_variables` VALUES (461,'Содержимое страницы',2,310,'2011-01-06 12:30:55','2011-01-06 12:30:55',NULL,55,NULL,'');
INSERT INTO `az_variables` VALUES (462,'Ключевые слова (поисковики)',1,310,'2011-01-06 12:31:14','2011-01-06 12:31:49',NULL,55,NULL,'');
INSERT INTO `az_variables` VALUES (463,'Описание (поисковики)',1,310,'2011-01-06 12:31:36','2011-01-06 12:31:36',NULL,55,NULL,'');
INSERT INTO `az_variables` VALUES (630,'page_name',1,366,'2011-01-06 12:30:03','2011-01-06 12:30:03',459,55,NULL,'');
INSERT INTO `az_variables` VALUES (631,'Заголовок страницы',1,366,'2011-01-06 12:30:36','2011-01-06 12:30:36',460,55,NULL,'');
INSERT INTO `az_variables` VALUES (632,'Содержимое страницы',2,366,'2011-01-06 12:30:55','2011-01-06 12:30:55',461,55,NULL,'');
INSERT INTO `az_variables` VALUES (633,'Ключевые слова (поисковики)',1,366,'2011-01-06 12:31:14','2011-01-06 12:31:49',462,55,NULL,'');
INSERT INTO `az_variables` VALUES (634,'Описание (поисковики)',1,366,'2011-01-06 12:31:36','2011-01-06 12:31:36',463,55,NULL,'');
INSERT INTO `az_variables` VALUES (3581,'Название',1,1000,'2011-02-21 15:21:09','2011-06-16 08:03:04',NULL,2,0,'');
INSERT INTO `az_variables` VALUES (3582,'Описание',1,1000,'2011-02-21 15:21:19','2011-06-16 08:03:04',NULL,2,1,'');
INSERT INTO `az_variables` VALUES (3583,'Название',1,1002,'2011-02-21 15:49:16','2011-06-16 08:03:04',NULL,2,0,'');
INSERT INTO `az_variables` VALUES (3584,'Описание',1,1002,'2011-02-21 15:49:39','2011-06-16 08:03:04',NULL,2,1,'');
INSERT INTO `az_variables` VALUES (3585,'Тип работы',1000,1002,'2011-02-21 15:49:57','2011-06-16 08:03:04',NULL,2,2,'');
INSERT INTO `az_variables` VALUES (3586,'Изображение',9,1004,'2011-02-21 15:56:43','2011-06-16 08:03:04',NULL,2,0,'');
INSERT INTO `az_variables` VALUES (3587,'Название',1,1004,'2011-02-21 15:57:00','2011-06-16 08:03:04',NULL,2,1,'');
INSERT INTO `az_variables` VALUES (3588,'Описание',2,1004,'2011-02-21 15:57:14','2011-06-16 08:03:04',NULL,2,2,'');
INSERT INTO `az_variables` VALUES (3589,'Название',1,1006,'2011-02-21 16:03:31','2011-06-16 08:03:04',NULL,2,0,'');
INSERT INTO `az_variables` VALUES (3591,'URL',1,1006,'2011-02-21 16:07:42','2011-06-16 08:03:04',NULL,2,1,'');
INSERT INTO `az_variables` VALUES (3592,'Клиент',1,1006,'2011-02-21 16:08:21','2011-06-16 08:03:04',NULL,2,2,'');
INSERT INTO `az_variables` VALUES (3593,'Анонс',2,1006,'2011-02-21 16:08:32','2011-06-16 08:03:04',NULL,2,3,'');
INSERT INTO `az_variables` VALUES (3594,'Дата сдачи проекта',6,1006,'2011-02-21 16:09:14','2011-06-16 08:03:04',NULL,2,4,'');
INSERT INTO `az_variables` VALUES (3595,'Тип',1000,1006,'2011-02-21 16:09:31','2011-06-16 08:03:04',NULL,2,5,'');
INSERT INTO `az_variables` VALUES (3596,'Категории',1003,1006,'2011-02-21 16:09:48','2011-06-16 08:03:04',NULL,2,6,'');
INSERT INTO `az_variables` VALUES (3597,'Изображения',1005,1006,'2011-02-21 16:10:22','2011-06-16 08:03:04',NULL,2,7,'');
INSERT INTO `az_variables` VALUES (3598,'Имя',1,1008,'2010-12-23 09:04:32','2011-06-16 08:03:05',1,2,0,'');
INSERT INTO `az_variables` VALUES (3599,'e-mail',1,1008,'2010-12-23 09:04:46','2011-06-16 08:03:05',2,2,1,'');
INSERT INTO `az_variables` VALUES (3600,'Сообщение',2,1008,'2010-12-23 09:05:06','2011-06-16 08:03:05',3,2,2,'');
INSERT INTO `az_variables` VALUES (3601,'Изображение-превью',1004,1006,'2011-02-22 10:05:42','2011-06-16 08:03:05',NULL,2,8,'');
INSERT INTO `az_variables` VALUES (5666,'Фото',9,1893,'2011-06-17 09:07:58','2011-06-17 09:07:58',NULL,2,1,'');
INSERT INTO `az_variables` VALUES (5667,'Название',1,1893,'2011-06-17 09:08:20','2011-06-17 09:08:20',NULL,2,2,'');
INSERT INTO `az_variables` VALUES (5668,'Описание',2,1893,'2011-06-17 09:08:43','2011-06-17 09:08:43',NULL,2,3,'');
INSERT INTO `az_variables` VALUES (58676,'Имя',1,25107,'2010-12-23 09:04:32','2011-06-16 08:02:27',1,2,1,'');
INSERT INTO `az_variables` VALUES (58677,'e-mail',1,25107,'2010-12-23 09:04:46','2011-06-16 08:02:27',2,2,2,'');
INSERT INTO `az_variables` VALUES (58678,'Сообщение',2,25107,'2010-12-23 09:05:06','2011-06-16 08:02:27',3,2,3,'');
INSERT INTO `az_variables` VALUES (58931,'Дата',8,25107,'2011-10-11 06:43:37','2011-10-11 06:43:37',NULL,2,4,'');
INSERT INTO `az_variables` VALUES (58932,'Статус',5,25107,'2011-10-11 06:43:51','2011-10-11 06:43:51',NULL,2,5,'');
/*!40000 ALTER TABLE `az_variables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20100331072724');
INSERT INTO `schema_migrations` VALUES ('20100331072734');
INSERT INTO `schema_migrations` VALUES ('20100408132829');
INSERT INTO `schema_migrations` VALUES ('20100411150743');
INSERT INTO `schema_migrations` VALUES ('20100528164943');
INSERT INTO `schema_migrations` VALUES ('20100531134941');
INSERT INTO `schema_migrations` VALUES ('20100604072724');
INSERT INTO `schema_migrations` VALUES ('20100605072724');
INSERT INTO `schema_migrations` VALUES ('20100617151636');
INSERT INTO `schema_migrations` VALUES ('20100617234941');
INSERT INTO `schema_migrations` VALUES ('20100618134941');
INSERT INTO `schema_migrations` VALUES ('20100705134941');
INSERT INTO `schema_migrations` VALUES ('20100709182624');
INSERT INTO `schema_migrations` VALUES ('20100709182724');
INSERT INTO `schema_migrations` VALUES ('20100709182824');
INSERT INTO `schema_migrations` VALUES ('20100709182924');
INSERT INTO `schema_migrations` VALUES ('20100711134941');
INSERT INTO `schema_migrations` VALUES ('20100719182824');
INSERT INTO `schema_migrations` VALUES ('20100719182825');
INSERT INTO `schema_migrations` VALUES ('20100719182926');
INSERT INTO `schema_migrations` VALUES ('20100719182927');
INSERT INTO `schema_migrations` VALUES ('20100719182928');
INSERT INTO `schema_migrations` VALUES ('20100719182930');
INSERT INTO `schema_migrations` VALUES ('20100720122927');
INSERT INTO `schema_migrations` VALUES ('20100720134141');
INSERT INTO `schema_migrations` VALUES ('20100720182930');
INSERT INTO `schema_migrations` VALUES ('20100722141443');
INSERT INTO `schema_migrations` VALUES ('20100722152454');
INSERT INTO `schema_migrations` VALUES ('20100722152553');
INSERT INTO `schema_migrations` VALUES ('20100725111425');
INSERT INTO `schema_migrations` VALUES ('20100725112044');
INSERT INTO `schema_migrations` VALUES ('20100725121327');
INSERT INTO `schema_migrations` VALUES ('20100725134143');
INSERT INTO `schema_migrations` VALUES ('20100725135528');
INSERT INTO `schema_migrations` VALUES ('20100726075550');
INSERT INTO `schema_migrations` VALUES ('20100728134143');
INSERT INTO `schema_migrations` VALUES ('20100728141443');
INSERT INTO `schema_migrations` VALUES ('20100728174527');
INSERT INTO `schema_migrations` VALUES ('20100730071615');
INSERT INTO `schema_migrations` VALUES ('20100731134143');
INSERT INTO `schema_migrations` VALUES ('20100804134143');
INSERT INTO `schema_migrations` VALUES ('20100811134143');
INSERT INTO `schema_migrations` VALUES ('20100814134143');
INSERT INTO `schema_migrations` VALUES ('20100814134145');
INSERT INTO `schema_migrations` VALUES ('20100817115152');
INSERT INTO `schema_migrations` VALUES ('20100821115152');
INSERT INTO `schema_migrations` VALUES ('20100825134143');
INSERT INTO `schema_migrations` VALUES ('20100825134153');
INSERT INTO `schema_migrations` VALUES ('20100825134253');
INSERT INTO `schema_migrations` VALUES ('20100826134253');
INSERT INTO `schema_migrations` VALUES ('20100827134253');
INSERT INTO `schema_migrations` VALUES ('20100829134253');
INSERT INTO `schema_migrations` VALUES ('20100829134353');
INSERT INTO `schema_migrations` VALUES ('20100830134353');
INSERT INTO `schema_migrations` VALUES ('20100830135528');
INSERT INTO `schema_migrations` VALUES ('20100830135548');
INSERT INTO `schema_migrations` VALUES ('20100831135548');
INSERT INTO `schema_migrations` VALUES ('20100831164253');
INSERT INTO `schema_migrations` VALUES ('20100903152217');
INSERT INTO `schema_migrations` VALUES ('20100904115858');
INSERT INTO `schema_migrations` VALUES ('20100904151149');
INSERT INTO `schema_migrations` VALUES ('20100907060819');
INSERT INTO `schema_migrations` VALUES ('20100925082610');
INSERT INTO `schema_migrations` VALUES ('20101004092821');
INSERT INTO `schema_migrations` VALUES ('20101009085534');
INSERT INTO `schema_migrations` VALUES ('20101009090354');
INSERT INTO `schema_migrations` VALUES ('20101009134143');
INSERT INTO `schema_migrations` VALUES ('20101009155631');
INSERT INTO `schema_migrations` VALUES ('20101010102220');
INSERT INTO `schema_migrations` VALUES ('20101010134029');
INSERT INTO `schema_migrations` VALUES ('20101011085910');
INSERT INTO `schema_migrations` VALUES ('20101011090833');
INSERT INTO `schema_migrations` VALUES ('20101011140336');
INSERT INTO `schema_migrations` VALUES ('20101012150137');
INSERT INTO `schema_migrations` VALUES ('20101012150655');
INSERT INTO `schema_migrations` VALUES ('20101016142021');
INSERT INTO `schema_migrations` VALUES ('20101024111840');
INSERT INTO `schema_migrations` VALUES ('20101025071258');
INSERT INTO `schema_migrations` VALUES ('20101027151310');
INSERT INTO `schema_migrations` VALUES ('20101028144608');
INSERT INTO `schema_migrations` VALUES ('20101028144609');
INSERT INTO `schema_migrations` VALUES ('20101101173051');
INSERT INTO `schema_migrations` VALUES ('20101107144808');
INSERT INTO `schema_migrations` VALUES ('20101107144818');
INSERT INTO `schema_migrations` VALUES ('20101115134153');
INSERT INTO `schema_migrations` VALUES ('20101115134253');
INSERT INTO `schema_migrations` VALUES ('20101119134253');
INSERT INTO `schema_migrations` VALUES ('20101120112938');
INSERT INTO `schema_migrations` VALUES ('20101122161325');
INSERT INTO `schema_migrations` VALUES ('20101122162532');
INSERT INTO `schema_migrations` VALUES ('20101128111833');
INSERT INTO `schema_migrations` VALUES ('20101206173330');
INSERT INTO `schema_migrations` VALUES ('20101207082917');
INSERT INTO `schema_migrations` VALUES ('20101207090354');
INSERT INTO `schema_migrations` VALUES ('20101210181040');
INSERT INTO `schema_migrations` VALUES ('20101211151310');
INSERT INTO `schema_migrations` VALUES ('20101211154253');
INSERT INTO `schema_migrations` VALUES ('20101212151310');
INSERT INTO `schema_migrations` VALUES ('20101212154253');
INSERT INTO `schema_migrations` VALUES ('20101212154353');
INSERT INTO `schema_migrations` VALUES ('20101218154353');
INSERT INTO `schema_migrations` VALUES ('20110106142547');
INSERT INTO `schema_migrations` VALUES ('20110110091410');
INSERT INTO `schema_migrations` VALUES ('20110117134350');
INSERT INTO `schema_migrations` VALUES ('20110123160133');
INSERT INTO `schema_migrations` VALUES ('20110127100426');
INSERT INTO `schema_migrations` VALUES ('20110129164259');
INSERT INTO `schema_migrations` VALUES ('20110131102135');
INSERT INTO `schema_migrations` VALUES ('20110211140948');
INSERT INTO `schema_migrations` VALUES ('20110218092706');
INSERT INTO `schema_migrations` VALUES ('20110224162723');
INSERT INTO `schema_migrations` VALUES ('20110301162847');
INSERT INTO `schema_migrations` VALUES ('20110304084950');
INSERT INTO `schema_migrations` VALUES ('20110311113856');
INSERT INTO `schema_migrations` VALUES ('20110311120922');
INSERT INTO `schema_migrations` VALUES ('20110316192401');
INSERT INTO `schema_migrations` VALUES ('20110319121944');
INSERT INTO `schema_migrations` VALUES ('20110511133329');
INSERT INTO `schema_migrations` VALUES ('20110518110359');
INSERT INTO `schema_migrations` VALUES ('20110601131337');
INSERT INTO `schema_migrations` VALUES ('20110601161457');
INSERT INTO `schema_migrations` VALUES ('20110602165212');
INSERT INTO `schema_migrations` VALUES ('20110602165222');
INSERT INTO `schema_migrations` VALUES ('20110615151911');
INSERT INTO `schema_migrations` VALUES ('20110617114410');
INSERT INTO `schema_migrations` VALUES ('20110619074542');
INSERT INTO `schema_migrations` VALUES ('20110619110501');
INSERT INTO `schema_migrations` VALUES ('20110623132647');
INSERT INTO `schema_migrations` VALUES ('20110725094129');
INSERT INTO `schema_migrations` VALUES ('20110817114338');
INSERT INTO `schema_migrations` VALUES ('20110822124419');
INSERT INTO `schema_migrations` VALUES ('20110822155204');
INSERT INTO `schema_migrations` VALUES ('20110823131543');
INSERT INTO `schema_migrations` VALUES ('20110825132041');
INSERT INTO `schema_migrations` VALUES ('20110901112625');
INSERT INTO `schema_migrations` VALUES ('20110901114752');
INSERT INTO `schema_migrations` VALUES ('20110901115120');
INSERT INTO `schema_migrations` VALUES ('20110901121606');
INSERT INTO `schema_migrations` VALUES ('20110904195303');
INSERT INTO `schema_migrations` VALUES ('20110905163039');
INSERT INTO `schema_migrations` VALUES ('20110907140849');
INSERT INTO `schema_migrations` VALUES ('20110907143352');
INSERT INTO `schema_migrations` VALUES ('20110925111223');
INSERT INTO `schema_migrations` VALUES ('20110930105452');
INSERT INTO `schema_migrations` VALUES ('20111016125036');
INSERT INTO `schema_migrations` VALUES ('20111016155254');
INSERT INTO `schema_migrations` VALUES ('20111016163735');
INSERT INTO `schema_migrations` VALUES ('20111022144225');
INSERT INTO `schema_migrations` VALUES ('20111101171241');
INSERT INTO `schema_migrations` VALUES ('20111102103851');
INSERT INTO `schema_migrations` VALUES ('20111105143723');
INSERT INTO `schema_migrations` VALUES ('20111110132144');
INSERT INTO `schema_migrations` VALUES ('20111110134523');
INSERT INTO `schema_migrations` VALUES ('20111115133209');
INSERT INTO `schema_migrations` VALUES ('20111115135342');
INSERT INTO `schema_migrations` VALUES ('20111121112048');
INSERT INTO `schema_migrations` VALUES ('20111121192748');
INSERT INTO `schema_migrations` VALUES ('20120112104635');
INSERT INTO `schema_migrations` VALUES ('20120119163032');
INSERT INTO `schema_migrations` VALUES ('20120130123523');
INSERT INTO `schema_migrations` VALUES ('20120131110817');
INSERT INTO `schema_migrations` VALUES ('20120131140613');
INSERT INTO `schema_migrations` VALUES ('20120131174933');
INSERT INTO `schema_migrations` VALUES ('20120201153859');
INSERT INTO `schema_migrations` VALUES ('20120202140718');
INSERT INTO `schema_migrations` VALUES ('20120204102627');
INSERT INTO `schema_migrations` VALUES ('20120204103149');
INSERT INTO `schema_migrations` VALUES ('20120205121500');
INSERT INTO `schema_migrations` VALUES ('20120206151417');
INSERT INTO `schema_migrations` VALUES ('20120206183033');
INSERT INTO `schema_migrations` VALUES ('20120207102425');
INSERT INTO `schema_migrations` VALUES ('20120207102533');
INSERT INTO `schema_migrations` VALUES ('20120207121246');
INSERT INTO `schema_migrations` VALUES ('20120208140514');
INSERT INTO `schema_migrations` VALUES ('20120209081949');
INSERT INTO `schema_migrations` VALUES ('20120210121244');
INSERT INTO `schema_migrations` VALUES ('20120214103104');
INSERT INTO `schema_migrations` VALUES ('20120215140514');
INSERT INTO `schema_migrations` VALUES ('20120215153636');
INSERT INTO `schema_migrations` VALUES ('20120216100159');
INSERT INTO `schema_migrations` VALUES ('20120220142047');
INSERT INTO `schema_migrations` VALUES ('20120221084326');
INSERT INTO `schema_migrations` VALUES ('20120222131934');
INSERT INTO `schema_migrations` VALUES ('20120222133044');
INSERT INTO `schema_migrations` VALUES ('20120222134613');
INSERT INTO `schema_migrations` VALUES ('20120222135550');
INSERT INTO `schema_migrations` VALUES ('20120222135806');
INSERT INTO `schema_migrations` VALUES ('20120222140709');
INSERT INTO `schema_migrations` VALUES ('20120222141554');
INSERT INTO `schema_migrations` VALUES ('20120301113016');
INSERT INTO `schema_migrations` VALUES ('20120325161900');
INSERT INTO `schema_migrations` VALUES ('20120410103545');
INSERT INTO `schema_migrations` VALUES ('20120509162816');
INSERT INTO `schema_migrations` VALUES ('20120811175544');
INSERT INTO `schema_migrations` VALUES ('20120818155929');
INSERT INTO `schema_migrations` VALUES ('20120822154947');
INSERT INTO `schema_migrations` VALUES ('20120822155606');
INSERT INTO `schema_migrations` VALUES ('20120822162654');
INSERT INTO `schema_migrations` VALUES ('20120822165821');
INSERT INTO `schema_migrations` VALUES ('20120826154427');
INSERT INTO `schema_migrations` VALUES ('20120930160425');
INSERT INTO `schema_migrations` VALUES ('20121007144151');
INSERT INTO `schema_migrations` VALUES ('20121030140419');
INSERT INTO `schema_migrations` VALUES ('20121103093606');
INSERT INTO `schema_migrations` VALUES ('20130105091921');
INSERT INTO `schema_migrations` VALUES ('20130106143745');
INSERT INTO `schema_migrations` VALUES ('20130106150455');
INSERT INTO `schema_migrations` VALUES ('20130310125754');
INSERT INTO `schema_migrations` VALUES ('20130319194511');
INSERT INTO `schema_migrations` VALUES ('20130319215707');
INSERT INTO `schema_migrations` VALUES ('20130414132449');
INSERT INTO `schema_migrations` VALUES ('20130416083333');
INSERT INTO `schema_migrations` VALUES ('20130422104612');
INSERT INTO `schema_migrations` VALUES ('20130428083249');
INSERT INTO `schema_migrations` VALUES ('20130430074114');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-07-15 16:10:03
