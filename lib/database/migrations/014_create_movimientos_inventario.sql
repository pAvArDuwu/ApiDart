CREATE TABLE IF NOT EXISTS `movimientos_inventario` (
  `id`                INT           NOT NULL AUTO_INCREMENT,
  `producto_id`       INT           NOT NULL,
  `tipo_movimiento_id` INT          NOT NULL,
  `cantidad`          DECIMAL(10,2) NOT NULL,
  `referencia`        VARCHAR(100)  DEFAULT NULL,
  `fecha`             TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `producto_id` (`producto_id`),
  KEY `tipo_movimiento_id` (`tipo_movimiento_id`),
  CONSTRAINT `movimientos_inventario_ibfk_1` FOREIGN KEY (`producto_id`)        REFERENCES `productos`        (`id`),
  CONSTRAINT `movimientos_inventario_ibfk_2` FOREIGN KEY (`tipo_movimiento_id`) REFERENCES `tipos_movimiento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
