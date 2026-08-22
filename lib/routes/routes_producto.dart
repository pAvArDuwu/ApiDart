import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/service_producto.dart';

Router productoRoutes(MySQLConnection connection) {
  final router = Router();

  final Service = ProductoService(connection);

  router.get('/api/productos', (Request request) async {
    final resultado = await service.obtenerTodos();

    final productos = resultado.rows.map((row) {
      return {
        'id': row.colAt(0),
        'nombre': row.colAt(1),
        'precio': row.colAt(2),
      };
    }).toList();

    return Response.ok(
      jsonEncode(productos),
      headers: {
        'content-type': 'application/json'
      },
    );
  });
  return router;
}
