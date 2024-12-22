import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vjti/conatants.dart';
import 'package:vjti/controller/pay_from_phone_upi_controller.dart';
import 'package:vjti/view/home/dashboard/verify_pin_for_transaction.dart';

class VjtiEnterAmount extends StatelessWidget {
  const VjtiEnterAmount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Payment to\nXXXX XXXX XXXX 3456",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  maxLines: null,
                  focusNode: FocusNode()..requestFocus(),
                  controller: payFromPhoneUpiController.amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: subTextColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: subTextColor,
                      size: 50,
                    ),
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: const TextStyle(
                      color: subTextColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => VjtiVerifyPinForTransaction()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    minimumSize: const Size(0, 50),
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text('Pay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
