import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_doctorappqueue/providers/queue_provider.dart';
import 'package:flutter_doctorappqueue/services/database_helper.dart';
import 'package:flutter_doctorappqueue/services/notification_service.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:flutter_doctorappqueue/screens/queue_screen.dart'; // Import QueueScreen

void main() {
  testWidgets('QueueScreen displays initial message', (WidgetTester tester) async {
    // 1. Create instances of DatabaseHelper and LocalNotificationService
    final dbHelper = DatabaseHelper();
    await dbHelper.initializeDatabase(); // Important!
    final localNotificationService = LocalNotificationService();
    await localNotificationService.initialize();

    // 2. Define a simple GoRouter for the test
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const QueueScreen(),
        ),
      ],
    );

    // 3. Build the app with MultiProvider and MaterialApp.router
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => QueueProvider(
              dbHelper: dbHelper,
              localNotificationService: localNotificationService,
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router, // Use the GoRouter instance
        ),
      ),
    );

    // 4. Verify that the initial message is displayed
    expect(find.text('Doctor/Patient Queue'), findsOneWidget);
  });
}