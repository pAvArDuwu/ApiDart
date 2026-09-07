import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:untitled1/database/database.dart';
import 'package:untitled1/routes/routes_cliente.dart';
import 'package:untitled1/routes/routes_detalle_venta.dart';
import 'package:untitled1/routes/routes_producto.dart';
import 'package:untitled1/routes/routes_venta.dart';

Future<void> main(List<String> args) async {
  final connection = await Database.connect();
  print('Conectado a MySQL.');

  final router = Router();

  router.get('/', (Request request) => Response.ok('API funcionando\n'));

  final productoRouter = clienteRoutes(connection);
  router.mount('/', productoRouter.call);
  final ventaRouter = ventaRoutes(connection);
  router.mount('/', ventaRouter.call);
  final productosRouter = productoRoutes(connection);
  router.mount('/', productosRouter.call);
  final detallesRouter = detalleVentaRoutes(connection);
  router.mount('/', detallesRouter.call);

  final staticHandler = createStaticHandler(
    'public',
    defaultDocument: 'docs.html',
  );
  router.mount('/docs', staticHandler.call);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  await serve(handler, InternetAddress.anyIPv4, 8080);
  print('Servidor en http://localhost:8080');
  print('Documentación en http://localhost:8080/docs');
}
