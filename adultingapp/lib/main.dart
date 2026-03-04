import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/auth_wrapper.dart';
import 'pages/home_page.dart';
import 'pages/quiz_page.dart';
import 'pages/completed_page.dart';
import 'pages/car_maintenance_lesson.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adulting App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),

        initialRoute: '/',

        // 🔥 Named Routes (scalable)
        routes: {
          '/': (_) => const AuthWrapper(),
          '/home': (_) => const MyHomePage(),
          '/completed': (_) => const CompletedPage(),
          '/car-maintenance': (_) => const CarMaintenanceLessonPage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}