import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meal_provider.dart';
import '../../models/meal_model.dart';
import '../../widgets/bottom_nav_bar.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<MealProvider>(context).meals;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Meals')),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final m = meals[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.restaurant, color: Colors.blue),
              ),
              title: Text(m.mealName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${m.calories} kcal • ${m.macros}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => Navigator.pushNamed(context, '/meal_form', arguments: m),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      Provider.of<MealProvider>(context, listen: false).deleteMeal(m.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/meal_form'),
        child: const Icon(Icons.add),
        tooltip: 'Add Meal',
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/workouts');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
} 