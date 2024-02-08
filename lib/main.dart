import 'package:flutter/material.dart';
import 'package:money_tracker/screens/create_screen.dart';
import 'package:money_tracker/screens/home_screen.dart';
import 'package:money_tracker/screens/onboarding_page.dart';
import 'package:money_tracker/screens/profile_screen.dart';
import 'package:money_tracker/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashPage(),
        '/onboarding': (context) => OnBoardingScreen(),
        '/home': (context) => HomeScreen(),
        '/create-transaction': (context) => CreateScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
