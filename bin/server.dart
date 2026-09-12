import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:untitled1/database/database.dart';
// Catálogos independientes
import 'package:untitled1/routes/routes_categoria.dart';
import 'package:untitled1/routes/routes_estado_compra.dart';
import 'package:untitled1/routes/routes_estado_venta.dart';
import 'package:untitled1/routes/routes_metodo_pago.dart';
import 'package:untitled1/routes/routes_tipo_movimiento.dart';
import 'package:untitled1/routes/routes_unidad_medida.dart';
// Entidades principales
import 'package:untitled1/routes/routes_cliente.dart';
import 'package:untitled1/routes/routes_producto.dart';
import 'package:untitled1/routes/routes_proveedor.dart';
// Transacciones
import 'package:untitled1/routes/routes_venta.dart';
import 'package:untitled1/routes/routes_compra.dart';
import 'package:untitled1/routes/routes_detalle_venta.dart';
import 'package:untitled1/routes/routes_detalle_compra.dart';
import 'package:untitled1/routes/routes_movimiento_inventario.dart';
import 'package:untitled1/routes/routes_pago.dart';

Future<void> main(List<String> args) async {
  final connection = await Database.connect();
  print('Conectado a MySQL — base de datos: api_dart');

  final router = Router();

  // Ruta raíz
  router.get('/', (Request request) => Response.ok('API Dart funcionando\n'));

  // ── Catálogos ──────────────────────────────────────────────────────────────
  router.mount('/', categoriaRoutes(connection).call);
  router.mount('/', estadoCompraRoutes(connection).call);
  router.mount('/', estadoVentaRoutes(connection).call);
  router.mount('/', metodoPagoRoutes(connection).call);
  router.mount('/', tipoMovimientoRoutes(connection).call);
  router.mount('/', unidadMedidaRoutes(connection).call);

  // ── Entidades principales ──────────────────────────────────────────────────
  router.mount('/', clienteRoutes(connection).call);
  router.mount('/', productoRoutes(connection).call);
  router.mount('/', proveedorRoutes(connection).call);

  // ── Transacciones ──────────────────────────────────────────────────────────
  router.mount('/', ventaRoutes(connection).call);
  router.mount('/', compraRoutes(connection).call);
  router.mount('/', detalleVentaRoutes(connection).call);
  router.mount('/', detalleCompraRoutes(connection).call);
  router.mount('/', movimientoInventarioRoutes(connection).call);
  router.mount('/', pagoRoutes(connection).call);

  // ── Documentación estática ─────────────────────────────────────────────────
  try {
    final staticHandler = createStaticHandler('public', defaultDocument: 'docs.html');
    router.mount('/docs', staticHandler.call);
  } catch (_) {
    // El directorio public puede no existir en desarrollo
  }

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  await serve(handler, InternetAddress.anyIPv4, port);
  print('Servidor en http://localhost:$port');
}
