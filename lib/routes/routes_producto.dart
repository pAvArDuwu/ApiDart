import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/producto_service.dart';

Router productoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ProductoService(connection);

  router.post('/api/productos', (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await service.crear(
        codigo: body['codigo'].toString(),
        nombre: body['nombre'].toString(),
        descripcion: body['descripcion']?.toString(),
        precio: double.parse(body['precio'].toString()),
        stock: int.parse(body['stock'].toString()),
      );
      return Response(
        201,
        body: jsonEncode({'id': result.lastInsertID.toInt()}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'Los datos del producto no son válidos'}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  router.get('/api/productos', (Request request) async {
    final productos = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(productos.map((producto) => producto.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  router.get('/api/productos/<id>', (Request request, String id) async {
    final producto = await service.obtenerPorId(int.parse(id));
    if (producto == null) {
      return Response.notFound(jsonEncode({'error': 'producto no encontrado'}));
    }
    return Response.ok(
      jsonEncode(producto.toMap()),
      headers: {'content-type': 'application/json'},
    );
  });

  return router;
}
