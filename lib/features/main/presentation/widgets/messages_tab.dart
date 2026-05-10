import 'package:flutter/material.dart';

import 'package:unitrade/features/main/data/campus_mart_mock_data.dart';
import 'package:unitrade/features/main/presentation/screens/chat_detail_screen.dart';
import 'package:unitrade/features/main/presentation/widgets/shared_widgets.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 14),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'UniLane Inbox',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ...conversations.map(
            (conversation) => ConversationTile(
              conversation: conversation,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        ChatDetailScreen(conversation: conversation),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
