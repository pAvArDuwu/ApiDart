import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/producto_service.dart';

Router productoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ProductoService(connection);

  // GET /api/productos
  router.get('/api/productos', (Request request) async {
    final lista = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(lista.map((p) => p.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  // GET /api/productos/:id
  router.get('/api/productos/<id>', (Request request, String id) async {
    final producto = await service.obtenerPorId(int.parse(id));
    if (producto == null) {
      return Response.notFound(
        jsonEncode({'error': 'Producto no encontrado'}),
        headers: {'content-type': 'application/json'},
      );
    }
    return Response.ok(jsonEncode(producto.toMap()), headers: {'content-type': 'application/json'});
  });

  // POST /api/productos
  router.post('/api/productos', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      if (!body.containsKey('categoria_id') || !body.containsKey('unidad_medida_id')) {
        return Response.badRequest(
          body: jsonEncode({'error': 'categoria_id y unidad_medida_id son requeridos'}),
          headers: {'content-type': 'application/json'},
        );
      }
      final result = await service.crear(
        categoriaId: int.parse(body['categoria_id'].toString()),
        unidadMedidaId: int.parse(body['unidad_medida_id'].toString()),
        nombre: body['nombre'].toString(),
        precio: double.parse(body['precio'].toString()),
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

  // PUT /api/productos/:id
  router.put('/api/productos/<id>', (Request request, String id) async {
    try {
      final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      if (!body.containsKey('categoria_id') || !body.containsKey('unidad_medida_id')) {
        return Response.badRequest(
          body: jsonEncode({'error': 'categoria_id y unidad_medida_id son requeridos'}),
          headers: {'content-type': 'application/json'},
        );
      }
      await service.actualizar(
        id: int.parse(id),
        categoriaId: int.parse(body['categoria_id'].toString()),
        unidadMedidaId: int.parse(body['unidad_medida_id'].toString()),
        nombre: body['nombre'].toString(),
        precio: double.parse(body['precio'].toString()),
      );
      return Response.ok(
        jsonEncode({'mensaje': 'Producto actualizado'}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'JSON inválido'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  // DELETE /api/productos/:id
  router.delete('/api/productos/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(
      jsonEncode({'mensaje': 'Producto eliminado'}),
      headers: {'content-type': 'application/json'},
    );
  });

  return router;
}
