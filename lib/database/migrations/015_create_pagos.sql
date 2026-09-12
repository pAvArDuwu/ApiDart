CREATE TABLE IF NOT EXISTS `pagos` (
  `id`             INT           NOT NULL AUTO_INCREMENT,
  `venta_id`       INT           NOT NULL,
  `metodo_pago_id` INT           NOT NULL,
  `monto`          DECIMAL(10,2) NOT NULL,
  `fecha`          TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `referencia`     VARCHAR(100)  DEFAULT NULL,
  `created_at`     TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`     TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `venta_id` (`venta_id`),
  KEY `metodo_pago_id` (`metodo_pago_id`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`venta_id`)       REFERENCES `ventas`       (`id`) ON DELETE CASCADE,
  CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`metodo_pago_id`) REFERENCES `metodos_pago` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
