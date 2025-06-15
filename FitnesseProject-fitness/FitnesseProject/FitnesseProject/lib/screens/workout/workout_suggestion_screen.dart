import 'package:flutter/material.dart';
import '../../services/workout_suggestion_service.dart';
import '../../models/workout_suggestion_model.dart';

class WorkoutSuggestionScreen extends StatefulWidget {
  const WorkoutSuggestionScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutSuggestionScreen> createState() => _WorkoutSuggestionScreenState();
}

class _WorkoutSuggestionScreenState extends State<WorkoutSuggestionScreen> {
  final WorkoutSuggestionService _suggestionService = WorkoutSuggestionService();
  List<WorkoutSuggestion> _suggestions = [];
  bool _isLoading = false;
  String _selectedType = 'tout';
  String _selectedMuscle = 'chest';
  String _selectedDifficulty = 'beginner';

  final Map<String, String> _muscleGroups = {
    'chest': 'Poitrine',
    'back': 'Dos',
    'shoulders': 'Épaules',
    'biceps': 'Biceps',
    'triceps': 'Triceps',
    'legs': 'Jambes',
    'abs': 'Abdominaux',
  };

  final List<Map<String, String>> _exerciseTypes = [
    {'value': 'tout', 'label': 'Tout'},
    {'value': 'cardio', 'label': 'Cardio'},
    {'value': 'strength', 'label': 'Force'},
    {'value': 'stretching', 'label': 'Étirements'},
    {'value': 'hiit', 'label': 'HIIT'},
    {'value': 'yoga', 'label': 'Yoga'},
    {'value': 'plyometrics', 'label': 'Plyometrics'},
    {'value': 'powerlifting', 'label': 'Powerlifting'},
    {'value': 'olympic_weightlifting', 'label': 'Olympic Weightlifting'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() => _isLoading = true);
    try {
      final suggestions = await WorkoutSuggestionService.fetchSuggestions(
        type: _selectedType == 'tout' ? null : _selectedType,
        muscle: _selectedMuscle,
        difficulty: _selectedDifficulty,
      );
      setState(() {
        _suggestions = suggestions.map((s) => WorkoutSuggestion.fromJson(s)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Color(0xFF6B46FF),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildFilterDropdown({
    required String value,
    required String label,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: Color(0xFF6B46FF),
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        items: items.map((item) => DropdownMenuItem<String>(
          value: item.value,
          child: Text(
            item.child is Text ? (item.child as Text).data! : '',
            style: TextStyle(color: Colors.white),
          ),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B46FF),
              Color(0xFF8B5FFF),
              Color(0xFF9F7AFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        ),
                        Spacer(),
                        Icon(Icons.lightbulb_outline, color: Colors.white.withOpacity(0.8)),
                        SizedBox(width: 16),
                        Icon(Icons.tune, color: Colors.white.withOpacity(0.8)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Suggestions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'd\'Entraînement',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Trouvez les exercices parfaits',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Filters Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildFilterDropdown(
                      value: _selectedType,
                      label: 'Type d\'exercice',
                      items: _exerciseTypes.map((type) =>
                        DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        )
                      ).toList(),
                      onChanged: (value) {
                        setState(() => _selectedType = value!);
                        _loadSuggestions();
                      },
                    ),
                    SizedBox(height: 16),
                    _buildFilterDropdown(
                      value: _selectedMuscle,
                      label: 'Groupe musculaire',
                      items: _muscleGroups.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedMuscle = value!);
                        _loadSuggestions();
                      },
                    ),
                    SizedBox(height: 16),
                    _buildFilterDropdown(
                      value: _selectedDifficulty,
                      label: 'Niveau',
                      items: [
                        DropdownMenuItem(value: 'beginner', child: Text('Débutant')),
                        DropdownMenuItem(value: 'intermediate', child: Text('Intermédiaire')),
                        DropdownMenuItem(value: 'expert', child: Text('Expert')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedDifficulty = value!);
                        _loadSuggestions();
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Results Section
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'Résultats',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            Spacer(),
                            if (!_isLoading)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF6B46FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_suggestions.length} exercices',
                                  style: TextStyle(
                                    color: Color(0xFF6B46FF),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B46FF)),
                                ),
                              )
                            : _suggestions.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Aucune suggestion trouvée',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Essayez de modifier vos filtres',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: _suggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = _suggestions[index];
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF6B46FF).withOpacity(0.08),
                                            blurRadius: 20,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                          childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                          backgroundColor: Colors.white,
                                          collapsedBackgroundColor: Colors.white,
                                          iconColor: Color(0xFF6B46FF),
                                          collapsedIconColor: Color(0xFF6B46FF),
                                          title: Text(
                                            suggestion.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF2D3748),
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF6B46FF).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    suggestion.muscle,
                                                    style: TextStyle(
                                                      color: Color(0xFF6B46FF),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    suggestion.difficulty,
                                                    style: TextStyle(
                                                      color: Colors.orange[700],
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF8F9FA),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.fitness_center,
                                                        color: Color(0xFF6B46FF),
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Équipement: ${suggestion.equipment}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(0xFF4A5568),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        color: Color(0xFF6B46FF),
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Instructions:',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                color: Color(0xFF4A5568),
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              suggestion.instructions,
                                                              style: TextStyle(
                                                                color: Color(0xFF718096),
                                                                height: 1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}