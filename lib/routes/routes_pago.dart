import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/pago_service.dart';

Router pagoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = PagoService(connection);

  router.get('/api/pagos', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((p) => p.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/pagos/<id>', (Request request, String id) async {
    final pago = await service.obtenerPorId(int.parse(id));
    if (pago == null) {
      return Response.notFound(jsonEncode({'error': 'Pago no encontrado'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(pago.toMap()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/ventas/<ventaId>/pagos', (Request request, String ventaId) async {
    final lista = await service.obtenerPorVenta(int.parse(ventaId));
    return Response.ok(jsonEncode(lista.map((p) => p.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/pagos', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        ventaId: int.parse(body['venta_id'].toString()),
        metodoPagoId: int.parse(body['metodo_pago_id'].toString()),
        monto: double.parse(body['monto'].toString()),
        referencia: body['referencia']?.toString(),
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/pagos/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Pago eliminado'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
