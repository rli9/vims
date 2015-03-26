-- MySQL dump 10.13  Distrib 5.5.17, for Win32 (x86)
--
-- Host: localhost    Database: swqd
-- ------------------------------------------------------
-- Server version	5.5.17

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
-- Table structure for table `bits_interpreters`
--

DROP TABLE IF EXISTS `bits_interpreters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bits_interpreters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `length` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bits_segments`
--

DROP TABLE IF EXISTS `bits_segments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bits_segments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bits_interpreter_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_bit` int(11) NOT NULL,
  `end_bit` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bits_values`
--

DROP TABLE IF EXISTS `bits_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bits_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bits_segment_id` int(11) NOT NULL,
  `bits` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bug_configs`
--

DROP TABLE IF EXISTS `bug_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bug_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_target_id` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bug_tracks`
--

DROP TABLE IF EXISTS `bug_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bug_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_target_id` int(11) NOT NULL,
  `bug_id` int(11) NOT NULL,
  `test_case_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `bug_config_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index2` (`test_case_id`,`bug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1769 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `change_lists`
--

DROP TABLE IF EXISTS `change_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `change_lists` (
  `id` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_transactions`
--

DROP TABLE IF EXISTS `device_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_item_id` int(11) NOT NULL,
  `from_member_id` int(11) DEFAULT NULL,
  `to_member_id` int(11) DEFAULT NULL,
  `device_transaction_status_type_id` int(11) DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hw_configs`
--

DROP TABLE IF EXISTS `hw_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hw_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `basic_io_system_id` int(11) NOT NULL,
  `embedded_controller_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member_project_associations`
--

DROP TABLE IF EXISTS `member_project_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_project_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_by_project_and_member` (`project_id`,`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member_template_sequences`
--

DROP TABLE IF EXISTS `member_template_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_template_sequences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `test_target_id` int(11) NOT NULL,
  `test_case_template_id` int(11) NOT NULL,
  `template_sequence` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `hashed_password` varchar(255) NOT NULL,
  `picture_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page_hierarchies`
--

DROP TABLE IF EXISTS `page_hierarchies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_hierarchies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `controller` varchar(255) NOT NULL,
  `action` varchar(255) DEFAULT NULL,
  `parent_page_hierarchy_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pictures`
--

DROP TABLE IF EXISTS `pictures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_type` varchar(255) NOT NULL,
  `data` blob NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `remark` text,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1124 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sw_configs`
--

DROP TABLE IF EXISTS `sw_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sw_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operating_system_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `operating_system_id` (`operating_system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_hsd_nonassociation_types`
--

DROP TABLE IF EXISTS `test_case_hsd_nonassociation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_hsd_nonassociation_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_hsd_nonassociations`
--

DROP TABLE IF EXISTS `test_case_hsd_nonassociations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_hsd_nonassociations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hsd_id` int(11) NOT NULL,
  `test_case_hsd_nonassociation_type_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hsd_id` (`hsd_id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_status_types`
--

DROP TABLE IF EXISTS `test_case_status_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_status_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_step_phases`
--

DROP TABLE IF EXISTS `test_case_step_phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_step_phases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_template_param_instances`
--

DROP TABLE IF EXISTS `test_case_template_param_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_template_param_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_case_template_param_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index0` (`test_case_template_param_id`),
  KEY `index1` (`name`),
  KEY `index2` (`test_case_template_param_id`,`name`),
  KEY `index3` (`id`,`test_case_template_param_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7596 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_template_params`
--

DROP TABLE IF EXISTS `test_case_template_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_template_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `test_case_template_id` int(11) DEFAULT NULL,
  `seq` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index0` (`test_case_template_id`),
  KEY `index1` (`name`),
  KEY `index2` (`test_case_template_id`,`name`),
  KEY `index3` (`test_case_template_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_templates`
--

DROP TABLE IF EXISTS `test_case_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `test_target_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index0` (`test_target_id`),
  KEY `index1` (`name`),
  KEY `index2` (`test_target_id`,`name`),
  KEY `index3` (`test_target_id`,`id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_test_case_template_param_instance_associations`
--

DROP TABLE IF EXISTS `test_case_test_case_template_param_instance_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_test_case_template_param_instance_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_case_id` int(11) NOT NULL,
  `test_case_template_param_instance_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index0` (`test_case_id`),
  KEY `index1` (`test_case_template_param_instance_id`),
  KEY `index2` (`test_case_id`,`test_case_template_param_instance_id`),
  KEY `index3` (`test_case_template_param_instance_id`,`test_case_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19461610 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_case_test_suite_associations`
--

DROP TABLE IF EXISTS `test_case_test_suite_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_case_test_suite_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_suite_id` int(11) NOT NULL,
  `test_case_id` int(11) NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `test_suite_id` (`test_suite_id`),
  KEY `test_case_id` (`test_case_id`),
  KEY `index_test_case_test_suite_associations_on_test_suite_id` (`test_suite_id`),
  KEY `index_test_case_test_suite_associations_on_test_case_id` (`test_case_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3316591 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_cases`
--

DROP TABLE IF EXISTS `test_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_cases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `test_target_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '2009-01-01 00:00:00',
  `updated_at` datetime NOT NULL,
  `test_type_id` int(11) DEFAULT NULL,
  `test_case_status_type_id` int(11) NOT NULL DEFAULT '1',
  `test_execution_time` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `version` int(11) DEFAULT '1',
  `next_test_case_id` int(11) DEFAULT NULL,
  `first_test_case_id` int(11) DEFAULT NULL,
  `command` varchar(2048) DEFAULT NULL,
  `lowercase_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `test_target_id` (`test_target_id`),
  KEY `index_test_cases_on_test_case_status_type_id` (`test_case_status_type_id`),
  KEY `index_by_test_target_and_name` (`test_target_id`,`name`),
  KEY `index_by_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3307678 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_code_instances`
--

DROP TABLE IF EXISTS `test_code_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_code_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `changeset` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `test_target_id` int(11) DEFAULT '25',
  PRIMARY KEY (`id`),
  KEY `index_test_code_instances_on_changeset` (`changeset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_results`
--

DROP TABLE IF EXISTS `test_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_case_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `test_target_instance_id` int(11) NOT NULL,
  `test_config_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT '0',
  `test_code_instance_id` int(11) DEFAULT NULL,
  `result` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_test_case_id_and_test_target_instance_id` (`test_case_id`,`test_target_instance_id`),
  KEY `index_by_test_target_instance_and_test_case` (`test_target_instance_id`,`test_case_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6181562 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_suite_test_suite_associations`
--

DROP TABLE IF EXISTS `test_suite_test_suite_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_suite_test_suite_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_test_suite_id` int(11) NOT NULL,
  `child_test_suite_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=382 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_suites`
--

DROP TABLE IF EXISTS `test_suites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_suites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `test_target_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=443 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_target_instance_role_associations`
--

DROP TABLE IF EXISTS `test_target_instance_role_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_target_instance_role_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_target_instance_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_by_member_and_test_cycle` (`member_id`,`test_target_instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=464 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_target_instances`
--

DROP TABLE IF EXISTS `test_target_instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_target_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `change_list_id` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `test_target_id` int(11) NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_by_test_target` (`test_target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=340 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_target_project_associations`
--

DROP TABLE IF EXISTS `test_target_project_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_target_project_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_target_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_targets`
--

DROP TABLE IF EXISTS `test_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_targets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weighted_target_instance_results`
--

DROP TABLE IF EXISTS `weighted_target_instance_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weighted_target_instance_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_case_id` int(11) NOT NULL,
  `test_target_pass` int(11) NOT NULL,
  `test_target_fail` int(11) NOT NULL,
  `test_target_block` int(11) NOT NULL,
  `test_case_fail` int(11) NOT NULL,
  `test_case_block` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `test_target_instance_id` int(11) NOT NULL,
  `test_config_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `test_cycle_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_weighted_target_instance_results_on_test_case_id` (`test_case_id`),
  KEY `index_weighted_target_instance_results_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=707353 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weighted_test_results`
--

DROP TABLE IF EXISTS `weighted_test_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weighted_test_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_case_id` int(11) NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `test_target_instance_id` int(11) NOT NULL,
  `value` int(11) DEFAULT '0',
  `test_code_instance_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_test_case_id_and_test_target_instance_id` (`test_case_id`,`test_target_instance_id`),
  KEY `incex_target_cycle_created_caseid` (`test_case_id`),
  KEY `index_type_cycle_case` (`test_case_id`),
  KEY `test_case_id` (`test_case_id`),
  KEY `index_by_test_target_instance_and_test_case` (`test_target_instance_id`,`test_case_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6018296 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-08-05 15:27:34
INSERT INTO schema_migrations (version) VALUES ('20091028032846');

INSERT INTO schema_migrations (version) VALUES ('20091028053454');

INSERT INTO schema_migrations (version) VALUES ('20091028053944');

INSERT INTO schema_migrations (version) VALUES ('20091029021557');

INSERT INTO schema_migrations (version) VALUES ('20091029051549');

INSERT INTO schema_migrations (version) VALUES ('20091029053937');

INSERT INTO schema_migrations (version) VALUES ('20091029064012');

INSERT INTO schema_migrations (version) VALUES ('20091105102256');

INSERT INTO schema_migrations (version) VALUES ('20091112010712');

INSERT INTO schema_migrations (version) VALUES ('20091112025334');

INSERT INTO schema_migrations (version) VALUES ('20091113015002');

INSERT INTO schema_migrations (version) VALUES ('20100603035554');

INSERT INTO schema_migrations (version) VALUES ('20100603041205');

INSERT INTO schema_migrations (version) VALUES ('20100603041628');

INSERT INTO schema_migrations (version) VALUES ('20100603042146');

INSERT INTO schema_migrations (version) VALUES ('20101222070746');

INSERT INTO schema_migrations (version) VALUES ('20110118020416');

INSERT INTO schema_migrations (version) VALUES ('20110121104225');

INSERT INTO schema_migrations (version) VALUES ('20110127020227');

INSERT INTO schema_migrations (version) VALUES ('20110127020337');

INSERT INTO schema_migrations (version) VALUES ('20110130020338');

INSERT INTO schema_migrations (version) VALUES ('20110130020449');

INSERT INTO schema_migrations (version) VALUES ('20110215020449');

INSERT INTO schema_migrations (version) VALUES ('20110222568168');

INSERT INTO schema_migrations (version) VALUES ('20110301574875');

INSERT INTO schema_migrations (version) VALUES ('20110305546871');

INSERT INTO schema_migrations (version) VALUES ('20110306549874');

INSERT INTO schema_migrations (version) VALUES ('20110315549819');

INSERT INTO schema_migrations (version) VALUES ('20110322149641');

INSERT INTO schema_migrations (version) VALUES ('20110322849641');

INSERT INTO schema_migrations (version) VALUES ('20110322949641');

INSERT INTO schema_migrations (version) VALUES ('20110328949644');

INSERT INTO schema_migrations (version) VALUES ('20110328949645');

INSERT INTO schema_migrations (version) VALUES ('20110328949646');

INSERT INTO schema_migrations (version) VALUES ('20110413949647');

INSERT INTO schema_migrations (version) VALUES ('20110413949648');

INSERT INTO schema_migrations (version) VALUES ('20110414049784');

INSERT INTO schema_migrations (version) VALUES ('20110416049784');

INSERT INTO schema_migrations (version) VALUES ('20110429084713');

INSERT INTO schema_migrations (version) VALUES ('20110429111045');

INSERT INTO schema_migrations (version) VALUES ('20110601124249');

INSERT INTO schema_migrations (version) VALUES ('20110603080608');

INSERT INTO schema_migrations (version) VALUES ('20110628135641');

INSERT INTO schema_migrations (version) VALUES ('20110816051808');

INSERT INTO schema_migrations (version) VALUES ('20110921561890');

INSERT INTO schema_migrations (version) VALUES ('20111008092214');

INSERT INTO schema_migrations (version) VALUES ('20111110204133');

INSERT INTO schema_migrations (version) VALUES ('20111114042432');

INSERT INTO schema_migrations (version) VALUES ('20111115048161');

INSERT INTO schema_migrations (version) VALUES ('20111121040824');

INSERT INTO schema_migrations (version) VALUES ('20111122075015');

INSERT INTO schema_migrations (version) VALUES ('20111129020451');

INSERT INTO schema_migrations (version) VALUES ('20111130081135');

INSERT INTO schema_migrations (version) VALUES ('20111130091546');

INSERT INTO schema_migrations (version) VALUES ('20111207122338');

INSERT INTO schema_migrations (version) VALUES ('20111223448612');

INSERT INTO schema_migrations (version) VALUES ('20120525160630');

INSERT INTO schema_migrations (version) VALUES ('20121122093330');

INSERT INTO schema_migrations (version) VALUES ('20121122093630');

INSERT INTO schema_migrations (version) VALUES ('20121122095230');

INSERT INTO schema_migrations (version) VALUES ('20121122111630');

INSERT INTO schema_migrations (version) VALUES ('20121122142030');

INSERT INTO schema_migrations (version) VALUES ('20121122142530');

INSERT INTO schema_migrations (version) VALUES ('20121122150530');

INSERT INTO schema_migrations (version) VALUES ('20121122152230');

INSERT INTO schema_migrations (version) VALUES ('20121206135130');

INSERT INTO schema_migrations (version) VALUES ('20121206142530');

INSERT INTO schema_migrations (version) VALUES ('20130108142544');

INSERT INTO schema_migrations (version) VALUES ('20130108142545');

INSERT INTO schema_migrations (version) VALUES ('20130108142546');

INSERT INTO schema_migrations (version) VALUES ('20130108142547');

INSERT INTO schema_migrations (version) VALUES ('20130108142548');

INSERT INTO schema_migrations (version) VALUES ('20130108142549');

INSERT INTO schema_migrations (version) VALUES ('20130218123650');

INSERT INTO schema_migrations (version) VALUES ('20130218161640');

INSERT INTO schema_migrations (version) VALUES ('20130218173651');

INSERT INTO schema_migrations (version) VALUES ('20130221131830');

INSERT INTO schema_migrations (version) VALUES ('20130221133030');

INSERT INTO schema_migrations (version) VALUES ('20130305140830');

INSERT INTO schema_migrations (version) VALUES ('20130307131430');

INSERT INTO schema_migrations (version) VALUES ('201303141335');

INSERT INTO schema_migrations (version) VALUES ('20130418114030');

INSERT INTO schema_migrations (version) VALUES ('20130421132030');

INSERT INTO schema_migrations (version) VALUES ('20130805162440');
