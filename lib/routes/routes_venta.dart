import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/venta.dart';
import '../services/venta_service.dart';

Router ventaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = VentaService(connection);

  // GET /api/ventas
  router.get('/api/ventas', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(lista.map((v) => v.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  // GET /api/ventas/:id
  router.get('/api/ventas/<id>', (Request request, String id) async {
    final venta = await service.obtenerPorId(int.parse(id));
    if (venta == null) {
      return Response.notFound(
        jsonEncode({'error': 'Venta no encontrada'}),
        headers: {'content-type': 'application/json'},
      );
    }
    return Response.ok(jsonEncode(venta.toMap()), headers: {'content-type': 'application/json'});
  });

  // POST /api/ventas
  router.post('/api/ventas', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final detalles = (body['detalles'] as List<dynamic>? ?? []).map((item) {
        final d = item as Map<String, dynamic>;
        return DetalleVentaInput(
          productoId: int.parse(d['producto_id'].toString()),
          cantidad: int.parse(d['cantidad'].toString()),
        );
      }).toList();

      final venta = await service.registrar(
        clienteId: int.parse(body['cliente_id'].toString()),
        detalles: detalles,
      );
      return Response(
        201,
        body: jsonEncode(venta.toMap()),
        headers: {'content-type': 'application/json'},
      );
    } on ArgumentError catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': e.message}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'JSON inválido'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // PUT /api/ventas/:id/estado
  router.put('/api/ventas/<id>/estado', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final estadoVal = body['estado_venta_id'] ?? body['estado'];
      if (estadoVal == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'estado_venta_id es requerido'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final estadoVentaId = int.parse(estadoVal.toString());
      await service.actualizarEstado(int.parse(id), estadoVentaId);
      return Response.ok(
        jsonEncode({'mensaje': 'Estado de venta actualizado'}),
        headers: {'content-type': 'application/json'},
      );
    } on ArgumentError catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': e.message}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'JSON inválido'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  return router;
}
