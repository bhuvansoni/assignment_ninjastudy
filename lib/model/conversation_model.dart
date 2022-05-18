class ConversationModel {
  String topic;
  int lastConversation;
  int id;

  ConversationModel({
    required this.id,
    required this.topic,
    required this.lastConversation,
  });

  Map<String, dynamic> toMap() {
    return {'topic': topic, 'lastConversation': lastConversation};
  }

  static ConversationModel fromMap(Map<String, dynamic> data) {
    return ConversationModel(
        topic: data['topic'], lastConversation: data['lastConversation'], id: data['id']);
  }
}
