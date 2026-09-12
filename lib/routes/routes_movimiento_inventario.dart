import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/movimiento_inventario_service.dart';

Router movimientoInventarioRoutes(MySQLConnection connection) {
  final router = Router();
  final service = MovimientoInventarioService(connection);

  router.get('/api/movimientos-inventario', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((m) => m.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/movimientos-inventario/<id>', (Request request, String id) async {
    final mov = await service.obtenerPorId(int.parse(id));
    if (mov == null) {
      return Response.notFound(jsonEncode({'error': 'Movimiento no encontrado'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(mov.toMap()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/productos/<productoId>/movimientos', (Request request, String productoId) async {
    final lista = await service.obtenerPorProducto(int.parse(productoId));
    return Response.ok(jsonEncode(lista.map((m) => m.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/movimientos-inventario', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        productoId: int.parse(body['producto_id'].toString()),
        tipoMovimientoId: int.parse(body['tipo_movimiento_id'].toString()),
        cantidad: double.parse(body['cantidad'].toString()),
        referencia: body['referencia']?.toString(),
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  return router;
}
