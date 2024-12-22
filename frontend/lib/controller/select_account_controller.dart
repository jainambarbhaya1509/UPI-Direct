import 'package:get/get.dart';

class AccountController extends GetxController {
  // List of accounts
  final accounts = [
    'Kotak Mahindra Bank',
  ];

  // Set to manage selected accounts
  final selectedAccounts = <String>{}.obs;

  // Toggles account selection
  void toggleAccount(String account) {
    if (selectedAccounts.contains(account)) {
      selectedAccounts.remove(account);
    } else {
      selectedAccounts.add(account);
    }
  }
}