import 'package:mysql_client/mysql_client.dart';

class MetodoPagoSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final metodos = [
      {'nombre': 'Efectivo',       'descripcion': 'Pago en efectivo'},
      {'nombre': 'Tarjeta crédito','descripcion': 'Pago con tarjeta de crédito'},
      {'nombre': 'Tarjeta débito', 'descripcion': 'Pago con tarjeta de débito'},
      {'nombre': 'Transferencia',  'descripcion': 'Transferencia bancaria'},
      {'nombre': 'QR',             'descripcion': 'Pago mediante código QR'},
    ];

    for (final metodo in metodos) {
      await connection.execute(
        'INSERT IGNORE INTO metodos_pago (nombre, descripcion) VALUES (:nombre, :descripcion)',
        metodo,
      );
    }
    print('✓ MetodoPagoSeeder: ${metodos.length} métodos insertados');
  }
}
