import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection.dart';
import '../bloc/payment_method/payment_method_bloc.dart';
import '../bloc/payment_method/payment_method_event.dart';
import '../bloc/payment_method/payment_method_state.dart';

class PaymentMethodListPage extends StatelessWidget {
  const PaymentMethodListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PaymentMethodBloc>()..add(LoadPaymentMethods()),
      child: const PaymentMethodListView(),
    );
  }
}

class PaymentMethodListView extends StatelessWidget {
  const PaymentMethodListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.payment_methods'.tr()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<PaymentMethodBloc, PaymentMethodState>(
        listener: (context, state) {
           if (state is PaymentMethodError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
           }
        },
        builder: (context, state) {
          if (state is PaymentMethodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentMethodLoaded) {
            if (state.methods.isEmpty) {
              return Center(child: Text('settings.no_payment_methods'.tr()));
            }
            
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.methods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final method = state.methods[index];
                return Card(
                  child: ListTile(
                    title: Text(method.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: method.isFixPayment 
                      ? Text('settings.fix_payment_desc'.tr(), style: const TextStyle(fontSize: 11, color: Colors.orange))
                      : Text('settings.free_nominal_desc'.tr(), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Fix Payment toggle
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Fix', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            SizedBox(
                              height: 24,
                              child: Switch(
                                value: method.isFixPayment,
                                activeColor: Colors.orange,
                                onChanged: (val) {
                                  context.read<PaymentMethodBloc>().add(ToggleFixPayment(method.id, val));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        // Active toggle
                        Switch(
                          value: method.isActive,
                          onChanged: (val) {
                             context.read<PaymentMethodBloc>().add(TogglePaymentMethod(method.id, val));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(context, method.id, method.name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('settings.add_payment_method'.tr()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'settings.method_name'.tr(), hintText: 'settings.eg_ovo_gopay'.tr()),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('settings.cancel'.tr())),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<PaymentMethodBloc>().add(AddPaymentMethod(controller.text.toUpperCase()));
                Navigator.pop(context);
              }
            },
            child: Text('settings.add'.tr()),
          ),
        ],
      )
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('settings.delete_payment_method_title'.tr()),
        content: Text('settings.confirm_delete_payment'.tr(args: [name])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('settings.cancel'.tr())),
          TextButton(
            onPressed: () {
              context.read<PaymentMethodBloc>().add(DeletePaymentMethod(id));
              Navigator.pop(context);
            },
            child: Text('settings.delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      )
    );
  }
}
