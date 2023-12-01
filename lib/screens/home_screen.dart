import 'package:flutter/material.dart';
import 'package:flutter_calorie_app/model/meal_plan.dart';
import 'package:flutter_calorie_app/screens/meal_selection_screen.dart';
import 'package:provider/provider.dart';
import '../providers/meal_plan_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MealPlanProvider mealPlanProvider = Provider.of<MealPlanProvider>(context);

    List<MealPlan> mealPlans = mealPlanProvider.mealPlans;

    // Meals sorted by date
    mealPlans.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Meal Plans')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_screen_background.jpeg'), // Adjust the path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mealPlans.length,
                itemBuilder: (context, index) {
                  MealPlan mealPlan = mealPlans[index];
                  int totalCalories = mealPlan.meals.fold(0, (sum, meal) => sum + meal.calories * meal.quantity);

                  return ListTile(
                    title: Text('Date: ${mealPlan.date}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Calories: $totalCalories'),
                        const Text('Meals:'),
                        ...mealPlan.meals.map(
                          (meal) => Text('${meal.name} - Quantity: ${meal.quantity}'),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            mealPlanProvider.deleteMealPlan(mealPlan.date);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Edit meal plan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealSelectionScreen(existingMealPlan: mealPlan),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Edit a meal
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealSelectionScreen(existingMealPlan: mealPlan),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0), 
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    // Add a new meal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealSelectionScreen(),
                      ),
                    );
                  },
                  child: const Text('Add Meal Plan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
