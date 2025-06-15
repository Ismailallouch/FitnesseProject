import 'package:flutter/material.dart';
import '../../SQLite/database_helper.dart';
import '../../JSON/users.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Users? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // Ici, on suppose que le dernier utilisateur connecté est celui avec l'ID le plus élevé
    final users = await DatabaseHelper().getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        _user = users.last;
        _loading = false;
      });
    } else {
      setState(() {
        _user = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color.fromARGB(255, 86, 40, 129),
              Color(0xFF2D1B69),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _user == null
                  ? const Center(child: Text('Aucun utilisateur trouvé', style: TextStyle(color: Colors.white)))
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.grey.shade400, size: 60),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _user!.fullName ?? _user!.usrName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _user!.email ?? '',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Card(
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nom d\'utilisateur : ${_user!.usrName}', style: const TextStyle(color: Colors.white)),
                                  if (_user!.fullName != null) Text('Nom complet : ${_user!.fullName}', style: const TextStyle(color: Colors.white)),
                                  if (_user!.email != null) Text('Email : ${_user!.email}', style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text('Retour au Dashboard'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF667eea),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
} 