
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gamequizzapp/src/database/app_database.dart';

class LoginDAO{
  static const String _table = 'login';
  static const String _accessToken = 'access_token';
  static const String _username = 'username';
  static const String _password = 'password';
  static const String _expiresIn = 'expires_in';
  static const String _dateTimeInsertion = 'dateTimeInsertion';
  static const String tableSql = 'CREATE TABLE $_table('
      '$_accessToken TEXT,'
      '$_expiresIn TEXT,'
      '$_username TEXT,'
      '$_password TEXT,'
      '$_dateTimeInsertion TEXT)';

  Future<int> insertTokenLocal(String accessToken, String username, String password, int expiresIn, String dateTimeInsertion) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> tokenMap = {};
    tokenMap[_accessToken] = accessToken;
    tokenMap[_expiresIn] = expiresIn;
    tokenMap[_dateTimeInsertion] = dateTimeInsertion;
    tokenMap[_username] = username;
    tokenMap[_password] = password;
    return db.insert(_table, tokenMap);
  }

  Future<List<String>> findTokenLocal() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_table);
    List<String> results = [];
    for (Map<String, dynamic> row in result) {
      results.add(row['access_token']);
      results.add(row['expires_in']);
      results.add(row['dateTimeInsertion']);
      results.add(row['username']);
      results.add(row['password']);
    }
    return results;
  }

  Future<int> deleteTokenLocal() async {
    final Database db = await getDatabase();
    return db.delete(_table);
  }

}