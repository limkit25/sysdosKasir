import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/voucher.dart';
import '../bloc/voucher_bloc.dart';
import '../bloc/voucher_event.dart';
import '../bloc/voucher_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/voucher_form_dialog.dart';

class VoucherManagementPage extends StatelessWidget {
  const VoucherManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VoucherBloc>()..add(LoadVouchers()),
      child: const _VoucherManagementView(),
    );
  }
}

class _VoucherManagementView extends StatelessWidget {
  const _VoucherManagementView();

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('vouchers.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showVoucherForm(context),
            tooltip: 'vouchers.add_voucher'.tr(),
          ),
        ],
      ),
      body: BlocConsumer<VoucherBloc, VoucherState>(
        listener: (context, state) {
          if (state is VoucherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is VoucherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is VoucherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<VoucherBloc>().add(LoadVouchers()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is VoucherLoaded) {
            if (state.vouchers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.card_giftcard, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('vouchers.no_vouchers_yet'.tr()),
                    const SizedBox(height: 8),
                    Text('vouchers.tap_to_create'.tr(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showVoucherForm(context),
                      icon: const Icon(Icons.add),
                      label: Text('vouchers.add_voucher'.tr()),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.vouchers.length,
              itemBuilder: (context, index) {
                final voucher = state.vouchers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: voucher.isActive ? Colors.green.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.card_giftcard,
                        color: voucher.isActive ? Colors.green.shade700 : Colors.grey.shade600,
                      ),
                    ),
                    title: Text(
                      voucher.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      currency.format(voucher.amount),
                      style: const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Active/Inactive Switch
                        Switch(
                          value: voucher.isActive,
                          onChanged: (val) {
                            context.read<VoucherBloc>().add(ToggleVoucherActive(voucher.id!, val));
                          },
                          activeColor: Colors.green,
                        ),
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showVoucherForm(context, voucher),
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, voucher),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showVoucherForm(BuildContext context, [Voucher? voucher]) async {
    final result = await showDialog<Voucher>(
      context: context,
      builder: (_) => VoucherFormDialog(voucher: voucher),
    );

    if (result != null && context.mounted) {
      if (voucher == null) {
        // Create new
        context.read<VoucherBloc>().add(SaveVoucher(result));
      } else {
        // Update existing
        context.read<VoucherBloc>().add(UpdateVoucher(result));
      }
    }
  }

  void _confirmDelete(BuildContext context, Voucher voucher) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('vouchers.delete_voucher_title'.tr()),
        content: Text('vouchers.confirm_delete_voucher'.tr(args: [voucher.name])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('vouchers.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              context.read<VoucherBloc>().add(DeleteVoucher(voucher.id!));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('vouchers.voucher_deleted'.tr(args: [voucher.name]))),
              );
            },
            child: Text('vouchers.delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
