import 'package:mysql_client/mysql_client.dart';

class ProductoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final productos = [
      {'categoria_id': 1, 'unidad_medida_id': 1, 'nombre': 'Laptop HP 15',      'precio': 850.00},
      {'categoria_id': 1, 'unidad_medida_id': 1, 'nombre': 'Mouse inalámbrico', 'precio': 25.50},
      {'categoria_id': 1, 'unidad_medida_id': 1, 'nombre': 'Teclado mecánico',  'precio': 75.00},
      {'categoria_id': 1, 'unidad_medida_id': 1, 'nombre': 'Monitor 24"',       'precio': 320.00},
      {'categoria_id': 1, 'unidad_medida_id': 1, 'nombre': 'Auriculares USB',   'precio': 45.99},
    ];

    for (final producto in productos) {
      await connection.execute(
        'INSERT INTO productos (categoria_id, unidad_medida_id, nombre, precio) '
        'VALUES (:categoria_id, :unidad_medida_id, :nombre, :precio)',
        producto,
      );
    }
    print('✓ ProductoSeeder: ${productos.length} productos insertados');
  }
}

