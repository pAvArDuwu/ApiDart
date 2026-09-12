class MetodoPago {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;
  final String? createdAt;
  final String? updatedAt;

  const MetodoPago({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory MetodoPago.fromMap(Map<String, dynamic> map) {
    return MetodoPago(
      id: int.parse(map['id'].toString()),
      nombre: map['nombre']?.toString() ?? '',
      descripcion: map['descripcion']?.toString(),
      activo: map['activo'].toString() == '1',
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'activo': activo,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
