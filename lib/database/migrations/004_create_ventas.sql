CREATE TABLE IF NOT EXISTS ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    estado ENUM('PENDIENTE', 'CONFIRMADA', 'ANULADA') NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id),
    CONSTRAINT chk_ventas_total CHECK (total >= 0),
    INDEX idx_ventas_cliente (cliente_id),
    INDEX idx_ventas_fecha (fecha_venta)
) ENGINE=InnoDB;