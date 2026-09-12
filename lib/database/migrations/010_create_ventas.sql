CREATE TABLE IF NOT EXISTS `ventas` (
  `id`              INT            NOT NULL AUTO_INCREMENT,
  `cliente_id`      INT            NOT NULL,
  `estado_venta_id` INT            NOT NULL DEFAULT 1,
  `fecha`           TIMESTAMP      NULL     DEFAULT CURRENT_TIMESTAMP,
  `total`           DECIMAL(10,2)  NOT NULL DEFAULT '0.00',
  `created_at`      TIMESTAMP      NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      TIMESTAMP      NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_ventas_clientes` (`cliente_id`),
  KEY `fk_ventas_estado_venta` (`estado_venta_id`),
  CONSTRAINT `fk_ventas_clientes` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `fk_ventas_estado_venta` FOREIGN KEY (`estado_venta_id`) REFERENCES `estados_venta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

