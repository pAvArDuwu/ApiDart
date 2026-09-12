CREATE TABLE IF NOT EXISTS `compras` (
  `id`               INT           NOT NULL AUTO_INCREMENT,
  `proveedor_id`     INT           NOT NULL,
  `estado_compra_id` INT           NOT NULL,
  `fecha`            TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `total`            DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `created_at`       TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `proveedor_id` (`proveedor_id`),
  KEY `estado_compra_id` (`estado_compra_id`),
  CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`),
  CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`estado_compra_id`) REFERENCES `estados_compra` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
