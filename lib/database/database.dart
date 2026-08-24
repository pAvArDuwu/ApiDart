import 'package:mysql_client/mysql_client.dart';

class Database {
  static Future<MySQLConnection> connect() async {
    final connection = await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: '', // Changed to empty string commonly used for root locally, or keep as 'root' if user prefer
      databaseName: 'apidart',
    );
    await connection.connect();
    return connection;
  }
}
