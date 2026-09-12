import 'package:mysql_client/mysql_client.dart';

class ClienteSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final clientes = [
      {'nombre': 'Pedro', 'apellido': 'García', 'telefono': '68001111', 'email': 'pedro.garcia@example.com'},
      {'nombre': 'María', 'apellido': 'López', 'telefono': '68002222', 'email': 'maria.lopez@example.com'},
      {'nombre': 'Carlos', 'apellido': 'Rodríguez', 'telefono': '68003333', 'email': 'carlos.rodriguez@example.com'},
      {'nombre': 'Ana', 'apellido': 'Martínez', 'telefono': '68004444', 'email': 'ana.martinez@example.com'},
      {'nombre': 'Luis', 'apellido': 'Sánchez', 'telefono': '68005555', 'email': 'luis.sanchez@example.com'},
    ];

    for (final cliente in clientes) {
      await connection.execute(
        'INSERT INTO clientes (nombre, apellido, telefono, email) VALUES (:nombre, :apellido, :telefono, :email)',
        cliente,
      );
    }
    print('✓ ClienteSeeder: ${clientes.length} clientes insertados');
  }
}