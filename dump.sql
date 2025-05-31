-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: back_in_stock
-- ------------------------------------------------------
-- Server version	8.0.28

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
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `purchase_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,2,3,'Running Shoes',79.99,'https://images.unsplash.com/photo-1542291026-7eec264c27ff','2025-05-30 05:06:59');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `sizes` text NOT NULL,
  `colors` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `in_stock` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Classic T-Shirt','Soft cotton T-shirt perfect for everyday wear.',19.99,'[\"S\", \"M\", \"L\", \"XL\"]','[\"Red\", \"Blue\", \"Black\"]','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',0),(2,'Slim Fit Jeans','Comfortable denim jeans with a modern slim fit.',49.99,'[\"30\", \"32\", \"34\"]','[\"Blue\", \"Black\"]','https://images.unsplash.com/photo-1542272604-787c3835535d',1),(3,'Running Shoes','Lightweight sneakers for running and casual use.',79.99,'[\"8\", \"9\", \"10\", \"11\"]','[\"White\", \"Black\", \"Grey\"]','https://images.unsplash.com/photo-1542291026-7eec264c27ff',1),(4,'Leather Jacket','Premium leather jacket for a stylish look.',129.99,'[\"M\", \"L\", \"XL\"]','[\"Brown\", \"Black\"]','https://www.harley-davidson.com/content/dam/h-d/images/product-images/merchandise/2023/97023-23ac/97023-23AC_F.jpg',1),(5,'Casual Backpack','Durable backpack for daily use.',39.99,'[\"One Size\"]','[\"Black\", \"Green\"]','https://images.unsplash.com/photo-1553062407-98eeb64c6a62',1),(6,'Sunglasses','Stylish polarized sunglasses.',29.99,'[\"One Size\"]','[\"Black\", \"Brown\"]','https://images.unsplash.com/photo-1572635196237-14b3f281503f',1),(7,'Winter Gloves','Insulated gloves for cold weather',24.99,'[\"S\", \"M\", \"L\"]','[\"Black\", \"Grey\", \"Blue\"]','https://tse1.mm.bing.net/th?id=OIP.kAlrPWMExWlne4RXKlpYzAHaHa&pid=Api',1),(8,'Laptop','High-performance laptop with SSD',999.99,'[\"One Size\"]','[\"Silver\", \"Black\"]','https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6273/6273508_sd.jpg',0),(9,'Sneaker Set','Casual sneakers for everyday wear',79.99,'[\"7\", \"8\", \"9\", \"10\"]','[\"White\", \"Black\", \"Grey\"]','https://cdn.cliqueinc.com/posts/303292/best-winter-sneakers-303292-1666885027482-main.700x0c.jpg',1),(10,'Wool Coat','Elegant wool coat for winter',149.99,'[\"S\", \"M\", \"L\"]','[\"Black\", \"Navy\", \"Camel\"]','https://i.pinimg.com/736x/db/80/0d/db800da7c496c6c28a1dae65aff15e6d.jpg',0),(11,'Smartphone','Latest 5G smartphone with OLED display',699.99,'[\"One Size\"]','[\"Black\", \"Blue\", \"White\"]','https://tse3.mm.bing.net/th?id=OIP.pCWe0XlmUQD9WORY4jsW8AHaGs&pid=Api',1),(12,'Earrings','Gold hoop earrings',39.99,'[\"One Size\"]','[\"Gold\", \"Silver\"]','https://tse2.mm.bing.net/th?id=OIP.ktClI_0e7vVHxe0q2qVgcAHaHL&pid=Api',1),(13,'Yoga Pants','Stretchy yoga pants for workouts',34.99,'[\"XS\", \"S\", \"M\", \"L\"]','[\"Black\", \"Navy\", \"Grey\"]','https://tse1.mm.bing.net/th?id=OIP.m6KLUjO_DCvMSUiqArTY9gHaKq&pid=Api',0),(14,'Desk Lamp','LED desk lamp with adjustable brightness',29.99,'[\"One Size\"]','[\"White\", \"Black\"]','https://tse1.mm.bing.net/th?id=OIP.QFmOK0QOW3_rZeYTrb63KAHaHa&pid=Api',1),(15,'Sweatshirt','Comfy crewneck sweatshirt',44.99,'[\"S\", \"M\", \"L\", \"XL\"]','[\"Red\", \"Blue\", \"Grey\"]','https://tse3.mm.bing.net/th?id=OIP.VAjPfSPXUHG4UDiJIOO3UgHaEV&pid=Api',1),(16,'Fitness Band','Water-resistant fitness tracker',49.99,'[\"One Size\"]','[\"Black\", \"Blue\", \"Pink\"]','https://tse4.mm.bing.net/th?id=OIP.cytEk-DhSldjt1F5jvBdLAHaJI&pid=Api',0),(17,'Leather Jacket','Premium leather biker jacket',199.99,'[\"M\", \"L\", \"XL\"]','[\"Black\", \"Brown\"]','https://tse4.mm.bing.net/th?id=OIP.gHMSHoXLq-QuLXv4fPQg-AHaLH&pid=Api',1),(18,'Umbrella','Compact travel umbrella',19.99,'[\"One Size\"]','[\"Black\", \"Navy\", \"Red\"]','https://tse1.mm.bing.net/th?id=OIP.83w2BlXqfKmyYUr3RCh7uwHaH8&pid=Api',1),(19,'Gaming Keyboard','Mechanical keyboard with RGB lighting',89.99,'[\"One Size\"]','[\"Black\", \"White\"]','https://tse4.mm.bing.net/th?id=OIP.AmcpaLzsjSNQZJkvFhizLQHaEK&pid=Api',0),(20,'Blouse','Silk blouse for formal events',59.99,'[\"S\", \"M\", \"L\"]','[\"White\", \"Black\", \"Blue\"]','https://tse3.mm.bing.net/th?id=OIP.KJkzsld6xf4W7T4cdy6gzAHaHL&pid=Api',1),(21,'Wallet','Slim leather wallet',34.99,'[\"One Size\"]','[\"Black\", \"Brown\"]','https://tse4.mm.bing.net/th?id=OIP.I5h7vjwpmCTRPwlLSEpYDgHaHa&pid=Api',1),(22,'Smart Speaker','Voice-activated smart speaker',99.99,'[\"One Size\"]','[\"Black\", \"White\"]','https://tse1.mm.bing.net/th?id=OIP.C75gw_czaPYJW-8SHJeH6AHaG0&pid=Api',0),(23,'Jeans','Slim-fit denim jeans',49.99,'[\"30\", \"32\", \"34\"]','[\"Blue\", \"Black\"]','https://tse4.mm.bing.net/th?id=OIF.8E7Al8FvdsejSjU3jNmFGg&pid=Api',1),(24,'Bracelet','Silver charm bracelet',44.99,'[\"One Size\"]','[\"Silver\", \"Gold\"]','https://tse4.mm.bing.net/th?id=OIP.eddWwD7slgVl5puQ8wZv0gHaHa&pid=Api',1),(25,'Camera','Mirrorless camera with lens',499.99,'[\"One Size\"]','[\"Black\", \"Silver\"]','https://tse2.mm.bing.net/th?id=OIP.Ls1TR9V-nTil5lZwZRB7fwHaHa&pid=Api',0),(26,'Hiking Boots','Waterproof boots for outdoor adventures',119.99,'[\"7\", \"8\", \"9\", \"10\"]','[\"Brown\", \"Black\"]','https://tse1.mm.bing.net/th?id=OIP.IKwc0ELddgJdn0xSt15RVgHaE8&pid=Api',1),(27,'Sweater','Knit sweater for cool weather',54.99,'[\"S\", \"M\", \"L\"]','[\"Green\", \"Grey\", \"Navy\"]','https://tse3.mm.bing.net/th?id=OIP.at2zt01zrEuziuw3ua1hCQHaJ4&pid=Api',1),(28,'Mouse Pad','Ergonomic mouse pad with wrist support',14.99,'[\"One Size\"]','[\"Black\", \"Blue\"]','https://tse2.mm.bing.net/th?id=OIP.D2cDe41nMtBEwFQn4N3PtgHaGX&pid=Api',0),(29,'Dress','Elegant evening dress',79.99,'[\"S\", \"M\", \"L\"]','[\"Black\", \"Red\", \"Blue\"]','https://tse2.mm.bing.net/th?id=OIP.LePNjyDh0-3nNYmniKBRSAHaLH&pid=Api',1),(30,'Power Bank','10000mAh portable charger',29.99,'[\"One Size\"]','[\"Black\", \"White\"]','https://tse4.mm.bing.net/th?id=OIP.naz88r-GEqGT7Ysc9AShpQHaFd&pid=Api',1),(31,'Skirt','A-line midi skirt',39.99,'[\"S\", \"M\", \"L\"]','[\"Black\", \"Navy\", \"Beige\"]','https://tse3.mm.bing.net/th?id=OIP.p3Tb666_SvMJKpAGq5i-YgHaFj&pid=Api',0),(32,'Smart TV','4K UHD smart television',399.99,'[\"One Size\"]','[\"Black\"]','https://tse4.mm.bing.net/th?id=OIP.2sKd934t5if8UCarPx4WBwHaHQ&pid=Api',1),(33,'Socks','Pack of 5 cotton socks',12.99,'[\"One Size\"]','[\"Black\", \"White\", \"Grey\"]','https://tse3.mm.bing.net/th?id=OIP.zHoWHA2MpFxhI_FK9wVHTgHaI4&pid=Api',1),(34,'Monitor','27-inch LED monitor',199.99,'[\"One Size\"]','[\"Black\", \"Silver\"]','https://tse1.mm.bing.net/th?id=OIP.yspjUMXB-f_q0l8kRt5I9AHaE8&pid=Api',0),(35,'T-shirt','Graphic print t-shirt',19.99,'[\"S\", \"M\", \"L\", \"XL\"]','[\"White\", \"Black\", \"Blue\"]','https://tse3.mm.bing.net/th?id=OIP.KcQvqpWN9oEoatSRsOmhTAHaFF&pid=Api',1),(36,'Handbag','Designer leather handbag',129.99,'[\"One Size\"]','[\"Black\", \"Brown\", \"Red\"]','https://tse2.mm.bing.net/th?id=OIP.tbeC8i1RSVRKScorFm8-MQHaHa&pid=Api',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `size` varchar(50) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `purchase_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchases`
--

LOCK TABLES `purchases` WRITE;
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
INSERT INTO `purchases` VALUES (1,2,6,'','',29.99,'2025-05-29 12:10:51'),(2,2,6,'One Size','Black',29.99,'2025-05-29 12:11:29');
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `size` varchar(50) NOT NULL,
  `color` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `subscriptions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@example.com','admin123','admin'),(2,'user@example.com','user123','user'),(3,'ssss@1','$2b$12$jrKpRrK32/rq1t0qFcPweeb6eAm3UUhYhFJrX/JXKAXmfPKLvpCRG','user'),(4,'ratna@123','ratna','user');
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

-- Dump completed on 2025-05-31 21:09:53
