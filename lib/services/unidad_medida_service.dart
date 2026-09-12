import 'package:mysql_client/mysql_client.dart';
import '../models/unidad_medida.dart';

class UnidadMedidaService {
  final MySQLConnection connection;

  UnidadMedidaService(this.connection);

  Future<List<UnidadMedida>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, abreviatura, activo, created_at, updated_at '
      'FROM unidades_medida ORDER BY id',
    );
    return result.rows.map((row) => UnidadMedida.fromMap(row.assoc())).toList();
  }

  Future<UnidadMedida?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, abreviatura, activo, created_at, updated_at '
      'FROM unidades_medida WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return UnidadMedida.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? abreviatura,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO unidades_medida (nombre, abreviatura, activo) '
      'VALUES (:nombre, :abreviatura, :activo)',
      {'nombre': nombre, 'abreviatura': abreviatura, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required String nombre,
    String? abreviatura,
    required bool activo,
  }) {
    return connection.execute(
      'UPDATE unidades_medida SET nombre = :nombre, abreviatura = :abreviatura, '
      'activo = :activo WHERE id = :id',
      {'id': id, 'nombre': nombre, 'abreviatura': abreviatura, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM unidades_medida WHERE id = :id',
      {'id': id},
    );
  }
}
