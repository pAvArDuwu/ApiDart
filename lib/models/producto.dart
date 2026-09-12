// Modelo alineado exactamente con la tabla SQL productos
// Campos: id, categoria_id, unidad_medida_id, nombre, precio, created_at, updated_at
class Producto {
  final int id;
  final int categoriaId;
  final int unidadMedidaId;
  final String nombre;
  final double precio;
  final String? createdAt;
  final String? updatedAt;

  const Producto({
    required this.id,
    required this.categoriaId,
    required this.unidadMedidaId,
    required this.nombre,
    required this.precio,
    this.createdAt,
    this.updatedAt,
  });

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: int.parse(map['id'].toString()),
      categoriaId: int.parse(map['categoria_id'].toString()),
      unidadMedidaId: int.parse(map['unidad_medida_id'].toString()),
      nombre: map['nombre']?.toString() ?? '',
      precio: double.parse(map['precio'].toString()),
      createdAt: map['created_at']?.toString(),
      updatedAt: map['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoria_id': categoriaId,
        'unidad_medida_id': unidadMedidaId,
        'nombre': nombre,
        'precio': precio,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

