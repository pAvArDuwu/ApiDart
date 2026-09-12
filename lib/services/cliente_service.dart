import 'package:mysql_client/mysql_client.dart';
import '../models/cliente.dart';

class ClienteService {
  final MySQLConnection connection;

  ClienteService(this.connection);

  Future<List<Cliente>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, apellido, telefono, email, created_at, updated_at '
      'FROM clientes ORDER BY id DESC',
    );
    return result.rows.map((row) => Cliente.fromMap(row.assoc())).toList();
  }

  Future<Cliente?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, apellido, telefono, email, created_at, updated_at '
      'FROM clientes WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Cliente.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear({
    required String nombre,
    String? apellido,
    String? telefono,
    String? email,
  }) {
    return connection.execute(
      'INSERT INTO clientes (nombre, apellido, telefono, email) '
      'VALUES (:nombre, :apellido, :telefono, :email)',
      {'nombre': nombre, 'apellido': apellido, 'telefono': telefono, 'email': email},
    );
  }

  Future<IResultSet> actualizar({
    required int id,
    required String nombre,
    String? apellido,
    String? telefono,
    String? email,
  }) {
    return connection.execute(
      'UPDATE clientes SET nombre = :nombre, apellido = :apellido, '
      'telefono = :telefono, email = :email WHERE id = :id',
      {'id': id, 'nombre': nombre, 'apellido': apellido, 'telefono': telefono, 'email': email},
    );
  }

  Future<IResultSet> eliminar(int id) {
    return connection.execute(
      'DELETE FROM clientes WHERE id = :id',
      {'id': id},
    );
  }
}
