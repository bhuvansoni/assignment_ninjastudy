import 'dart:convert';
import 'package:assignment_app/model/chat_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatController extends GetxController {
  final chat = <ChatModel>[].obs;
  final loading = false.obs;
  final currentMessage = 0.obs;
  final speechToText = SpeechToText().obs;
  bool speechEnabled = false;
  String lastWords = '';
  final listening = false.obs;

  @override
  void onInit() {
    getChat();
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

  void validateMessage(String message) {
    // if (completedChats.last.human == message) {
    currentMessage(currentMessage.value + 1);
    // return true;
    // } else {
    //   return false;
    // }
  }

  /// This has to happen only once per app
  Future<void> initSpeech() async {
    speechEnabled = await speechToText.value.initialize();
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    await initSpeech();
    await speechToText.value.listen(onResult: onSpeechResult);
    listening(true);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await speechToText.value.stop();
    listening(false);
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    if (speechToText.value.isListening) {
      return;
    }
    if (chat[currentMessage.value].human.toLowerCase() ==
        lastWords.toLowerCase()) {
      currentMessage(currentMessage.value + 1);
    } else {
      Get.snackbar('Invalid response', 'Please try again!',
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 1));
    }
  }
}
