import 'package:flutter/material.dart';
import 'package:taskly/pages/bmi/bmi_page.dart';
import 'package:taskly/pages/meal/meal_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/pages/route_page.dart';
import 'package:taskly/pages/signin/signin_page.dart';
import 'package:taskly/pages/signup/signup_page.dart';

void main() async {
  await Hive.initFlutter("hive_boxes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mydiet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      // home: HomePage(),
      initialRoute: "/signin",
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => MealPage(),
        '/bmi': (context) => const BmiPage(),
        '/route': (context) => const RoutePage(),
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => const SignupPage(),
      },
      // home: MealPage(),
    );
  }
}
