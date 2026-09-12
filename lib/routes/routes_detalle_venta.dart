import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/detalle_venta_service.dart';

Router detalleVentaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = DetalleVentaService(connection);

  // GET /api/ventas/:ventaId/detalles
  router.get('/api/ventas/<ventaId>/detalles', (Request request, String ventaId) async {
    final lista = await service.obtenerPorVenta(int.parse(ventaId));
    return Response.ok(
      jsonEncode(lista.map((d) => d.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  // GET /api/detalles-venta/:id
  router.get('/api/detalles-venta/<id>', (Request request, String id) async {
    final detalle = await service.obtenerPorId(int.parse(id));
    if (detalle == null) {
      return Response.notFound(
        jsonEncode({'error': 'Detalle de venta no encontrado'}),
        headers: {'content-type': 'application/json'},
      );
    }
    return Response.ok(jsonEncode(detalle.toMap()), headers: {'content-type': 'application/json'});
  });

  return router;
}
