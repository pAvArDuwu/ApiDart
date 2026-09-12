import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/compra_service.dart';

Router compraRoutes(MySQLConnection connection) {
  final router = Router();
  final service = CompraService(connection);

  router.get('/api/compras', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((c) => c.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/compras/<id>', (Request request, String id) async {
    final compra = await service.obtenerPorId(int.parse(id));
    if (compra == null) {
      return Response.notFound(jsonEncode({'error': 'Compra no encontrada'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(compra.toMap()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/compras', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        proveedorId: int.parse(body['proveedor_id'].toString()),
        estadoCompraId: int.parse(body['estado_compra_id'].toString()),
        total: double.parse(body['total'].toString()),
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.put('/api/compras/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(id: int.parse(id), proveedorId: int.parse(body['proveedor_id'].toString()), estadoCompraId: int.parse(body['estado_compra_id'].toString()), total: double.parse(body['total'].toString()));
      return Response.ok(jsonEncode({'mensaje': 'Compra actualizada'}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/compras/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Compra eliminada'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
