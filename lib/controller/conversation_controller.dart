import 'package:assignment_app/model/conversation_model.dart';
import 'package:assignment_app/service/database_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class ConversationController extends GetxController {
  final loading = false.obs;
  final conversations = <ConversationModel>[].obs;

  @override
  void onInit() {
    getConversations();
    super.onInit();
  }

  Future<void> getConversations() async {
    loading(true);
    conversations.value = await DatabaseService.conversations();
    loading(false);
  }

  Future<void> updateLastConversation(int id, int lastConversation) async {
    loading(true);
    await DatabaseService.updateConversation(lastConversation, id);
    loading(false);
    await getConversations();
  }

  Future<void> deleteConversation(int id) async {
    loading(true);
    await DatabaseService.deleteConversation(id);
    loading(false);
    await getConversations();
  }
  Future<void> deleteConversations() async {
    loading(true);
    await DatabaseService.deleteConversations();
    loading(false);
    await getConversations();
  }

  Future<ConversationModel> addConversation(String topic) async {
    loading(true);
    ConversationModel data =
        ConversationModel(id: 0, topic: topic, lastConversation: 0);
    await DatabaseService.insertConversation(data);
    loading(false);
    await getConversations();
    return data;
  }
}
