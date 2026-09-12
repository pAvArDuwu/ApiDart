import 'package:mysql_client/mysql_client.dart';
import '../models/tipo_movimiento.dart';

class TipoMovimientoService {
  final MySQLConnection connection;

  TipoMovimientoService(this.connection);

  Future<List<TipoMovimiento>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, signo, activo '
      'FROM tipos_movimiento ORDER BY id',
    );
    return result.rows.map((row) => TipoMovimiento.fromMap(row.assoc())).toList();
  }

  Future<TipoMovimiento?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, signo, activo '
      'FROM tipos_movimiento WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return TipoMovimiento.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? descripcion,
    required int signo,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO tipos_movimiento (nombre, descripcion, signo, activo) '
      'VALUES (:nombre, :descripcion, :signo, :activo)',
      {'nombre': nombre, 'descripcion': descripcion, 'signo': signo, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required String nombre,
    String? descripcion,
    required int signo,
    required bool activo,
  }) {
    return connection.execute(
      'UPDATE tipos_movimiento SET nombre = :nombre, descripcion = :descripcion, '
      'signo = :signo, activo = :activo WHERE id = :id',
      {'id': id, 'nombre': nombre, 'descripcion': descripcion, 'signo': signo, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM tipos_movimiento WHERE id = :id',
      {'id': id},
    );
  }
}
