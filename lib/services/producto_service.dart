import 'package:mysql_client/mysql_client.dart';
import '../models/producto.dart';

class ProductoService {
  final MySQLConnection connection;

  ProductoService(this.connection);

  Future<List<Producto>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, categoria_id, unidad_medida_id, nombre, precio, created_at, updated_at '
      'FROM productos ORDER BY id DESC',
    );
    return result.rows.map((row) => Producto.fromMap(row.assoc())).toList();
  }

  Future<Producto?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, categoria_id, unidad_medida_id, nombre, precio, created_at, updated_at '
      'FROM productos WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Producto.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required int categoriaId,
    required int unidadMedidaId,
    required String nombre,
    required double precio,
  }) {
    return connection.execute(
      'INSERT INTO productos (categoria_id, unidad_medida_id, nombre, precio) '
      'VALUES (:categoriaId, :unidadMedidaId, :nombre, :precio)',
      {
        'categoriaId': categoriaId,
        'unidadMedidaId': unidadMedidaId,
        'nombre': nombre,
        'precio': precio,
      },
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required int categoriaId,
    required int unidadMedidaId,
    required String nombre,
    required double precio,
  }) {
    return connection.execute(
      'UPDATE productos SET categoria_id = :categoriaId, unidad_medida_id = :unidadMedidaId, '
      'nombre = :nombre, precio = :precio WHERE id = :id',
      {
        'id': id,
        'categoriaId': categoriaId,
        'unidadMedidaId': unidadMedidaId,
        'nombre': nombre,
        'precio': precio,
      },
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM productos WHERE id = :id',
      {'id': id},
    );
  }
}

