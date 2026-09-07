import 'package:untitled1/database/database.dart';
import 'package:untitled1/database/seeders/cliente_seeder.dart';

Future<void> main() async{
  print ('Iniciando seeders...');

  final connection = await Database.connect();
  try{

    await ClienteSeeder.run(connection);
    print('Seeders ejecutados correctamente.');
  }catch(e){
    print('Error al ejecutar seeders: $e');
  }finally{
    await connection.close();
  }

}