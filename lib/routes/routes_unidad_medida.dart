import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/unidad_medida_service.dart';

Router unidadMedidaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = UnidadMedidaService(connection);

  router.get('/api/unidades-medida', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((u) => u.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/unidades-medida/<id>', (Request request, String id) async {
    final unidad = await service.obtenerPorId(int.parse(id));
    if (unidad == null) {
      return Response.notFound(jsonEncode({'error': 'Unidad de medida no encontrada'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(unidad.toMap()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/unidades-medida', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(nombre: body['nombre'].toString(), abreviatura: body['abreviatura']?.toString(), activo: body['activo'] != false);
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.put('/api/unidades-medida/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(id: int.parse(id), nombre: body['nombre'].toString(), abreviatura: body['abreviatura']?.toString(), activo: body['activo'] != false);
      return Response.ok(jsonEncode({'mensaje': 'Unidad de medida actualizada'}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/unidades-medida/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Unidad de medida eliminada'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
