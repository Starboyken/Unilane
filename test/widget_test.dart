// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:unitrade/app/app.dart';
import 'package:unitrade/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unitrade/features/main/presentation/screens/main_shell_screen.dart';

void main() {
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
    await tester.pumpAndSettle();

    expect(find.text('Adewale Ogunleye'), findsOneWidget);
    expect(
      find.text('Hi, is "Smart Watch Series 6" still available on UniLane?'),
      findsOneWidget,
    );
  });

  testWidgets('message tile opens chat detail screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CampusMartProvider(),
        child: const MaterialApp(home: MainShellScreen()),
      ),
    );

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adewale Ogunleye'));
    await tester.pumpAndSettle();

    expect(find.text('Online now'), findsOneWidget);
    expect(find.text('Is the laptop still available?'), findsWidgets);
  });
}
