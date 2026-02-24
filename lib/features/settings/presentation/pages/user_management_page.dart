import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final result = await _authRepository.getUsers();
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      },
      (users) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _deleteUser(User user) async {
    final result = await _authRepository.deleteUser(user.id);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      },
      (_) => _loadUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.staff'.tr()),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserFormDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('settings.no_users_found'.tr()))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.name[0].toUpperCase()),
                      ),
                      title: Text(user.name),
                      subtitle: Text('${user.role} - ${user.email}'),
                      trailing: user.role == 'Administrator'
                          ? null // Don't allow deleting the admin easily from here
                          : IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmDialog(user),
                            ),
                      onTap: () => _showUserFormDialog(user: user),
                    );
                  },
                ),
    );
  }

  void _showDeleteConfirmDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.delete_user'.tr()),
        content: Text('settings.confirm_delete_user'.tr(args: [user.name])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('settings.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('settings.delete'.tr()),
          ),
        ],
      ),
    );
  }

  void _showUserFormDialog({User? user}) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);
    final passwordController = TextEditingController(text: user?.password);
    String selectedRole = user?.role ?? 'Cashier';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, setStateBuilder) {
          return AlertDialog(
            title: Text(isEditing ? 'settings.edit_user'.tr() : 'settings.add_user'.tr()),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'settings.name'.tr()),
                      validator: (v) => v!.isEmpty ? 'auth.required'.tr() : null,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'settings.email_username'.tr()),
                      validator: (v) => v!.isEmpty ? 'auth.required'.tr() : null,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'settings.password'.tr()),
                      obscureText: !isEditing, // Show password if editing for simplicity in this demo, or hide normally
                      validator: (v) => v!.isEmpty ? 'auth.required'.tr() : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(labelText: 'settings.role'.tr()),
                      items: ['Administrator', 'Cashier']
                          .map((role) => DropdownMenuItem(value: role, child: Text(role == 'Administrator' ? 'settings.role_admin'.tr() : 'settings.role_cashier'.tr())))
                          .toList(),
                      onChanged: (val) {
                        setStateBuilder(() {
                          selectedRole = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('settings.cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final newUser = User(
                      id: user?.id ?? 0,
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      role: selectedRole,
                      isActive: true,
                      createdAt: user?.createdAt ?? DateTime.now(),
                    );

                    final repository = getIt<AuthRepository>();
                    final result = isEditing
                        ? await repository.updateUser(newUser)
                        : await repository.createUser(newUser);

                    result.fold(
                      (failure) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
                        }
                      },
                      (_) {
                        Navigator.pop(dialogContext);
                        _loadUsers();
                      },
                    );
                  }
                },
                child: Text(isEditing ? 'settings.update'.tr() : 'settings.save'.tr()),
              ),
            ],
          );
        });
      },
    );
  }
}
