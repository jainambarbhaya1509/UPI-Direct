import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vjti/controller/contacts_controller.dart';
import 'package:vjti/controller/transaction_queue_controller.dart';
import 'package:vjti/db/db_pin.dart';
import 'package:vjti/service/connectivity_service.dart';
import 'package:vjti/view/login/login.dart';
import 'package:vjti/view/login/set_and_check_pin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter engine is initialized
  Get.put(TransactionController());
  final pinController = Get.put(PinController());
  // Wait for SharedPreferences and fetch login state
  final isLoggedIn = await pinController.getLoginState();
  print("Is Logged In: $isLoggedIn");

  ConnectivityService().startMonitoring();

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactController());
    return GetMaterialApp(
      title: 'VJTI Hackathon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: isLoggedIn ? VjtiSetAndCheckPin() : VjtiLogin(),
    );
  }
}
