import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationController extends GetxController {
  final loading = false.obs;
  final tags = <String>[].obs;
  final tagsKey = 'tags';

  @override
  void onInit() {
    getTags();
    super.onInit();
  }

  Future<void> getTags() async {
    loading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tags = prefs.getStringList(tagsKey);
    if (tags != null) {
      this.tags.value = tags;
    }
    loading(false);
  }

  Future<void> addTag(String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tags = prefs.getStringList(tagsKey);
    if (tags == null) {
      final newTagList = [tag];
      await prefs.setStringList(tagsKey, newTagList);
    } else {
      if (!tags.contains(tag)) {
        print(tags.length);
        tags.add(tag);
        print(tags.length);
        await prefs.setStringList(tagsKey, tags);
      }
      getTags();
    }
  }
}
