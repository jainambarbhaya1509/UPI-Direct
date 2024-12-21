import 'package:get/get.dart';
import 'package:vjti/controller/transaction_queue_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart' as connectivity_plus;


class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  bool isInternetAvailable = false;
  final TransactionController transactionController = Get.find();
  List<Map<String, dynamic>> transactionQueue = []; // Queue to store offline transactions

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  void startMonitoring() {
    connectivity_plus.Connectivity()
        .onConnectivityChanged
        .listen((connectivityResult) {
      isInternetAvailable =
          connectivityResult != connectivity_plus.ConnectivityResult.none;

      if (isInternetAvailable) {
        processPendingTransactions();
      } else {
        addToQueue(); // Add transactions to queue when offline
      }
    });
  }

  bool getIsInternetAvailable() {
    return isInternetAvailable;
  }

  void addToQueue() {
    var pendingTransactions = transactionController.transactions
        .where((txn) => txn['status'] == 'Pending')
        .toList();
    
    transactionQueue.addAll(pendingTransactions); // Add transactions to the queue
  }

  void processPendingTransactions() async {
    // Process all transactions from the queue after delay
    for (var transaction in transactionQueue) {
      await Future.delayed(Duration(seconds: 10)); // Delay of 10 seconds before processing each
      transactionController.updateTransactionStatus(transaction['id'], 'Processed');
      print("Processed Transaction ID: ${transaction['id']}");
    }

    transactionQueue.clear(); // Clear the queue after processing
  }
}
