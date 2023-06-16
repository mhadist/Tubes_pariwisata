import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;
  static final _databaseName = 'my_app.db';
  static final _databaseVersion = 2;

  // Add the 'instance' getter
  static DatabaseHelper get instance => _instance;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Create or open the database at a given path
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        // Create the users table
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            password TEXT,
            role INTEGER
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Perform migration from oldVersion to newVersion
          // Add the "username" column to the "users" table
          await db.execute('ALTER TABLE users ADD COLUMN username TEXT');
          await db.execute('ALTER TABLE users ADD COLUMN role INTEGER');
        }
      },
    );
  }

  // User operations

  Future<int> createUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final dbClient = await db;
    final list = await dbClient.query('users', where: 'email = ?', whereArgs: [email]);

    if (list.isEmpty) {
      return null;
    }

    return User.fromMap(list.first);
  }

  Future<int> saveUser(User user) async {
    final dbClient = await db;
    if (user.id != null) {
      // Update existing user
      return await dbClient.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    } else {
      // Insert new user
      return await dbClient.insert('users', user.toMap());
    }
  }
}

class User {
  int? id;
  String username;
  String email;
  String password;
  UserRole role;

  User({this.id, required this.username, required this.email, required this.password, required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role.index,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      role: UserRole.values[map['role']],
    );
  }
}

enum UserRole { hotelOwner, restaurantOwner, customer, admin }
