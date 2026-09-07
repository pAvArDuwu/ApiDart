
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/cliente_service.dart';

Router clienteRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ClienteService(connection);


  router.get('/api/clientes', (Request request) async {
    final cliente = await service.obtenerTodos();
    return Response.ok(
      jsonEncode(cliente.map((p) => p.toMap()).toList()),
      headers: {'content-type': 'application/json'},
    );
  });


  router.get('/api/clientes/<id>', (Request request, String id) async {
    final cliente = await service.obtenerPorId(int.parse(id));
    if (cliente == null) {
      return Response.notFound(jsonEncode({'error': 'cliente no encontrado'}));
    }
    return Response.ok(
      jsonEncode(cliente.toMap()),
      headers: {'content-type': 'application/json'},
    );
  });



  return router;
}
