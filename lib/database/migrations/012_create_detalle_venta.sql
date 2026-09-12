CREATE TABLE IF NOT EXISTS `detalle_venta` (
  `id`              INT           NOT NULL AUTO_INCREMENT,
  `venta_id`        INT           NOT NULL,
  `producto_id`     INT           NOT NULL,
  `cantidad`        INT           NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `subtotal`        DECIMAL(10,2) NOT NULL,
  `created_at`      TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_detalle_venta_venta` (`venta_id`),
  KEY `fk_detalle_venta_producto` (`producto_id`),
  CONSTRAINT `fk_detalle_venta_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  CONSTRAINT `fk_detalle_venta_venta`    FOREIGN KEY (`venta_id`)    REFERENCES `ventas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
