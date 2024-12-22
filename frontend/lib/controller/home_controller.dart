import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs; // Observable index for the current tab

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
