class MealModel {
  final String id;
  final String mealName;
  final int calories;
  final String macros; // e.g. "P:20g, C:30g, F:10g"
  final DateTime time;

  MealModel({
    required this.id,
    required this.mealName,
    required this.calories,
    required this.macros,
    required this.time,
  });
} 