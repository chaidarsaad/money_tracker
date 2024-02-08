import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_tracker/db/database_helper.dart';
import 'package:money_tracker/shared/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      checkUserTableAndNavigate();
    });
  }

  Future<void> checkUserTableAndNavigate() async {
    bool isUserTableEmpty = await DatabaseHelper.instance.isUserTableEmpty();

    if (isUserTableEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/onboarding', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Money Tracker',
              style: colorTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 25,
              ),
            ),
            Icon(
              Icons.attach_money,
              size: 45,
              color: Color(
                0xff14193F,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
