import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_model.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:intl/intl.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  // Fonction pour obtenir l'icône en fonction du type d'entraînement
  IconData _getWorkoutIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run;
      case 'musculation':
        return Icons.fitness_center;
      case 'hiit':
        return Icons.timer;
      case 'yoga':
        return Icons.self_improvement;
      case 'étirements':
        return Icons.accessibility_new;
      case 'course':
        return Icons.directions_run;
      case 'natation':
        return Icons.pool;
      default:
        return Icons.sports;
    }
  }

  // Fonction pour obtenir la couleur en fonction du type d'entraînement
  Color _getWorkoutColor(String type) {
    switch (type.toLowerCase()) {
      case 'cardio':
        return Colors.red.shade400;
      case 'musculation':
        return Colors.blue.shade600;
      case 'hiit':
        return Colors.orange.shade500;
      case 'yoga':
        return Colors.teal.shade400;
      case 'étirements':
        return Colors.purple.shade300;
      case 'course':
        return Colors.green.shade500;
      case 'natation':
        return Colors.cyan.shade500;
      default:
        return Colors.indigo.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColor,
        centerTitle: true,
        title: const Text(
          'Mes Entraînements',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded),
            onPressed: () {
              // Fonctionnalité de filtrage pourrait être ajoutée ici
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Filtrage bientôt disponible'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                )
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête statistiques
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, 
                      '${workouts.length}', 
                      'Entraînements', 
                      Icons.fitness_center_rounded),
                  _buildStatItem(context, 
                      '${workouts.fold(0, (sum, item) => sum + item.duration)}', 
                      'Minutes', 
                      Icons.timer_rounded),
                  _buildStatItem(context, 
                      '${_calculateWeeklyWorkouts(workouts)}', 
                      'Cette semaine', 
                      Icons.calendar_today_rounded),
                ],
              ),
            ),
          ),
          
          // Titre de la section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              'Historique',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          
          // Liste des entraînements
          Expanded(
            child: workouts.isEmpty 
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      final workoutColor = _getWorkoutColor(workout.type);
                      final workoutIcon = _getWorkoutIcon(workout.type);
                      final formattedDate = DateFormat('dd MMM yyyy').format(workout.date);
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: workoutColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    workoutIcon,
                                    color: workoutColor,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  workout.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: workoutColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            workout.type,
                                            style: TextStyle(
                                              color: workoutColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.timer_outlined,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${workout.duration} min',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.pushNamed(
                                        context, 
                                        '/workout_form', 
                                        arguments: workout
                                      );
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmation(context, workout);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_rounded, color: theme.primaryColor, size: 20),
                                          const SizedBox(width: 8),
                                          const Text('Modifier'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                                          const SizedBox(width: 8),
                                          const Text('Supprimer'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/workout_form'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        elevation: 2,
        tooltip: 'Ajouter un entraînement',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
  
  // Widget pour afficher un élément de statistique
  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  // Widget pour afficher un état vide
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun entraînement enregistré',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par ajouter votre premier entraînement',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/workout_form'),
            child: const Text('Ajouter un entraînement'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
  
  // Fonction pour calculer le nombre d'entraînements cette semaine
  int _calculateWeeklyWorkouts(List<WorkoutModel> workouts) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
    
    return workouts.where((workout) => 
      workout.date.isAfter(startOfWeek) || 
      workout.date.isAtSameMomentAs(startOfWeek)
    ).length;
  }
  
  // Afficher une boîte de dialogue de confirmation de suppression
  void _showDeleteConfirmation(BuildContext context, WorkoutModel workout) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer l\'entraînement'),
        content: Text('Voulez-vous vraiment supprimer "${workout.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<WorkoutProvider>(context, listen: false)
                .deleteWorkout(workout.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}