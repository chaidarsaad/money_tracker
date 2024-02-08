import 'package:money_tracker/models/transaksi_model.dart';
import 'package:money_tracker/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'moneyTracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY,
        name TEXT NULL,
        type INTEGER,
        total INTEGER,
        createdAt TEXT NULL,
        updatedAt TEXT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NULL
      )
    ''');
  }

  Future<void> clearTransaksiTable() async {
    Database db = await database;
    await db.delete('transaksi');
  }

  Future<bool> isTransaksiTableEmpty() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT COUNT(*) as count FROM transaksi");
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<bool> isUserTableEmpty() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT COUNT(*) as count FROM user");
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('user', user.toMap());
  }

  Future<User?> getUser() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('user');

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update(
      'user',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // transaksi
  Future<List<Transaksi>> getAllTransactions() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      orderBy:
          'createdAt DESC', // Menambahkan orderBy untuk mengurutkan secara ascending
    );
    return List.generate(maps.length, (i) {
      return Transaksi.fromMap(maps[i]);
    });
  }

  Future<int> insertTransaksi(Transaksi transaksi) async {
    Database db = await database;
    return await db.insert('transaksi', transaksi.toMap());
  }

  Future<int> totalPemasukan() async {
    Database db = await database;
    List<Map<String, dynamic>> query = await db
        .rawQuery("SELECT SUM(total) as total FROM transaksi WHERE type = 1");

    int total = query.isNotEmpty ? query.first['total'] ?? 0 : 0;
    return total;
  }

  Future<int> totalPengeluaran() async {
    Database db = await database;
    List<Map<String, dynamic>> query = await db
        .rawQuery("SELECT SUM(total) as total FROM transaksi WHERE type = 2");

    int total = query.isNotEmpty ? query.first['total'] ?? 0 : 0;
    return total;
  }

  Future<int> deleteTransaksi(int id) async {
    Database db = await database;
    return await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTransaksi(Transaksi transaksi) async {
    Database db = await database;
    return await db.update(
      'transaksi',
      transaksi.toMap(),
      where: 'id = ?',
      whereArgs: [transaksi.id],
    );
  }

  // Metode untuk menghitung total pemasukan bulan ini
  Future<int> totalPemasukanBulanIni() async {
    Database db = await database;

    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    List<Map<String, dynamic>> query = await db.rawQuery(
      "SELECT SUM(total) as total FROM transaksi WHERE type = 1 AND createdAt BETWEEN ? AND ?",
      [firstDayOfMonth.toIso8601String(), lastDayOfMonth.toIso8601String()],
    );

    int total = query.isNotEmpty ? query.first['total'] ?? 0 : 0;
    return total;
  }

  // Metode untuk menghitung total pengeluaran bulan ini
  Future<int> totalPengeluaranBulanIni() async {
    Database db = await database;

    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    List<Map<String, dynamic>> query = await db.rawQuery(
      "SELECT SUM(total) as total FROM transaksi WHERE type = 2 AND createdAt BETWEEN ? AND ?",
      [firstDayOfMonth.toIso8601String(), lastDayOfMonth.toIso8601String()],
    );

    int total = query.isNotEmpty ? query.first['total'] ?? 0 : 0;
    return total;
  }

  Future<List<Transaksi>> getTransaksiBulanIni() async {
    Database db = await database;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      orderBy: 'createdAt DESC',
      where: 'createdAt BETWEEN ? AND ?',
      whereArgs: [
        firstDayOfMonth.toIso8601String(),
        lastDayOfMonth.toIso8601String()
      ],
    );

    return List.generate(maps.length, (i) {
      return Transaksi.fromMap(maps[i]);
    });
  }
}
