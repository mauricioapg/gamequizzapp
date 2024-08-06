import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gamequizzapp/src/database/dao/login_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'quizzgame.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(LoginDAO.tableSql);
  }, version: 1,
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}