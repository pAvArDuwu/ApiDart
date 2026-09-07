import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/detalle_venta_service.dart';

Router detalleVentaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = DetalleVentaService(connection);

  router.get('/api/ventas/<ventaId>/detalles', (
    Request request,
    String ventaId,
  ) async {
    final detalles = await service.obtenerPorVenta(int.parse(ventaId));
    return Response.ok(
      jsonEncode(detalles.map((detalle) => detalle.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  return router;
}
