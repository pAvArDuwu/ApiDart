import 'package:mysql_client/mysql_client.dart';

class CategoriaSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final categorias = [
      {'nombre': 'Electrónica', 'descripcion': 'Dispositivos y componentes electrónicos'},
      {'nombre': 'Alimentos', 'descripcion': 'Productos alimenticios y bebidas'},
      {'nombre': 'Ropa', 'descripcion': 'Prendas de vestir y accesorios'},
      {'nombre': 'Hogar', 'descripcion': 'Artículos para el hogar'},
      {'nombre': 'Herramientas', 'descripcion': 'Herramientas y equipos de trabajo'},
    ];

    for (final cat in categorias) {
      await connection.execute(
        'INSERT IGNORE INTO categorias (nombre, descripcion) VALUES (:nombre, :descripcion)',
        cat,
      );
    }
    print('✓ CategoriaSeeder: ${categorias.length} categorías insertadas');
  }
}
