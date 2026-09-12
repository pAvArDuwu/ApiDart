class MovimientoInventario {
  final int id;
  final int productoId;
  final int tipoMovimientoId;
  final double cantidad;
  final String? referencia;
  final String? fecha;

  const MovimientoInventario({
    required this.id,
    required this.productoId,
    required this.tipoMovimientoId,
    required this.cantidad,
    this.referencia,
    this.fecha,
  });

  factory MovimientoInventario.fromMap(Map<String, dynamic> map) {
    return MovimientoInventario(
      id: int.parse(map['id'].toString()),
      productoId: int.parse(map['producto_id'].toString()),
      tipoMovimientoId: int.parse(map['tipo_movimiento_id'].toString()),
      cantidad: double.parse(map['cantidad'].toString()),
      referencia: map['referencia']?.toString(),
      fecha: map['fecha']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'producto_id': productoId,
        'tipo_movimiento_id': tipoMovimientoId,
        'cantidad': cantidad,
        'referencia': referencia,
        'fecha': fecha,
      };
}
