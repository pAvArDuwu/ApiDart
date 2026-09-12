import 'package:mysql_client/mysql_client.dart';

class TipoMovimientoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final tipos = [
      {'nombre': 'Entrada',          'descripcion': 'Ingreso de mercancía al inventario',  'signo': 1},
      {'nombre': 'Salida por venta', 'descripcion': 'Salida de mercancía por venta',       'signo': -1},
      {'nombre': 'Ajuste positivo',  'descripcion': 'Ajuste manual positivo de inventario','signo': 1},
      {'nombre': 'Ajuste negativo',  'descripcion': 'Ajuste manual negativo de inventario','signo': -1},
      {'nombre': 'Devolución',       'descripcion': 'Devolución de mercancía',             'signo': 1},
    ];

    for (final tipo in tipos) {
      await connection.execute(
        'INSERT IGNORE INTO tipos_movimiento (nombre, descripcion, signo) VALUES (:nombre, :descripcion, :signo)',
        tipo,
      );
    }
    print('✓ TipoMovimientoSeeder: ${tipos.length} tipos insertados');
  }
}
