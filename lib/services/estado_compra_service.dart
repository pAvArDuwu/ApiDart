import 'package:mysql_client/mysql_client.dart';
import '../models/estado_compra.dart';

class EstadoCompraService {
  final MySQLConnection connection;

  EstadoCompraService(this.connection);

  Future<List<EstadoCompra>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo FROM estados_compra ORDER BY id',
    );
    return result.rows.map((row) => EstadoCompra.fromMap(row.assoc())).toList();
  }

  Future<EstadoCompra?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo FROM estados_compra WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return EstadoCompra.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? descripcion,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO estados_compra (nombre, descripcion, activo) '
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
      'UPDATE estados_compra SET nombre = :nombre, descripcion = :descripcion, '
      'activo = :activo WHERE id = :id',
      {'id': id, 'nombre': nombre, 'descripcion': descripcion, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM estados_compra WHERE id = :id',
      {'id': id},
    );
  }
}
