import 'package:mysql_client/mysql_client.dart';
import '../models/venta.dart';

class VentaService {
  final MySQLConnection connection;

  VentaService(this.connection);

  Future<List<Venta>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, cliente_id, estado_venta_id, fecha, total, created_at, updated_at '
      'FROM ventas ORDER BY id DESC',
    );
    return result.rows.map((row) => Venta.fromMap(row.assoc())).toList();
  }

  Future<Venta?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, cliente_id, estado_venta_id, fecha, total, created_at, updated_at '
      'FROM ventas WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Venta.fromMap(result.rows.first.assoc());
  }

  Future<VentaCreada> registrar({
    required int clienteId,
    required List<DetalleVentaInput> detalles,
  }) async {
    if (detalles.isEmpty) {
      throw ArgumentError('La venta debe tener al menos un producto');
    }
    final productosRepetidos =
        detalles.map((d) => d.productoId).toSet().length != detalles.length;
    if (productosRepetidos) {
      throw ArgumentError('No se puede repetir un producto en la misma venta');
    }
    if (detalles.any((d) => d.cantidad <= 0)) {
      throw ArgumentError('La cantidad debe ser mayor que cero');
    }

    return connection.transactional((tx) async {
      // Verificar que el cliente existe
      final clienteResult = await tx.execute(
        'SELECT id FROM clientes WHERE id = :clienteId',
        {'clienteId': clienteId},
      );
      if (clienteResult.rows.isEmpty) {
        throw ArgumentError('El cliente $clienteId no existe');
      }

      // Insertar la venta con estado_venta_id = 1 ('pendiente')
      final ventaResult = await tx.execute(
        'INSERT INTO ventas (cliente_id, estado_venta_id, total) VALUES (:clienteId, 1, 0)',
        {'clienteId': clienteId},
      );
      final ventaId = ventaResult.lastInsertID.toInt();
      var total = 0.0;

      for (final detalle in detalles) {
        // Verificar que el producto existe
        final productoResult = await tx.execute(
          'SELECT id, precio FROM productos WHERE id = :productoId',
          {'productoId': detalle.productoId},
        );
        if (productoResult.rows.isEmpty) {
          throw ArgumentError('El producto ${detalle.productoId} no existe');
        }

        final datos = productoResult.rows.first.assoc();
        final precio = double.parse(datos['precio'].toString());
        final subtotal = _redondear(precio * detalle.cantidad);
        total = _redondear(total + subtotal);

        await tx.execute(
          'INSERT INTO detalle_venta '
          '(venta_id, producto_id, cantidad, precio_unitario, subtotal) '
          'VALUES (:ventaId, :productoId, :cantidad, :precio, :subtotal)',
          {
            'ventaId': ventaId,
            'productoId': detalle.productoId,
            'cantidad': detalle.cantidad,
            'precio': precio,
            'subtotal': subtotal,
          },
        );
      }

      // Actualizar total y cambiar estado a pagada (estado_venta_id = 2)
      await tx.execute(
        'UPDATE ventas SET total = :total, estado_venta_id = 2 WHERE id = :ventaId',
        {'total': total, 'ventaId': ventaId},
      );

      return VentaCreada(id: ventaId, total: total);
    });
  }

  Future<IResultSet> actualizarEstado(int id, int estadoVentaId) async {
    final estadoResult = await connection.execute(
      'SELECT id FROM estados_venta WHERE id = :id',
      {'id': estadoVentaId},
    );
    if (estadoResult.rows.isEmpty) {
      throw ArgumentError('El estado de venta $estadoVentaId no existe');
    }
    return connection.execute(
      'UPDATE ventas SET estado_venta_id = :estadoVentaId WHERE id = :id',
      {'id': id, 'estadoVentaId': estadoVentaId},
    );
  }

  double _redondear(double valor) => double.parse(valor.toStringAsFixed(2));
}

