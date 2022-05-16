import 'package:assignment_app/views/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationListTile extends StatelessWidget {
  final String chatTitle;
  final IconData icon;
  const ConversationListTile({
    Key? key,
    required this.chatTitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(() => ChatPage(tag: 'restaurant'));
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
            chatTitle,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 2,
        )
      ],
    );
  }
}
