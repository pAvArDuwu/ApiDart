class TipoMovimiento {
  final int id;
  final String nombre;
  final String? descripcion;
  final int signo; // 1 = entrada, -1 = salida
  final bool activo;

  const TipoMovimiento({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.signo,
    required this.activo,
  });

  factory TipoMovimiento.fromMap(Map<String, dynamic> map) {
    return TipoMovimiento(
      id: int.parse(map['id'].toString()),
      nombre: map['nombre']?.toString() ?? '',
      descripcion: map['descripcion']?.toString(),
      signo: int.parse(map['signo'].toString()),
      activo: map['activo'].toString() == '1',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'signo': signo,
        'activo': activo,
      };
}
