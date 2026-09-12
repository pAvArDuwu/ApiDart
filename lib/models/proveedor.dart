class Proveedor {
  final int id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? direccion;
  final bool activo;
  final String? createdAt;
  final String? updatedAt;

  const Proveedor({
    required this.id,
    required this.nombre,
    this.telefono,
    this.email,
    this.direccion,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory Proveedor.fromMap(Map<String, dynamic> map) {
    return Proveedor(
      id: int.parse(map['id'].toString()),
      nombre: map['nombre']?.toString() ?? '',
      telefono: map['telefono']?.toString(),
      email: map['email']?.toString(),
      direccion: map['direccion']?.toString(),
      activo: map['activo'].toString() == '1',
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'activo': activo,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
