import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/model/surah_response.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    // Initialize and open the database.
    final path = join(await getDatabasesPath(), 'hafiz_database.db');
    return openDatabase(path, version: 2, onCreate: _createTable);
  }

  static void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surah (
        id INTEGER PRIMARY KEY,
        chapter TEXT
      )
    ''');
  }

  Future<int> insertData(ChapterResponse data) async {
    return await _database!.insert('surah', data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ChapterResponse?> queryDataById(String surahId) async {
    var result = await _database!.query(
      'surah',
      where: 'id = ?',
      whereArgs: [surahId],
    );

    return handleQueryResult(result, surahId);
  }

  ChapterResponse? handleQueryResult(List<Map<String, dynamic>> result,
      String surahId) {
    if (result.isNotEmpty) {
      var surah = result.first;

      var jsonData = surah['chapter'];
      final List<dynamic> chapterList = json.decode(jsonData);
      final List<Chapter> chapters = chapterList
          .map((chapterJson) => Chapter.fromJson(chapterJson))
          .toList();

      return ChapterResponse(chapters: chapters, id: surahId);
    } else {
      return null;
    }
  }
}
