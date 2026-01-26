import 'package:flutter/material.dart';
import 'package:registration_form_app/models/user_model.dart';
import 'package:registration_form_app/services/storage_service.dart';
import 'package:registration_form_app/screens/registration_screen.dart';
import 'package:registration_form_app/widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<UserModel> _users = [];
  bool _showActiveOnly = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _storageService.getUsers();
    setState(() {
      _users = users;
    });
  }

  void _toggleFilter() {
    setState(() {
      _showActiveOnly = !_showActiveOnly;
    });
  }

  List<UserModel> get _filteredUsers {
    if (_showActiveOnly) {
      return _users.where((user) => user.isActive).toList();
    }
    return _users;
  }

  void _navigateToRegistration({UserModel? user}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationScreen(
          user: user,
          onUserSaved: _loadUsers,
        ),
      ),
    );
    _loadUsers();
  }

  void _deleteUser(String userId) async {
    await _storageService.deleteUser(userId);
    _loadUsers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted successfully')),
    );
  }

  void _toggleUserStatus(String userId) async {
    await _storageService.toggleUserStatus(userId);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
        actions: [
          IconButton(
            icon: Icon(_showActiveOnly ? Icons.filter_alt : Icons.filter_alt_outlined),
            onPressed: _toggleFilter,
            tooltip: _showActiveOnly ? 'Show All Users' : 'Show Active Only',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToRegistration(),
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
      body: _filteredUsers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No users registered yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a new user',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserCard(
                    user: user,
                    onEdit: () => _navigateToRegistration(user: user),
                    onDelete: () => _deleteUser(user.id),
                    onToggleStatus: () => _toggleUserStatus(user.id),
                  ),
                );
              },
            ),
    );
  }
}