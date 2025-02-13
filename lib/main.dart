import 'package:flutter/material.dart';
import 'package:flutter_doctorappqueue/services/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_doctorappqueue/providers/queue_provider.dart';
import 'package:flutter_doctorappqueue/screens/queue_screen.dart';
import 'package:flutter_doctorappqueue/services/notification_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_doctorappqueue/screens/patient_details_screen.dart';
import 'package:flutter_doctorappqueue/screens/patient_view_screen.dart'; // Import PatientViewScreen
import 'package:flutter_doctorappqueue/screens/welcome_screen.dart';   // Import WelcomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.initializeDatabase();

  final LocalNotificationService localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();
  await localNotificationService.requestPermissions();

final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomeScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'patient_details/:patientId',
            builder: (BuildContext context, GoRouterState state) {
              final patientId = state.pathParameters['patientId']!;
              return PatientDetailsScreen(patientId: patientId);
            },
          ),
          GoRoute(
            path: 'patient_view/:patientId',
            builder: (BuildContext context, GoRouterState state) {
              final patientId = state.pathParameters['patientId']!;
              return PatientViewScreen(patientId: patientId);
            },
          ),
          GoRoute(
            path: 'queue',
            builder: (BuildContext context, GoRouterState state) {
              return const QueueScreen();
            },
          ),
        ],
      ),
    ],
  );

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
      child: MaterialApp.router(  // Use MaterialApp.router
        routerConfig: _router,   // Pass the router configuration
        title: 'Doctor Patient Queue',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    ),
  );
}
