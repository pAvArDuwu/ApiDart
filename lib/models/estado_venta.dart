class EstadoVenta {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool activo;

  const EstadoVenta({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.activo,
  });

  factory EstadoVenta.fromMap(Map<String, dynamic> map) {
    return EstadoVenta(
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
