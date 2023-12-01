// lib/models/meal.dart
class Meal {
  final String name;
  final int calories;
  int quantity;

  // Constructor for meal name and calories 
  Meal({
    required this.name,
    required this.calories,
    this.quantity = 1, 
  });
}
