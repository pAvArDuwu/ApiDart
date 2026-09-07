import 'package:mysql_client/mysql_client.dart';

import '../models/producto.dart';

class ProductoService {
  final MySQLConnection connection;

  ProductoService(this.connection);

  Future<List<Producto>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, codigo, nombre, descripcion, precio, stock, activo '
      'FROM productos ORDER BY id DESC',
    );
    return result.rows.map((row) => Producto.fromMap(row.assoc())).toList();
  }

  Future<Producto?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, codigo, nombre, descripcion, precio, stock, activo '
      'FROM productos WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Producto.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String codigo,
    required String nombre,
    String? descripcion,
    required double precio,
    required int stock,
  }) {
    return connection.execute(
      'INSERT INTO productos '
      '(codigo, nombre, descripcion, precio, stock) '
      'VALUES (:codigo, :nombre, :descripcion, :precio, :stock)',
      {
        'codigo': codigo,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
      },
    );
  }
}
