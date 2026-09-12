class UnidadMedida {
  final int id;
  final String nombre;
  final String? abreviatura;
  final bool activo;
  final String? createdAt;
  final String? updatedAt;

  const UnidadMedida({
    required this.id,
    required this.nombre,
    this.abreviatura,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory UnidadMedida.fromMap(Map<String, dynamic> map) {
    return UnidadMedida(
      id: int.parse(map['id'].toString()),
      nombre: map['nombre']?.toString() ?? '',
      abreviatura: map['abreviatura']?.toString(),
      activo: map['activo'].toString() == '1',
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'abreviatura': abreviatura,
        'activo': activo,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
