// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/meal_plan_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MealPlanProvider(),
      child: MaterialApp(
        title: 'Calorie Tracker',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
