import 'package:mysql_client/mysql_client.dart';

class ProveedorSeeder {
  static Future<void> run(MySQLConnection connection) async {
    final proveedores = [
      {'nombre': 'TechSupply S.A.',    'telefono': '22001100', 'email': 'ventas@techsupply.com',  'direccion': 'Av. Industrial 123'},
      {'nombre': 'Importadora Global', 'telefono': '22002200', 'email': 'info@importglobal.com',  'direccion': 'Zona Franca, Lote 5'},
      {'nombre': 'Distribuidora Norte','telefono': '22003300', 'email': 'norte@distribuidora.com','direccion': 'Calle Norte 456'},
    ];

    for (final proveedor in proveedores) {
      await connection.execute(
        'INSERT INTO proveedores (nombre, telefono, email, direccion) VALUES (:nombre, :telefono, :email, :direccion)',
        proveedor,
      );
    }
    print('✓ ProveedorSeeder: ${proveedores.length} proveedores insertados');
  }
}
