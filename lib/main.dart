import 'package:flutter/material.dart';
import 'package:shetrackv1/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shetrackv1/screens/track_period_screen.dart';
import 'firebase_options.dart';
import 'package:shetrackv1/screens/calendar_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/track_period': (context) => TrackPeriodScreen(),
        // '/log_nutrition': (context) => LogNutritionScreen(),
        // '/mindfulness': (context) => MindfulnessScreen(),
        // '/health_insights': (context) => HealthInsightsScreen(),
        // '/medications': (context) => MedicationsScreen(),
        // '/symptoms': (context) => SymptomsScreen(),
        '/calendarScreen': (context) => const CalendarScreen(),
      },
    );
  }

}