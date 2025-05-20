import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/meal_model.dart';
import '../../providers/meal_provider.dart';
import 'package:uuid/uuid.dart';

class MealFormScreen extends StatefulWidget {
  const MealFormScreen({Key? key}) : super(key: key);

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mealName = '';
  int _calories = 0;
  String _macros = '';
  DateTime _time = DateTime.now();
  bool _isEdit = false;
  String? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is MealModel) {
      _isEdit = true;
      _id = arg.id;
      _mealName = arg.mealName;
      _calories = arg.calories;
      _macros = arg.macros;
      _time = arg.time;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final provider = Provider.of<MealProvider>(context, listen: false);
    final meal = MealModel(
      id: _id ?? const Uuid().v4(),
      mealName: _mealName,
      calories: _calories,
      macros: _macros,
      time: _time,
    );
    if (_isEdit) {
      provider.updateMeal(meal.id, meal);
    } else {
      provider.addMeal(meal);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_isEdit ? 'Edit Meal' : 'Add Meal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _mealName,
                decoration: const InputDecoration(labelText: 'Meal Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter meal name' : null,
                onSaved: (v) => _mealName = v ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _calories == 0 ? '' : _calories.toString(),
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter calories' : null,
                onSaved: (v) => _calories = int.tryParse(v ?? '') ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _macros,
                decoration: const InputDecoration(labelText: 'Macros (e.g. P:20g, C:30g, F:10g)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter macros' : null,
                onSaved: (v) => _macros = v ?? '',
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.blue.shade50,
                child: ListTile(
                  title: Text('Time: ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time_filled, color: Colors.blue),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_time),
                      );
                      if (picked != null) setState(() => _time = DateTime(_time.year, _time.month, _time.day, picked.hour, picked.minute));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(_isEdit ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 