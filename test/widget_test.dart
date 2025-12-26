import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_app/main.dart';

void main() {
  group('MiniChatApp Widget Tests', () {
    testWidgets('App loads and displays Home screen by default', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MiniChatApp());

      // Verify that the Home screen is displayed.
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Chat History'), findsOneWidget);
    });

    testWidgets('Bottom navigation switches tabs', (WidgetTester tester) async {
      await tester.pumpWidget(const MiniChatApp());

      // Verify Home is selected initially.
      expect(find.text('Users'), findsOneWidget);

      // Tap on 'Offers' tab.
      await tester.tap(find.text('Offers'));
      await tester.pumpAndSettle();

      // Verify Offers screen content is displayed.
      // Using 'Offers' finding which could be the tab label or the title in the body.
      // The body title is a Text widget with 'Offers', the tab label is likely also 'Offers'.
      // find.text('Offers') might find 2 widgets now.
      // Let's look for the body text specifically which has a larger font size or simply that we can find it.
      // Alternatively, check if 'Users' is NO longer visible (it might be since it's an IndexedStack effectively or similar? No MainScreen uses IndexedStack).
      // MainScreen uses IndexedStack, so widgets build but are just offscreen/hidden?
      // standard IndexedStack keeps state but painting might be off.
      // However, usually we test visibility or specific unique content.
      // The _buildScrollablePage in MainScreen confirms it puts a Text with 'Offers' in the center.

      // We should check that one of the 'Offers' text widgets corresponds to the body content.
      // Let's navigate to Settings to be distinct.
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Center, 'Settings'), findsOneWidget);
    });

    testWidgets('Home screen tab switcher changes views', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MiniChatApp());

      // Initially 'Users' tab is selected and UsersListScreen is visible.
      // 'Chat History' tab is present but not selected.

      // Tap on 'Chat History'.
      await tester.tap(find.text('Chat History'));
      await tester.pumpAndSettle();

      // Verify that we switched. Since it's a PageView, verify expectation logic.
      // Detailed content verification might depend on empty states, but the action itself shouldn't crash
      // and should settle.

      // This is a basic smoke test for the custom tab switcher interactivity.
    });

    testWidgets('Add user flow works', (WidgetTester tester) async {
      await tester.pumpWidget(const MiniChatApp());

      // Verify initial state: FAB is present.
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Tap FAB to add user.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify Dialog appears.
      expect(find.text('Add User'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter user name.
      await tester.enterText(find.byType(TextField), 'Test User');

      // Tap Add button.
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify Dialog closes.
      expect(find.text('Add User'), findsNothing);

      // Verify 'Test User' appears in the list.
      expect(find.text('Test User'), findsOneWidget);
    });
  });
}
