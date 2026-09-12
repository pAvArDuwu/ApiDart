class Pago {
  final int id;
  final int ventaId;
  final int metodoPagoId;
  final double monto;
  final String? fecha;
  final String? referencia;
  final String? createdAt;
  final String? updatedAt;

  const Pago({
    required this.id,
    required this.ventaId,
    required this.metodoPagoId,
    required this.monto,
    this.fecha,
    this.referencia,
    this.createdAt,
    this.updatedAt,
  });

  factory Pago.fromMap(Map<String, dynamic> map) {
    return Pago(
      id: int.parse(map['id'].toString()),
      ventaId: int.parse(map['venta_id'].toString()),
      metodoPagoId: int.parse(map['metodo_pago_id'].toString()),
      monto: double.parse(map['monto'].toString()),
      fecha: map['fecha']?.toString(),
      referencia: map['referencia']?.toString(),
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'venta_id': ventaId,
        'metodo_pago_id': metodoPagoId,
        'monto': monto,
        'fecha': fecha,
        'referencia': referencia,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
