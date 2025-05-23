import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/workout_model.dart';
import '../../providers/workout_provider.dart';
import 'package:uuid/uuid.dart';

class WorkoutFormScreen extends StatefulWidget {
  const WorkoutFormScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = '';
  int _duration = 0;
  DateTime _date = DateTime.now();
  bool _isEdit = false;
  String? _id;
  
  // Liste prédéfinie des types d'entraînement
  final List<String> _workoutTypes = [
    'Cardio',
    'Musculation',
    'HIIT',
    'Yoga',
    'Étirements',
    'Course',
    'Natation',
    'Autre'
  ];
  
  String _selectedType = 'Cardio';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is WorkoutModel) {
      _isEdit = true;
      _id = arg.id;
      _name = arg.name;
      _type = arg.type;
      _selectedType = arg.type;
      _duration = arg.duration;
      _date = arg.date;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    final workout = WorkoutModel(
      id: _id ?? const Uuid().v4(),
      name: _name,
      type: _selectedType,
      duration: _duration,
      date: _date,
    );
    if (_isEdit) {
      provider.updateWorkout(workout.id, workout);
    } else {
      provider.addWorkout(workout);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          _isEdit ? 'Modifier l\'entraînement' : 'Nouvel entraînement',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              
              // Section Titre
              Text(
                'Détails de l\'entraînement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Nom de l'entraînement
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'entraînement',
                  hintText: 'Ex: Running matinal',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.fitness_center_rounded, color: theme.primaryColor),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Veuillez entrer un nom' : null,
                onSaved: (v) => _name = v ?? '',
              ),
              const SizedBox(height: 20),
              
              // Type d'entraînement (dropdown)
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Type d\'entraînement',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.category_rounded, color: theme.primaryColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                items: _workoutTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
                onSaved: (v) => _type = v ?? '',
              ),
              const SizedBox(height: 20),
              
              // Durée
              TextFormField(
                initialValue: _duration == 0 ? '' : _duration.toString(),
                decoration: InputDecoration(
                  labelText: 'Durée (minutes)',
                  hintText: 'Ex: 30',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.timer_rounded, color: theme.primaryColor),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Veuillez entrer une durée' : null,
                onSaved: (v) => _duration = int.tryParse(v ?? '') ?? 0,
              ),
              const SizedBox(height: 24),
              
              // Sélecteur de date
              Text(
                'Date de l\'entraînement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: theme.primaryColor,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: theme.primaryColor),
                      const SizedBox(width: 16),
                      Text(
                        '${_date.day}/${_date.month}/${_date.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded, 
                        size: 16, 
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Bouton de sauvegarde
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  _isEdit ? 'Mettre à jour' : 'Ajouter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}