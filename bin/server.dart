import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:miprimeraapi/database/database.dart';
import 'package:miprimeraapi/routes/routes_producto.dart';

void main(List<String> args) async {
  // Conectar a la base de datos
  final connection = await Database.connect();
  print('Conectado a la base de datos MySQL');

  // Configurar rutas
  final router = Router();

  // Montar las rutas de productos
  router.mount('/', productoRoutes(connection).call);

  router.get('/', (Request request) {
    return Response.ok('API de Productos en Dart activa');
  });

  // Configurar el pipeline
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  // Iniciar el servidor
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  print('Servidor escuchando en http://${server.address.host}:${server.port}');
}
