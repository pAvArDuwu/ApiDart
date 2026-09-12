class DetalleCompra {
  final int id;
  final int compraId;
  final int productoId;
  final double cantidad;
  final double precioUnitario;
  final double subtotal;
  final String? createdAt;
  final String? updatedAt;

  const DetalleCompra({
    required this.id,
    required this.compraId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.createdAt,
    this.updatedAt,
  });

  factory DetalleCompra.fromMap(Map<String, dynamic> map) {
    return DetalleCompra(
      id: int.parse(map['id'].toString()),
      compraId: int.parse(map['compra_id'].toString()),
      productoId: int.parse(map['producto_id'].toString()),
      cantidad: double.parse(map['cantidad'].toString()),
      precioUnitario: double.parse(map['precio_unitario'].toString()),
      subtotal: double.parse(map['subtotal'].toString()),
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'compra_id': compraId,
        'producto_id': productoId,
        'cantidad': cantidad,
        'precio_unitario': precioUnitario,
        'subtotal': subtotal,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
