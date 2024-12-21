import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinController extends GetxController {
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', pin);
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_pin');
  }

  Future<bool> isPinValid(String pin) async {
    final storedPin = await getPin();
    return storedPin == pin;
  }

  Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    print('Login state set to: $isLoggedIn'); // Debugging line
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    print('Login state fetched: $isLoggedIn'); // Debugging line
    return isLoggedIn;
  }
}
