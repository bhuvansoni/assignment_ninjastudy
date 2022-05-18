import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/conversation_model.dart';

class DatabaseService {
  static late Database _database;
  static const String _tableName = 'conversation';
  static _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), 'conversation_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, topic TEXT, lastConversation INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<int> insertConversation(ConversationModel data) async {
    print(data.toMap());
    await _initDatabase();
    return _database.insert(
      _tableName,
      data.toMap(),
    );
  }

  static Future<List<ConversationModel>> conversations() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database.query(_tableName);
    print(maps);
    return List.generate(
      maps.length,
      (index) {
        return ConversationModel.fromMap(maps[index]);
      },
    );
  }

  static Future<int> updateConversation(int lastConversation, int id) async {
    await _initDatabase();
    return _database.update(
        _tableName,
        {
          'lastConversation': lastConversation,
        },
        where: 'id=?',
        whereArgs: [id]);
  }

  static Future<int> deleteConversation(int id) async {
    await _initDatabase();
    return _database.delete(_tableName, where: 'id=?', whereArgs: [id]);
  }

  static Future<int> deleteConversations() async {
    await _initDatabase();
    return _database.delete(_tableName);
  }
}
