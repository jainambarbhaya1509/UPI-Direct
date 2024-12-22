import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcrypt/bcrypt.dart';

class PinController extends GetxController {
  // Save hashed pin
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    // Hash the pin with bcrypt using 10 rounds
    final hashedPin = BCrypt.hashpw(pin, BCrypt.gensalt(logRounds: 10));
    await prefs.setString('user_pin', hashedPin);
  }

  // Get hashed pin
  Future<String?> getHashedPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_pin');
  }

  // Validate the pin
  Future<bool> isPinValid(String pin) async {
    print(pin);
    print(await getHashedPin());
    final storedHashedPin = await getHashedPin();
    if (storedHashedPin == null) {
      return false;
    }
    // Compare the provided pin with the stored hashed pin
    return BCrypt.checkpw(pin, storedHashedPin);
  }

  // Set login state
  Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    print('Login state set to: $isLoggedIn'); // Debugging line
  }

  // Get login state
  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    print('Login state fetched: $isLoggedIn'); // Debugging line
    return isLoggedIn;
  }
}
