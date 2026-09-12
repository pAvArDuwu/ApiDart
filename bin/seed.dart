import 'package:untitled1/database/database.dart';
import 'package:untitled1/database/seeders/categoria_seeder.dart';
import 'package:untitled1/database/seeders/cliente_seeder.dart';
import 'package:untitled1/database/seeders/estado_compra_seeder.dart';
import 'package:untitled1/database/seeders/estado_venta_seeder.dart';
import 'package:untitled1/database/seeders/metodo_pago_seeder.dart';
import 'package:untitled1/database/seeders/tipo_movimiento_seeder.dart';
import 'package:untitled1/database/seeders/unidad_medida_seeder.dart';
import 'package:untitled1/database/seeders/producto_seeder.dart';
import 'package:untitled1/database/seeders/proveedor_seeder.dart';

Future<void> main() async {
  print('=== Iniciando Seeders ===');

  final connection = await Database.connect();

  try {
    // Orden correcto: catálogos sin FK primero
    await CategoriaSeeder.run(connection);
    await ClienteSeeder.run(connection);
    await EstadoCompraSeeder.run(connection);
    await EstadoVentaSeeder.run(connection);
    await MetodoPagoSeeder.run(connection);
    await TipoMovimientoSeeder.run(connection);
    await UnidadMedidaSeeder.run(connection);
    // Luego tablas con dependencias
    await ProductoSeeder.run(connection);
    await ProveedorSeeder.run(connection);

    print('\n=== Seeders completados correctamente ===');
  } catch (e) {
    print('Error al ejecutar seeders: $e');
  } finally {
    await connection.close();
  }
}