CREATE TABLE IF NOT EXISTS `categorias` (
  `id`          INT          NOT NULL AUTO_INCREMENT,
  `nombre`      VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(200) DEFAULT NULL,
  `activo`      TINYINT(1)   NOT NULL DEFAULT '1',
  `created_at`  TIMESTAMP    NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  TIMESTAMP    NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_categorias_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
