import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/detalle_compra_service.dart';

Router detalleCompraRoutes(MySQLConnection connection) {
  final router = Router();
  final service = DetalleCompraService(connection);

  // GET /api/compras/:compraId/detalles
  router.get('/api/compras/<compraId>/detalles', (Request request, String compraId) async {
    final lista = await service.obtenerPorCompra(int.parse(compraId));
    return Response.ok(jsonEncode(lista.map((d) => d.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  // GET /api/detalles-compra/:id
  router.get('/api/detalles-compra/<id>', (Request request, String id) async {
    final detalle = await service.obtenerPorId(int.parse(id));
    if (detalle == null) {
      return Response.notFound(jsonEncode({'error': 'Detalle de compra no encontrado'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(detalle.toMap()), headers: {'content-type': 'application/json'});
  });

  // POST /api/detalles-compra
  router.post('/api/detalles-compra', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        compraId: int.parse(body['compra_id'].toString()),
        productoId: int.parse(body['producto_id'].toString()),
        cantidad: double.parse(body['cantidad'].toString()),
        precioUnitario: double.parse(body['precio_unitario'].toString()),
        subtotal: double.parse(body['subtotal'].toString()),
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  // DELETE /api/detalles-compra/:id
  router.delete('/api/detalles-compra/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Detalle de compra eliminado'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
