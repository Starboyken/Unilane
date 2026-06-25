import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/core/widgets/app_search_field.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/chat_detail_screen.dart';
import 'package:unilane/features/main/presentation/widgets/shared_widgets.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final conversations = provider.conversations;
    final searchQuery = provider.messagesSearchQuery.trim().toLowerCase();
    final filteredConversations = conversations.where((conversation) {
      if (searchQuery.isEmpty) {
        return true;
      }

      final haystack = [
        conversation.name,
        conversation.lastMessage,
        ...conversation.messages.map((message) => message.text),
      ].join(' ').toLowerCase();

      return haystack.contains(searchQuery);
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 14),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSearchField(
              hintText: 'Search chats, names, or messages',
              value: provider.messagesSearchQuery,
              onChanged: context
                  .read<CampusMartProvider>()
                  .setMessagesSearchQuery,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Expanded(
            child: filteredConversations.isEmpty
                ? _EmptyMessagesState(hasQuery: searchQuery.isNotEmpty)
                : ListView.builder(
                    itemCount: filteredConversations.length,
                    itemBuilder: (context, index) {
                      final conversation = filteredConversations[index];

                      return ConversationTile(
                        conversation: conversation,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => ChatDetailScreen(
                                conversationId: conversation.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessagesState extends StatelessWidget {
  const _EmptyMessagesState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasQuery ? Icons.search_off_rounded : Icons.chat_bubble_outline,
              size: 56,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            Text(
              hasQuery ? 'No chats found' : 'No messages yet',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasQuery
                  ? 'Try a different name or keyword.'
                  : 'Start a conversation from a listing or roommate profile.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
