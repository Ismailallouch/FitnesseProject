class WorkoutSuggestion {
  final String name;
  final String type;
  final String muscle;
  final String equipment;
  final String difficulty;
  final String instructions;

  WorkoutSuggestion({
    required this.name,
    required this.type,
    required this.muscle,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
  });

  factory WorkoutSuggestion.fromJson(Map<String, dynamic> json) {
    return WorkoutSuggestion(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      muscle: json['muscle'] ?? '',
      equipment: json['equipment'] ?? '',
      difficulty: json['difficulty'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'muscle': muscle,
      'equipment': equipment,
      'difficulty': difficulty,
      'instructions': instructions,
    };
  }
} 