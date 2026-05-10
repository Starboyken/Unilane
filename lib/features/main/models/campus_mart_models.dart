import 'package:flutter/material.dart';

class CategoryItem {
  const CategoryItem({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.targetTabIndex,
    this.targetFilter = 'All',
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final int targetTabIndex;
  final String targetFilter;
}

class ListingItem {
  const ListingItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.location,
    required this.category,
    required this.description,
    required this.sellerName,
    required this.sellerRole,
    required this.condition,
    required this.postedTime,
    this.badge,
  });

  final String imageUrl;
  final String title;
  final String price;
  final String location;
  final String category;
  final String description;
  final String sellerName;
  final String sellerRole;
  final String condition;
  final String postedTime;
  final String? badge;
}

class RecommendationItem {
  const RecommendationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
    required this.targetTabIndex,
    this.targetFilter = 'All',
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;
  final int targetTabIndex;
  final String targetFilter;
}

class ServiceItem {
  const ServiceItem({
    required this.imageUrl,
    required this.title,
    required this.provider,
    required this.price,
    required this.rating,
    required this.category,
  });

  final String imageUrl;
  final String title;
  final String provider;
  final String price;
  final String rating;
  final String category;
}

class ChatMessageItem {
  const ChatMessageItem({
    required this.text,
    required this.time,
    required this.isMine,
  });

  final String text;
  final String time;
  final bool isMine;
}

class ConversationItem {
  const ConversationItem({
    required this.initials,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.messages,
    this.isOnline = true,
  });

  final String initials;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final List<ChatMessageItem> messages;
}

class NotificationItem {
  const NotificationItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.isUnread,
  });

  final IconData icon;
  final String title;
  final String time;
  final bool isUnread;
}
