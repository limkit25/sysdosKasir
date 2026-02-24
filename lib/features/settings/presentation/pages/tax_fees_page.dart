import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/settings_repository.dart';

class TaxFeesPage extends StatefulWidget {
  const TaxFeesPage({super.key});

  @override
  State<TaxFeesPage> createState() => _TaxFeesPageState();
}

class _TaxFeesPageState extends State<TaxFeesPage> {
  final _formKey = GlobalKey<FormState>();
  final _taxController = TextEditingController();
  final _serviceFeeController = TextEditingController();
  final _repository = getIt<SettingsRepository>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final tax = await _repository.getTaxRate();
    final service = await _repository.getServiceFeeRate();
    setState(() {
      _taxController.text = tax.toString();
      _serviceFeeController.text = service.toString();
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final tax = double.parse(_taxController.text);
        final service = double.parse(_serviceFeeController.text);
        
        await _repository.setTaxRate(tax);
        await _repository.setServiceFeeRate(service);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('settings.settings_saved_success'.tr())),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('settings.error_saving'.tr(args: [e.toString()]))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _taxController.dispose();
    _serviceFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.tax_fees_title'.tr()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      controller: _taxController,
                      label: 'settings.tax_label'.tr(),
                      icon: Icons.percent,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _serviceFeeController,
                      label: 'settings.service_fee_label'.tr(),
                      icon: Icons.room_service,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'settings.save_settings'.tr(),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'settings.please_fill_field'.tr(args: [label]);
        }
        final number = double.tryParse(value);
        if (number == null) {
          return 'settings.invalid_number_format'.tr();
        }
        if (number < 0 || number > 100) {
          return 'settings.value_between_0_100'.tr();
        }
        return null;
      },
    );
  }
}
