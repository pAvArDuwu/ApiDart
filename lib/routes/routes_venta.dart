import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/venta.dart';
import '../services/venta_service.dart';

Router ventaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = VentaService(connection);

  router.post('/api/ventas', (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final detalles = (body['detalles'] as List<dynamic>? ?? []).map((
        detalle,
      ) {
        final item = detalle as Map<String, dynamic>;
        return DetalleVentaInput(
          productoId: int.parse(item['producto_id'].toString()),
          cantidad: int.parse(item['cantidad'].toString()),
        );
      }).toList();

      final venta = await service.registrar(
        clienteId: int.parse(body['cliente_id'].toString()),
        detalles: detalles,
      );
      return Response(
        201,
        body: jsonEncode(venta.toMap()),
        headers: {'content-type': 'application/json'},
      );
    } on ArgumentError catch (error) {
      return Response.badRequest(
        body: jsonEncode({'error': error.message}),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(
        body: jsonEncode({'error': 'El cuerpo de la solicitud no es válido'}),
        headers: {'content-type': 'application/json'},
      );
    } on StateError catch (error) {
      return Response(
        409,
        body: jsonEncode({'error': error.message}),
        headers: {'content-type': 'application/json'},
      );
    }
  });

  return router;
}
