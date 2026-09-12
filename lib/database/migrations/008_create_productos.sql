CREATE TABLE IF NOT EXISTS `productos` (
  `id`               INT           NOT NULL AUTO_INCREMENT,
  `categoria_id`     INT           NOT NULL,
  `unidad_medida_id` INT           NOT NULL,
  `nombre`           VARCHAR(100)  NOT NULL,
  `precio`           DECIMAL(10,2) NOT NULL,
  `created_at`       TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       TIMESTAMP     NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_productos_categoria` (`categoria_id`),
  KEY `fk_productos_unidad_medida` (`unidad_medida_id`),
  CONSTRAINT `fk_productos_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  CONSTRAINT `fk_productos_unidad_medida` FOREIGN KEY (`unidad_medida_id`) REFERENCES `unidades_medida` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

