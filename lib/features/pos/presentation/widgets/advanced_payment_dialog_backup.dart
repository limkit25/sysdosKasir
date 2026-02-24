import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/pos_bloc.dart';
import '../../presentation/bloc/pos_event.dart';
import '../../presentation/bloc/pos_state.dart';
import '../../../partners/domain/entities/customer.dart';
import '../../../settings/domain/entities/payment_method.dart';
import 'package:intl/intl.dart';

class AdvancedPaymentDialog extends StatefulWidget {
  final int totalAmount;
  final PosBloc posBloc;

  const AdvancedPaymentDialog({Key? key, required this.totalAmount, required this.posBloc}) : super(key: key);

  @override
  _AdvancedPaymentDialogState createState() => _AdvancedPaymentDialogState();
}

class _AdvancedPaymentDialogState extends State<AdvancedPaymentDialog> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();
  final TextEditingController _paxController = TextEditingController();

  String _selectedMethod = 'CASH';
  bool _isSplitPayment = false;
  List<Map<String, dynamic>> _splitPayments = [];

  final List<String> _paymentMethods = [
    'CASH', 'QRIS', 'DEBIT', 'CREDIT', 'TRANSFER', 'OVO', 'GOPAY', 'DANA', 'SHOPEEPAY', 'DEBT'
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalAmount.toString();
    
    // Initialize with existing state if any
    final state = widget.posBloc.state;
    if (state is PosLoaded) {
       if (state.note != null) _noteController.text = state.note!;
       if (state.tableNumber != null) _tableController.text = state.tableNumber!;
       if (state.pax != null) _paxController.text = state.pax.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      bloc: widget.posBloc,
      builder: (context, state) {
        if (state is! PosLoaded) return const SizedBox.shrink();

        return AlertDialog(
          title: const Text('Payment Details'),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // 1. Customer Selection
                   _buildCustomerSelection(state),
                   const SizedBox(height: 10),
                   
                   // 2. Table & Pax & Note
                   Row(
                     children: [
                       Expanded(
                         flex: 3,
                         child: TextField(
                           controller: _tableController,
                           decoration: const InputDecoration(
                             labelText: 'Table Number', 
                             border: OutlineInputBorder(),
                             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                           ),
                           onChanged: (val) => widget.posBloc.add(SetTableInfo(tableNumber: val, pax: state.pax)),
                         ),
                       ),
                       const SizedBox(width: 10),
                       // Pax Counter - More compact design
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Text('Pax', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                           const SizedBox(height: 4),
                           Container(
                             decoration: BoxDecoration(
                               border: Border.all(color: Colors.grey[400]!),
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 InkWell(
                                   onTap: () {
                                     final current = state.pax ?? 0;
                                     if (current > 0) {
                                        _paxController.text = (current - 1).toString();
                                        widget.posBloc.add(SetTableInfo(tableNumber: state.tableNumber, pax: current - 1));
                                     }
                                   },
                                   child: Container(
                                     padding: const EdgeInsets.all(8),
                                     child: const Icon(Icons.remove, size: 20),
                                   ),
                                 ),
                                 Container(
                                   constraints: const BoxConstraints(minWidth: 32),
                                   alignment: Alignment.center,
                                   child: Text(
                                     "${state.pax ?? 0}", 
                                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                   ),
                                 ),
                                 InkWell(
                                   onTap: () {
                                      final current = state.pax ?? 0;
                                      _paxController.text = (current + 1).toString();
                                      widget.posBloc.add(SetTableInfo(tableNumber: state.tableNumber, pax: current + 1));
                                   },
                                   child: Container(
                                     padding: const EdgeInsets.all(8),
                                     child: const Icon(Icons.add, size: 20),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                   const SizedBox(height: 10),
                   TextField(
                     controller: _noteController,
                     decoration: const InputDecoration(labelText: 'Note', border: OutlineInputBorder()),
                     maxLines: 2,
                     onChanged: (val) => widget.posBloc.add(SetTransactionNote(val)),
                   ),
                   const Divider(height: 30),

                   // 3. Payment Method
                   Text("Payment Method", style: Theme.of(context).textTheme.titleMedium),
                   const SizedBox(height: 10),
                   Wrap(
                     spacing: 8.0,
                     runSpacing: 8.0,
                     children: [
                        ...state.paymentMethods.map((method) {
                           final isSelected = _selectedMethod == method.name;
                           final isDebt = false; // Regular methods are not debt
                           return ChoiceChip(
                             label: Text(method.name),
                             selected: isSelected,
                             onSelected: (selected) {
                               if (selected) {
                                 setState(() {
                                   _selectedMethod = method.name;
                                   widget.posBloc.add(const SetDebt(false));
                                 });
                               }
                             },
                             selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                             labelStyle: TextStyle(
                                color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                             ),
                           );
                        }).toList(),
                        // Always verify Debt option is distinct or included? 
                        // User request: "Payment method itu bisa ditambahkan dan hapus di management bisa kan ya?"
                        // So usually "Debt" is a special system method, or can be managed.
                        // Let's keep "DEBT" as a hardcoded option OR rely on it being in the DB?
                        // Usually Debt logic is special (updates isDebt flag).
                        // Let's keep a dedicated "DEBT" chip if it's not in the dynamic list, OR just assume user adds "DEBT" method?
                        // Better: Add dedicated "DEBT" option at the end for the special behavior.
                        ChoiceChip(
                           label: const Text('DEBT / HUTANG'),
                           selected: _selectedMethod == 'DEBT',
                           onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedMethod = 'DEBT';
                                  widget.posBloc.add(const SetDebt(true));
                                });
                              }
                           },
                           selectedColor: Colors.red.shade100,
                           labelStyle: TextStyle(
                              color: _selectedMethod == 'DEBT' ? Colors.red : Colors.black,
                              fontWeight: _selectedMethod == 'DEBT' ? FontWeight.bold : FontWeight.normal
                           ),
                        ),
                     ],
                   ),
                   const SizedBox(height: 20),

                   // 4. Amount
                   TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Payment Amount',
                        border: const OutlineInputBorder(),
                        prefixText: 'Rp ',
                        suffixText: _selectedMethod == 'CASH' ? 'Change: ${_calculateChange()}' : null,
                      ),
                      onChanged: (val) => setState(() {}),
                   ),
                   const SizedBox(height: 10),
                   
                   // Quick Cash Buttons
                   if (_selectedMethod == 'CASH')
                     Wrap(
                       spacing: 8.0,
                       children: [
                         _quickCashButton(widget.totalAmount),
                         _quickCashButton(10000),
                         _quickCashButton(20000),
                         _quickCashButton(50000),
                         _quickCashButton(100000),
                       ],
                     ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                 final amount = int.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                 if (amount < widget.totalAmount && _selectedMethod != 'DEBT') {
                    // Quick confirmation for partial payment not allowed unless Debt
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Full payment required or use DEBT.")));
                    return; 
                 }
                 
                 widget.posBloc.add(ProcessPayment(
                   paymentAmount: amount,
                   paymentMethod: _selectedMethod,
                 ));
                 Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedMethod == 'DEBT' ? Colors.red : Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(_selectedMethod == 'DEBT' ? 'Save as Debt' : 'Pay Now'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerSelection(PosLoaded state) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         DropdownButtonFormField<Customer>(
           decoration: const InputDecoration(labelText: 'Customer', border: OutlineInputBorder()),
           value: state.selectedCustomer,
           items: [
             const DropdownMenuItem<Customer>(value: null, child: Text('Guest / General')),
             ...state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
           ],
           onChanged: (customer) {
              widget.posBloc.add(SelectCustomer(customer));
           },
         ),
         if (state.selectedCustomer == null) ...[
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Guest Name (Optional)', 
                border: OutlineInputBorder(),
                hintText: 'Enter name for order'
              ),
              onChanged: (val) => widget.posBloc.add(SetGuestName(val)),
            ),
         ]
       ],
     );
  }

  Widget _quickCashButton(int amount) {
    return ActionChip(
      label: Text(NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(amount)),
      onPressed: () {
        setState(() {
           _amountController.text = amount.toString();
        });
      },
    );
  }

  String _calculateChange() {
    final amount = int.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final change = amount - widget.totalAmount;
    if (change < 0) return '-';
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(change);
  }

  int _getRemainingAmount() {
    if (!_isSplitPayment || _splitPayments.isEmpty) return widget.totalAmount;
    final totalPaid = _splitPayments.fold<int>(0, (sum, payment) => sum + (payment['amount'] as int? ?? 0));
    return widget.totalAmount - totalPaid;
  }
}
