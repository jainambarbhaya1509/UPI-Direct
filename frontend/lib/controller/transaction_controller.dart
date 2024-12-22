import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:vjti/conatants.dart';

class AllTransactionController extends GetxController {
  final transactions = [].obs;
  Future<void> fetchTransactions() async {
  try {
    final response = await Dio().get(
      "$baseUrl/api/transaction/transactionStatement/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjEyMzQ1Njc4OTAxMiIsImlhdCI6MTczNDc1OTk4NywiZXhwIjoxNzM3MzUxOTg3fQ.sBHnxTIvhUBl0csrkt--IntqlQKorOGEY61O3K5sEq8",
    );
    print(response);
    if (response.statusCode == 200 && response.data != null) {
      transactions.assignAll(response.data["transactions"]);
    
    } else {
      print("Failed to fetch UPI ID: ${response.statusMessage}");
    }
  } catch (e) {
    print("Error occurred while fetching UPI ID: $e");
  }
}
}



AllTransactionController allTransactionController = Get.put(AllTransactionController());
