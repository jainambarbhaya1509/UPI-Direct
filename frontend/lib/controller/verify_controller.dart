import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/db/db_pin.dart';
import 'package:vjti/view/home/home.dart';

class VerifyController extends GetxController {
  // RxString aadharNumber = "".obs;
  TextEditingController aadharNumber = TextEditingController();
  TextEditingController pinInputController = TextEditingController();
  final pinController = Get.put(PinController());

  Future<void> createUser(String aadharNumber) async {
    try {
      final response = await Dio().post(
        "$baseUrl/api/auth/createUser",
        data: {"vid": aadharNumber},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Assuming response.data contains JSON data
        final data = response.data;

        // Store the response data in shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('vid', data['vid'] ?? '');
        prefs.setString('name', data['name'] ?? '');
        prefs.setString('email', data['email'] ?? '');
        prefs.setString('phone_number', data['phone_number'] ?? '');
        prefs.setBool('valid', data['valid'] ?? false);
        prefs.setString('token', data['token'] ?? '');

        print("User data saved to shared preferences");
      } else {
        print("Failed to create user: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await Dio().post(
        "$baseUrl/api/auth/setPin",
        data: {"token": token, "pin": pin},
      );
      print(response);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('upi_id', data['user']["upi_id"] ?? '');
        Get.snackbar("Success", "PIN has been set!",
            snackPosition: SnackPosition.TOP);
        await pinController.savePin(pin);
        await pinController.setLoginState(true);
        Get.to(() => VjtiHomeScreem());
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> validateUser(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final pin = prefs.getString("user_pin");
    final response = Dio().post("$baseUrl/api/auth/validateUser",
        data: {"pin": pin, "token": token});
    print(response);
  }
}

VerifyController verifyController = Get.put(VerifyController());
