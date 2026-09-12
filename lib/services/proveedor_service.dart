import 'package:mysql_client/mysql_client.dart';
import '../models/proveedor.dart';

class ProveedorService {
  final MySQLConnection connection;

  ProveedorService(this.connection);

  Future<List<Proveedor>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, telefono, email, direccion, activo, created_at, updated_at '
      'FROM proveedores ORDER BY id DESC',
    );
    return result.rows.map((row) => Proveedor.fromMap(row.assoc())).toList();
  }

  Future<Proveedor?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, telefono, email, direccion, activo, created_at, updated_at '
      'FROM proveedores WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Proveedor.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? telefono,
    String? email,
    String? direccion,
    bool activo = true,
  }) {
    return connection.execute(
      'INSERT INTO proveedores (nombre, telefono, email, direccion, activo) '
      'VALUES (:nombre, :telefono, :email, :direccion, :activo)',
      {
        'nombre': nombre,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'activo': activo ? 1 : 0,
      },
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required String nombre,
    String? telefono,
    String? email,
    String? direccion,
    required bool activo,
  }) {
    return connection.execute(
      'UPDATE proveedores SET nombre = :nombre, telefono = :telefono, '
      'email = :email, direccion = :direccion, activo = :activo WHERE id = :id',
      {
        'id': id,
        'nombre': nombre,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'activo': activo ? 1 : 0,
      },
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'UPDATE proveedores SET activo = 0 WHERE id = :id',
      {'id': id},
    );
  }
}
