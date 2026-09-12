import 'package:mysql_client/mysql_client.dart';

class EstadoCompraSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final estados = [
      {'nombre': 'pendiente',  'descripcion': 'Compra registrada, pendiente de aprobación'},
      {'nombre': 'aprobada',   'descripcion': 'Compra aprobada y en proceso'},
      {'nombre': 'recibida',   'descripcion': 'Mercancía recibida en almacén'},
      {'nombre': 'cancelada',  'descripcion': 'Compra cancelada'},
    ];

    for (final estado in estados) {
      await connection.execute(
        'INSERT IGNORE INTO estados_compra (nombre, descripcion) VALUES (:nombre, :descripcion)',
        estado,
      );
    }
    print('✓ EstadoCompraSeeder: ${estados.length} estados insertados');
  }
}
