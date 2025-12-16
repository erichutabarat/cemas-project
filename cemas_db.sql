-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: cemas_db
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.1

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
-- Table structure for table `hars_questions`
--

DROP TABLE IF EXISTS `hars_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hars_questions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` longtext NOT NULL,
  `question` longtext NOT NULL,
  `description` longtext,
  `symptom_type` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hars_questions`
--

LOCK TABLES `hars_questions` WRITE;
/*!40000 ALTER TABLE `hars_questions` DISABLE KEYS */;
INSERT INTO `hars_questions` VALUES (1,'Anxious Mood','Worrying, anticipation of the worst, fearful rumination.',NULL,'Psychic'),(2,'Tension','Feelings of tension, fatigability, startle response, moving about restlessly, inability to relax.',NULL,'Psychic'),(3,'Fears','Fear of darkness, of strangers, of being left alone, of animals, of crowds, of traffic, etc.',NULL,'Psychic'),(4,'Insomnia','Difficulty falling asleep, broken sleep, unsatisfying sleep and fatigue on waking, dreams, nightmares, night terrors.',NULL,'Psychic'),(5,'Intellectual (Cognitive) Symptoms','Difficulty in concentration, poor memory.',NULL,'Psychic'),(6,'Depressed Mood','Loss of interest, lack of pleasure in hobbies, depression, early waking, diurnal swing.',NULL,'Psychic'),(7,'Somatic (Muscular) Symptoms','Aches and pains, twitching, stiffness, grinding of teeth, unsteady voice, muscular tension.',NULL,'Somatic'),(8,'Sensory Symptoms','Tinnitus, blurring of vision, hot and cold flushes, feelings of weakness, pricking sensations.',NULL,'Somatic'),(9,'Cardiovascular Symptoms','Tachycardia, palpitations, pain in chest, throbbing of vessels, fainting feelings, skipped heart beat.',NULL,'Somatic'),(10,'Respiratory Symptoms','Pressure or constriction in chest, choking feelings, sighs, dyspnea.',NULL,'Somatic'),(11,'Gastrointestinal Symptoms','Difficulty swallowing, wind, abdominal pain, burning sensations, abdominal fullness, nausea, vomiting, looseness of bowels, loss of weight, constipation.',NULL,'Somatic'),(12,'Genitourinary Symptoms','Frequency of micturition, urgency of micturition, amenorrhoea, menorrhagia, frigidity, premature ejaculation, loss of libido, impotence.',NULL,'Somatic'),(13,'Autonomic Symptoms','Dry mouth, flushing, pallor, tendency to sweat, giddiness, tension headache, raising of hair.',NULL,'Somatic'),(14,'Behaviour at Interview','General behavior (fidgeting, restlessness, tremor of hands, furrowed brow, strained face, sighing respiration, rapid respiration, pallor, swallowing, belching, etc.)',NULL,'General');
/*!40000 ALTER TABLE `hars_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hars_results`
--

DROP TABLE IF EXISTS `hars_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hars_results` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `score` bigint NOT NULL,
  `level` longtext NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_hars_results` (`user_id`),
  KEY `idx_hars_results_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_users_hars_results` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hars_results`
--

LOCK TABLES `hars_results` WRITE;
/*!40000 ALTER TABLE `hars_results` DISABLE KEYS */;
INSERT INTO `hars_results` VALUES (1,1,18,'Mild Anxiety','2025-11-29 10:13:58.838','2025-11-29 10:13:58.838',NULL),(2,1,42,'Severe Anxiety','2025-11-29 10:31:20.762','2025-11-29 10:31:20.762',NULL),(3,1,18,'Mild Anxiety','2025-11-29 10:33:54.070','2025-11-29 10:33:54.070',NULL),(4,2,18,'Mild Anxiety','2025-11-29 10:47:21.512','2025-11-29 10:47:21.512',NULL),(5,1,28,'Moderate Anxiety','2025-11-29 11:31:53.384','2025-11-29 11:31:53.384',NULL),(6,1,56,'Severe Anxiety','2025-11-30 10:58:56.782','2025-11-30 10:58:56.782',NULL),(7,1,14,'No Anxiety','2025-11-30 11:11:30.085','2025-11-30 11:11:30.085',NULL),(8,1,55,'Severe Anxiety','2025-11-30 13:15:31.736','2025-11-30 13:15:31.736',NULL),(9,1,54,'Severe Anxiety','2025-12-01 09:07:03.022','2025-12-01 09:07:03.022',NULL),(10,1,41,'Severe Anxiety','2025-12-01 19:31:58.745','2025-12-01 19:31:58.745',NULL),(11,1,18,'Mild Anxiety','2025-12-05 13:13:33.123','2025-12-05 13:13:33.123',NULL),(12,1,29,'Moderate Anxiety','2025-12-08 09:55:18.462','2025-12-08 09:55:18.462',NULL),(13,1,27,'Moderate Anxiety','2025-12-09 10:46:33.513','2025-12-09 10:46:33.513',NULL);
/*!40000 ALTER TABLE `hars_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inspections`
--

DROP TABLE IF EXISTS `inspections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspections` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `audio_url` longtext,
  `checked` tinyint(1) DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspections`
--

LOCK TABLES `inspections` WRITE;
/*!40000 ALTER TABLE `inspections` DISABLE KEYS */;
INSERT INTO `inspections` VALUES (1,1,'http://localhost:8080/uploads/heartbeat_sample.wav',1,'2025-12-06 14:19:25.599'),(2,1,'http://localhost:8080/uploads/heartbeat_sample.wav',1,'2025-12-06 14:31:42.565');
/*!40000 ALTER TABLE `inspections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendation_activities`
--

DROP TABLE IF EXISTS `recommendation_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendation_activities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` longtext,
  `image_url` longtext,
  `description` longtext,
  `anxiety_level` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendation_activities`
--

LOCK TABLES `recommendation_activities` WRITE;
/*!40000 ALTER TABLE `recommendation_activities` DISABLE KEYS */;
INSERT INTO `recommendation_activities` VALUES (1,'Deep Breathing Exercises','/uploads/activities/12849230_15_inhale-exhale-1.jpg','Deep breathing helps calm your nervous system by activating the body’s relaxation response. It reduces heart rate and lowers stress hormones, making it easier to manage anxious thoughts.','Moderate Anxiety'),(2,'Light Physical Exercise','/uploads/activities/9733.jpg','Light activities like walking, stretching, or gentle yoga increase endorphins, which naturally improve your mood. Regular movement also reduces tension in your body, helping you feel more relaxed overall.','Moderate Anxiety'),(3,'Creative Activities','/uploads/activities/162958.jpg','Engaging in art, music, or crafts helps distract your mind from stress and encourages self-expression. Creative activities also promote relaxation by stimulating the brain in a positive and enjoyable way.','Moderate Anxiety');
/*!40000 ALTER TABLE `recommendation_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendation_foods`
--

DROP TABLE IF EXISTS `recommendation_foods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendation_foods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` longtext,
  `image_url` longtext,
  `description` longtext,
  `anxiety_level` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendation_foods`
--

LOCK TABLES `recommendation_foods` WRITE;
/*!40000 ALTER TABLE `recommendation_foods` DISABLE KEYS */;
INSERT INTO `recommendation_foods` VALUES (1,'Dark Chocolate','/uploads/foods/2150660956.jpg','Dark chocolate contains antioxidants and flavonoids that may help lower stress hormone levels. Eating small portions can also boost serotonin, which improves mood and relaxation.','Moderate Anxiety'),(2,'Salmon','/uploads/foods/2148308091.jpg','Salmon is rich in omega-3 fatty acids, which support brain function and may reduce symptoms of anxiety. Regular consumption can help stabilize mood and decrease inflammation that affects mental health.','Moderate Anxiety'),(5,'Bananas','/uploads/foods/18876.jpg','Bananas are rich in vitamin B6, which helps your body produce mood-regulating neurotransmitters like serotonin. The potassium content also supports proper nerve and muscle function, helping stabilize your stress response.','Moderate Anxiety');
/*!40000 ALTER TABLE `recommendation_foods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `anxiety_score` double DEFAULT NULL,
  `anxiety_level` longtext,
  `hrv` double DEFAULT NULL,
  `bpm` double DEFAULT NULL,
  `confidence` double DEFAULT NULL,
  `inspection_id` bigint NOT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_results_inspection_id` (`inspection_id`),
  CONSTRAINT `fk_inspections_result` FOREIGN KEY (`inspection_id`) REFERENCES `inspections` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
INSERT INTO `results` VALUES (1,40.5,'Moderate',72,80,0.89,1,'2025-12-06 14:27:33.376'),(3,40.5,'Moderate',72,80,0.89,2,'2025-12-06 14:38:42.505');
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(191) NOT NULL,
  `password` longtext NOT NULL,
  `name` longtext NOT NULL,
  `birthdate` datetime(3) DEFAULT NULL,
  `gender` longtext,
  `job` longtext,
  `address` longtext,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=365 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'jane.doe@example.com','$2a$10$6VZ9cB4.qavMDDI1gnxP6uFpnI.IbwcmfURu4fCrydgP1sUQFb3Za','JANE DOE','1992-08-20 07:00:00.000','female',NULL,NULL,'2025-11-27 11:53:16.810','2025-11-27 13:19:34.636'),(2,'john.doe@example.com','$2a$10$buc9heNSvk0lRDY/JvKT7.hL65WX2b.s1T4BlniGIIipyavVwVq.e','John Doe','1992-08-20 07:00:00.000','male',NULL,NULL,'2025-11-29 10:35:42.092','2025-11-29 10:35:42.092'),(3,'jack.doe@example.com','$2a$10$yGHPDVqXqNI90aJuQTxZs.Z/eJ00W50LK6OOQ2/DqRmmGnTcPqnqK','Jack Doe','1992-08-20 07:00:00.000','male',NULL,NULL,'2025-12-05 10:47:27.181','2025-12-05 10:47:27.181'),(4,'jessica.doe@example.com','$2a$10$/9rKbptRFkwUOuJvxYCeCe2BfCVlvZitMcXlo.xaG2ibeX3Qx3R3S','Jessica Doe','1992-08-20 07:00:00.000','female',NULL,NULL,'2025-12-05 10:47:44.837','2025-12-05 10:47:44.837'),(5,'jaccob.doe@example.com','$2a$10$0lPAqxCNCat5lVY/6OHYveBulGtQcUlSMDf0R8dXQ4Xcg40hbsFnS','Jaccob Doe','1992-08-20 07:00:00.000','male',NULL,NULL,'2025-12-05 10:48:10.125','2025-12-05 10:48:10.125'),(264,'test001@example.com','$2a$04$y7iNhz2Grj0YUb9j1aT70etDBJJ1qL7QPgEErmU1h6BS.D4LdPqBu','User One','1995-01-15 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:15.631','2025-12-08 17:14:15.631'),(265,'test002@example.com','$2a$04$2ExF7zO/cGN9lecmxqklOOViTMOfdUtOjDFeD5e9M.bJohV36Y8z.','User Two','1993-02-20 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:16.650','2025-12-08 17:14:16.650'),(266,'test003@example.com','$2a$04$W1Z8RNfZiEycIfJCWx4Kg.X76F/6WanIFxgom1lTZmeU9ZyknO94O','User Three','1990-03-10 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:17.670','2025-12-08 17:14:17.670'),(267,'test004@example.com','$2a$04$ycuNvLoyghRCUY2j5y/t5udcZ5xugsKRVTb6UvBD/KF3EHQebjBVy','User Four','1998-04-05 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:18.680','2025-12-08 17:14:18.680'),(268,'test005@example.com','$2a$04$GZyfTmZI4k7L1CbJZRH0feDzueBPaXTkfmdvStQDVarcyjj/tGvyC','User Five','1991-05-25 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:19.691','2025-12-08 17:14:19.691'),(269,'test006@example.com','$2a$04$9SLvUzrWTSIdYObLyVxQD.UjokK.6/cR9kmcAa5QMZVX0yO5HLYx6','User Six','1989-06-30 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:20.713','2025-12-08 17:14:20.713'),(270,'test007@example.com','$2a$04$hH2gSYsNO1bl9LVxYVsMoeU9zi.3oNccY1lb1w6agbSs9MwPWwKPO','User Seven','1996-07-01 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:21.730','2025-12-08 17:14:21.730'),(271,'test008@example.com','$2a$04$y9h1YqVaJ211OUiwz0cBbO2gCzMzzS0l2hw6Jyb8IHOa9I0CZ6iMu','User Eight','1994-08-12 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:22.740','2025-12-08 17:14:22.740'),(272,'test009@example.com','$2a$04$EVbUtowRmhoEn9tGyxN72O.DZ2oplOhJfrmIAHHakiwmD8Ee1vdFa','User Nine','1997-09-08 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:23.750','2025-12-08 17:14:23.750'),(273,'test010@example.com','$2a$04$FkmG2ycyk3mvh4.Eq8cTQu6U5yavzSm53843fNj61R9J6WbshLbYu','User Ten','1992-10-18 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:24.762','2025-12-08 17:14:24.762'),(274,'test011@example.com','$2a$04$nOc7ckFp9Dll2NyAnjrD8OapSd8vndIZ2pdzeL9eFyRLHJxYsv/KO','User Eleven','1995-11-03 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:25.771','2025-12-08 17:14:25.771'),(275,'test012@example.com','$2a$04$ZpJ8ax4P2Vl42sxrTVtDfu7Px0swlQY6roQM9Yv3Y2OTm4CfSusMa','User Twelve','1993-12-28 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:26.780','2025-12-08 17:14:26.780'),(276,'test013@example.com','$2a$04$4kCYnuFdthbXDYirmoKarOQhdTtHoHHUhZ9LRhs3cYDynXV1Gtw8a','User Thirteen','1990-01-01 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:27.789','2025-12-08 17:14:27.789'),(277,'test014@example.com','$2a$04$.1az8z30ZjGDfzcfvvMtYek22K2W1myl0IiEi9F6xAE3MwV.CmT46','User Fourteen','1998-02-14 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:28.800','2025-12-08 17:14:28.800'),(278,'test015@example.com','$2a$04$GWZYF2FxbyXKN5QY4.64S.J8QeB8Z.Ioy1BdWY8tASIZyeKErBdlW','User Fifteen','1991-03-09 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:29.810','2025-12-08 17:14:29.810'),(279,'test016@example.com','$2a$04$c5/GG3DqHpHBqJ3Ca8QCWOp.2kZuNZ2OPck..mn7uVoyEAEt4zBdG','User Sixteen','1989-04-22 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:30.823','2025-12-08 17:14:30.823'),(280,'test017@example.com','$2a$04$m6N5pZP/gS9AfliJBdKuWeIoE.MlaU9st0qk8ggrGV2qw3UNDZpcS','User Seventeen','1996-05-17 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:31.840','2025-12-08 17:14:31.840'),(281,'test018@example.com','$2a$04$fK/7WqM4brFTiAG8YEEREO5dzmPhwShKaTlWC8/dunwSFziU.uUwy','User Eighteen','1994-06-25 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:32.860','2025-12-08 17:14:32.860'),(282,'test019@example.com','$2a$04$Cm8CQHvQepY1RfxAYuabjOavfBVgdTwVZwcoZuLjGwmn9Astmv/Zy','User Nineteen','1997-07-07 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:33.880','2025-12-08 17:14:33.880'),(283,'test020@example.com','$2a$04$IyrXQvhtCRqskth/QU0iPusf3W4AK/ECl.J0aKgkDiZpwF3zXa5Ny','User Twenty','1992-08-29 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:34.900','2025-12-08 17:14:34.900'),(284,'test021@example.com','$2a$04$FyQrUfDGABN//fGQutTIR.FMkHJDv.wiVVxba4SfK7AXHBr6VxZ2S','User Twenty One','1995-09-19 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:35.922','2025-12-08 17:14:35.922'),(285,'test022@example.com','$2a$04$.Yy8jm0nTHXCWOUJCgWsUurZCFLYgOH9cMl/OuBTq90QR0vTimCBK','User Twenty Two','1993-10-04 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:36.943','2025-12-08 17:14:36.943'),(286,'test023@example.com','$2a$04$ZZvMKR/bVekX5wczWN4H9utpiNWAeN4Unf6HKSNfVsOq3IIP6wnDi','User Twenty Three','1990-11-21 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:37.960','2025-12-08 17:14:37.960'),(287,'test024@example.com','$2a$04$jshpx9Vc9uRgB78MVJYuI.uI4T4hsYwgRvsvcpYynsolb94sU2/0m','User Twenty Four','1998-12-06 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:38.981','2025-12-08 17:14:38.981'),(288,'test025@example.com','$2a$04$pGhrf.fHHOjdT5h.PG.Fle9wdY4CmvqnmEtUcxAZU42JRXLCKpvFC','User Twenty Five','1991-01-31 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:40.001','2025-12-08 17:14:40.001'),(289,'test026@example.com','$2a$04$ROMPO7Wdp1VtgwxINXzisekxg01jriTyFCBmPC0BtJ8GZcAgv5dgi','User Twenty Six','1989-02-27 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:41.023','2025-12-08 17:14:41.023'),(290,'test027@example.com','$2a$04$8iGojneYzEF4ib4.EyOZN.Ap/1d.7cMHwcM4jaaEae8/W08TrLoV2','User Twenty Seven','1996-03-14 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:42.040','2025-12-08 17:14:42.040'),(291,'test028@example.com','$2a$04$pIeS5DmfRoOR22Ead4EzquCgMi2fB4fBvjPKNv5Qhx8dNNpMIypZi','User Twenty Eight','1994-04-09 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:43.061','2025-12-08 17:14:43.061'),(292,'test029@example.com','$2a$04$OPwNXlsCsZoao6DKseKH5evP8weJDCdlU9qrf6u5piGw/WYxcaslG','User Twenty Nine','1997-05-02 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:44.080','2025-12-08 17:14:44.080'),(293,'test030@example.com','$2a$04$N5hjNNkRHeQ5QaxyYzXxbu.JdDKRBtoRNJwfch4rpUNTq6oCcLKwO','User Thirty','1992-06-16 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:45.101','2025-12-08 17:14:45.101'),(294,'test031@example.com','$2a$04$sITcNxq6GDzrYtlnmS0qfuXk5iVfr31d/s4OsZnD.tpL3RJjxuL4W','User Thirty One','1995-07-28 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:46.121','2025-12-08 17:14:46.121'),(295,'test032@example.com','$2a$04$IT2Dygc9FoQjuNWuSXumOOxCv0wfE4L4fWqJG87ei2VLCD/FFkprG','User Thirty Two','1993-08-01 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:47.140','2025-12-08 17:14:47.140'),(296,'test033@example.com','$2a$04$BkCQ.QraUywi09zdtPCha.VV5fPltoUcoKv99Ysw/fEhNDWZY9rxG','User Thirty Three','1990-09-13 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:48.162','2025-12-08 17:14:48.162'),(297,'test034@example.com','$2a$04$2xK5NO8BxVnQNcgY6fe8U.H.0HR8oWHn2GgamfUT.uJ8UC6nOFDJu','User Thirty Four','1998-10-26 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:49.180','2025-12-08 17:14:49.180'),(298,'test035@example.com','$2a$04$ck8V8Iqx8cNjIEqgpGxiwOYf9el83E1kllhX2AG052CieRdxRL5Ne','User Thirty Five','1991-11-19 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:50.202','2025-12-08 17:14:50.202'),(299,'test036@example.com','$2a$04$BuHBAuNf3qZB1wr6K/9VmOvOLHkc369cKfHWyHGCnh3R.Taaa4jbW','User Thirty Six','1989-12-05 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:51.220','2025-12-08 17:14:51.220'),(300,'test037@example.com','$2a$04$Gtwb.lvmOnlmuqa1hSRYgO3JPxMhhpmlKLi.H2c59cGGC8AEQx6TS','User Thirty Seven','1996-01-24 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:52.242','2025-12-08 17:14:52.242'),(301,'test038@example.com','$2a$04$KYhUbbmcTzRg58epiSRVN.LvMsI30wULsshHjFfL/y5tqBt.05GAq','User Thirty Eight','1994-02-18 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:53.260','2025-12-08 17:14:53.260'),(302,'test039@example.com','$2a$04$ex5BD1gR91r0SvJuFnO09OUEE.MtpvBO0IAulvy3FlMYDisupTVHi','User Thirty Nine','1997-03-29 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:54.281','2025-12-08 17:14:54.281'),(303,'test040@example.com','$2a$04$NfJD9c1WUnGIcZXPFZgEKuHioD.JPEM4ldRMntk7ugvZGsfxnAhTK','User Forty','1992-04-04 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:55.300','2025-12-08 17:14:55.300'),(304,'test041@example.com','$2a$04$uPmNs5xFcICYegC6jlF5g.tIR0Mj45YoTmGWJlUtUhkzu4/MANYJy','User Forty One','1995-05-10 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:56.323','2025-12-08 17:14:56.323'),(305,'test042@example.com','$2a$04$TUs2IZ.fYEymbMx/5E3iEueFn1zM0Jr6d/JtylKeQ5mr59WFw/VIC','User Forty Two','1993-06-03 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:57.340','2025-12-08 17:14:57.340'),(306,'test043@example.com','$2a$04$6/RVz0uEiUQN/4r4h7YoQOcMy13chzq/mzCbY8MKdt.aJ2Kpbyi1G','User Forty Three','1990-07-27 07:00:00.000','male',NULL,NULL,'2025-12-08 17:14:58.360','2025-12-08 17:14:58.360'),(307,'test044@example.com','$2a$04$pwOFbbEGQKaiyyevHvRgV.D4ho6sHE.0nlTd21NPjW1qAbJv7XNqu','User Forty Four','1998-08-20 07:00:00.000','female',NULL,NULL,'2025-12-08 17:14:59.380','2025-12-08 17:14:59.380'),(308,'test045@example.com','$2a$04$6fv1QEG39r0f3mwkq/YaGeK6.GxDfhEPYatlZyV.Oyi6b/QH48uHy','User Forty Five','1991-09-11 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:00.402','2025-12-08 17:15:00.402'),(309,'test046@example.com','$2a$04$SaW9F.ZS3wjsIViEasKf0efmBBQLJWZanL76TltBgCpzWlqcqlCNO','User Forty Six','1989-10-07 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:01.420','2025-12-08 17:15:01.420'),(310,'test047@example.com','$2a$04$/g3Da0wz/SDNLtF8yZmgHeWJlP9OpS1RpWYk1i5g83x4s2Qm9GTQS','User Forty Seven','1996-11-30 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:02.441','2025-12-08 17:15:02.441'),(311,'test048@example.com','$2a$04$tao1CZJhrFqU42KXhcS.b.igAkAerdfaehqUTCSCPolY01tdHpgKW','User Forty Eight','1994-12-15 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:03.460','2025-12-08 17:15:03.460'),(312,'test049@example.com','$2a$04$VSalPh2feVduOPP6BEm5Du3wUMJijwrCIP67zEakvxt6/PbVOmcYq','User Forty Nine','1997-01-05 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:04.480','2025-12-08 17:15:04.480'),(313,'test050@example.com','$2a$04$1V4u.wIhCR4.7B7g79LU1OfDJ.49tKHqti5HhD5pd8bKoY4oHP0MO','User Fifty','1992-02-09 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:05.501','2025-12-08 17:15:05.501'),(314,'test051@example.com','$2a$04$BGp2PrMP0iZqIrWc3NIgTuIdDR3h7PwZs9TAe5Dxah9AkuI80BWfa','User Fifty One','1995-03-24 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:06.522','2025-12-08 17:15:06.522'),(315,'test052@example.com','$2a$04$PQYUBlAG4cKjvYMA93l.4..e92obcj5P9F91JPtjgP4A0kh0ItB6i','User Fifty Two','1993-04-19 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:07.539','2025-12-08 17:15:07.539'),(316,'test053@example.com','$2a$04$gW17K6clrEW5yFDgQ.kL6eJqD5jGOWhHPqAUNfe8az2dOBQiA/nrm','User Fifty Three','1990-05-14 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:08.562','2025-12-08 17:15:08.562'),(317,'test054@example.com','$2a$04$xwlP4i5lDDZQgrXVDcpwt.xbTPA21a0rReXuxJlwXanIHwuxDx/eS','User Fifty Four','1998-06-27 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:09.580','2025-12-08 17:15:09.580'),(318,'test055@example.com','$2a$04$Lfk/x6nxxa0qVVKuCaAd9.21EMyjk3vb6/opk4AjN9f7wgDCwDKvm','User Fifty Five','1991-07-22 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:10.601','2025-12-08 17:15:10.601'),(319,'test056@example.com','$2a$04$BNv3yign/qaIvY85X7gvHuDk20BgIXNGrLYbuz0cKo827t9mnDWE.','User Fifty Six','1989-08-16 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:11.621','2025-12-08 17:15:11.621'),(320,'test057@example.com','$2a$04$6gk0VY2SyCTTjZdJZYlw1.HSokRr1EOdnkEpXeCsncGqtqQ/KvI1.','User Fifty Seven','1996-09-06 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:12.639','2025-12-08 17:15:12.639'),(321,'test058@example.com','$2a$04$o2/EM5sm2/zslgesEgi5Au/RQEioNrm4.H3OJG4i4tna283F5hPm2','User Fifty Eight','1994-10-11 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:13.661','2025-12-08 17:15:13.661'),(322,'test059@example.com','$2a$04$zwzihql0RYFqt94wLK2D7.ZD6Ea9LkAtBLnORpg7Ddj2gqwc94MR6','User Fifty Nine','1997-11-26 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:14.680','2025-12-08 17:15:14.680'),(323,'test060@example.com','$2a$04$FpLdiqfPv.pGqv6hmEYwUucL2n2xPHcr/C42UO9XoSV5cSx58Pz8e','User Sixty','1992-12-08 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:15.701','2025-12-08 17:15:15.701'),(324,'test061@example.com','$2a$04$PUlLXXleixbycfbveacWpOBCKlDeHODDHislDXKhH4oqfJlcpFI22','User Sixty One','1995-01-03 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:16.719','2025-12-08 17:15:16.719'),(325,'test062@example.com','$2a$04$34X4N4l0MkcxNK4bDUvM/u.WZUo/XXePw893SLOVTpMoSLpQnzb.u','User Sixty Two','1993-02-07 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:17.739','2025-12-08 17:15:17.739'),(326,'test063@example.com','$2a$04$mhm/yMn17EWJ2ZZ/AMh.kuz4sl1djkLvZC89kcmBta3yDNbPM4hjW','User Sixty Three','1990-03-20 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:18.762','2025-12-08 17:15:18.762'),(327,'test064@example.com','$2a$04$Yq45aQyZFs7xyZU34RYuOevFgfnD3k7zDJbReiBq/q98pANTXoNmu','User Sixty Four','1998-04-14 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:19.780','2025-12-08 17:15:19.780'),(328,'test065@example.com','$2a$04$DkScW2N9.z5f4KfrCRqCLOm/xEv2oIl6NxKWA1INFKIURc9dTZxVe','User Sixty Five','1991-05-09 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:20.800','2025-12-08 17:15:20.800'),(329,'test066@example.com','$2a$04$SsKwgXd6vBvaAI/X5P9PY.xmrW5.oWhmWZpMpGkTkElGjqIqMnhQe','User Sixty Six','1989-06-24 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:21.823','2025-12-08 17:15:21.823'),(330,'test067@example.com','$2a$04$qXNM02Oi6ZJIl/r9gWzuXO6pi28VgC68MpDdw5byEYS2t3.bAxeDW','User Sixty Seven','1996-07-19 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:22.841','2025-12-08 17:15:22.841'),(331,'test068@example.com','$2a$04$7PRv4uj8StDM/LrvkKpafeU3m2YgNASfofrvdmQJsBufjC0f7DE6y','User Sixty Eight','1994-08-25 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:23.859','2025-12-08 17:15:23.859'),(332,'test069@example.com','$2a$04$JaFWjPT0wqgugB3hNekDtOJrrXwxn0pSfr7uCKMNFzsnZWN6BCr3q','User Sixty Nine','1997-09-16 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:24.881','2025-12-08 17:15:24.881'),(333,'test070@example.com','$2a$04$y3KTii9pf3ACHdGlw8b7aOI.7p1TyJQjzk.Mu.7zlw1k1VdovbLv6','User Seventy','1992-10-02 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:25.902','2025-12-08 17:15:25.902'),(334,'test071@example.com','$2a$04$UJ7EW88J/wJRn4fIJi6Wg.HA7KvjhRl2cJcVLwcqrdAZb.NxsKqsW','User Seventy One','1995-11-21 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:26.922','2025-12-08 17:15:26.922'),(335,'test072@example.com','$2a$04$EV/SZzKbBoOKYsA5EJqjJ.sebtt9xU6XsjZK4zIzJjgldF9/NCg36','User Seventy Two','1993-12-16 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:27.941','2025-12-08 17:15:27.941'),(336,'test073@example.com','$2a$04$yfOcGiJI4w6jL6slOPhJNOu3SUB/IZXtzZLPf7g0LmxrBQrVx2ZCO','User Seventy Three','1990-01-11 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:28.959','2025-12-08 17:15:28.959'),(337,'test074@example.com','$2a$04$eLKWfhlHq77QpHw02RiZtOhgFaNzXPSTQNnxOQ5QqrGpec.KCncfS','User Seventy Four','1998-02-05 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:29.980','2025-12-08 17:15:29.980'),(338,'test075@example.com','$2a$04$LxVekF2bo/hX1p2eJ3Bx8OGc7z/rzxBp67Lfyda5q2BMbbpUr5p9.','User Seventy Five','1991-03-01 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:31.001','2025-12-08 17:15:31.001'),(339,'test076@example.com','$2a$04$rr.mluvE.6CBLwhtsVtkg.eW.PQC7o0H6rixE1QcdF82lXhpk6vum','User Seventy Six','1989-04-15 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:32.023','2025-12-08 17:15:32.023'),(340,'test077@example.com','$2a$04$ODGnmTwzRmkvAW43tSPZu.UMCES67wmHHpo/LgiNC.qi/TJlY3oT6','User Seventy Seven','1996-05-29 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:33.039','2025-12-08 17:15:33.039'),(341,'test078@example.com','$2a$04$Iy19y5LpOpOC546hLW7lYuxL/h49vsBatQ8FC.dw5ZWkhp9mJMWIa','User Seventy Eight','1994-06-23 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:34.061','2025-12-08 17:15:34.061'),(342,'test079@example.com','$2a$04$frAeysQMw/Ern7gt10TL6eU.73YPhaUybiR4B4SHVzzmzAByzkOlC','User Seventy Nine','1997-07-18 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:35.080','2025-12-08 17:15:35.080'),(343,'test080@example.com','$2a$04$R9hdSg4BTJ2aLQ5jrduSPeYrW3QURqnIrLuTfq767zdVsXDcjdkTG','User Eighty','1992-08-03 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:36.100','2025-12-08 17:15:36.100'),(344,'test081@example.com','$2a$04$QseP3s6FepYNV/CvWOtsBegbs6bdI9rgFORg3AKJlUJEvvX8T54yy','User Eighty One','1995-09-27 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:37.122','2025-12-08 17:15:37.122'),(345,'test082@example.com','$2a$04$iDc0cJvtw6qLqoczY4A8C.KD9FbHU/d47bQvJfPiQ2u4oGAKRTwCm','User Eighty Two','1993-10-22 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:38.140','2025-12-08 17:15:38.140'),(346,'test083@example.com','$2a$04$XylA5GqwOKNK3E77FgEoAeVpjBEwmGuqzvZ/toEJ4FwBiFbXZA5RG','User Eighty Three','1990-11-16 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:39.163','2025-12-08 17:15:39.163'),(347,'test084@example.com','$2a$04$mMHZ23fhfLAeNXTXGmpdVeUMb7YPcsbzyLIqGhNWVsuaHel8YuSV.','User Eighty Four','1998-12-01 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:40.179','2025-12-08 17:15:40.179'),(348,'test085@example.com','$2a$04$PIKe8spo28BML0RGxpN7petCz/s6nO7miSJ2SpphQWV7PxnpSPjdu','User Eighty Five','1991-01-26 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:41.201','2025-12-08 17:15:41.201'),(349,'test086@example.com','$2a$04$p4VlhQx.IuufVQAgj0/icu7AY5sZjq1cNTI1eqA7NLPb98pcgMN1C','User Eighty Six','1989-02-21 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:42.222','2025-12-08 17:15:42.222'),(350,'test087@example.com','$2a$04$2sS.wGXckI8EZ6ofh.og5ue0qzKfLT4/oFpt6RciswWgz7Pyc81SS','User Eighty Seven','1996-03-17 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:43.240','2025-12-08 17:15:43.240'),(351,'test088@example.com','$2a$04$/0tJbpLGLyUKkRK8l850KuPpeolohNIyGJyaUwR2nBmiQkSIr2nbu','User Eighty Eight','1994-04-12 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:44.262','2025-12-08 17:15:44.262'),(352,'test089@example.com','$2a$04$T/V02WBOVzn/bez.KF.L7Or.YuNWjT9Ydq7SkyV8iUmoTztZ86on2','User Eighty Nine','1997-05-07 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:45.282','2025-12-08 17:15:45.282'),(353,'test090@example.com','$2a$04$7v8ml.Byl0N9c.cp6bhJAO4qFkwLfk442c2BUooOibRefHNdDdzFi','User Ninety','1992-06-02 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:46.301','2025-12-08 17:15:46.301'),(354,'test091@example.com','$2a$04$p6A5KfPUSWErCtO8boj3TeH0o7AdrxhWE4Hie7uz/I4GQ.ggjvqry','User Ninety One','1995-07-17 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:47.320','2025-12-08 17:15:47.320'),(355,'test092@example.com','$2a$04$E8xM3jy3W2RbPbgIEQUdc.hzNiIzmulxrNFa2nj9z2JaE9FOQmD2S','User Ninety Two','1993-08-23 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:48.340','2025-12-08 17:15:48.340'),(356,'test093@example.com','$2a$04$bdRKW4eqnlAkCMnGEV2gRurRwakBkwL8kVUPPbAwCPpvO7EcmsHM2','User Ninety Three','1990-09-08 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:49.360','2025-12-08 17:15:49.360'),(357,'test094@example.com','$2a$04$uKtjmd.V0yhnIMp4Pa.QiuGXS8eQU76V2TkUHvALAFF7JfmnUGJu2','User Ninety Four','1998-10-21 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:50.379','2025-12-08 17:15:50.379'),(358,'test095@example.com','$2a$04$NwKk3L.5i6MnEWAXj/VNZ.TAvcV101M2r9KAHurtKsfbd4CJKxE6a','User Ninety Five','1991-11-15 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:51.403','2025-12-08 17:15:51.403'),(359,'test096@example.com','$2a$04$4N45gzlieiDJxMJdYJo/Memwdh4YfF.LWLrt4yBOyd5hE9KY5LqaG','User Ninety Six','1989-12-09 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:52.420','2025-12-08 17:15:52.420'),(360,'test097@example.com','$2a$04$k3fPugTeQWqltKt5JvhLJuuC2maV52qUO9rZC4LvXXjF/aZI1abj2','User Ninety Seven','1996-01-04 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:53.442','2025-12-08 17:15:53.442'),(361,'test098@example.com','$2a$04$Jb.//sU/Gw421o5vcI8AxOX7pdPGtDUHLkAXxfxU3oUyT0HTPyCeO','User Ninety Eight','1994-02-28 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:54.460','2025-12-08 17:15:54.460'),(362,'test099@example.com','$2a$04$u1nm97HfDa2moYS78Z3bfuv/0mzYqOtCBl3Cuvc5cWAaoAeN/kDye','User Ninety Nine','1997-03-24 07:00:00.000','male',NULL,NULL,'2025-12-08 17:15:55.480','2025-12-08 17:15:55.480'),(363,'test100@example.com','$2a$04$t7mYNQ6rOTlu.Ol/OKkMJOeb2mZKWOW3K0aXB8drwsU8GmeVW.ABa','User One Hundred','1992-04-08 07:00:00.000','female',NULL,NULL,'2025-12-08 17:15:56.500','2025-12-08 17:15:56.500'),(364,'jaccob.doe@example.coms','$2a$04$.C3wez7q5UKwePE06zH6ieV4HR2rVSGrnn60coCIcxZ/x3uMHZFem','Jaccob Doe','1992-08-20 07:00:00.000','male',NULL,NULL,'2025-12-08 17:20:39.865','2025-12-08 17:20:39.865');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-16 10:01:51
