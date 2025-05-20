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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is WorkoutModel) {
      _isEdit = true;
      _id = arg.id;
      _name = arg.name;
      _type = arg.type;
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
      type: _type,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_isEdit ? 'Edit Workout' : 'Add Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Workout Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type (e.g. Cardio, Strength)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter type' : null,
                onSaved: (v) => _type = v ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _duration == 0 ? '' : _duration.toString(),
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter duration' : null,
                onSaved: (v) => _duration = int.tryParse(v ?? '') ?? 0,
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.blue.shade50,
                child: ListTile(
                  title: Text('Date: ${_date.toLocal().toString().split(' ')[0]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month_outlined, color: Colors.blue),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _date = picked);
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