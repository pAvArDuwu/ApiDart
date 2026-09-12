CREATE TABLE IF NOT EXISTS `detalle_compra` (
  `id`              INT           NOT NULL AUTO_INCREMENT,
  `compra_id`       INT           NOT NULL,
  `producto_id`     INT           NOT NULL,
  `cantidad`        DECIMAL(10,2) NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `subtotal`        DECIMAL(10,2) NOT NULL,
  `created_at`      TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `compra_id` (`compra_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `detalle_compra_ibfk_1` FOREIGN KEY (`compra_id`)   REFERENCES `compras`   (`id`) ON DELETE CASCADE,
  CONSTRAINT `detalle_compra_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
