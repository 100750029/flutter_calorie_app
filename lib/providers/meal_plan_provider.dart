import 'package:flutter/material.dart';
import 'package:flutter_calorie_app/model/meal_plan.dart';

class MealPlanProvider extends ChangeNotifier {
  List<MealPlan> _mealPlans = [];

  List<MealPlan> get mealPlans => _mealPlans;

  // Function to add a new meal plan
  void addMealPlan(MealPlan mealPlan) {
    _mealPlans.add(mealPlan);
    notifyListeners();
  }

  // Function to delete old meal plans
  void deleteMealPlan(DateTime date) {
    _mealPlans.removeWhere((mealPlan) => mealPlan.date.isAtSameMomentAs(date));
    notifyListeners();
  }

  // Function to update meal plans
  void updateMealPlan(DateTime date, MealPlan updatedMealPlan) {
    final index = _mealPlans.indexWhere((mealPlan) => mealPlan.date.isAtSameMomentAs(date));
    if (index != -1) {
      _mealPlans[index] = updatedMealPlan;
      notifyListeners();
    }
  }
}
