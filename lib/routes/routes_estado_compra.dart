import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/estado_compra_service.dart';

Router estadoCompraRoutes(MySQLConnection connection) {
  final router = Router();
  final service = EstadoCompraService(connection);

  router.get('/api/estados-compra', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(lista.map((e) => e.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  router.get('/api/estados-compra/<id>', (Request request, String id) async {
    final estado = await service.obtenerPorId(int.parse(id));
    if (estado == null) {
      return Response.notFound(
        jsonEncode({'error': 'Estado de compra no encontrado'}),
        headers: {'content-type': 'application/json'},
      );
    }
    return Response.ok(jsonEncode(estado.toMap()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/estados-compra', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        nombre: body['nombre'].toString(),
        descripcion: body['descripcion']?.toString(),
        activo: body['activo'] != false,
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.put('/api/estados-compra/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(id: int.parse(id), nombre: body['nombre'].toString(), descripcion: body['descripcion']?.toString(), activo: body['activo'] != false);
      return Response.ok(jsonEncode({'mensaje': 'Estado de compra actualizado'}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/estados-compra/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Estado de compra eliminado'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
