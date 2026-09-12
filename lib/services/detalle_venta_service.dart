import 'package:mysql_client/mysql_client.dart';
import '../models/detalle_venta.dart';

class DetalleVentaService {
  final MySQLConnection connection;

  DetalleVentaService(this.connection);

  Future<List<DetalleVenta>> obtenerPorVenta(int ventaId) async {
    final result = await connection.execute(
      'SELECT id, venta_id, producto_id, cantidad, precio_unitario, subtotal, created_at, updated_at '
      'FROM detalle_venta WHERE venta_id = :ventaId ORDER BY id',
      {'ventaId': ventaId},
    );
    return result.rows.map((row) => DetalleVenta.fromMap(row.assoc())).toList();
  }

  Future<DetalleVenta?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, venta_id, producto_id, cantidad, precio_unitario, subtotal, created_at, updated_at '
      'FROM detalle_venta WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return DetalleVenta.fromMap(result.rows.first.assoc());
  }
}
