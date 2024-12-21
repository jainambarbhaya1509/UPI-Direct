import 'package:get/get.dart';
import 'package:vjti/db/db_helper.dart';

class TransactionController extends GetxController {
  var transactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void loadTransactions() async {
    final dbHelper = TransactionDatabaseHelper.instance;
    var storedTransactions = await dbHelper.fetchTransactions();
    transactions.assignAll(storedTransactions);
  }

  void updateTransactionStatus(int id, String status) async {
    final dbHelper = TransactionDatabaseHelper.instance;
    await dbHelper.updateTransactionStatus(id, status);
    loadTransactions(); 
  }
}
