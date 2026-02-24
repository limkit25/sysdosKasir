import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';

import '../bloc/shift/shift_bloc.dart';
import 'open_shift_page.dart';
import 'close_shift_page.dart';
import 'shift_history_page.dart';

class ShiftManagementPage extends StatelessWidget {
  const ShiftManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ShiftBloc>()..add(CheckActiveShift()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('shift.title'.tr()),
          elevation: 0,
          centerTitle: true,
        ),
      body: BlocConsumer<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state is ShiftError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          final isShiftActive = state is ShiftActive;
          final isShiftLoading = state is ShiftLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(context, state),
                const SizedBox(height: 32),
                
                // Action Buttons
                if (isShiftLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isShiftActive ? Colors.red.shade600 : Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(isShiftActive ? Icons.lock : Icons.lock_open, size: 28),
                    label: Text(isShiftActive ? 'shift.end_shift'.tr() : 'shift.start_shift'.tr()),
                    onPressed: () {
                      if (isShiftActive) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CloseShiftPage(currentShift: state.shift)),
                        ).then((_) {
                           if (context.mounted) context.read<ShiftBloc>().add(CheckActiveShift());
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OpenShiftPage()),
                        ).then((_) {
                           if (context.mounted) context.read<ShiftBloc>().add(CheckActiveShift());
                        });
                      }
                    },
                  ),
                
                const SizedBox(height: 16),
                
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.history, size: 28),
                  label: Text('shift.history'.tr()),
                  onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ShiftHistoryPage()),
                     );
                  },
                ),

                const SizedBox(height: 32),
                const Divider(),
                
                // Shift Settings
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settingsState) {
                    if (settingsState is SettingsLoaded) {
                      return SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.point_of_sale, color: Colors.blue),
                        title: Text('shift.require_shift'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('shift.require_shift_desc'.tr()),
                        value: settingsState.isShiftEnabled,
                        onChanged: (val) {
                          context.read<SettingsCubit>().toggleShiftEnabled(val);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, ShiftState state) {
    bool isActive = state is ShiftActive;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isActive ? Colors.blue.shade50 : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.info,
              size: 48,
              color: isActive ? Colors.blue.shade600 : Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'shift.running'.tr() : 'shift.none'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.blue.shade900 : Colors.grey.shade800,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildInfoRow('shift.start_time'.tr(), dateFormat.format(state.shift.startTime)),
              const SizedBox(height: 8),
              _buildInfoRow('shift.starting_cash'.tr(), currencyFormat.format(state.shift.startingCash)),
              // Expected Ending Cash is calculated dynamically when requested, 
              // we don't necessarily show it here unless we constantly poll the DB for transactions.
            ] else ...[
              const SizedBox(height: 16),
              Text(
                'shift.open_must'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
