import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/pay_from_phone_upi_controller.dart';
import 'package:vjti/db/db_helper.dart';

class TransactionController extends GetxController {
  var transactions = <Map<dynamic, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void loadTransactions() async {
    try {
      final dbHelper = TransactionDatabaseHelper.instance;
      var storedTransactions = await dbHelper.fetchTransactions();
      if (storedTransactions.isNotEmpty) {
        transactions.assignAll(storedTransactions);
      } else {
        transactions.clear();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load transactions: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void updateTransactionStatus(int id, String status) async {
    try {
      final dbHelper = TransactionDatabaseHelper.instance;
      await dbHelper.updateTransactionStatus(id, status);
      loadTransactions();
      Get.snackbar("Success", "Transaction status updated",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to update status: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    try {
      final dbHelper = TransactionDatabaseHelper.instance;
      final sanitizedRow = {
        'pin': row['pin'] ?? '',
        'receiver': row['receiver'] ?? '',
        'amount': row['amount'] ?? 0,
        'timeInitiated': row['timeInitiated'] ?? DateTime.now().toString(),
        'status': row['status'] ?? 'Pending',
      };
      return await dbHelper.insertTransaction(sanitizedRow);
    } catch (e) {
      Get.snackbar("Error", "Failed to insert transaction: $e",
          snackPosition: SnackPosition.BOTTOM);
      return -1;
    }
  }

  Future<void> processTransaction() async {
    try {
      final dbHelper = TransactionDatabaseHelper.instance;
      var storedTransactions = await dbHelper.fetchTransactions();

      for (var transaction in storedTransactions) {
        var transactionJson = {
          'pin': transaction['pin'].toString(),
          'receiver': transaction['receiver'],
          'amount': transaction['amount']
        };
        transactions.add(transactionJson);
      }

      loadTransactions();
    } catch (e) {
      Get.snackbar("Error", "Failed to process transactions: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

TransactionController transactionController = Get.put(TransactionController());
