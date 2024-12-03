import 'package:flutter/material.dart';
import 'package:jimkanman_delivery/config/AppColors.dart';
import 'package:jimkanman_delivery/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryDark,
          secondary: AppColors.primary,
        ),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
