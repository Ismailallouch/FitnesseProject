import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_model.dart';
import '../../widgets/bottom_nav_bar.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Workouts')),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final w = workouts[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.fitness_center, color: Colors.blue),
              ),
              title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${w.type} • ${w.duration} min'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => Navigator.pushNamed(context, '/workout_form', arguments: w),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      Provider.of<WorkoutProvider>(context, listen: false).deleteWorkout(w.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/workout_form'),
        child: const Icon(Icons.add),
        tooltip: 'Add Workout',
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard');
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