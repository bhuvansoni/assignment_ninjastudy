class ChatModel {
  String bot;
  String human;

  ChatModel({required this.bot, required this.human});

  static ChatModel fromMap(Map<String, dynamic> data) {
    return ChatModel(bot: data['bot'], human: data['human']);
  }

  Map<String, dynamic> toMap() {
    return {
      'bot': bot,
      'human': human,
    };
  }
}
