class Producto {
  final int id;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final bool activo;

  const Producto({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
    required this.activo,
  });

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: int.parse(map['id'].toString()),
      codigo: map['codigo'].toString(),
      nombre: map['nombre'].toString(),
      descripcion: map['descripcion']?.toString(),
      precio: double.parse(map['precio'].toString()),
      stock: int.parse(map['stock'].toString()),
      activo:
          map['activo'].toString() == '1' ||
          map['activo'].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'codigo': codigo,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio': precio,
    'stock': stock,
    'activo': activo,
  };
}
