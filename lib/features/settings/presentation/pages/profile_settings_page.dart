import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  String? _profilePath;
  final ImagePicker _picker = ImagePicker();
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _roleController = TextEditingController();
  }
  
  // ... dispose ...

  void _populateControllers(Map<String, String> profile) {
    if (_isDataLoaded) return;
    _isDataLoaded = true;
    _nameController.text = profile['name'] ?? '';
    _emailController.text = profile['email'] ?? '';
    _roleController.text = profile['role'] ?? '';
    setState(() {
      _profilePath = profile['profile_path'];
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'user_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String localPath = path.join(directory.path, 'user', fileName);
        
        await Directory(path.join(directory.path, 'user')).create(recursive: true);
        await pickedFile.saveTo(localPath);

        setState(() {
          _profilePath = localPath;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('settings.error_picking_image'.tr(args: [e.toString()]))));
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text('settings.camera'.tr()),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text('settings.gallery'.tr()),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('settings.change_password'.tr()),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(labelText: 'settings.current_password'.tr()),
                  obscureText: true,
                  validator: (val) => val == null || val.isEmpty ? 'auth.required'.tr() : null,
                ),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(labelText: 'settings.new_password'.tr()),
                  obscureText: true,
                  validator: (val) => val == null || val.length < 4 ? 'settings.min_4_chars'.tr() : null,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(labelText: 'settings.confirm_password'.tr()),
                  obscureText: true,
                  validator: (val) {
                    if (val != newPasswordController.text) return 'settings.passwords_do_not_match'.tr();
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('settings.cancel'.tr()),
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {},
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(ChangePasswordRequested(
                      currentPassword: currentPasswordController.text,
                      newPassword: newPasswordController.text,
                    ));
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text('settings.change'.tr()),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>()..loadSettings(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
               if (state is SettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthPasswordChangeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('settings.password_changed_success'.tr())),
                );
              } else if (state is AuthPasswordChangeFailure) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
               if (!_isDataLoaded) {
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                    _populateControllers(state.profileSettings);
                 });
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text('settings.profile_settings_title'.tr()),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileHeader(context),
                        const SizedBox(height: 32),
                        _buildTextField(_nameController, 'settings.full_name'.tr(), Icons.person),
                        const SizedBox(height: 16),
                        _buildTextField(_emailController, 'settings.email'.tr(), Icons.email, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 16),
                        _buildTextField(_roleController, 'settings.role'.tr(), Icons.badge, readOnly: true),
                        const SizedBox(height: 32),
                         SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SettingsCubit>().updateProfileSettings({
                                  'name': _nameController.text,
                                  'email': _emailController.text,
                                  'role': _roleController.text,
                                  'profile_path': _profilePath ?? '',
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('settings.profile_updated_success'.tr())),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('settings.save_changes'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 16),
                         SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _showChangePasswordDialog(context),
                             style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('settings.change_password'.tr(), style: const TextStyle(fontSize: 16, color: Colors.blue)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showImagePickerOptions,
        child: Stack(
          children: [
             Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                image: _profilePath != null && _profilePath!.isNotEmpty && File(_profilePath!).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(_profilePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _profilePath == null || _profilePath!.isEmpty || !File(_profilePath!).existsSync()
                  ? const Icon(Icons.person, size: 60, color: Colors.blue)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Theme.of(context).inputDecorationTheme.fillColor,
      ),
      validator: (val) => val != null && val.isEmpty ? 'auth.required'.tr() : null,
    );
  }
}
