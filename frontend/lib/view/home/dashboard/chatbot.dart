import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vjti/conatants.dart';
import 'package:vjti/controller/bot_controller.dart';

class VjtiChatBot extends StatelessWidget {
  const VjtiChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    final BotController botController = Get.put(BotController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,  // Ensure you have a 'backgroundColor' constant
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => botController.chatList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Lottie.asset(
                            //   "assets/chatbot_initial.json",
                            //   height: MediaQuery.of(context).size.height * 0.3,
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              "ProBot",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Start asking a question",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: botController.chatList.length,
                        itemBuilder: (context, index) {
                          final message = botController.chatList[index];
                          final isUser = message.isUser;

                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              isUser ? 64.0 : 16.0,
                              4,
                              isUser ? 16.0 : 64.0,
                              4,
                            ),
                            child: Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      isUser ? Colors.grey[300] : Colors.grey,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                        color: isUser
                                            ? Colors.black87
                                            : Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            enableSuggestions: true,
                            maxLines: null,
                            controller: botController.messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ask ProBot a question...",
                              hintStyle: TextStyle(color: subTextColor),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (botController.messageController.text.isNotEmpty) {
                            botController.getBotResponse(
                              botController.messageController.text.trim(),
                            );
                          }
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.paperPlane,
                          color: buttonColor,  // Ensure you have a 'buttonColor' constant
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
