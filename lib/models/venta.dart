class Venta {
  final int id;
  final int clienteId;
  final int estadoVentaId;
  final String? fecha;
  final double total;
  final String? createdAt;
  final String? updatedAt;

  const Venta({
    required this.id,
    required this.clienteId,
    required this.estadoVentaId,
    this.fecha,
    required this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: int.parse(map['id'].toString()),
      clienteId: int.parse(map['cliente_id'].toString()),
      estadoVentaId: int.parse((map['estado_venta_id'] ?? 1).toString()),
      fecha: map['fecha']?.toString(),
      total: double.parse(map['total'].toString()),
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'cliente_id': clienteId,
        'estado_venta_id': estadoVentaId,
        'fecha': fecha,
        'total': total,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}


// DTO para crear venta desde la ruta POST
class DetalleVentaInput {
  final int productoId;
  final int cantidad;

  const DetalleVentaInput({
    required this.productoId,
    required this.cantidad,
  });
}

// DTO de respuesta al registrar una venta
class VentaCreada {
  final int id;
  final double total;

  const VentaCreada({required this.id, required this.total});

  Map<String, dynamic> toMap() => {'id': id, 'total': total};
}
