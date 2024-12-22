import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vjti/conatants.dart';

import '../../../controller/bank_controller.dart';

class VjtiAccountManagement extends StatelessWidget {
  const VjtiAccountManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountManagementController controller =
        Get.put(AccountManagementController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account Management",
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              itemCount: controller.bankAccounts.length,
              itemBuilder: (context, index) {
                final bank = controller.bankAccounts[index];
                bool isSelected = index == controller.selectedIndex.value;

                return GestureDetector(
                  onTap: () => controller.selectAccount(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.network(
                            bank['image']!,
                            scale: 1.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bank['bankName']!,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Account No: ${bank['accountNo']}",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
