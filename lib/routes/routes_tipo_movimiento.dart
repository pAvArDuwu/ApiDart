import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/tipo_movimiento_service.dart';

Router tipoMovimientoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = TipoMovimientoService(connection);

  router.get('/api/tipos-movimiento', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((t) => t.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/tipos-movimiento/<id>', (Request request, String id) async {
    final tipo = await service.obtenerPorId(int.parse(id));
    if (tipo == null) {
      return Response.notFound(jsonEncode({'error': 'Tipo de movimiento no encontrado'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(tipo.toMap()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/tipos-movimiento', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        nombre: body['nombre'].toString(),
        descripcion: body['descripcion']?.toString(),
        signo: int.parse(body['signo'].toString()),
        activo: body['activo'] != false,
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.put('/api/tipos-movimiento/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(id: int.parse(id), nombre: body['nombre'].toString(), descripcion: body['descripcion']?.toString(), signo: int.parse(body['signo'].toString()), activo: body['activo'] != false);
      return Response.ok(jsonEncode({'mensaje': 'Tipo de movimiento actualizado'}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/tipos-movimiento/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Tipo de movimiento eliminado'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
