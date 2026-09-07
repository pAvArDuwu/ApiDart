import 'package:mysql_client/mysql_client.dart';

import '../models/venta.dart';

class VentaService {
  final MySQLConnection connection;

  VentaService(this.connection);

  Future<VentaCreada> registrar({
    required int clienteId,
    required List<DetalleVentaInput> detalles,
  }) async {
    if (detalles.isEmpty) {
      throw ArgumentError('La venta debe tener al menos un producto');
    }

    final productosRepetidos =
        detalles.map((detalle) => detalle.productoId).toSet().length !=
        detalles.length;
    if (productosRepetidos) {
      throw ArgumentError('No se puede repetir un producto en la venta');
    }
    if (detalles.any((detalle) => detalle.cantidad <= 0)) {
      throw ArgumentError('La cantidad debe ser mayor que cero');
    }

    return connection.transactional((transactionConnection) async {
      final cliente = await transactionConnection.execute(
        'SELECT id FROM clientes WHERE id = :clienteId',
        {'clienteId': clienteId},
      );
      if (cliente.rows.isEmpty) {
        throw ArgumentError('El cliente no existe');
      }

      final ventaResult = await transactionConnection.execute(
        'INSERT INTO ventas (cliente_id, total) VALUES (:clienteId, 0)',
        {'clienteId': clienteId},
      );
      final ventaId = ventaResult.lastInsertID.toInt();
      var total = 0.0;

      for (final detalle in detalles) {
        final producto = await transactionConnection.execute(
          'SELECT precio, stock, activo FROM productos '
          'WHERE id = :productoId FOR UPDATE',
          {'productoId': detalle.productoId},
        );
        if (producto.rows.isEmpty) {
          throw ArgumentError('El producto ${detalle.productoId} no existe');
        }

        final datos = producto.rows.first.assoc();
        final activo =
            datos['activo'].toString() == '1' ||
            datos['activo'].toString().toLowerCase() == 'true';
        final stock = int.parse(datos['stock'].toString());
        if (!activo) {
          throw StateError('El producto ${detalle.productoId} está inactivo');
        }
        if (stock < detalle.cantidad) {
          throw StateError(
            'Stock insuficiente para el producto ${detalle.productoId}',
          );
        }

        final precio = double.parse(datos['precio'].toString());
        final subtotal = _redondear(precio * detalle.cantidad);
        total = _redondear(total + subtotal);

        await transactionConnection.execute(
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
        await transactionConnection.execute(
          'UPDATE productos SET stock = stock - :cantidad WHERE id = :productoId',
          {'cantidad': detalle.cantidad, 'productoId': detalle.productoId},
        );
      }

      await transactionConnection.execute(
        'UPDATE ventas SET total = :total, estado = \'CONFIRMADA\' WHERE id = :ventaId',
        {'total': total, 'ventaId': ventaId},
      );

      return VentaCreada(id: ventaId, total: total);
    });
  }

  double _redondear(double valor) => double.parse(valor.toStringAsFixed(2));
}
