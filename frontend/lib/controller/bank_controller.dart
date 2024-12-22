import 'package:get/get.dart';

class AccountManagementController extends GetxController {
  // Observable variable to track the selected index
  var selectedIndex = 0.obs;

  // List of bank accounts
  final List<Map<String, String>> bankAccounts = [
    {
      'bankName': 'Kotak Mahindra Bank',
      'accountNo': '1234567890',
      'image': 'https://www.psuconnect.in/sdsdsd/kotak_mahindra_bank_(1).jpg',
    },
  ];

  // Function to update the selected index
  void selectAccount(int index) {
    selectedIndex.value = index;
  }
}
