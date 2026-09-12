import 'package:mysql_client/mysql_client.dart';
import '../models/detalle_compra.dart';

class DetalleCompraService {
  final MySQLConnection connection;

  DetalleCompraService(this.connection);

  Future<List<DetalleCompra>> obtenerPorCompra(int compraId) async {
    final result = await connection.execute(
      'SELECT id, compra_id, producto_id, cantidad, precio_unitario, subtotal, created_at, updated_at '
      'FROM detalle_compra WHERE compra_id = :compraId ORDER BY id',
      {'compraId': compraId},
    );
    return result.rows.map((row) => DetalleCompra.fromMap(row.assoc())).toList();
  }

  Future<DetalleCompra?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, compra_id, producto_id, cantidad, precio_unitario, subtotal, created_at, updated_at '
      'FROM detalle_compra WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return DetalleCompra.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required int compraId,
    required int productoId,
    required double cantidad,
    required double precioUnitario,
    required double subtotal,
  }) {
    return connection.execute(
      'INSERT INTO detalle_compra (compra_id, producto_id, cantidad, precio_unitario, subtotal) '
      'VALUES (:compraId, :productoId, :cantidad, :precioUnitario, :subtotal)',
      {
        'compraId': compraId,
        'productoId': productoId,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'subtotal': subtotal,
      },
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM detalle_compra WHERE id = :id',
      {'id': id},
    );
  }
}
