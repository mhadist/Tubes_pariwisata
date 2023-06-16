import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper4 {
  static final DatabaseHelper4 _instance = DatabaseHelper4.internal();
  factory DatabaseHelper4() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  DatabaseHelper4.internal();

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'galeri.db');

    // Membuka database atau membuat baru jika belum ada
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE galeri (id INTEGER PRIMARY KEY, imagePath TEXT)',
        );
      },
    );
  }

  Future<void> insertImage(String imagePath) async {
    Database db = await database;
    await db.insert('galeri', {'imagePath': imagePath});
  }

  Future<List<String>> getImages() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('galeri');
    return List.generate(maps.length, (index) {
      return maps[index]['imagePath'] as String;
    });
  }

  Future<void> deleteImage(int id) async {
    Database db = await database;
    await db.delete('galeri', where: 'id = ?', whereArgs: [id]);
  }
}