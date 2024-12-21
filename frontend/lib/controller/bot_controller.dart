import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class BotController extends GetxController {
  // The list of chat messages (user and bot messages)
  var chatList = <ChatMessage>[].obs;

  // The text editing controller for the user's input
  var messageController = TextEditingController();

  void getBotResponse(String userMessage) async {
    // Add the user message to the chat list
    chatList.add(ChatMessage(message: userMessage, isUser: true));

    try {
      // Make an API request to get the bot's response
      var response = await Dio().post(
        'https://api.example.com/getBotResponse',
        data: {'message': userMessage},
      );

      // Extract the bot's response from the API response
      String botResponse = response.data['botResponse'];

      // Add the bot response to the chat list
      chatList.add(ChatMessage(message: botResponse, isUser: false));
    } catch (e) {
      // Handle any errors that occur during the API request
      chatList.add(ChatMessage(
          message: 'Bot: Sorry, something went wrong.', isUser: false));
    }
  }
}

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});
}
