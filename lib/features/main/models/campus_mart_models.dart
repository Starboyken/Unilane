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
    this.roomType,
    this.rentDuration,
    this.utilities,
    this.distanceToCampus,
    this.ownerId,
    this.isVerifiedSeller = false,
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
  final String? roomType;
  final String? rentDuration;
  final String? utilities;
  final String? distanceToCampus;
  final String? ownerId;
  final bool isVerifiedSeller;

  factory ListingItem.fromJson(Map<String, dynamic> json) {
    return ListingItem(
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: json['price'] as String? ?? '',
      location: json['location'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sellerName: json['sellerName'] as String? ?? '',
      sellerRole: json['sellerRole'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      postedTime: json['postedTime'] as String? ?? '',
      badge: json['badge'] as String?,
      roomType: json['roomType'] as String?,
      rentDuration: json['rentDuration'] as String?,
      utilities: json['utilities'] as String?,
      distanceToCampus: json['distanceToCampus'] as String?,
      ownerId: json['ownerId'] as String?,
      isVerifiedSeller: json['isVerifiedSeller'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'location': location,
      'category': category,
      'description': description,
      'sellerName': sellerName,
      'sellerRole': sellerRole,
      'condition': condition,
      'postedTime': postedTime,
      'badge': badge,
      'roomType': roomType,
      'rentDuration': rentDuration,
      'utilities': utilities,
      'distanceToCampus': distanceToCampus,
      'ownerId': ownerId,
      'isVerifiedSeller': isVerifiedSeller,
    };
  }

  ListingItem copyWith({
    String? imageUrl,
    String? title,
    String? price,
    String? location,
    String? category,
    String? description,
    String? sellerName,
    String? sellerRole,
    String? condition,
    String? postedTime,
    String? badge,
    String? roomType,
    String? rentDuration,
    String? utilities,
    String? distanceToCampus,
    String? ownerId,
    bool? isVerifiedSeller,
  }) {
    return ListingItem(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      price: price ?? this.price,
      location: location ?? this.location,
      category: category ?? this.category,
      description: description ?? this.description,
      sellerName: sellerName ?? this.sellerName,
      sellerRole: sellerRole ?? this.sellerRole,
      condition: condition ?? this.condition,
      postedTime: postedTime ?? this.postedTime,
      badge: badge ?? this.badge,
      roomType: roomType ?? this.roomType,
      rentDuration: rentDuration ?? this.rentDuration,
      utilities: utilities ?? this.utilities,
      distanceToCampus: distanceToCampus ?? this.distanceToCampus,
      ownerId: ownerId ?? this.ownerId,
      isVerifiedSeller: isVerifiedSeller ?? this.isVerifiedSeller,
    );
  }
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

class RoommateProfileItem {
  const RoommateProfileItem({
    required this.id,
    required this.initials,
    required this.name,
    required this.level,
    required this.area,
    required this.budget,
    required this.moveIn,
    required this.genderPreference,
    required this.interests,
    required this.about,
    this.isVerifiedStudent = false,
  });

  final String id;
  final String initials;
  final String name;
  final String level;
  final String area;
  final String budget;
  final String moveIn;
  final String genderPreference;
  final List<String> interests;
  final String about;
  final bool isVerifiedStudent;

  factory RoommateProfileItem.fromJson(Map<String, dynamic> json) {
    final interests = json['interests'];

    return RoommateProfileItem(
      id: json['id'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? '',
      area: json['area'] as String? ?? '',
      budget: json['budget'] as String? ?? '',
      moveIn: json['moveIn'] as String? ?? '',
      genderPreference: json['genderPreference'] as String? ?? '',
      interests: interests is List
          ? interests.map((interest) => interest.toString()).toList()
          : const <String>[],
      about: json['about'] as String? ?? '',
      isVerifiedStudent: json['isVerifiedStudent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initials': initials,
      'name': name,
      'level': level,
      'area': area,
      'budget': budget,
      'moveIn': moveIn,
      'genderPreference': genderPreference,
      'interests': interests,
      'about': about,
      'isVerifiedStudent': isVerifiedStudent,
    };
  }
}

class UserProfileItem {
  const UserProfileItem({
    required this.userId,
    required this.displayName,
    required this.contact,
    required this.campus,
    required this.level,
    required this.bio,
    required this.initials,
    required this.interests,
    required this.memberSince,
    this.avatarUrl,
    this.isVerifiedStudent = false,
  });

  final String userId;
  final String displayName;
  final String contact;
  final String campus;
  final String level;
  final String bio;
  final String initials;
  final List<String> interests;
  final String memberSince;
  final String? avatarUrl;
  final bool isVerifiedStudent;

  factory UserProfileItem.fromJson(Map<String, dynamic> json) {
    final interests = json['interests'];

    return UserProfileItem(
      userId: json['userId'] as String? ?? json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      campus: json['campus'] as String? ?? '',
      level: json['level'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      interests: interests is List
          ? interests.map((interest) => interest.toString()).toList()
          : const <String>[],
      memberSince: json['memberSince'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      isVerifiedStudent: json['isVerifiedStudent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'contact': contact,
      'campus': campus,
      'level': level,
      'bio': bio,
      'initials': initials,
      'interests': interests,
      'memberSince': memberSince,
      'avatarUrl': avatarUrl,
      'isVerifiedStudent': isVerifiedStudent,
    };
  }

  UserProfileItem copyWith({
    String? userId,
    String? displayName,
    String? contact,
    String? campus,
    String? level,
    String? bio,
    String? initials,
    List<String>? interests,
    String? memberSince,
    String? avatarUrl,
    bool? isVerifiedStudent,
  }) {
    return UserProfileItem(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      contact: contact ?? this.contact,
      campus: campus ?? this.campus,
      level: level ?? this.level,
      bio: bio ?? this.bio,
      initials: initials ?? this.initials,
      interests: interests ?? this.interests,
      memberSince: memberSince ?? this.memberSince,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerifiedStudent: isVerifiedStudent ?? this.isVerifiedStudent,
    );
  }
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

  factory ChatMessageItem.fromJson(Map<String, dynamic> json) {
    return ChatMessageItem(
      text: json['text'] as String? ?? '',
      time: json['time'] as String? ?? '',
      isMine: json['isMine'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'time': time, 'isMine': isMine};
  }
}

class ConversationItem {
  const ConversationItem({
    required this.id,
    required this.initials,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.messages,
    this.isOnline = true,
  });

  final String id;
  final String initials;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final List<ChatMessageItem> messages;

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];

    return ConversationItem(
      id: json['id'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      time: json['time'] as String? ?? '',
      unreadCount: json['unreadCount'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? true,
      messages: rawMessages is List
          ? rawMessages
                .map((rawMessage) {
                  if (rawMessage is Map) {
                    return ChatMessageItem.fromJson(
                      Map<String, dynamic>.from(rawMessage),
                    );
                  }

                  return null;
                })
                .whereType<ChatMessageItem>()
                .toList()
          : const <ChatMessageItem>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initials': initials,
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  ConversationItem copyWith({
    String? id,
    String? initials,
    String? name,
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? isOnline,
    List<ChatMessageItem>? messages,
  }) {
    return ConversationItem(
      id: id ?? this.id,
      initials: initials ?? this.initials,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      messages: messages ?? this.messages,
    );
  }
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.time,
    required this.isUnread,
    required this.destinationType,
    this.destinationId,
    this.marketplaceCategory,
  });

  final String id;
  final IconData icon;
  final String title;
  final String time;
  final bool isUnread;
  final NotificationDestinationType destinationType;
  final String? destinationId;
  final String? marketplaceCategory;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final destinationTypeValue =
        json['destinationType'] as String? ??
        NotificationDestinationType.listing.name;
    final iconCodePoint =
        json['iconCodePoint'] as int? ??
        Icons.notifications_none_rounded.codePoint;

    return NotificationItem(
      id: json['id'] as String? ?? '',
      icon: IconData(
        iconCodePoint,
        fontFamily: json['iconFontFamily'] as String?,
        fontPackage: json['iconFontPackage'] as String?,
      ),
      title: json['title'] as String? ?? '',
      time: json['time'] as String? ?? '',
      isUnread: json['isUnread'] as bool? ?? false,
      destinationType: NotificationDestinationType.fromValue(
        destinationTypeValue,
      ),
      destinationId: json['destinationId'] as String?,
      marketplaceCategory: json['marketplaceCategory'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'title': title,
      'time': time,
      'isUnread': isUnread,
      'destinationType': destinationType.name,
      'destinationId': destinationId,
      'marketplaceCategory': marketplaceCategory,
    };
  }

  NotificationItem copyWith({
    String? id,
    IconData? icon,
    String? title,
    String? time,
    bool? isUnread,
    NotificationDestinationType? destinationType,
    String? destinationId,
    String? marketplaceCategory,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      time: time ?? this.time,
      isUnread: isUnread ?? this.isUnread,
      destinationType: destinationType ?? this.destinationType,
      destinationId: destinationId ?? this.destinationId,
      marketplaceCategory: marketplaceCategory ?? this.marketplaceCategory,
    );
  }
}

enum NotificationDestinationType {
  conversation,
  listing,
  marketplaceCategory,
  roommates,
  lodges;

  static NotificationDestinationType fromValue(String value) {
    return NotificationDestinationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => NotificationDestinationType.listing,
    );
  }
}
