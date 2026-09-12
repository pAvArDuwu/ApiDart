import 'package:mysql_client/mysql_client.dart';
import '../models/pago.dart';

class PagoService {
  final MySQLConnection connection;

  PagoService(this.connection);

  Future<List<Pago>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, venta_id, metodo_pago_id, monto, fecha, referencia, created_at, updated_at '
      'FROM pagos ORDER BY id DESC',
    );
    return result.rows.map((row) => Pago.fromMap(row.assoc())).toList();
  }

  Future<List<Pago>> obtenerPorVenta(int ventaId) async {
    final result = await connection.execute(
      'SELECT id, venta_id, metodo_pago_id, monto, fecha, referencia, created_at, updated_at '
      'FROM pagos WHERE venta_id = :ventaId ORDER BY id',
      {'ventaId': ventaId},
    );
    return result.rows.map((row) => Pago.fromMap(row.assoc())).toList();
  }

  Future<Pago?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, venta_id, metodo_pago_id, monto, fecha, referencia, created_at, updated_at '
      'FROM pagos WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Pago.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required int ventaId,
    required int metodoPagoId,
    required double monto,
    String? referencia,
  }) {
    return connection.execute(
      'INSERT INTO pagos (venta_id, metodo_pago_id, monto, referencia) '
      'VALUES (:ventaId, :metodoPagoId, :monto, :referencia)',
      {
        'ventaId': ventaId,
        'metodoPagoId': metodoPagoId,
        'monto': monto,
        'referencia': referencia,
      },
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM pagos WHERE id = :id',
      {'id': id},
    );
  }
}
