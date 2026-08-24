import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/service_producto.dart';
import '../models/producto.dart';

Router productoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ProductoService(connection);

  // Obtener todos los productos
  router.get('/api/productos', (Request request) async {
    final productos = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(productos.map((p) => p.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });

  // Obtener un producto por ID
  router.get('/api/productos/<id>', (Request request, String id) async {
    final producto = await service.obtenerPorId(int.parse(id));
    if (producto == null) {
      return Response.notFound(jsonEncode({'error': 'Producto no encontrado'}));
    }
    return Response.ok(
      jsonEncode(producto.toMap()),
      headers: {'content-type': 'application/json'},
    );
  });

  // Crear un producto
  router.post('/api/productos', (Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    // Asignamos un ID temporal 0 porque la DB lo autoincrementa
    final nuevoProducto = Producto(
      id: 0,
      nombre: data['nombre'],
      precio: double.parse(data['precio'].toString())
    );

    await service.crear(nuevoProducto);
    return Response.ok(
      jsonEncode({'message': 'Producto creado con éxito'}),
      headers: {'content-type': 'application/json'},
    );
  });

  // Actualizar un producto
  router.put('/api/productos/<id>', (Request request, String id) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final productoEditado = Producto(
      id: int.parse(id),
      nombre: data['nombre'],
      precio: double.parse(data['precio'].toString())
    );

    await service.actualizar(int.parse(id), productoEditado);
    return Response.ok(
      jsonEncode({'message': 'Producto actualizado con éxito'}),
      headers: {'content-type': 'application/json'},
    );
  });

  // Eliminar un producto
  router.delete('/api/productos/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(
      jsonEncode({'message': 'Producto eliminado con éxito'}),
      headers: {'content-type': 'application/json'},
    );
  });

  return router;
}
