import 'package:mysql_client/mysql_client.dart';

class UnidadMedidaSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final unidades = [
      {'nombre': 'Unidad',     'abreviatura': 'Und'},
      {'nombre': 'Kilogramo',  'abreviatura': 'Kg'},
      {'nombre': 'Litro',      'abreviatura': 'L'},
      {'nombre': 'Metro',      'abreviatura': 'm'},
      {'nombre': 'Caja',       'abreviatura': 'Cj'},
      {'nombre': 'Docena',     'abreviatura': 'Doc'},
    ];

    for (final unidad in unidades) {
      await connection.execute(
        'INSERT IGNORE INTO unidades_medida (nombre, abreviatura) VALUES (:nombre, :abreviatura)',
        unidad,
      );
    }
    print('✓ UnidadMedidaSeeder: ${unidades.length} unidades insertadas');
  }
}
