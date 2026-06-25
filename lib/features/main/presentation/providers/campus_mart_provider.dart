import 'dart:async';

import 'package:flutter/material.dart';

import 'package:unilane/features/auth/domain/auth_user.dart';
import 'package:unilane/features/main/data/marketplace_listing_repository.dart';
import 'package:unilane/features/main/data/listing_media_repository.dart';
import 'package:unilane/features/main/data/local_listing_media_repository.dart';
import 'package:unilane/features/main/data/conversation_repository.dart';
import 'package:unilane/features/main/data/roommate_profile_repository.dart';
import 'package:unilane/features/main/data/profile_repository.dart';
import 'package:unilane/features/main/data/notification_repository.dart';
import 'package:unilane/features/main/data/campus_mart_mock_data.dart'
    as mock_data;
import 'package:unilane/features/main/data/shared_preferences_conversation_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_roommate_profile_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_notification_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_marketplace_listing_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_profile_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class CampusMartProvider extends ChangeNotifier {
  static const String _guestUserId = 'guest';

  CampusMartProvider({
    MarketplaceListingRepository? marketplaceListingRepository,
    ListingMediaRepository? listingMediaRepository,
    ConversationRepository? conversationRepository,
    RoommateProfileRepository? roommateProfileRepository,
    NotificationRepository? notificationRepository,
    UserProfileRepository? profileRepository,
  }) : _marketplaceListingRepository =
           marketplaceListingRepository ??
           SharedPreferencesMarketplaceListingRepository(),
       _listingMediaRepository =
           listingMediaRepository ?? LocalListingMediaRepository(),
       _conversationRepository =
           conversationRepository ?? SharedPreferencesConversationRepository(),
       _roommateProfileRepository =
           roommateProfileRepository ??
           SharedPreferencesRoommateProfileRepository(),
       _notificationRepository =
           notificationRepository ?? SharedPreferencesNotificationRepository(),
       _profileRepository =
           profileRepository ?? SharedPreferencesProfileRepository() {
    _conversations.addAll(_buildSeedConversations());
    _loadSavedListings();
    _loadSavedRoommateProfiles();
    unawaited(_loadSavedNotifications(generation: _userStateGeneration));
    unawaited(_loadSavedConversations(generation: _userStateGeneration));
  }

  final MarketplaceListingRepository _marketplaceListingRepository;
  final ListingMediaRepository _listingMediaRepository;
  final ConversationRepository _conversationRepository;
  final RoommateProfileRepository _roommateProfileRepository;
  final NotificationRepository _notificationRepository;
  final UserProfileRepository _profileRepository;

  int _selectedTabIndex = 0;
  String _selectedMarketplaceCategory = 'All';
  String _selectedServiceCategory = 'All';
  String _homeSearchQuery = '';
  String _marketplaceSearchQuery = '';
  String _servicesSearchQuery = '';
  String _messagesSearchQuery = '';
  final List<ListingItem> _baseFeaturedListings = mock_data.featuredListings
      .toList();
  final List<ListingItem> _baseMarketplaceListings = mock_data
      .marketplaceListings
      .toList();
  final List<ListingItem> _savedMarketplaceListings = [];
  final List<RoommateProfileItem> _baseRoommateProfiles = mock_data
      .roommateProfiles
      .toList();
  final List<RoommateProfileItem> _savedRoommateProfiles = [];
  final List<NotificationItem> _seedNotificationItems = mock_data
      .notificationItems
      .map((notification) => notification.copyWith())
      .toList();
  final List<NotificationItem> _notificationItems = mock_data.notificationItems
      .map((notification) => notification.copyWith())
      .toList();
  final List<ConversationItem> _conversations = [];
  String? _activeConversationId;
  String _currentUserId = _guestUserId;
  AuthUser? _currentAuthUser;
  UserProfileItem? _currentUserProfile;
  int _userStateGeneration = 0;
  Future<void> _conversationSaveQueue = Future<void>.value();

  int get selectedTabIndex => _selectedTabIndex;
  String get selectedMarketplaceCategory => _selectedMarketplaceCategory;
  String get selectedServiceCategory => _selectedServiceCategory;
  String get homeSearchQuery => _homeSearchQuery;
  String get marketplaceSearchQuery => _marketplaceSearchQuery;
  String get servicesSearchQuery => _servicesSearchQuery;
  String get messagesSearchQuery => _messagesSearchQuery;
  List<ListingItem> get featuredListings => List.unmodifiable([
    ..._savedMarketplaceListings,
    ..._baseFeaturedListings,
  ]);
  List<ListingItem> get marketplaceListings => List.unmodifiable([
    ..._savedMarketplaceListings,
    ..._baseMarketplaceListings,
  ]);
  List<RoommateProfileItem> get roommateProfiles =>
      List.unmodifiable([..._savedRoommateProfiles, ..._baseRoommateProfiles]);
  List<ConversationItem> get conversations => List.unmodifiable(_conversations);
  List<NotificationItem> get notificationItems =>
      List.unmodifiable(_notificationItems);
  UserProfileItem? get currentUserProfile => _currentUserProfile;
  int get unreadNotificationCount =>
      _notificationItems.where((item) => item.isUnread).length;
  bool get hasUnreadNotifications => unreadNotificationCount > 0;
  String get currentUserId => _currentUserId;

  ConversationItem? getConversationById(String conversationId) {
    for (final conversation in _conversations) {
      if (conversation.id == conversationId) {
        return conversation;
      }
    }

    return null;
  }

  ListingItem? getListingBySlug(String slug) {
    final normalizedSlug = _slugify(slug);

    for (final listing in marketplaceListings) {
      if (_slugify(listing.title) == normalizedSlug) {
        return listing;
      }
    }

    return null;
  }

  Future<void> setCurrentUser(AuthUser? user) async {
    final normalizedUserId = _normalizeUserId(user?.uid);
    if (_currentUserId == normalizedUserId &&
        _currentAuthUser?.uid == user?.uid) {
      return;
    }

    _currentAuthUser = user;
    _currentUserId = normalizedUserId;
    _currentUserProfile = _currentUserId == _guestUserId
        ? null
        : _buildDefaultProfile();
    _activeConversationId = null;
    _messagesSearchQuery = '';
    final generation = ++_userStateGeneration;
    notifyListeners();
    unawaited(_loadSavedNotifications(generation: generation));
    unawaited(_loadCurrentUserProfile(generation: generation));
    unawaited(_loadSavedConversations(generation: generation));
  }

  void setSelectedTab(int index) {
    if (_selectedTabIndex == index) return;

    _selectedTabIndex = index;
    notifyListeners();
  }

  void setMarketplaceCategory(String category) {
    if (_selectedMarketplaceCategory == category) return;

    _selectedMarketplaceCategory = category;
    notifyListeners();
  }

  void setServiceCategory(String category) {
    if (_selectedServiceCategory == category) return;

    _selectedServiceCategory = category;
    notifyListeners();
  }

  void setHomeSearchQuery(String query) {
    if (_homeSearchQuery == query) return;

    _homeSearchQuery = query;
    notifyListeners();
  }

  void setMarketplaceSearchQuery(String query) {
    if (_marketplaceSearchQuery == query) return;

    _marketplaceSearchQuery = query;
    notifyListeners();
  }

  void setServicesSearchQuery(String query) {
    if (_servicesSearchQuery == query) return;

    _servicesSearchQuery = query;
    notifyListeners();
  }

  void setMessagesSearchQuery(String query) {
    if (_messagesSearchQuery == query) return;

    _messagesSearchQuery = query;
    notifyListeners();
  }

  void openMarketplace({String category = 'All'}) {
    var shouldNotify = false;

    if (_selectedTabIndex != 1) {
      _selectedTabIndex = 1;
      shouldNotify = true;
    }

    if (_selectedMarketplaceCategory != category) {
      _selectedMarketplaceCategory = category;
      shouldNotify = true;
    }

    if (_marketplaceSearchQuery.isNotEmpty) {
      _marketplaceSearchQuery = '';
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void openServices({String category = 'All'}) {
    var shouldNotify = false;

    if (_selectedTabIndex != 2) {
      _selectedTabIndex = 2;
      shouldNotify = true;
    }

    if (_selectedServiceCategory != category) {
      _selectedServiceCategory = category;
      shouldNotify = true;
    }

    if (_servicesSearchQuery.isNotEmpty) {
      _servicesSearchQuery = '';
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void openMessages() {
    if (_selectedTabIndex == 3) return;

    _selectedTabIndex = 3;
    notifyListeners();
  }

  Future<void> addMarketplaceListing(ListingItem listing) async {
    final resolvedListing = listing.copyWith(
      imageUrl: await _listingMediaRepository.resolveListingImageUrl(
        imageUrl: listing.imageUrl,
        listingTitle: listing.title,
        listingCategory: listing.category,
        ownerId: _currentUserId,
      ),
      ownerId: _currentUserId,
    );

    _savedMarketplaceListings.insert(0, resolvedListing);
    try {
      await _marketplaceListingRepository.addListing(resolvedListing);
    } catch (_) {
      // Keep the newly added listing visible locally even if the backend fails.
    }
    _insertNotification(
      id: _buildNotificationId('listing'),
      icon: Icons.notifications_none_rounded,
      title: 'Your ${resolvedListing.title} listing is now live on UniLane',
      time: 'just now',
      destinationType: NotificationDestinationType.listing,
      destinationId: _slugify(resolvedListing.title),
    );
    notifyListeners();
  }

  Future<void> addRoommateProfile(RoommateProfileItem profile) async {
    _savedRoommateProfiles.insert(0, profile);
    try {
      await _roommateProfileRepository.addRoommateProfile(profile);
    } catch (_) {
      // Keep the new roommate request visible locally even if saving fails.
    }
    _insertNotification(
      id: _buildNotificationId('roommate'),
      icon: Icons.people_outline_rounded,
      title: 'Your roommate request is now live on UniLane',
      time: 'just now',
      destinationType: NotificationDestinationType.roommates,
    );
    notifyListeners();
  }

  void markNotificationRead(String notificationId) {
    final notificationIndex = _notificationItems.indexWhere(
      (notification) => notification.id == notificationId,
    );

    if (notificationIndex == -1 ||
        !_notificationItems[notificationIndex].isUnread) {
      return;
    }

    _notificationItems[notificationIndex] =
        _notificationItems[notificationIndex].copyWith(isUnread: false);
    unawaited(_persistNotifications());
    notifyListeners();
  }

  void markAllNotificationsRead() {
    if (!hasUnreadNotifications) {
      return;
    }

    for (var index = 0; index < _notificationItems.length; index++) {
      _notificationItems[index] = _notificationItems[index].copyWith(
        isUnread: false,
      );
    }

    unawaited(_persistNotifications());
    notifyListeners();
  }

  Future<void> _loadSavedListings() async {
    try {
      final loadedListings = await _marketplaceListingRepository
          .loadSavedListings();

      if (loadedListings.isEmpty) {
        return;
      }

      _savedMarketplaceListings
        ..clear()
        ..addAll(loadedListings);
      notifyListeners();
    } catch (_) {
      return;
    }
  }

  Future<void> _loadSavedRoommateProfiles() async {
    try {
      final loadedProfiles = await _roommateProfileRepository
          .loadSavedRoommateProfiles();

      if (loadedProfiles.isEmpty) {
        return;
      }

      _savedRoommateProfiles
        ..clear()
        ..addAll(loadedProfiles);
      notifyListeners();
    } catch (_) {
      return;
    }
  }

  Future<void> _loadSavedNotifications({int? generation}) async {
    final activeGeneration = generation ?? _userStateGeneration;

    try {
      final loadedNotifications = await _notificationRepository
          .loadNotifications(userId: _currentUserId);

      if (activeGeneration != _userStateGeneration) {
        return;
      }

      if (loadedNotifications.isEmpty) {
        if (_currentUserId == _guestUserId) {
          _notificationItems
            ..clear()
            ..addAll(
              _seedNotificationItems.map(
                (notification) => notification.copyWith(),
              ),
            );
        } else {
          _notificationItems.clear();
        }
        notifyListeners();
        unawaited(_persistNotifications());
        return;
      }

      _notificationItems
        ..clear()
        ..addAll(loadedNotifications);
      notifyListeners();
    } catch (_) {
      return;
    }
  }

  Future<void> _loadCurrentUserProfile({int? generation}) async {
    final activeGeneration = generation ?? _userStateGeneration;

    if (activeGeneration != _userStateGeneration) {
      return;
    }

    if (_currentUserId == _guestUserId) {
      _currentUserProfile = null;
      notifyListeners();
      return;
    }

    try {
      final loadedProfile = await _profileRepository.loadProfile(
        userId: _currentUserId,
      );

      if (activeGeneration != _userStateGeneration) {
        return;
      }

      if (loadedProfile != null) {
        _currentUserProfile = loadedProfile.copyWith(
          isVerifiedStudent:
              loadedProfile.isVerifiedStudent ||
              (_currentAuthUser?.isVerifiedStudent ?? false),
        );
      } else {
        _currentUserProfile = _buildDefaultProfile();
        await _profileRepository.saveProfile(_currentUserProfile!);
      }

      notifyListeners();
    } catch (_) {
      return;
    }
  }

  Future<void> _loadSavedConversations({int? generation}) async {
    final activeGeneration = generation ?? _userStateGeneration;

    try {
      final loadedConversations = await _conversationRepository
          .loadConversations(userId: _currentUserId);

      if (activeGeneration != _userStateGeneration) {
        return;
      }

      if (loadedConversations.isEmpty) {
        _conversations
          ..clear()
          ..addAll(_buildSeedConversations());
        notifyListeners();
        unawaited(_persistConversations());
        return;
      }

      _conversations
        ..clear()
        ..addAll(_cloneConversations(loadedConversations));
      notifyListeners();
    } catch (_) {
      if (activeGeneration != _userStateGeneration) {
        return;
      }

      _conversations
        ..clear()
        ..addAll(_buildSeedConversations());
      notifyListeners();
    }
  }

  Future<void> _persistNotifications() async {
    try {
      await _notificationRepository.saveNotifications(
        _notificationItems,
        userId: _currentUserId,
      );
    } catch (_) {
      return;
    }
  }

  Future<void> _persistConversations() {
    final conversationsSnapshot = _cloneConversations(_conversations);
    final userId = _currentUserId;

    _conversationSaveQueue = _conversationSaveQueue.then((_) async {
      try {
        await _conversationRepository.saveConversations(
          conversationsSnapshot,
          userId: userId,
        );
      } catch (_) {
        // Keep the current chat state in memory if the backend save fails.
      }
    });

    return _conversationSaveQueue;
  }

  Future<void> saveCurrentUserProfile(UserProfileItem profile) async {
    if (_currentUserId == _guestUserId) {
      return;
    }

    _currentUserProfile = profile.copyWith(
      userId: _currentUserId,
      isVerifiedStudent:
          _currentAuthUser?.isVerifiedStudent ?? profile.isVerifiedStudent,
    );

    try {
      await _profileRepository.saveProfile(_currentUserProfile!);
    } catch (_) {
      // Keep the edited profile visible locally even if saving fails.
    }

    notifyListeners();
  }

  UserProfileItem _buildDefaultProfile() {
    final displayName = _currentAuthUser?.displayName.trim().isNotEmpty == true
        ? _currentAuthUser!.displayName.trim()
        : 'UniLane Student';
    final contact = _currentAuthUser?.contact.trim() ?? '';
    final memberSince = _formatJoinedLabel(DateTime.now());

    return UserProfileItem(
      userId: _currentUserId,
      displayName: displayName,
      contact: contact,
      campus: 'Your campus',
      level: '200 Level',
      bio: 'Buying, selling, and connecting safely on campus.',
      initials: _buildInitials(displayName),
      interests: const ['Marketplace', 'Lodges', 'Chat'],
      memberSince: memberSince,
      isVerifiedStudent: _currentAuthUser?.isVerifiedStudent ?? false,
    );
  }

  String _buildInitials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'UL';
    }

    if (words.length == 1) {
      final word = words.first;
      return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
    }

    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _formatJoinedLabel(DateTime timestamp) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[timestamp.month - 1];
    return 'Joined $month ${timestamp.year}';
  }

  String _slugify(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  void _insertNotification({
    required String id,
    required IconData icon,
    required String title,
    required String time,
    required NotificationDestinationType destinationType,
    String? destinationId,
    String? marketplaceCategory,
  }) {
    final notification = NotificationItem(
      id: id,
      icon: icon,
      title: title,
      time: time,
      isUnread: true,
      destinationType: destinationType,
      destinationId: destinationId,
      marketplaceCategory: marketplaceCategory,
    );

    _notificationItems.removeWhere((item) => item.id == id);
    _notificationItems.insert(0, notification);
    unawaited(_persistNotifications());
  }

  String _buildNotificationId(String prefix) {
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}';
  }

  String _normalizeUserId(String? userId) {
    final trimmed = userId?.trim() ?? '';
    return trimmed.isEmpty ? _guestUserId : trimmed;
  }

  String ensureConversation({
    required String preferredId,
    required String initials,
    required String name,
    bool isOnline = true,
    String? initialMessage,
  }) {
    final messageText = initialMessage?.trim() ?? '';
    final conversationIndex = _conversations.indexWhere(
      (conversation) => conversation.id == preferredId,
    );

    if (conversationIndex == -1) {
      final seededMessages = <ChatMessageItem>[
        if (messageText.isNotEmpty)
          ChatMessageItem(
            text: messageText,
            time: _formatMessageTime(DateTime.now()),
            isMine: true,
          ),
      ];

      _conversations.insert(
        0,
        ConversationItem(
          id: preferredId,
          initials: initials,
          name: name,
          lastMessage: seededMessages.isEmpty
              ? 'Start a conversation'
              : seededMessages.last.text,
          time: 'now',
          unreadCount: 0,
          isOnline: isOnline,
          messages: seededMessages,
        ),
      );
      unawaited(_persistConversations());
      if (messageText.isNotEmpty) {
        _scheduleAutoReply(
          preferredId,
          messageText,
          generation: _userStateGeneration,
        );
      }
      notifyListeners();

      return preferredId;
    }

    if (messageText.isNotEmpty &&
        _conversations[conversationIndex].lastMessage != messageText) {
      _appendMessage(
        conversationId: preferredId,
        text: messageText,
        isMine: true,
      );
      _scheduleAutoReply(
        preferredId,
        messageText,
        generation: _userStateGeneration,
      );
    }

    return preferredId;
  }

  void sendMessage(String conversationId, String text) {
    final trimmedText = text.trim();

    if (trimmedText.isEmpty) {
      return;
    }

    _appendMessage(conversationId: conversationId, text: trimmedText);
    _scheduleAutoReply(
      conversationId,
      trimmedText,
      generation: _userStateGeneration,
    );
  }

  void _appendMessage({
    required String conversationId,
    required String text,
    bool isMine = true,
  }) {
    final conversationIndex = _conversations.indexWhere(
      (conversation) => conversation.id == conversationId,
    );

    if (conversationIndex == -1) {
      return;
    }

    final currentConversation = _conversations.removeAt(conversationIndex);
    final isActiveConversation = _activeConversationId == conversationId;
    final updatedConversation = currentConversation.copyWith(
      lastMessage: text,
      time: 'now',
      unreadCount: isMine || isActiveConversation
          ? 0
          : currentConversation.unreadCount + 1,
      messages: [
        ...currentConversation.messages,
        ChatMessageItem(
          text: text,
          time: _formatMessageTime(DateTime.now()),
          isMine: isMine,
        ),
      ],
    );

    _conversations.insert(0, updatedConversation);
    notifyListeners();
    unawaited(_persistConversations());
  }

  void openConversation(String conversationId) {
    _activeConversationId = conversationId;
    markConversationRead(conversationId);
  }

  void closeConversation(String conversationId) {
    if (_activeConversationId == conversationId) {
      _activeConversationId = null;
    }
  }

  void markConversationRead(String conversationId) {
    final conversationIndex = _conversations.indexWhere(
      (conversation) => conversation.id == conversationId,
    );

    if (conversationIndex == -1) {
      return;
    }

    if (_conversations[conversationIndex].unreadCount == 0) {
      return;
    }

    _conversations[conversationIndex] = _conversations[conversationIndex]
        .copyWith(unreadCount: 0);
    notifyListeners();
    unawaited(_persistConversations());
  }

  void _scheduleAutoReply(
    String conversationId,
    String userText, {
    required int generation,
  }) {
    Future.delayed(const Duration(seconds: 1), () {
      if (generation != _userStateGeneration) {
        return;
      }

      if (getConversationById(conversationId) == null) {
        return;
      }

      _appendMessage(
        conversationId: conversationId,
        text: _buildAutoReplyText(conversationId, userText),
        isMine: false,
      );

      final conversation = getConversationById(conversationId);
      if (conversation == null) {
        return;
      }

      _insertNotification(
        id: _buildNotificationId('message'),
        icon: Icons.chat_bubble_outline_rounded,
        title: '${conversation.name} sent you a new message',
        time: 'just now',
        destinationType: NotificationDestinationType.conversation,
        destinationId: conversationId,
      );
      notifyListeners();
    });
  }

  String _buildAutoReplyText(String conversationId, String userText) {
    final lowerText = userText.toLowerCase();

    if (conversationId.startsWith('roommate-')) {
      return 'Sounds good, we can talk more about budget and room preferences.';
    }

    if (lowerText.contains('still available') ||
        lowerText.contains('available')) {
      return 'Yes, it is still available.';
    }

    if (lowerText.contains('view') || lowerText.contains('see')) {
      return 'Sure, we can arrange a viewing.';
    }

    if (lowerText.contains('price') || lowerText.contains('how much')) {
      return 'I can share a small discount if you are serious.';
    }

    if (conversationId == 'mr-balogun-landlord') {
      return 'You can come by tomorrow and check it out.';
    }

    return "Thanks, I'll get back to you shortly.";
  }

  String _formatMessageTime(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  List<ConversationItem> _buildSeedConversations() {
    return mock_data.conversations
        .map(
          (conversation) => conversation.copyWith(
            messages: List<ChatMessageItem>.from(conversation.messages),
          ),
        )
        .toList();
  }

  List<ConversationItem> _cloneConversations(
    List<ConversationItem> conversations,
  ) {
    return conversations
        .map(
          (conversation) => conversation.copyWith(
            messages: List<ChatMessageItem>.from(conversation.messages),
          ),
        )
        .toList();
  }
}
