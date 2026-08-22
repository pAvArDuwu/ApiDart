import 'package:mysql_client/mysql_client.dart';

class Database {

  static future<MySQLConnection> connect() async {
     final conneection= await MySQLConnection.createConnection.createConnection(
       host: '127.0.0.1',
       port: 3306,
       userName: 'root',
       password: 'root',
       databaseName: 'apidart',
     );
    await connection.connect();
    return connection;
  }
}