import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'hotel.dart';

class DatabaseHelper2 {
  static final DatabaseHelper2 _instance = DatabaseHelper2.internal();
  factory DatabaseHelper2() => _instance;

  late Database? _database;
  static final _databaseName = 'hotels.db';
  static final _databaseVersion = 2;

  static DatabaseHelper2 get instance => _instance;

  final String tableName = 'hotels';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnAddress = 'address';
  final String columnDescription = 'description';
  final String columnImage = 'image';
  final String columnRoomImages = 'roomImages';

  DatabaseHelper2.internal() {
    initDatabase().then((db) {
      _database = db;
    });
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Create or open the database at a given path
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        // Create the hotels table
        await db.execute('''
          CREATE TABLE $tableName(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnAddress TEXT NOT NULL,
            $columnDescription TEXT,
            $columnImage TEXT,
            $columnRoomImages TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Perform migration from oldVersion to newVersion
          // Add the "username" column to the "hotels" table
        }
      },
    );
  }

  Future<int> insertHotel(Hotel hotel) async {
    Database db = await database;
    return await db.insert(tableName, hotel.toMap());
  }

  Future<List<Hotel>> getHotels() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) => Hotel.fromMap(maps[index]));
  }

  Future<int> deleteHotel(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}


class Hotel {
  int? id;
  String name;
  String address;
  String description;
  String? image;
  List<String?>? roomImages;

  Hotel({
    this.id,
    required this.name,
    required this.address,
    required this.description,
    this.image,
    this.roomImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'image': image,
      'roomImages': roomImages?.join(','),
    };
  }

  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      description: map['description'],
      image: map['image'],
      roomImages: map['roomImages']?.split(','),
    );
  }
}
