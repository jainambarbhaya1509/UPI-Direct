import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionDatabaseHelper {
  static final TransactionDatabaseHelper instance =
      TransactionDatabaseHelper._init();
  static Database? _database;

  TransactionDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''CREATE TABLE transactions (
      id $idType,
      pin $textType,
      receiver $textType,
      amount $intType,
      timeInitiated $textType,
      status $textType
    )''');
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
  final db = await instance.database;
  final result = await db.query('transactions');

  return result.map((transaction) {
    return {
      'id': transaction['id'] ?? 0,
      'pin': transaction['pin'] ?? '',
      'receiver': transaction['receiver'] ?? '',
      'amount': transaction['amount'] ?? 0,
      'timeInitiated': transaction['timeInitiated'] ?? '',
      'status': transaction['status'] ?? 'Pending',
    };
  }).toList();
}


  Future<int> updateTransactionStatus(int id, String status) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;

    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
