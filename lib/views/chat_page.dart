import 'package:assignment_app/components/chat_bubble_custom.dart';
import 'package:assignment_app/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final String tag;
  ChatPage({Key? key, required this.tag}) : super(key: key);

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          tag.capitalize!,
          style: Get.textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () => controller.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.currentMessage.value + 1,
                itemBuilder: (context, index) {
                  if (index == controller.currentMessage.value) {
                    return ChatBubbleCustom(
                        message: controller.chat[index].bot, fromBot: true);
                  }
                  return Column(
                    children: [
                      ChatBubbleCustom(
                        message: controller.chat[index].bot,
                        fromBot: true,
                      ),
                      ChatBubbleCustom(
                        message: controller.chat[index].human,
                        fromBot: false,
                      ),
                    ],
                  );
                },
              ),
      ),
      bottomNavigationBar: Obx(
        () => controller.loading.value
            ? Container()
            : Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() => Text(
                            controller
                                .chat[controller.currentMessage.value].human,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 100),
                      onPressed: controller.speechToText.value.isNotListening
                          ? controller.startListening
                          : controller.stopListening,
                      tooltip: 'Listen',
                      child: Obx(() => !controller.listening.value
                          ? Icon(
                              Icons.mic_off,
                            )
                          : Icon(Icons.mic)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
