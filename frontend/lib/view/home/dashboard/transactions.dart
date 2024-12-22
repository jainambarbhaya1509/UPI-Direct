import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/transaction_controller.dart';

class VjtiAllTransactions extends StatelessWidget {
  const VjtiAllTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Transactions",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Obx(() {
                // Check if there are transactions available
                if (allTransactionController.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "No transactions available",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                // Render the list of transactions
                return ListView.builder(
                  itemCount: allTransactionController.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction =
                        allTransactionController.transactions[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            "${transaction["receiver_vid"]}",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.orangeAccent,
                            ),
                            ),
                            Spacer(),
                            Text(
                            "₹${transaction["amount"]}",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            ),
                          ],
                          ),
                          Text(
                          "${DateTime.parse(transaction["created_at"]).toLocal().toString().split(' ')[0]}",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[500],
                          ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
