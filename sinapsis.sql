-- --------------------------------------------------------
-- Host:                         localhost
-- Versión del servidor:         8.4.3 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para sinapsis
CREATE DATABASE IF NOT EXISTS `sinapsis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sinapsis`;

-- Volcando estructura para tabla sinapsis.campaigns
CREATE TABLE IF NOT EXISTS `campaigns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `process_date` date NOT NULL,
  `process_hour` time NOT NULL,
  `total_records` int NOT NULL DEFAULT '0',
  `total_sent` int NOT NULL DEFAULT '0',
  `total_error` int NOT NULL DEFAULT '0',
  `process_status` int NOT NULL DEFAULT '1',
  `final_hour` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `campaigns_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sinapsis.campaigns: ~5 rows (aproximadamente)
INSERT INTO `campaigns` (`id`, `user_id`, `name`, `process_date`, `process_hour`, `total_records`, `total_sent`, `total_error`, `process_status`, `final_hour`) VALUES
	(1, 1, 'Promo Tarjeta Enero', '2024-01-15', '09:00:00', 6, 4, 2, 2, '09:03:45'),
	(2, 2, 'Recordatorio Pago', '2024-02-10', '10:30:00', 5, 2, 1, 1, NULL),
	(3, 3, 'Descuento Vitaminas', '2024-03-05', '08:00:00', 0, 0, 0, 1, NULL),
	(4, 3, 'Campaña Fin de Año', '2023-12-20', '16:00:00', 0, 0, 0, 1, NULL),
	(5, 5, 'Campaña Borrada', '2024-04-01', '11:00:00', 0, 0, 0, 1, NULL);

-- Volcando estructura para tabla sinapsis.customers
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sinapsis.customers: ~4 rows (aproximadamente)
INSERT INTO `customers` (`id`, `name`, `deleted`) VALUES
	(1, 'Banco Andino', 0),
	(2, 'Farmacias Vida', 0),
	(3, 'Retail Express', 0),
	(4, 'Cliente Eliminado', 1);

-- Volcando estructura para tabla sinapsis.messages
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `campaign_id` int NOT NULL,
  `phone` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `text` varchar(160) COLLATE utf8mb4_general_ci NOT NULL,
  `shipping_status` tinyint NOT NULL DEFAULT '1',
  `shipping_hour` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_campaign_status` (`campaign_id`,`shipping_status`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sinapsis.messages: ~20 rows (aproximadamente)
INSERT INTO `messages` (`id`, `campaign_id`, `phone`, `text`, `shipping_status`, `shipping_hour`) VALUES
	(1, 1, '987654321', 'Banco Andino: 0% de interés este mes.', 2, '09:01:10'),
	(2, 1, '987654322', 'Banco Andino: 0% de interés este mes.', 2, '09:01:15'),
	(3, 1, '987654323', 'Banco Andino: 0% de interés este mes.', 3, '09:01:20'),
	(4, 1, '987654324', 'Banco Andino: 0% de interés este mes.', 2, '09:02:05'),
	(5, 1, '987654325', 'Banco Andino: 0% de interés este mes.', 3, '09:02:30'),
	(6, 1, '987654326', 'Banco Andino: 0% de interés este mes.', 2, '09:03:45'),
	(7, 2, '912345678', 'Banco Andino: paga tu cuota antes del 15.', 2, '10:31:00'),
	(8, 2, '912345679', 'Banco Andino: paga tu cuota antes del 15.', 2, '10:31:12'),
	(9, 2, '912345680', 'Banco Andino: paga tu cuota antes del 15.', 3, '10:31:40'),
	(10, 2, '912345681', 'Banco Andino: paga tu cuota antes del 15.', 1, NULL),
	(11, 2, '912345682', 'Banco Andino: paga tu cuota antes del 15.', 1, NULL),
	(12, 3, '955111222', 'Farmacias Vida: 20% dscto en vitaminas.', 2, '08:00:30'),
	(13, 3, '955111223', 'Farmacias Vida: 20% dscto en vitaminas.', 2, '08:00:45'),
	(14, 3, '955111224', 'Farmacias Vida: 20% dscto en vitaminas.', 2, '08:01:00'),
	(15, 3, '955111225', 'Farmacias Vida: 20% dscto en vitaminas.', 2, '08:01:20'),
	(16, 4, '955333444', 'Farmacias Vida: 2x1 en cuidado personal.', 2, '16:00:10'),
	(17, 4, '955333445', 'Farmacias Vida: 2x1 en cuidado personal.', 2, '16:00:25'),
	(18, 4, '955333446', 'Farmacias Vida: 2x1 en cuidado personal.', 3, '16:00:40'),
	(19, 5, '900000001', 'Mensaje de prueba.', 2, '11:00:05'),
	(20, 5, '900000002', 'Mensaje de prueba.', 2, '11:00:10');

-- Volcando estructura para tabla sinapsis.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sinapsis.users: ~5 rows (aproximadamente)
INSERT INTO `users` (`id`, `customer_id`, `username`, `deleted`) VALUES
	(1, 1, 'jperez', 0),
	(2, 1, 'mlopez', 0),
	(3, 2, 'acastro', 0),
	(4, 3, 'rvargas', 0),
	(5, 4, 'xborrado', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
