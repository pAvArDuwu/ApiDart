import 'package:mysql_client/mysql_client.dart';

class EstadoVentaSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final estados = [
      {'nombre': 'pendiente',  'descripcion': 'Venta pendiente de pago'},
      {'nombre': 'pagada',     'descripcion': 'Venta pagada completamente'},
      {'nombre': 'cancelada',  'descripcion': 'Venta cancelada'},
    ];

    for (final estado in estados) {
      await connection.execute(
        'INSERT IGNORE INTO estados_venta (nombre, descripcion) VALUES (:nombre, :descripcion)',
        estado,
      );
    }
    print('✓ EstadoVentaSeeder: ${estados.length} estados insertados');
  }
}
