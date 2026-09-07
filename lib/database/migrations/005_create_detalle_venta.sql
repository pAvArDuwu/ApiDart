CREATE TABLE IF NOT EXISTS detalle_venta (
	id INT AUTO_INCREMENT PRIMARY KEY,
	venta_id INT NOT NULL,
	producto_id INT NOT NULL,
	cantidad INT NOT NULL,
	precio_unitario DECIMAL(10, 2) NOT NULL,
	subtotal DECIMAL(10, 2) NOT NULL,
	CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (venta_id) REFERENCES ventas (id) ON DELETE CASCADE,
	CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (producto_id) REFERENCES productos (id),
	CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
	CONSTRAINT chk_detalle_precio CHECK (precio_unitario >= 0),
	CONSTRAINT chk_detalle_subtotal CHECK (subtotal >= 0),
	UNIQUE KEY uk_detalle_venta_producto (venta_id, producto_id),
	INDEX idx_detalle_producto (producto_id)
) ENGINE=InnoDB;