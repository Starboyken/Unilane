// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/app/app.dart';
import 'package:unilane/features/auth/domain/auth_user.dart';
import 'package:unilane/features/auth/models/signup_method.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/add_listing_screen.dart';
import 'package:unilane/features/main/presentation/screens/lodges_screen.dart';
import 'package:unilane/features/main/presentation/screens/main_shell_screen.dart';
import 'package:unilane/features/main/presentation/screens/product_detail_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows splash and moves to onboarding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UniLaneApp());

    expect(find.text('UniLane'), findsOneWidget);
    expect(
      find.text('Trusted campus marketplace and student living'),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Buy & Sell with Confidence'), findsOneWidget);
  });

  testWidgets('returning users go from splash to login', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'seen_onboarding': true});

    await tester.pumpWidget(const UniLaneApp());

    expect(find.text('UniLane'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Log In'), findsWidgets);
  });

  testWidgets('marketplace search filters items', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();

    expect(find.text('Used Textbooks Bundle (5 books)'), findsOneWidget);
    expect(find.text('Smart Watch Series 6'), findsOneWidget);

    final marketplaceSearchField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Search books, gadgets, clothes...',
    );

    await tester.enterText(marketplaceSearchField, 'smart');
    await tester.pumpAndSettle();

    expect(find.text('Smart Watch Series 6'), findsOneWidget);
    expect(find.text('Used Textbooks Bundle (5 books)'), findsNothing);
  });

  testWidgets('home search filters featured content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    final homeSearchField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Search deals, stays, services...',
    );

    await tester.enterText(homeSearchField, 'iphone');
    await tester.pumpAndSettle();

    expect(find.text('iPhone 12 Pro Max 256GB'), findsOneWidget);
    expect(find.text('2 Bedroom Self-Contained'), findsNothing);
  });

  testWidgets('listing opens details screen and seller chat', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Smart Watch Series 6').first);
    await tester.pumpAndSettle();

    expect(find.text('About this listing'), findsOneWidget);
    expect(find.text('Quick details'), findsOneWidget);
    expect(find.text('Message Seller'), findsOneWidget);

    await tester.tap(find.text('Message Seller'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Adewale Ogunleye'), findsOneWidget);
    expect(
      find.text('Hi, is "Smart Watch Series 6" still available on UniLane?'),
      findsOneWidget,
    );
    expect(find.text('Yes, it is still available.'), findsWidgets);
  });

  testWidgets('message tile opens chat detail screen', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    expect(provider.getConversationById('adewale-ogunleye')!.unreadCount, 2);

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adewale Ogunleye'));
    await tester.pumpAndSettle();

    expect(find.text('Online now'), findsOneWidget);
    expect(find.text('Is the laptop still available?'), findsWidgets);
    expect(provider.getConversationById('adewale-ogunleye')!.unreadCount, 0);
  });

  testWidgets('messages search filters the inbox', (WidgetTester tester) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();

    final searchField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Search chats, names, or messages',
    );

    await tester.enterText(searchField, 'balogun');
    await tester.pumpAndSettle();

    expect(find.text('Mr. Balogun (Landlord)'), findsOneWidget);
    expect(find.text('Adewale Ogunleye'), findsNothing);
    expect(find.text('Sarah Johnson'), findsNothing);
  });

  testWidgets('notifications open and mark as read', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    expect(provider.unreadNotificationCount, 2);

    await tester.tap(find.byKey(const Key('homeNotificationButton')));
    await tester.pumpAndSettle();

    expect(find.text('UniLane Alerts'), findsOneWidget);
    expect(find.text('Mark all as read'), findsOneWidget);

    await tester.tap(find.text('Mark all as read'));
    await tester.pumpAndSettle();

    expect(provider.unreadNotificationCount, 0);
    expect(find.text('All caught up'), findsOneWidget);
  });

  testWidgets('notification tap opens the related chat', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.byKey(const Key('homeNotificationButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adewale replied about your MacBook listing'));
    await tester.pumpAndSettle();

    expect(find.text('Adewale Ogunleye'), findsOneWidget);
    expect(provider.unreadNotificationCount, 1);
  });

  testWidgets('sending a message updates chat and inbox preview', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adewale Ogunleye'));
    await tester.pumpAndSettle();

    final chatComposer = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Type a message...',
    );

    await tester.enterText(chatComposer, 'Hello');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text("Thanks, I'll get back to you shortly."), findsOneWidget);
    expect(provider.unreadNotificationCount, 3);
    expect(
      provider.notificationItems.first.title,
      'Adewale Ogunleye sent you a new message',
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text("Thanks, I'll get back to you shortly."), findsOneWidget);
  });

  testWidgets('profile edits persist and update the profile card', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();
    await provider.setCurrentUser(
      const AuthUser(
        uid: 'student_1',
        displayName: 'Kenneth Okoh',
        contact: 'okohkenneth65@gmail.com',
        signupMethod: SignupMethod.email,
        isVerifiedStudent: true,
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Kenneth Okoh'), findsOneWidget);
    expect(find.text('Verified student'), findsWidgets);

    await provider.saveCurrentUserProfile(
      provider.currentUserProfile!.copyWith(
        displayName: 'Kenneth O. Okoh',
        campus: 'Ignatius Ajuru University of Education',
        bio: 'Building UniLane for IAUE students.',
        initials: 'KO',
        interests: <String>['Marketplace', 'Lodges', 'Chat', 'Services'],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kenneth O. Okoh'), findsOneWidget);
    expect(provider.currentUserProfile?.displayName, 'Kenneth O. Okoh');
    expect(provider.currentUserProfile?.interests, <String>[
      'Marketplace',
      'Lodges',
      'Chat',
      'Services',
    ]);
  });

  testWidgets('posting a listing adds it to the marketplace', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: AddListingScreen()),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('listingTitleField')),
      'Canon Camera',
    );
    await tester.enterText(
      find.byKey(const Key('listingPriceField')),
      '125000',
    );
    await tester.enterText(
      find.byKey(const Key('listingLocationField')),
      'UniLane Hostel',
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('listingDescriptionField')),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('listingDescriptionField')),
      'A clean camera listing for students who need good photos.',
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('sellerNameField')),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('sellerNameField')), 'Kenneth');

    await tester.scrollUntilVisible(
      find.text('Publish Listing'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Publish Listing'), findsOneWidget);
    await tester.tap(find.text('Publish Listing'));
    await tester.pumpAndSettle();

    expect(provider.marketplaceListings.first.title, 'Canon Camera');
    expect(provider.featuredListings.first.title, 'Canon Camera');
    expect(provider.unreadNotificationCount, 3);
    expect(
      provider.notificationItems.first.title,
      'Your Canon Camera listing is now live on UniLane',
    );
  });

  testWidgets('services flow opens details and starts a chat', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Campus Services'), findsOneWidget);
    expect(find.text('Professional Haircut & Styling'), findsOneWidget);

    await tester.tap(find.text('Professional Haircut & Styling').first);
    await tester.pumpAndSettle();

    expect(find.text("Kola's Barbershop"), findsOneWidget);
    expect(find.text('Message Provider'), findsOneWidget);

    await tester.tap(find.text('Message Provider'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text("Kola's Barbershop"), findsOneWidget);
    expect(
      find.text(
        "Hi Kola's Barbershop, I am interested in Professional Haircut & Styling. Can I book a slot this week?",
      ),
      findsOneWidget,
    );
    expect(find.text("Thanks, I'll get back to you shortly."), findsOneWidget);
  });

  testWidgets('lodges tile opens the lodge browsing screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Lodges').first);
    await tester.pumpAndSettle();

    expect(find.text('Find Student-Friendly Stays'), findsOneWidget);
    expect(find.text('Post a Lodge'), findsOneWidget);
  });

  testWidgets('lodge details show stay-specific information', (
    WidgetTester tester,
  ) async {
    const listing = ListingItem(
      imageUrl:
          'https://images.unsplash.com/photo-1513258496099-48168024aec0?auto=format&fit=crop&w=900&q=80',
      title: '2 Bedroom Self-Contained',
      price: 'N350,000/year',
      location: 'Rumuolumeni',
      category: 'Lodges',
      description:
          'A student-friendly apartment with tiled floors, prepaid meter access, steady water supply, and enough space for two to three students who want a calmer off-campus stay.',
      sellerName: 'Mr. Balogun (Landlord)',
      sellerRole: 'Property owner',
      condition: 'Available now',
      postedTime: 'Posted today',
      roomType: 'Self-contained',
      rentDuration: 'Per year',
      utilities: 'Water, Power',
      distanceToCampus: '12 mins from campus',
      isVerifiedSeller: true,
    );

    await tester.pumpWidget(
      const MaterialApp(home: ProductDetailScreen(listing: listing)),
    );

    expect(find.text('Message Landlord'), findsOneWidget);
    expect(find.text('Verified landlord'), findsWidgets);
    expect(find.text('Lodge specifics'), findsOneWidget);
    expect(find.text('Self-contained'), findsOneWidget);
    expect(find.text('Per year'), findsOneWidget);
    expect(find.text('Water, Power'), findsOneWidget);
    expect(find.text('12 mins from campus'), findsOneWidget);
  });

  testWidgets('lodge filters narrow the stay results', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: LodgesScreen()),
      ),
    );

    expect(find.text('2 Bedroom Self-Contained'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Mini Flat Close to School Gate'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Mini Flat Close to School Gate'), findsOneWidget);

    await tester.tap(find.text('Mini flat'));
    await tester.pumpAndSettle();

    expect(find.text('Mini Flat Close to School Gate'), findsOneWidget);
    expect(find.text('2 Bedroom Self-Contained'), findsNothing);
  });

  testWidgets('roommates flow opens and starts a chat', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Roommates').first);
    await tester.pumpAndSettle();

    expect(find.text('Roommate Matches'), findsOneWidget);
    expect(find.text('Verified student'), findsOneWidget);

    final firstRoommateMessageButton = find.byKey(
      const ValueKey('roommateMessage-toyin-adekoya'),
    );

    await tester.scrollUntilVisible(
      firstRoommateMessageButton,
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(firstRoommateMessageButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Toyin Adekoya'), findsOneWidget);
    expect(
      find.text(
        'Hi Toyin, I saw your roommate post on UniLane. Are you still looking?',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Sounds good, we can talk more about budget and room preferences.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('posting a roommate request adds it to the roommate list', (
    WidgetTester tester,
  ) async {
    final provider = CampusMartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Roommates').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Post Request'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('roommateNameField')),
      'Blessing Okafor',
    );
    await tester.enterText(
      find.byKey(const Key('roommateAreaField')),
      'Rumuolumeni',
    );
    await tester.enterText(
      find.byKey(const Key('roommateBudgetField')),
      'Up to N180k/year',
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('roommateInterestsField')),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('roommateInterestsField')),
      'cooking, quiet study, reading',
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('roommateAboutField')),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('roommateAboutField')),
      'Looking for a calm and neat roommate near IAUE.',
    );

    await tester.scrollUntilVisible(
      find.text('Post Request'),
      200.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post Request'));
    await tester.pumpAndSettle();

    expect(find.text('Blessing Okafor'), findsOneWidget);
    expect(provider.unreadNotificationCount, 3);
    expect(
      provider.notificationItems.first.title,
      'Your roommate request is now live on UniLane',
    );
  });
}
