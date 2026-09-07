import 'package:mysql_client/mysql_client.dart';

class ClienteSeeder {
  static Future <void> run(MySQLConnection connection) async{

    await connection.execute(
        'INSERT INTO clientes (nombre, apellido, telefono, email) VALUES (:nombre, :apellido, :telefono, :email)',
        {
          'nombre':'Pedro',
          'apellido':'Pepo',
          'telefono':68007833,
          'email':'pedro.pepo@example.com',
        }
    );

    await connection.execute(
        'INSERT INTO clientes (nombre, apellido, telefono, email) VALUES (:nombre, :apellido, :telefono, :email)',
        {
          'nombre':'Pedro',
          'apellido':'Pepa Pig',
          'telefono':68007893,
          'email':'pepa.pig@example.com',
        }
    );

    print('Clientes creados');
  }
}