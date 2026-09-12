CREATE TABLE IF NOT EXISTS `unidades_medida` (
  `id`          INT         NOT NULL AUTO_INCREMENT,
  `nombre`      VARCHAR(50) NOT NULL,
  `abreviatura` VARCHAR(10) DEFAULT NULL,
  `activo`      TINYINT(1)  NOT NULL DEFAULT '1',
  `created_at`  TIMESTAMP   NULL     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  TIMESTAMP   NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unidades_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
