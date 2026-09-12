import 'package:mysql_client/mysql_client.dart';
import '../models/metodo_pago.dart';

class MetodoPagoService {
  final MySQLConnection connection;

  MetodoPagoService(this.connection);

  Future<List<MetodoPago>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo, created_at, updated_at '
      'FROM metodos_pago ORDER BY id',
    );
    return result.rows.map((row) => MetodoPago.fromMap(row.assoc())).toList();
  }

  Future<MetodoPago?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo, created_at, updated_at '
      'FROM metodos_pago WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return MetodoPago.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? descripcion,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO metodos_pago (nombre, descripcion, activo) '
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
      'UPDATE metodos_pago SET nombre = :nombre, descripcion = :descripcion, '
      'activo = :activo WHERE id = :id',
      {'id': id, 'nombre': nombre, 'descripcion': descripcion, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM metodos_pago WHERE id = :id',
      {'id': id},
    );
  }
}
