import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/banking_service.dart';
import 'package:vjti/controller/pay_from_phone_upi_controller.dart';
import 'package:vjti/controller/qr_controller.dart';
import 'package:vjti/controller/transaction_controller.dart';
import 'package:vjti/controller/transaction_queue_controller.dart';
import 'package:vjti/view/home/dashboard/chatbot.dart';
import 'package:vjti/view/home/dashboard/pay_from_contacts.dart';
import 'package:vjti/view/home/dashboard/pay_with_phone_number.dart';
import 'package:vjti/view/home/dashboard/pay_with_qr.dart';
import 'package:vjti/view/home/dashboard/pay_with_upi_id.dart';
import 'package:vjti/view/home/dashboard/transactions.dart';

class VjtiUPIDashboard extends StatelessWidget {
  const VjtiUPIDashboard({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    // Request permission
    var status = await Permission.phone.request();
    if (status.isGranted) {
      await launchUrl(launchUri);
    } else {
      // Handle the case where the permission is not granted
      print('Phone call permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(left: 20, top: 50, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "ProPay",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                ConnectivityBuilder(builder: (context, isConnected, status) {
                  if (isConnected == true &&
                      status != ConnectivityStatus.none) {
                    payFromPhoneUpiController.processsPendingTransactions();
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: isConnected == true ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isConnected == true ? "online" : "offline",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: status != ConnectivityStatus.none
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: null,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                hintText: 'Search phone number or UPI ID',
                hintStyle: const TextStyle(
                  color: subTextColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF6D6D6D)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              onFieldSubmitted: (value) {},
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => VjtiPayWithPhoneNumber()),
                  child: Column(
                    children: [
                      Icon(Icons.phone, color: iconColor),
                      const SizedBox(height: 10),
                      Text(
                        "Pay phone \nnumber",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => PayWithUpiId()),
                  child: Column(
                    children: [
                      Icon(Icons.payment, color: iconColor),
                      const SizedBox(height: 10),
                      Text(
                        "Pay UPI ID \nor number",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => VjtiPayWithQRCode()),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code, color: iconColor),
                      const SizedBox(height: 10),
                      Text(
                        "Scan any \nQR code",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => VjtiPayFromContacts()),
                  child: Column(
                    children: [
                      Icon(Icons.contacts, color: iconColor),
                      const SizedBox(height: 10),
                      Text(
                        "Pay from \ncontacts",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Banking Options",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => {},
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0XFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.wifi,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WiFi Banking",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Wifi Enabled Offline Payments",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => _makePhoneCall("+918696074241"),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0XFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.voice_over_off,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Voice Over Payments",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Voice enabled payment system",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () =>
                  bankingServiceController.sendMessage("9971056767", "BAL"),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0XFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Balance",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Check your account balance offline",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                allTransactionController.fetchTransactions();
                Get.to(() => VjtiAllTransactions());
              },
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0XFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transactions",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Check your transactions offline",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ConnectivityBuilder(
              builder: (context, isConnected, status) {
                if (isConnected == true) {
                  return GestureDetector(
                    onTap: () => Get.to(() => VjtiChatBot()),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(0XFF2D2D2D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chatbot",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Ask me anything",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
