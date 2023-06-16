import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper3 {
  static final _databaseName = 'restoran_menu.db';
  static final _databaseVersion = 1;

  static final tableRestoran = 'restoran';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnAddress = 'address';
  static final columnDescription = 'description';
  static final columnImage = 'image';

  static final tableMenu = 'menu';
  static final columnMenuId = 'menu_id';
  static final columnRestoranId = 'restoran_id';
  static final columnMenuName = 'menu_name';
  static final columnMenuDescription = 'menu_description';
  static final columnMenuImage = 'menu_image';

  static Database? _database;

  DatabaseHelper3._privateConstructor();
  static final DatabaseHelper3 instance = DatabaseHelper3._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final fullPath = join(path, _databaseName);
    return await openDatabase(fullPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableRestoran (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnAddress TEXT,
        $columnDescription TEXT,
        $columnImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMenu (
        $columnMenuId INTEGER PRIMARY KEY,
        $columnRestoranId INTEGER,
        $columnMenuName TEXT,
        $columnMenuDescription TEXT,
        $columnMenuImage TEXT,
        FOREIGN KEY ($columnRestoranId) REFERENCES $tableRestoran ($columnId)
      )
    ''');
  }

  Future<int> insertRestoran(Map<String, dynamic> restoran) async {
    final db = await instance.database;
    return await db.insert(tableRestoran, restoran);
  }

  Future<int> insertMenu(Map<String, dynamic> menu) async {
    final db = await instance.database;
    return await db.insert(tableMenu, menu);
  }

  Future<List<Map<String, dynamic>>> getAllRestorans() async {
    final db = await instance.database;
    return await db.query(tableRestoran);
  }

  Future<List<Map<String, dynamic>>> getMenusForRestoran(int restoranId) async {
    final db = await instance.database;
    return await db.query(tableMenu,
        where: '$columnRestoranId = ?', whereArgs: [restoranId]);
  }

  Future<int> deleteRestoran(int restoranId) async {
    final db = await instance.database;
    return await db.delete(tableRestoran,
        where: '$columnId = ?', whereArgs: [restoranId]);
  }

  Future<int> deleteMenu(int menuId) async {
    final db = await instance.database;
    return await db.delete(tableMenu, where: '$columnMenuId = ?', whereArgs: [menuId]);
  }
}
