import 'package:mysql_client/mysql_client.dart';
import '../models/producto.dart';

class ProductoService {
  final MySQLConnection connection;

  ProductoService(this.connection);

  Future<List<Producto>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, precio FROM productos ORDER BY id DESC',
    );
    return result.rows.map((row) => Producto.fromMap(row.assoc())).toList();
  }

  Future<Producto?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, precio FROM productos WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Producto.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear(Producto producto) async {
    return await connection.execute(
      'INSERT INTO productos (nombre, precio) VALUES (:nombre, :precio)',
      {
        'nombre': producto.nombre,
        'precio': producto.precio,
      },
    );
  }

  Future<IResultSet> actualizar(int id, Producto producto) async {
    return await connection.execute(
      'UPDATE productos SET nombre = :nombre, precio = :precio WHERE id = :id',
      {
        'id': id,
        'nombre': producto.nombre,
        'precio': producto.precio,
      },
    );
  }

  Future<IResultSet> eliminar(int id) async {
    return await connection.execute(
      'DELETE FROM productos WHERE id = :id',
      {'id': id},
    );
  }
}
