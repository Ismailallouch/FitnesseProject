import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/meal_provider.dart';
import '../../models/workout_model.dart';
import '../../models/meal_model.dart';
import '../../widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    final meals = Provider.of<MealProvider>(context).meals;
    final today = DateTime.now();
    final todayWorkouts = workouts.where((w) =>
      w.date.year == today.year && w.date.month == today.month && w.date.day == today.day).toList();
    final todayMeals = meals.where((m) =>
      m.time.year == today.year && m.time.month == today.month && m.time.day == today.day).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Today\'s Workouts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 8),
              if (todayWorkouts.isEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('No workouts logged today.', style: TextStyle(color: Colors.blueGrey)),
                ),
              ...todayWorkouts.map((w) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.fitness_center, color: Colors.blue),
                  ),
                  title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${w.type} • ${w.duration} min'),
                  trailing: Text('${w.date.hour.toString().padLeft(2, '0')}:${w.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.blue)),
                ),
              )),
              const SizedBox(height: 24),
              const Text('Today\'s Meals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 8),
              if (todayMeals.isEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('No meals logged today.', style: TextStyle(color: Colors.blueGrey)),
                ),
              ...todayMeals.map((m) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.restaurant, color: Colors.blue),
                  ),
                  title: Text(m.mealName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${m.calories} kcal • ${m.macros}'),
                  trailing: Text('${m.time.hour.toString().padLeft(2, '0')}:${m.time.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.blue)),
                ),
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/workouts');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/meals');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
} 