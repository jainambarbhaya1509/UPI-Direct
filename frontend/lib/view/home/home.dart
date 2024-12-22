import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/home_controller.dart';
import 'package:vjti/view/home/accountManagement/account_management.dart';

import 'package:vjti/view/home/dashboard/vjti_dashboard.dart';
import 'package:vjti/view/home/transactionQueue/vjti_transaction_queue.dart';

class VjtiHomeScreem extends StatelessWidget {
  VjtiHomeScreem({super.key});

  final HomeController _controller = Get.put(HomeController());

  final List<Widget> body = [
    VjtiUPIDashboard(),
    VjtiTransactionQueue(),
    VjtiAccountManagement()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() => body[_controller.selectedIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _controller.selectedIndex.value,
        onTap: _controller.selectedIndex.call,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue),
            label: 'Queued',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
