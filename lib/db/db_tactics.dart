import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Tactics{
  static const databaseName = 'tactics';
  final int recId;
  final String title;
  final String course;
  final String spin;

  Tactics({
    required this.recId,
    required this.title,
    required this.course,
    required this.spin,
  }); 
  
  Map<String, dynamic> toMap(){
    return {
      'title':title,
      'course':course,
      'spin':spin,
    };
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(),databaseName+'.db'),
      onCreate: (db,version){
        return db.execute(
          "CREATE TABLE tactics(recId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, course TEXT, spin TEXT)",
        );
      },
      version: 1,
    );
    return _database;
  }

  /// 全てのデータ取得
  static Future<List<Tactics>> getDatas() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(databaseName);
    return List.generate(maps.length,(i){
      return Tactics(
        recId: maps[i]['recId'],
        title: maps[i]['title'],
        course: maps[i]['course'],
        spin:maps[i]['spin']
      );
    });
  }

  /// 特定のデータ取得
  static Future<List<Tactics>> getData(int recId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(databaseName,where: "recId=?",whereArgs:[recId]);
    return List.generate(maps.length,(i){
      return Tactics(
        recId: maps[i]['recId'],
        title: maps[i]['title'],
        course: maps[i]['course'],
        spin:maps[i]['spin']
      );
    });
  }

  /// データ挿入
  /// @param Note データモデル
  static Future<void> insertData(Tactics data) async {
    final Database db = await database;
    await db.insert(
      databaseName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// データ更新
  /// @param recId レコードID
  /// @param data データモデル
  static void update(int recId,Tactics data) async{
    final Database db = await database;
    await db.update(
      databaseName,
      data.toMap(),
      where:"recId=?",
      whereArgs: [recId],
    );
  }

  /// データ削除
  /// @param recId レコードID
  static Future<void> deleteData(int recId) async {
    final db = await database;
    await db.delete(
      databaseName,
      where: "recId = ?",
      whereArgs: [recId],
    );
  }
}
