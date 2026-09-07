class DetalleVenta {
  final int id;
  final int ventaId;
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleVenta({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      id: int.parse(map['id'].toString()),
      ventaId: int.parse(map['venta_id'].toString()),
      productoId: int.parse(map['producto_id'].toString()),
      cantidad: int.parse(map['cantidad'].toString()),
      precioUnitario: double.parse(map['precio_unitario'].toString()),
      subtotal: double.parse(map['subtotal'].toString()),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'venta_id': ventaId,
    'producto_id': productoId,
    'cantidad': cantidad,
    'precio_unitario': precioUnitario,
    'subtotal': subtotal,
  };
}
