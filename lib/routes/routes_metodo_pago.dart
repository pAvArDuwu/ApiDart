import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/metodo_pago_service.dart';

Router metodoPagoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = MetodoPagoService(connection);

  router.get('/api/metodos-pago', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((m) => m.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/metodos-pago/<id>', (Request request, String id) async {
    final metodo = await service.obtenerPorId(int.parse(id));
    if (metodo == null) {
      return Response.notFound(jsonEncode({'error': 'Método de pago no encontrado'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(metodo.toMap()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/metodos-pago', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(nombre: body['nombre'].toString(), descripcion: body['descripcion']?.toString(), activo: body['activo'] != false);
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.put('/api/metodos-pago/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(id: int.parse(id), nombre: body['nombre'].toString(), descripcion: body['descripcion']?.toString(), activo: body['activo'] != false);
      return Response.ok(jsonEncode({'mensaje': 'Método de pago actualizado'}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/metodos-pago/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Método de pago eliminado'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
