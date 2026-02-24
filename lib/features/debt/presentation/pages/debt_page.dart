import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/debt_bloc.dart';
import '../bloc/debt_event.dart';
import '../bloc/debt_state.dart';
import '../../../partners/domain/entities/customer.dart'; // Ensure correct import logic or fetch customer name from transaction if available
import '../../../pos/domain/entities/transaction_entity.dart';

class DebtPage extends StatelessWidget {
  const DebtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DebtBloc>()..add(LoadDebts()),
      child: const DebtView(),
    );
  }
}

class DebtView extends StatefulWidget {
  const DebtView({super.key});

  @override
  State<DebtView> createState() => _DebtViewState();
}

class _DebtViewState extends State<DebtView> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  bool _showUnpaid = true;
  bool _showPaid = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<DebtBloc>().add(LoadDebts(
      searchQuery: _searchController.text,
      filterDate: _selectedDate,
      showUnpaid: _showUnpaid,
      showPaid: _showPaid,
    ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('debt.title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue.shade800),
      ),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.sort, color: Colors.blue.shade800),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                    onChanged: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedDate == null ? 'Due Date' : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                              style: TextStyle(color: _selectedDate == null ? Colors.grey.shade600 : Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_selectedDate != null)
                            GestureDetector(
                              onTap: () {
                                setState(() { _selectedDate = null; });
                                _applyFilters();
                              },
                              child: const Icon(Icons.close, size: 16, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Summary Header
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: BlocBuilder<DebtBloc, DebtState>(
              builder: (context, state) {
                int totalTransaction = 0;
                int totalCash = 0;

                if (state is DebtLoaded) {
                  totalTransaction = state.debts.length;
                  for (var t in state.debts) {
                    // Total Cash = Remaining Unpaid
                    totalCash += (t.totalAmount - t.paymentAmount);
                  }
                }

                final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Cash', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(currency.format(totalCash), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Total Transaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('$totalTransaction', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // Checkboxes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _showUnpaid,
                      activeColor: Colors.blue.shade800,
                      onChanged: (val) {
                        setState(() { _showUnpaid = val ?? false; });
                        _applyFilters();
                      },
                    ),
                    const Text('Not paid off yet', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _showPaid,
                      activeColor: Colors.blue.shade800,
                      onChanged: (val) {
                        setState(() { _showPaid = val ?? false; });
                        _applyFilters();
                      },
                    ),
                    const Text('Paid Off', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),

          // List Body
          Expanded(
            child: BlocConsumer<DebtBloc, DebtState>(
              listener: (context, state) {
                 if (state is DebtError) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
                 } else if (state is DebtLoaded && state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green));
                 }
              },
              builder: (context, state) {
                if (state is DebtLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DebtLoaded) {
                  if (state.debts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Data of credit is empty',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.debts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final transaction = state.debts[index];
                      final remaining = transaction.totalAmount - transaction.paymentAmount;
                      final customerName = transaction.guestName ?? (transaction.customerId != null ? 'Customer #${transaction.customerId}' : 'Guest');

                      return InkWell(
                        onTap: () => _showDetailDialog(context, transaction, currency),
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Expanded(child: Text('Order #${transaction.id} - $customerName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                     Chip(
                                       label: Text(remaining <= 0 ? 'Paid' : 'Unpaid', style: const TextStyle(color: Colors.white, fontSize: 10)),
                                       backgroundColor: remaining <= 0 ? Colors.green : Colors.red,
                                       padding: EdgeInsets.zero,
                                       visualDensity: VisualDensity.compact,
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 8),
                                 Text('Date: ${DateFormat('dd MMM yyyy HH:mm').format(transaction.dateTime)}', style: const TextStyle(color: Colors.grey)),
                                 if (transaction.note != null && transaction.note!.isNotEmpty)
                                    Text('Note: ${transaction.note}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                 
                                 const Divider(),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                          Text('Total: ${currency.format(transaction.totalAmount)}'),
                                          Text('${'debt.already_paid'.tr()}: ${currency.format(transaction.paymentAmount)}', style: const TextStyle(color: Colors.green)),
                                          if (remaining > 0)
                                            Text('${'debt.remaining'.tr()}: ${currency.format(remaining)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                       ],
                                     ),
                                     if (remaining > 0)
                                       ElevatedButton(
                                         onPressed: () => _showPayDialog(context, transaction),
                                         style: ElevatedButton.styleFrom(
                                           backgroundColor: Colors.blue.shade800, 
                                           foregroundColor: Colors.white,
                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                         ),
                                         child: Text('debt.pay'.tr()),
                                       ),
                                   ],
                                 ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          
          // Add Credit Bottom Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to Dashboard and switch to POS tab, or just navigate to PosPage directly
                // (Since Add Credit manually is not a feature yet, navigating to POS is the logical step)
                Navigator.pop(context); // Go back to dashboard where POS is an option
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Add Credit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPayDialog(BuildContext context, Transaction transaction) {
      final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
      final remaining = transaction.totalAmount - transaction.paymentAmount;
      final controller = TextEditingController(text: remaining.toString());
      final bloc = context.read<DebtBloc>(); // Capture bloc context

      showDialog(
        context: context,
        builder: (dialogContext) {
           return StatefulBuilder(
             builder: (dialogContext, setDialogState) {
               return AlertDialog(
                 title: Text('${'debt.pay_debt'.tr()} (Order #${transaction.id})'),
                 content: Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Text('Total: ${currency.format(transaction.totalAmount)}'),
                      Text('${'debt.already_paid'.tr()}: ${currency.format(transaction.paymentAmount)}', style: const TextStyle(color: Colors.green)),
                      Text('${'debt.remaining'.tr()}: ${currency.format(remaining)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'debt.pay'.tr(), prefixText: 'Rp ', border: const OutlineInputBorder()),
                        autofocus: true,
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 8),
                      // Quick pay chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ActionChip(
                            label: Text('debt.lunas'.tr(), style: const TextStyle(fontSize: 12)),
                            avatar: const Icon(Icons.check_circle, size: 14, color: Colors.green),
                            onPressed: () {
                              controller.text = remaining.toString();
                              setDialogState(() {});
                            },
                          ),
                          if (remaining > 10000) ActionChip(
                            label: const Text('50%', style: TextStyle(fontSize: 12)),
                            onPressed: () {
                              controller.text = (remaining ~/ 2).toString();
                              setDialogState(() {});
                            },
                          ),
                        ],
                      ),
                      // Show validation info
                      Builder(builder: (context) {
                        final amount = int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                        if (amount > 0 && amount < remaining) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${'debt.partial_payment_success'.tr()}: ${'debt.remaining'.tr()} = ${currency.format(remaining - amount)}',
                              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                            ),
                          );
                        } else if (amount >= remaining) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('✅ ${'debt.lunas'.tr()}!', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                   ],
                 ),
                 actions: [
                   TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('debt.cancel'.tr())),
                   ElevatedButton(
                     onPressed: () {
                        final amount = int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                        if (amount <= 0) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('debt.invalid_amount'.tr())));
                           return;
                        }
                        if (amount > remaining) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('debt.amount_exceeds_debt'.tr())));
                           return;
                        }
                        
                        bloc.add(PayDebt(transaction.id!, amount));
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(amount >= remaining ? 'debt.debt_cleared'.tr() : 'debt.partial_payment_success'.tr()),
                          backgroundColor: Colors.green,
                        ));
                     },
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                     child: Text('debt.pay'.tr()),
                   ),
                 ],
               );
             },
           );
        },
      );
  }

  void _showDetailDialog(BuildContext context, Transaction transaction, NumberFormat currency) {
    final remaining = transaction.totalAmount - transaction.paymentAmount;
    final customerName = transaction.guestName ?? (transaction.customerId != null ? 'Customer #${transaction.customerId}' : 'Guest');
    final paidPercent = transaction.totalAmount > 0 
        ? (transaction.paymentAmount / transaction.totalAmount).clamp(0.0, 1.0) 
        : 0.0;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'debt.detail_order'.tr()} #${transaction.id}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),

                // Customer & Date Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text('Customer: $customerName', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(DateFormat('dd MMM yyyy, HH:mm').format(transaction.dateTime), 
                            style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      if (transaction.tableNumber != null && transaction.tableNumber!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.table_restaurant, size: 16, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text('Meja: ${transaction.tableNumber}'),
                          ],
                        ),
                      ],
                      if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.note, size: 16, color: Colors.amber),
                            const SizedBox(width: 6),
                            Expanded(child: Text('Note: ${transaction.note}', style: const TextStyle(fontStyle: FontStyle.italic))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Items List
                Text('debt.item_list'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                ...transaction.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text('${item.quantity}x @ ${currency.format(item.price)}', 
                              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Text(currency.format(item.quantity * item.price), 
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                )),

                const Divider(height: 20),

                // Pricing Breakdown
                _priceRow('Subtotal', currency.format(transaction.items.fold<int>(0, (sum, i) => sum + (i.quantity * i.price)))),
                if (transaction.discountAmount > 0)
                  _priceRow('Diskon', '-${currency.format(transaction.discountAmount)}', color: Colors.red),
                if (transaction.taxAmount > 0)
                  _priceRow('Pajak', '+${currency.format(transaction.taxAmount)}'),
                if (transaction.serviceFeeAmount > 0)
                  _priceRow('Service Fee', '+${currency.format(transaction.serviceFeeAmount)}'),
                const Divider(height: 8),
                _priceRow('Total', currency.format(transaction.totalAmount), isBold: true),

                const SizedBox(height: 16),

                // Payment Progress
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('debt.payment_status'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: paidPercent,
                          backgroundColor: Colors.red.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${'debt.already_paid'.tr()}: ${currency.format(transaction.paymentAmount)}', 
                            style: const TextStyle(color: Colors.green, fontSize: 12)),
                          Text('${'debt.remaining'.tr()}: ${currency.format(remaining)}', 
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          )),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          )),
        ],
      ),
    );
  }
}
