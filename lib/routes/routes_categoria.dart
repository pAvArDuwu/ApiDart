import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/categoria_service.dart';

Router categoriaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = CategoriaService(connection);

  // GET /api/categorias
  router.get('/api/categorias', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(lista.map((c) => c.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  // GET /api/categorias/:id
  router.get('/api/categorias/<id>', (Request request, String id) async {
    final categoria = await service.obtenerPorId(int.parse(id));
    if (categoria == null) {
      return Response.notFound(
        jsonEncode({'error': 'Categoría no encontrada'}),
        headers: {'content-type': 'application/json'},
      );
    }
    return Response.ok(
      jsonEncode(categoria.toMap()),
      headers: {'content-type': 'application/json'},
    );
  });

  // POST /api/categorias
  router.post('/api/categorias', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        nombre: body['nombre'].toString(),
        descripcion: body['descripcion']?.toString(),
        activo: body['activo'] != false,
      );
      return Response(
        201,
        body: jsonEncode({'id': result.lastInsertID.toInt()}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'JSON inválido'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // PUT /api/categorias/:id
  router.put('/api/categorias/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      await service.actualizar(
        id: int.parse(id),
        nombre: body['nombre'].toString(),
        descripcion: body['descripcion']?.toString(),
        activo: body['activo'] != false,
      );
      return Response.ok(
        jsonEncode({'mensaje': 'Categoría actualizada'}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'JSON inválido'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // DELETE /api/categorias/:id
  router.delete('/api/categorias/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(
      jsonEncode({'mensaje': 'Categoría eliminada'}),
      headers: {'content-type': 'application/json'},
    );
  });

  return router;
}
