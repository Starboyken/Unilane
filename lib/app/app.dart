import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/auth/data/firebase_auth_repository.dart';
import 'package:unilane/features/auth/data/app_launch_repository.dart';
import 'package:unilane/features/auth/data/mock_auth_repository.dart';
import 'package:unilane/features/auth/presentation/providers/auth_provider.dart';
import 'package:unilane/features/auth/presentation/screens/splash_screen.dart';
import 'package:unilane/features/auth/data/shared_preferences_app_launch_repository.dart';
import 'package:unilane/features/main/data/firestore_notification_repository.dart';
import 'package:unilane/features/main/data/firestore_conversation_repository.dart';
import 'package:unilane/features/main/data/firestore_marketplace_listing_repository.dart';
import 'package:unilane/features/main/data/firestore_profile_repository.dart';
import 'package:unilane/features/main/data/firebase_storage_listing_media_repository.dart';
import 'package:unilane/features/main/data/local_listing_media_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_conversation_repository.dart';
import 'package:unilane/features/main/data/firestore_roommate_profile_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_notification_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_marketplace_listing_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_roommate_profile_repository.dart';
import 'package:unilane/features/main/data/shared_preferences_profile_repository.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';

class UniLaneApp extends StatelessWidget {
  const UniLaneApp({super.key, this.useFirebaseAuth = false});

  final bool useFirebaseAuth;

  @override
  Widget build(BuildContext context) {
    final authRepository = useFirebaseAuth
        ? FirebaseAuthRepository()
        : MockAuthRepository();
    final launchRepository = SharedPreferencesAppLaunchRepository();
    final marketplaceListingRepository = useFirebaseAuth
        ? FirestoreMarketplaceListingRepository()
        : SharedPreferencesMarketplaceListingRepository();
    final listingMediaRepository = useFirebaseAuth
        ? FirebaseStorageListingMediaRepository()
        : LocalListingMediaRepository();
    final conversationRepository = useFirebaseAuth
        ? FirestoreConversationRepository()
        : SharedPreferencesConversationRepository();
    final roommateProfileRepository = useFirebaseAuth
        ? FirestoreRoommateProfileRepository()
        : SharedPreferencesRoommateProfileRepository();
    final notificationRepository = useFirebaseAuth
        ? FirestoreNotificationRepository()
        : SharedPreferencesNotificationRepository();
    final profileRepository = useFirebaseAuth
        ? FirestoreProfileRepository()
        : SharedPreferencesProfileRepository();

    return MultiProvider(
      providers: [
        Provider<AppLaunchRepository>.value(value: launchRepository),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: authRepository),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CampusMartProvider>(
          create: (_) => CampusMartProvider(
            marketplaceListingRepository: marketplaceListingRepository,
            listingMediaRepository: listingMediaRepository,
            conversationRepository: conversationRepository,
            roommateProfileRepository: roommateProfileRepository,
            notificationRepository: notificationRepository,
            profileRepository: profileRepository,
          ),
          update: (_, authProvider, campusProvider) {
            final provider =
                campusProvider ??
                CampusMartProvider(
                  marketplaceListingRepository: marketplaceListingRepository,
                  listingMediaRepository: listingMediaRepository,
                  conversationRepository: conversationRepository,
                  roommateProfileRepository: roommateProfileRepository,
                  notificationRepository: notificationRepository,
                  profileRepository: profileRepository,
                );

            unawaited(provider.setCurrentUser(authProvider.currentUser));
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniLane',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1D4ED8),
            primary: const Color(0xFF1D4ED8),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF1D4ED8),
                width: 1.5,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF1D4ED8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
