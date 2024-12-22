import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcards/sim_card.dart';
import 'package:simcards/simcards.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/transaction_queue_controller.dart';
import 'package:vjti/db/db_helper.dart';

class PayFromPhoneUpiController extends GetxController {
  TextEditingController pinController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();

  final RxString upiId = "".obs;
  final RxString phoneNumber = "".obs;
  final RxString amount = "".obs;
  final RxString pin = "".obs;

  // final RxString ussdCode = "*99*1*${bankcode}#".obs;
  String? ussdCode;

  @override
  void onInit() {
    super.onInit();
    ussdCode =
        "*99*${upiIdController.text}*${amountController.text}*${pinController.text}#";
  }

  final RxString mode = "UPI".obs;
  void toggleMode() {
    if (mode.value == "UPI") {
      payFromUpi();
    } else {
      payFromPhoneNumber();
    }
  }

  final RxList simCards = [].obs;

  Future<void> getSimCards() async {
    final simcards = Simcards();
    await simcards.requestPermission();
    bool permissionGranted = await simcards.hasPermission();
    if (permissionGranted) {
      List<SimCard> simCardList = await simcards.getSimCards();
      simCards.assignAll(simCardList);
    }
  }

  Future<void> payFromUpi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    upiId.value = upiIdController.text;
    phoneNumber.value = phoneNumberController.text;
    amount.value = amountController.text;
    pin.value = pinController.text;
    try {
      if (!(await isConnected())) {
        if (simCards.contains("Jio")) {
          Get.snackbar("Error", "SIM Card Not Supported for USSD",
              snackPosition: SnackPosition.TOP);
          final upiData = {
            "pin": pin.value,
            "receiver": upiId.value,
            "amount": amount.value,
            "timeInitiated": DateTime.now().toString(),
            "status": "Pending",
          };
          print("No internet connection");
          await TransactionDatabaseHelper.instance.insertTransaction(upiData);
          transactionController.loadTransactions();
          return;
        } else {
          try {
            await UssdAdvanced.sendUssd(code: ussdCode!);
          } catch (e) {
            print("Error occurred: $e");
          }
        }
      } else {
        final response = await Dio().post(
          "$baseUrl/api/transaction/executeTransaction",
          data: {
            "pin": "123455",
            "token": authToken,
            "receiver_upi_id": upiId.value,
            "amount": amount.value,
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          print("Online Payment successful");
          Get.back();
        } else {
          throw Exception("Failed to make payment: ${response.statusMessage}");
        }
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await Dio().get('https://google.com');
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> payFromPhoneNumber() async {
    upiId.value = upiIdController.text;
    phoneNumber.value = phoneNumberController.text;
    amount.value = amountController.text;
    pin.value = pinController.text;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print(token);
    if (!(await isConnected())) {
      if (simCards.contains("Jio")) {
        Get.snackbar("Error", "SIM Card Not Supported for USSD",
            snackPosition: SnackPosition.TOP);
        final phoneData = {
          "pin": pin.value.toString(),
          "receiver": phoneNumber.value,
          "amount": amount.value,
          "timeInitiated": DateTime.now().toString(),
          "status": "Pending",
        };
        print("No internet connection");
        await TransactionDatabaseHelper.instance.insertTransaction(phoneData);
        transactionController.loadTransactions();
        return;
      } else {
        try {
          await UssdAdvanced.sendUssd(code: ussdCode!);
        } catch (e) {
          print("Error occurred: $e");
        }
      }
    } else {
      try {
        final response = await Dio().post(
          "$baseUrl/api/transaction/payWithPhone",
          data: {
            "pin": "123455",
            "token": authToken,
            "amount": amount.value,
            "receiver_phone": phoneNumber.value.toString()
          },
        );
        print(response);
        if (response.statusCode == 200 && response.data != null) {
          print("Online Payment successful");
          Get.back();
        } else {
          print("Failed to make payment: ${response.statusMessage}");
        }
      } catch (e) {
        print("Error occurred: $e");
      }
    }
  }

  Future<void> processsPendingTransactions() async {
    final dbHelper = TransactionDatabaseHelper.instance;
    var storedTransactions = await dbHelper.fetchTransactions();

    for (var transaction in storedTransactions) {
      if (transaction['status'] == 'Pending') {
        if (transaction['receiver'].contains('@')) {
          var transactionJson = {
            'pin': transaction['pin'].toString(),
            'receiver': transaction['receiver'],
            'amount': transaction['amount']
          };
          Dio().post(
            "$baseUrl/api/transaction/executeTransaction",
            data: {
              "pin": transaction['pin'].toString(),
              "token": authToken,
              "receiver_upi_id": transaction['receiver'],
              "amount": transaction['amount'],
            },
          );
        } else {
          var transactionJson = {
            'pin': transaction['pin'].toString(),
            'receiver': transaction['receiver'],
            'amount': transaction['amount']
          };
          Dio().post(
            "$baseUrl/api/transaction/payWithPhone",
            data: {
              "pin": transaction['pin'].toString(),
              "token": authToken,
              "amount": transaction['amount'],
              "receiver_phone": transaction['receiver']
            },
          );
        }
        transactionController.updateTransactionStatus(
            transaction['id'], 'Processed');
      }
    }

    transactionController.loadTransactions();
  }
}

PayFromPhoneUpiController payFromPhoneUpiController =
    Get.put(PayFromPhoneUpiController());
