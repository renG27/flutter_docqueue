import 'package:flutter/material.dart';
import 'package:flutter_doctorappqueue/services/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_doctorappqueue/providers/queue_provider.dart';
import 'package:flutter_doctorappqueue/screens/queue_screen.dart';
import 'package:flutter_doctorappqueue/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.initializeDatabase();

  final LocalNotificationService localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();
  await localNotificationService.requestPermissions(); // Request permissions

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QueueProvider(
            dbHelper: dbHelper,
            localNotificationService: localNotificationService,
          ),
        ),
      ],
      child: const MaterialApp(
        home: QueueScreen(),
      ),
    ),
  );
}