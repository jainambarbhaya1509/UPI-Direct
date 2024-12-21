import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/verify_controller.dart';
import 'package:vjti/view/login/select_accounts.dart';

class VjtiLogin extends StatelessWidget {
  const VjtiLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Aadhar Number',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
                controller: verifyController.aadharNumber,
                maxLength: 12,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6D6D6D)),
                  ),
                  hintText: 'XXXX XXXX XXXX 0000',
                  hintStyle: GoogleFonts.inter(
                    color: Color(0XFF6D6D6D),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                )),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  minimumSize: const Size(0, 50),
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  textStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  verifyController
                      .createUser(verifyController.aadharNumber.text);
                  Get.to(() => VjtiSelectAccounts());
                },
                child: const Text('Link Accounts'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
