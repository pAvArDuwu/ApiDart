import 'package:mysql_client/mysql_client.dart';
import '../models/cliente.dart';

class ClienteService {
  final MySQLConnection connection;

  ClienteService(this.connection);

  Future<List<Cliente>> obtenerTodos() async {
    final result = await connection.execute(
      'SELECT id, nombre, apellido, telefono, email FROM clientes ORDER BY id DESC',
    );
    return result.rows.map((row) => Cliente.fromMap(row.assoc())).toList();
  }

  Future<Cliente?> obtenerPorId(int id) async {
    final result = await connection.execute(
      'SELECT id, nombre, apellido, telefono, email FROM clientes WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) return null;
    return Cliente.fromMap(result.rows.first.assoc());
  }

  Future<IResultSet> crear(Cliente cliente) async {
    return await connection.execute(
      'INSERT INTO clientes (nombre, apellido, telefono, email) VALUES (:nombre, :apellido, :telefono, :email)',
      {
        'nombre': cliente.nombre,
        'apellido': cliente.apellido,
        'telefono': cliente.telefono,
        'email': cliente.email,
      },
    );
  }

  Future<IResultSet> actualizar(int id, Cliente cliente) async {
    return await connection.execute(
      'UPDATE clientes SET nombre = :nombre, apellido = :apellido, telefono = :telefono, email = :email WHERE id = :id',
      {
        'id': id,
        'nombre': cliente.nombre,
        'apellido': cliente.apellido,
        'telefono': cliente.telefono,
        'email':cliente.email,
      },
    );
  }

  Future<IResultSet> eliminar(int id) async {
    return await connection.execute(
      'DELETE FROM clientes WHERE id = :id',
      {'id': id},
    );
  }
}
