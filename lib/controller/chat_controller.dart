import 'dart:convert';
import 'package:assignment_app/controller/conversation_controller.dart';
import 'package:assignment_app/model/chat_model.dart';
import 'package:assignment_app/model/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatController extends GetxController {
  final conversationController = Get.find<ConversationController>();

  final chat = <ChatModel>[].obs;
  final loading = false.obs;
  final currentMessage = 0.obs;
  final speechToText = SpeechToText().obs;
  bool speechEnabled = false;
  final lastWords = ''.obs;
  final listening = false.obs;
  ConversationModel conversationData;
  ChatController(this.conversationData);
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getChat();
    currentMessage.value = conversationData.lastConversation;
    super.onInit();
  }

  Future<void> getChat() async {
    loading(true);
    final response = await http.get(Uri.parse(
        'https://my-json-server.typicode.com/tryninjastudy/dummyapi/db'));
    Map<String, dynamic> decodedData = json.decode(response.body);
    final restaurantChat = decodedData['restaurant'] as List;
    chat.value = restaurantChat.map((e) {
      return ChatModel.fromMap(e);
    }).toList();
    loading(false);
  }

  Future<void> initSpeech() async {
    speechEnabled = await speechToText.value.initialize(debugLogging: true);
  }

  void startListening() async {
    await initSpeech();

    listening(true);
    speechToText.value.listen(
      pauseFor: Duration(seconds: 30),
      listenMode: ListenMode.dictation,
      onResult: onSpeechResult,
      listenFor: Duration(minutes: 1),
    );
  }

  void stopListening() async {
    print('here');
    listening(false);
    await speechToText.value.stop();
    print(speechToText.value.isNotListening);
  }

  Future<void> onSpeechResult(SpeechRecognitionResult result) async {
    lastWords.value = result.recognizedWords;

    if (speechToText.value.isListening) {
      listening(true);
    } else {
      listening(false);
    }
    print(chat[currentMessage.value]
        .human
        .toLowerCase()
        .replaceAll(RegExp('[^A-Za-z0-9]'), ''));
    if (chat[currentMessage.value]
            .human
            .toLowerCase()
            .replaceAll(RegExp('[^A-Za-z0-9]'), '') ==
        lastWords.toLowerCase().replaceAll(' ', '')) {
      lastWords('');
      print(lastWords.value);
      currentMessage(currentMessage.value + 1);
      if (currentMessage.value == chat.length - 1) {
        return;
      }
      conversationController.updateLastConversation(
          conversationData.id, currentMessage.value);
      stopListening();
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}
