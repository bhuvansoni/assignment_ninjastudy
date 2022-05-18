import 'package:assignment_app/controller/conversation_controller.dart';
import 'package:assignment_app/controller/validation_controller.dart';
import 'package:assignment_app/mock_data/data.dart';
import 'package:assignment_app/views/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/conversation_list_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final authController = Get.find<ValidationController>();
  final tagController = Get.put(ConversationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Conversations',
          style: Get.textTheme.headline4!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActionChip(
              label: const Text(
                'Log out',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                await authController.logout();
                await tagController.deleteConversations();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: const Color.fromARGB(108, 255, 226, 236),
        onPressed: () {
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: const Text('Select topic...'),
              content: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: topics.map(
                  (e) {
                    return ChoiceChip(
                      label: Text(
                        e,
                        style: const TextStyle(color: Colors.black),
                      ),
                      selected: false,
                      onSelected: (isSelected) async {
                        final data = await tagController.addConversation(e);
                        Get.back();
                        Get.to(ChatPage(
                          data: data,
                        ));
                      },
                      backgroundColor: const Color.fromARGB(108, 255, 226, 236),
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.add,
          color: const Color.fromARGB(255, 255, 0, 100),
        ),
        label: const Text(
          'Add Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(
        () => tagController.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: tagController.conversations.length,
                itemBuilder: (context, index) {
                  return ConversationListTile(
                    data: tagController.conversations[index],
                    icon: topicUrl[tagController.conversations[index].topic],
                  );
                },
              ),
      ),
    );
  }
}
