import 'package:mysql_client/mysql_client.dart';
import '../models/categoria.dart';

class CategoriaService {
  final MySQLConnection connection;

  CategoriaService(this.connection);

  Future<List<Categoria>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo, created_at, updated_at '
      'FROM categorias ORDER BY id DESC',
    );
    return result.rows.map((row) => Categoria.fromMap(row.assoc())).toList();
  }

  Future<Categoria?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo, created_at, updated_at '
      'FROM categorias WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Categoria.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? descripcion,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO categorias (nombre, descripcion, activo) '
      'VALUES (:nombre, :descripcion, :activo)',
      {'nombre': nombre, 'descripcion': descripcion, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required String nombre,
    String? descripcion,
    required bool activo,
  }) {
    return connection.execute(
      'UPDATE categorias SET nombre = :nombre, descripcion = :descripcion, '
      'activo = :activo WHERE id = :id',
      {'id': id, 'nombre': nombre, 'descripcion': descripcion, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM categorias WHERE id = :id',
      {'id': id},
    );
  }
}
