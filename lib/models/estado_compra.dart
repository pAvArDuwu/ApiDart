class EstadoCompra {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;

  const EstadoCompra({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.activo,
  });

  factory EstadoCompra.fromMap(Map<String, dynamic> map) {
    return EstadoCompra(
      id: int.parse(map['id'].toString()),
      nombre: map['nombre']?.toString() ?? '',
      descripcion: map['descripcion']?.toString(),
      activo: map['activo'].toString() == '1',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'activo': activo,
      };
}
