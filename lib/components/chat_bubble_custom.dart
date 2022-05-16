import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

class ChatBubbleCustom extends StatelessWidget {
  final String message;
  final bool fromBot;
  const ChatBubbleCustom(
      {Key? key, required this.message, required this.fromBot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper6(
          type: fromBot ? BubbleType.receiverBubble : BubbleType.sendBubble),
      alignment: fromBot ? Alignment.topLeft : Alignment.topRight,
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: fromBot ? Colors.pink : Colors.blue,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
