import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vjti/conatants.dart';

class PayWithUpiId extends StatelessWidget {
  const PayWithUpiId({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter UPI ID or number",
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: null,
              style: const TextStyle(
                  color: subTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF6D6D6D)),
                ),
                labelText: "Enter UPI ID or number",
                labelStyle: const TextStyle(
                    color: subTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              onFieldSubmitted: (value) {},
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              child: TextButton(
                onPressed: () => {},
                style: TextButton.styleFrom(
                    backgroundColor: iconColor.withOpacity(0.5)),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
