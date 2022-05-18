import 'package:assignment_app/controller/conversation_controller.dart';
import 'package:assignment_app/model/conversation_model.dart';
import 'package:assignment_app/views/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ConversationListTile extends StatelessWidget {
  final ConversationModel data;
  final IconData? icon;
  ConversationListTile({
    Key? key,
    required this.data,
    required this.icon,
  }) : super(key: key);
  final tagController = Get.find<ConversationController>();
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(data.id),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              tagController.deleteConversation(data.id);
            },
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'delete',
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Get.to(() => ChatPage(
                    data: data,
                  ));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 26,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            title: Text(
              data.topic.capitalize!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 2,
          )
        ],
      ),
    );
  }
}
