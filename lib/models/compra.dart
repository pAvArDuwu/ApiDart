class Compra {
  final int id;
  final int proveedorId;
  final int estadoCompraId;
  final String? fecha;
  final double total;
  final String? createdAt;
  final String? updatedAt;

  const Compra({
    required this.id,
    required this.proveedorId,
    required this.estadoCompraId,
    this.fecha,
    required this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory Compra.fromMap(Map<String, dynamic> map) {
    return Compra(
      id: int.parse(map['id'].toString()),
      proveedorId: int.parse(map['proveedor_id'].toString()),
      estadoCompraId: int.parse(map['estado_compra_id'].toString()),
      fecha: map['fecha']?.toString(),
      total: double.parse(map['total'].toString()),
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'proveedor_id': proveedorId,
        'estado_compra_id': estadoCompraId,
        'fecha': fecha,
        'total': total,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
