import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionDatabaseHelper {
  static final TransactionDatabaseHelper instance = TransactionDatabaseHelper._init();
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

    // await db.execute("drop table if exists transactions");
    await db.execute('''CREATE TABLE transactions (
      id $idType,
      receiverPhoneNumber $textType,
      senderPin $textType,
      receiverUpiId $textType,
      transactionId $textType,
      amount $intType,
      senderId $textType,
      receiverId $textType,
      message $textType,
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
    return await db.query('transactions');
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
}
