import 'package:assignment_app/components/chat_bubble_custom.dart';
import 'package:assignment_app/controller/chat_controller.dart';
import 'package:assignment_app/model/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final ConversationModel data;
  ChatPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController controller;

  @override
  void initState() {
    controller = Get.put(ChatController(widget.data));
    super.initState();
  }

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
          widget.data.topic.capitalize!,
          style: Get.textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
            initialValue: 0,
            onSelected: ((value) async {
              await controller.conversationController
                  .updateLastConversation(widget.data.id, 0);
              controller.currentMessage(0);
            }),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Clear Conversation"),
                value: 1,
              ),
            ],
          ),
        ],
      ),
      body: Obx(
        () => controller.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: controller.scrollController,
                itemCount:
                    controller.currentMessage.value < controller.chat.length
                        ? controller.currentMessage.value + 1
                        : controller.chat.length,
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
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: controller.currentMessage.value <
                        controller.chat.length,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() => Text(
                            'Speak: ' +
                                controller.chat[controller.currentMessage.value]
                                    .human,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => Text(
                                  controller.lastWords.value,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 0, 100),
                            onPressed: !controller.listening.value
                                ? controller.startListening
                                : controller.stopListening,
                            tooltip: 'Listen',
                            child: Obx(() => !controller.listening.value
                                ? const Icon(
                                    Icons.mic_off,
                                  )
                                : const Icon(Icons.mic)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
