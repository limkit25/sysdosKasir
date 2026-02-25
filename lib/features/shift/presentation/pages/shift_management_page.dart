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
        backgroundColor: const Color(0xFFF2F3F8),
        body: BlocConsumer<ShiftBloc, ShiftState>(
          listener: (context, state) {
            if (state is ShiftError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStatusSummary(context, state),
                        const SizedBox(height: 16),
                        _buildActionSection(context, state),
                        const SizedBox(height: 16),
                        _buildSettingsSection(context),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'shift.title'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(BuildContext context, ShiftState state) {
    final bool isActive = state is ShiftActive;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.verified_user_rounded : Icons.lock_clock_rounded,
              size: 48,
              color: isActive ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isActive ? 'shift.running'.tr() : 'shift.none'.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isActive ? 'Kasir sedang beroperasi' : 'Kasir sedang tutup',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          if (isActive) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(Icons.access_time_filled_rounded, 'shift.start_time'.tr(), dateFormat.format(state.shift.startTime)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _buildSummaryRow(Icons.account_balance_wallet_rounded, 'shift.starting_cash'.tr(), currencyFormat.format(state.shift.startingCash)),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Text(
              'shift.open_must'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context, ShiftState state) {
    final bool isActive = state is ShiftActive;
    final bool isLoading = state is ShiftLoading;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActionButton(
            context: context,
            title: isActive ? 'shift.end_shift'.tr() : 'shift.start_shift'.tr(),
            subtitle: isActive ? 'Finalisasi transaksi & hitung kas' : 'Mulai sesi penjualan baru',
            icon: isActive ? Icons.logout_rounded : Icons.login_rounded,
            color: isActive ? Colors.red : Colors.green,
            onTap: () {
              if (isActive) {
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
          _buildActionButton(
            context: context,
            title: 'shift.history'.tr(),
            subtitle: 'Lihat rekapitulasi shift sebelumnya',
            icon: Icons.history_rounded,
            color: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShiftHistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 6))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 16, bottom: 12),
          child: Text(
            'shift.settings'.tr().toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              if (settingsState is SettingsLoaded) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.security_rounded, color: Colors.blue),
                  ),
                  title: Text('shift.require_shift'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('shift.require_shift_desc'.tr(), style: const TextStyle(fontSize: 12)),
                  trailing: Switch(
                    value: settingsState.isShiftEnabled,
                    activeColor: Colors.blue,
                    onChanged: (val) => context.read<SettingsCubit>().toggleShiftEnabled(val),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
