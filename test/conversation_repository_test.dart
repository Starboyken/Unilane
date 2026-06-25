import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/shared_preferences_conversation_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('conversation repository round-trips messages per user', () async {
    final repository = SharedPreferencesConversationRepository();
    final conversations = [
      ConversationItem(
        id: 'test-chat',
        initials: 'TC',
        name: 'Test Chat',
        lastMessage: 'See you tomorrow',
        time: 'now',
        unreadCount: 1,
        isOnline: true,
        messages: const [
          ChatMessageItem(text: 'Hello there', time: '9:00 AM', isMine: false),
          ChatMessageItem(
            text: 'See you tomorrow',
            time: '9:01 AM',
            isMine: true,
          ),
        ],
      ),
    ];

    await repository.saveConversations(conversations, userId: 'student_1');

    final loadedForStudent = await repository.loadConversations(
      userId: 'student_1',
    );
    final loadedForGuest = await repository.loadConversations(userId: 'guest');

    expect(loadedForStudent, hasLength(1));
    expect(loadedForStudent.first.id, 'test-chat');
    expect(loadedForStudent.first.messages, hasLength(2));
    expect(loadedForStudent.first.messages.last.text, 'See you tomorrow');
    expect(loadedForGuest, isEmpty);
  });
}
