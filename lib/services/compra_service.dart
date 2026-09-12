import 'package:mysql_client/mysql_client.dart';
import '../models/compra.dart';

class CompraService {
  final MySQLConnection connection;

  CompraService(this.connection);

  Future<List<Compra>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, proveedor_id, estado_compra_id, fecha, total, created_at, updated_at '
      'FROM compras ORDER BY id DESC',
    );
    return result.rows.map((row) => Compra.fromMap(row.assoc())).toList();
  }

  Future<Compra?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, proveedor_id, estado_compra_id, fecha, total, created_at, updated_at '
      'FROM compras WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Compra.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required int proveedorId,
    required int estadoCompraId,
    required double total,
  }) {
    return connection.execute(
      'INSERT INTO compras (proveedor_id, estado_compra_id, total) '
      'VALUES (:proveedorId, :estadoCompraId, :total)',
      {'proveedorId': proveedorId, 'estadoCompraId': estadoCompraId, 'total': total},
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required int proveedorId,
    required int estadoCompraId,
    required double total,
  }) {
    return connection.execute(
      'UPDATE compras SET proveedor_id = :proveedorId, '
      'estado_compra_id = :estadoCompraId, total = :total WHERE id = :id',
      {'id': id, 'proveedorId': proveedorId, 'estadoCompraId': estadoCompraId, 'total': total},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM compras WHERE id = :id',
      {'id': id},
    );
  }
}
