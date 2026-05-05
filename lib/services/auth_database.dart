import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class AuthDatabase {
  AuthDatabase._();
  static final AuthDatabase instance = AuthDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<bool> signUp(String email, String password) async {
    final db = await database;
    final hashedPassword = password.hashCode.toString();

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );

    if (existing.isNotEmpty) return false;

    await db.insert('users', {
      'email': email.trim().toLowerCase(),
      'password': hashedPassword,
      'name': '',
    });

    return true;
  }

  Future<bool> signIn(String email, String password) async {
    final db = await database;
    final hashedPassword = password.hashCode.toString();

    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), hashedPassword],
    );

    return results.isNotEmpty;
  }

  Future<String?> getUserName(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      columns: ['name'],
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    if (results.isNotEmpty) {
      return results.first['name'] as String?;
    }
    return null;
  }
}
