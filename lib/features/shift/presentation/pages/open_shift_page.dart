import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/shift/shift_bloc.dart';

class OpenShiftPage extends StatefulWidget {
  const OpenShiftPage({super.key});

  @override
  State<OpenShiftPage> createState() => _OpenShiftPageState();
}

class _OpenShiftPageState extends State<OpenShiftPage> {
  final _formKey = GlobalKey<FormState>();
  final _cashController = TextEditingController(text: '0');
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return BlocProvider(
      create: (context) => getIt<ShiftBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('shift.open_shift_title'.tr()),
          elevation: 0,
        ),
      body: BlocListener<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state is ShiftActive) {
            Navigator.pop(context, true); // Return true indicating success
          } else if (state is ShiftError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.point_of_sale, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                Text(
                  'shift.enter_starting_cash'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'shift.starting_cash_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _cashController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'shift.starting_cash_label'.tr(),
                    prefixIcon: const Icon(Icons.money),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'shift.please_enter_starting_cash'.tr();
                    }
                    if (int.tryParse(value) == null) {
                      return 'shift.invalid_amount'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'shift.note_optional'.tr(),
                    prefixIcon: const Icon(Icons.note),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),

                BlocBuilder<ShiftBloc, ShiftState>(
                  builder: (context, state) {
                    if (state is ShiftLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final authState = context.read<AuthBloc>().state;
                           // Simplified: Ideally we want User ID here, but our current AuthState only has Name. 
                           // For now, assume User ID 1 (Admin) or fallback logic.
                           // In a real scenario, AuthAuthenticated should hold the user ID.
                           int userId = 1; 
                           if (authState is AuthAuthenticated) {
                              userId = authState.user.id;
                           }

                          context.read<ShiftBloc>().add(OpenShift(
                            userId: userId, 
                            startingCash: int.parse(_cashController.text),
                            note: _noteController.text,
                          ));
                        }
                      },
                      child: Text('shift.open_now'.tr()),
                    );
                  },
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
