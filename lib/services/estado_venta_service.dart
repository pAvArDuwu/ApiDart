import 'package:mysql_client/mysql_client.dart';
import '../models/estado_venta.dart';

class EstadoVentaService {
  final MySQLConnection connection;

  EstadoVentaService(this.connection);

  Future<List<EstadoVenta>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo FROM estados_venta ORDER BY id',
    );
    return result.rows.map((row) => EstadoVenta.fromMap(row.assoc())).toList();
  }

  Future<EstadoVenta?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, descripcion, activo FROM estados_venta WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return EstadoVenta.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? descripcion,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO estados_venta (nombre, descripcion, activo) '
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
      'UPDATE estados_venta SET nombre = :nombre, descripcion = :descripcion, '
      'activo = :activo WHERE id = :id',
      {'id': id, 'nombre': nombre, 'descripcion': descripcion, 'activo': activo ? 1 : 0},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM estados_venta WHERE id = :id',
      {'id': id},
    );
  }
}
