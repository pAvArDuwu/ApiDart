import 'package:mysql_client/mysql_client.dart';
import '../models/movimiento_inventario.dart';

class MovimientoInventarioService {
  final MySQLConnection connection;

  MovimientoInventarioService(this.connection);

  Future<List<MovimientoInventario>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, producto_id, tipo_movimiento_id, cantidad, referencia, fecha '
      'FROM movimientos_inventario ORDER BY id DESC',
    );
    return result.rows.map((row) => MovimientoInventario.fromMap(row.assoc())).toList();
  }

  Future<List<MovimientoInventario>> obtenerPorProducto(int productoId) async {
    final result = await connection.execute(
      'SELECT id, producto_id, tipo_movimiento_id, cantidad, referencia, fecha '
      'FROM movimientos_inventario WHERE producto_id = :productoId ORDER BY id DESC',
      {'productoId': productoId},
    );
    return result.rows.map((row) => MovimientoInventario.fromMap(row.assoc())).toList();
  }

  Future<MovimientoInventario?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, producto_id, tipo_movimiento_id, cantidad, referencia, fecha '
      'FROM movimientos_inventario WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return MovimientoInventario.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required int productoId,
    required int tipoMovimientoId,
    required double cantidad,
    String? referencia,
  }) {
    return connection.execute(
      'INSERT INTO movimientos_inventario (producto_id, tipo_movimiento_id, cantidad, referencia) '
      'VALUES (:productoId, :tipoMovimientoId, :cantidad, :referencia)',
      {
        'productoId': productoId,
        'tipoMovimientoId': tipoMovimientoId,
        'cantidad': cantidad,
        'referencia': referencia,
      },
    );
  }
}
