import 'package:unilane/features/main/models/campus_mart_models.dart';

abstract class ConversationRepository {
  Future<List<ConversationItem>> loadConversations({String? userId});

  Future<void> saveConversations(
    List<ConversationItem> conversations, {
    String? userId,
  });
}
