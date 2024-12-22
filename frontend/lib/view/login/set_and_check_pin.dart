import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/verify_controller.dart';
import 'package:vjti/db/db_pin.dart';
import 'package:vjti/view/home/home.dart';

class VjtiSetAndCheckPin extends StatelessWidget {
  const VjtiSetAndCheckPin({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = Get.put(PinController());

    return FutureBuilder<String?>(
      future: pinController.getHashedPin(),
      builder: (context, snapshot) {
        final existingHashedPin = snapshot.data;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingHashedPin == null
                      ? "Secure Your Accounts"
                      : "Enter Your PIN",
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  existingHashedPin == null
                      ? "Set a 6-digit PIN to secure your account"
                      : "Enter your 6-digit PIN to continue",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Pinput(
                    controller: verifyController.pinInputController,
                    defaultPinTheme: PinTheme(
                      textStyle: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white60,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    length: 6,
                    obscureText: true,
                    obscuringCharacter: "*",
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    final pin = verifyController.pinInputController.text;

                    if (pin.isEmpty || pin.length != 6) {
                      Get.snackbar(
                        "Error",
                        "Please enter a valid 6-digit PIN",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    if (existingHashedPin == null) {
                      // Set PIN if none exists
                      verifyController.setPin(pin);
                      await pinController.savePin(pin);
                      await pinController.setLoginState(true);
                      Get.snackbar("Success", "PIN has been set!",
                          snackPosition: SnackPosition.TOP);
                      Get.to(() => VjtiHomeScreem());
                    } else {
                      // Validate PIN
                      final isValid = await pinController.isPinValid(pin);
                      if (isValid==true) {
                        await pinController.setLoginState(true);
                        Get.snackbar("Success", "Login Successful",
                            snackPosition: SnackPosition.TOP);
                        Get.to(() => VjtiHomeScreem());
                      } else {
                        Get.snackbar("Error", "Incorrect PIN",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      existingHashedPin == null ? "Set PIN" : "Verify PIN",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
