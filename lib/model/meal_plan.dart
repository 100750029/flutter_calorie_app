// lib/models/meal_plan.dart
import 'meal.dart';

// Constructor for date and meals added
class MealPlan {
  final DateTime date;
  final List<Meal> meals;

  MealPlan({required this.date, required this.meals});
}
