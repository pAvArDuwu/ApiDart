import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/proveedor_service.dart';

Router proveedorRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ProveedorService(connection);

  router.get('/api/proveedores', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(jsonEncode(lista.map((p) => p.toMap()).toList()), headers: {'content-type': 'application/json'});
  });

  router.get('/api/proveedores/<id>', (Request request, String id) async {
    final proveedor = await service.obtenerPorId(int.parse(id));
    if (proveedor == null) {
      return Response.notFound(jsonEncode({'error': 'Proveedor no encontrado'}), headers: {'content-type': 'application/json'});
    }
    return Response.ok(jsonEncode(proveedor.toMap()), headers: {'content-type': 'application/json'});
  });

  router.post('/api/proveedores', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        nombre: body['nombre'].toString(),
        telefono: body['telefono']?.toString(),
        email: body['email']?.toString(),
        direccion: body['direccion']?.toString(),
        activo: body['activo'] != false,
      );
      return Response(201, body: jsonEncode({'id': result.lastInsertID.toInt()}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.put('/api/proveedores/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(
        id: int.parse(id),
        nombre: body['nombre'].toString(),
        telefono: body['telefono']?.toString(),
        email: body['email']?.toString(),
        direccion: body['direccion']?.toString(),
        activo: body['activo'] != false,
      );
      return Response.ok(jsonEncode({'mensaje': 'Proveedor actualizado'}), headers: {'content-type': 'application/json'});
    } on FormatException {
      return Response.badRequest(body: jsonEncode({'error': 'JSON inválido'}), headers: {'content-type': 'application/json'});
    }
  });

  router.delete('/api/proveedores/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Proveedor desactivado'}), headers: {'content-type': 'application/json'});
  });

  return router;
}
