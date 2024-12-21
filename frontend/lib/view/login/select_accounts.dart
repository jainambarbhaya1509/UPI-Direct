import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vjti/conatants.dart';

import '../../controller/select_account_controller.dart';
import 'set_and_check_pin.dart';

class VjtiSelectAccounts extends StatelessWidget {
  const VjtiSelectAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.put(AccountController());

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          margin: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Accounts',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: controller.accounts.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            onTap: () {
                              controller
                                  .toggleAccount(controller.accounts[index]);
                            },
                            title: Text(
                              controller.accounts[index],
                              style: GoogleFonts.inter(
                                color: controller.selectedAccounts
                                        .contains(controller.accounts[index])
                                    ? Colors.white
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Icon(
                              controller.selectedAccounts
                                      .contains(controller.accounts[index])
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: Colors.white,
                            ),
                          ),
                        );
                      });
                    }),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () => Get.to(() => VjtiSetAndCheckPin()),
                  child: const Text('Link Accounts'),
                ),
              ),
            ],
          ),
        ));
  }
}
