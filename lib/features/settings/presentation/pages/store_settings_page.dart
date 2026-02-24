import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/di/injection.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class StoreSettingsPage extends StatefulWidget {
  const StoreSettingsPage({super.key});

  @override
  State<StoreSettingsPage> createState() => _StoreSettingsPageState();
}

class _StoreSettingsPageState extends State<StoreSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _footerController;
  String? _logoPath;
  final ImagePicker _picker = ImagePicker();
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _footerController = TextEditingController();
  }
  
  // ... dispose ...

  void _populateControllers(Map<String, String> settings) {
    if (_isDataLoaded) return; // Prevent overwriting if already loaded
    _isDataLoaded = true;
    _nameController.text = settings['name'] ?? '';
    _addressController.text = settings['address'] ?? '';
    _phoneController.text = settings['phone'] ?? '';
    _emailController.text = settings['email'] ?? '';
    _websiteController.text = settings['website'] ?? '';
    _footerController.text = settings['footer'] ?? '';
    setState(() {
      _logoPath = settings['logo_path'];
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'store_logo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String localPath = path.join(directory.path, 'store', fileName);
        
        await Directory(path.join(directory.path, 'store')).create(recursive: true);
        await pickedFile.saveTo(localPath);

        setState(() {
          _logoPath = localPath;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>()..loadSettings(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('settings.store_settings_title'.tr()),
          centerTitle: true,
           backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
           elevation: 0,
           leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            // Listener removed for population, handled in builder with post frame callback
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
              if (!_isDataLoaded) {
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                    _populateControllers(state.storeSettings);
                 });
              }
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildLogoSection(context),
                      const SizedBox(height: 24),
                      _buildTextField(_nameController, 'settings.store_name'.tr(), Icons.store),
                      const SizedBox(height: 16),
                      _buildTextField(_addressController, 'settings.address'.tr(), Icons.location_on, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildTextField(_phoneController, 'settings.phone'.tr(), Icons.phone, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildTextField(_emailController, 'settings.email'.tr(), Icons.email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildTextField(_websiteController, 'settings.website'.tr(), Icons.language, keyboardType: TextInputType.url),
                      const SizedBox(height: 16),
                      _buildTextField(_footerController, 'settings.receipt_footer_message'.tr(), Icons.receipt, maxLines: 2),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SettingsCubit>().updateStoreSettings({
                                'name': _nameController.text,
                                'address': _addressController.text,
                                'phone': _phoneController.text,
                                'email': _emailController.text,
                                'website': _websiteController.text,
                                'logo_path': _logoPath ?? '',
                                'footer': _footerController.text,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('settings.settings_saved_success'.tr())),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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

  Widget _buildLogoSection(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showImagePickerOptions,
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                image: _logoPath != null && _logoPath!.isNotEmpty && File(_logoPath!).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(_logoPath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _logoPath == null || _logoPath!.isEmpty || !File(_logoPath!).existsSync()
                  ? const Icon(Icons.store, size: 50, color: Colors.grey)
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
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      ),
      validator: (val) => val != null && val.isEmpty ? 'auth.required'.tr() : null,
    );
  }
}
