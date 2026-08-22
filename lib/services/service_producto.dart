import 'package:mysql_client/mysql_client.dart';


class ProductoService{

  final MySQLConnection connection;

  ProductoService(this.connection);

  Future<IResultSet>obteberTodos() async{

    return await connection.execute(
      'SELECT id, nombre, precio FROM productos ORDER BY id DESC',
    );
  }
}