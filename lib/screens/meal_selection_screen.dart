import 'package:flutter/material.dart';
import 'package:flutter_calorie_app/model/meal.dart';
import 'package:flutter_calorie_app/model/meal_plan.dart';
import '../providers/meal_plan_provider.dart';
import 'package:provider/provider.dart';

class MealSelectionScreen extends StatefulWidget {
  final MealPlan? existingMealPlan;

  MealSelectionScreen({Key? key, this.existingMealPlan}) : super(key: key);

  @override
  _MealSelectionScreenState createState() => _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {
  List<Meal> selectedMeals = [];
  String selectedDate = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    if (widget.existingMealPlan != null) {
      // State of editing a meal plan
      selectedDate = widget.existingMealPlan!.date.toString();
      selectedMeals = widget.existingMealPlan!.meals;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingMealPlan != null ? 'Edit Meal Plan' : 'Select Meals'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/meal_selection_background.jpeg'), // Adjust the path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Date Picker
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (pickedDate != null && pickedDate != DateTime.now()) {
                  setState(() {
                    selectedDate = pickedDate.toString();
                  });
                }
              },
              child: Text('Select Date: $selectedDate'),
            ),
            // Meal List
            Expanded(
              child: ListView(
                children: [
                  buildMealTile('Milk', 65),
                  buildMealTile('Butter', 740),
                  buildMealTile('Cream', 210),
                  buildMealTile('Cheese', 310),
                  buildMealTile('Ice Cream', 170),
                  buildMealTile('Eggs', 150),
                  buildMealTile('Chicken', 150),
                  buildMealTile('Fish', 220),
                  buildMealTile('Beans', 20),
                  buildMealTile('Carrot', 20),
                  buildMealTile('Peas', 50),
                  buildMealTile('Potatoes', 80),
                  buildMealTile('Tomatoes', 15),
                  buildMealTile('Apple', 45),
                  buildMealTile('Cherries', 50),
                  buildMealTile('Grapes', 60),
                  buildMealTile('Oranges', 35),
                  buildMealTile('Bread', 230),
                  buildMealTile('Rice', 120),
                  buildMealTile('Coffe', 50),
                ],
              ),
            ),
            // Total Calories
            Text('Total Calories: ${calculateTotalCalories()}'),
            // Add Meal Plan Button
            ElevatedButton(
              onPressed: () {
                // Add or update selected meals to the meal plan
                MealPlanProvider mealPlanProvider = Provider.of<MealPlanProvider>(context, listen: false);

                if (widget.existingMealPlan != null) {
                  // Update existing meal plan
                  mealPlanProvider.updateMealPlan(
                    widget.existingMealPlan!.date,
                    MealPlan(date: DateTime.parse(selectedDate), meals: selectedMeals),
                  );
                } else {
                  // Add new meal plan
                  mealPlanProvider.addMealPlan(
                    MealPlan(date: DateTime.parse(selectedDate), meals: selectedMeals),
                  );
                }

                // Navigate to the home screen
                Navigator.pop(context);
              },
              child: Text(widget.existingMealPlan != null ? 'Update Meal Plan' : 'Add Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealTile(String name, int calories) {
    Meal selectedMeal = selectedMeals.firstWhere(
      (meal) => meal.name == name,
      orElse: () => Meal(name: name, calories: calories, quantity: 0),
    );

    return ListTile(
      title: Text(name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Calories: $calories'),
              Text('Quantity: ${selectedMeal.quantity}'),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (selectedMeal.quantity > 0) {
                      selectedMeal.quantity--;
                    }
                  });
                },
              ),
              Text('${selectedMeal.quantity}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    selectedMeal.quantity++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        setState(() {
          // Check if a meal with the same name is already selected
          final existingMealIndex = selectedMeals.indexWhere((meal) => meal.name == name);

          if (existingMealIndex != -1) {
            // If meal is already selected, update its quantity
            selectedMeals[existingMealIndex] = selectedMeal;
          } else {
            // If meal is not selected, add it to the list
            selectedMeals.add(selectedMeal);
          }
        });
      },
    );
  }

  int calculateTotalCalories() {
    return selectedMeals.fold(0, (total, meal) => total + meal.calories * meal.quantity);
  }
}
