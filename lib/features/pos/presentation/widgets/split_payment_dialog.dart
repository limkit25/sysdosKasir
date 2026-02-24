import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/payment_detail.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../../../shift/presentation/bloc/shift/shift_bloc.dart';

class SplitPaymentDialog extends StatefulWidget {
  final int totalAmount;
  final PosBloc posBloc;

  const SplitPaymentDialog({
    Key? key,
    required this.totalAmount,
    required this.posBloc,
  }) : super(key: key);

  @override
  State<SplitPaymentDialog> createState() => _SplitPaymentDialogState();
}

class _SplitPaymentDialogState extends State<SplitPaymentDialog> {
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();

  String _selectedMethod = 'CASH';

  @override
  void initState() {
    super.initState();
    _paymentController.text = widget.totalAmount.toString();
    
    // Load existing state
    final state = widget.posBloc.state;
    if (state is PosLoaded) {
      if (state.tableNumber != null) _tableController.text = state.tableNumber!;
      if (state.note != null) _noteController.text = state.note!;
      if (state.guestName != null) _guestNameController.text = state.guestName!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    
    return BlocBuilder<PosBloc, PosState>(
      bloc: widget.posBloc,
      builder: (context, state) {
        if (state is! PosLoaded) return const SizedBox();

        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'pos.payment_details'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Grand Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'pos.grand_total'.tr()}:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currency.format(widget.totalAmount),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table Number & Pax
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _tableController,
                          decoration: InputDecoration(
                            labelText: 'pos.table_number'.tr(),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          onChanged: (val) => widget.posBloc.add(
                            SetTableInfo(tableNumber: val, pax: state.pax),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('pos.pax'.tr(), style: TextStyle(fontSize: 12, color: Colors.grey[700])),
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
                                      widget.posBloc.add(SetTableInfo(
                                        tableNumber: state.tableNumber,
                                        pax: current - 1,
                                      ));
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
                                    widget.posBloc.add(SetTableInfo(
                                      tableNumber: state.tableNumber,
                                      pax: current + 1,
                                    ));
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
                  const SizedBox(height: 16),

                  // Note
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'pos.note'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (val) => widget.posBloc.add(SetTransactionNote(val)),
                  ),
                  const SizedBox(height: 16),

                  // Customer Name (autocomplete from management + free text)
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: _guestNameController.text),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        // Show all customers when field is empty/focused
                        return state.customers.map((c) => c.name).toList();
                      }
                      return state.customers
                          .where((c) => c.name.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                          .map((c) => c.name)
                          .toList();
                    },
                    onSelected: (String selection) {
                      _guestNameController.text = selection;
                      widget.posBloc.add(SetGuestName(selection));
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      // Sync with our controller
                      if (controller.text.isEmpty && _guestNameController.text.isNotEmpty) {
                        controller.text = _guestNameController.text;
                      }
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'pos.customer_name_optional'.tr(),
                          hintText: 'pos.type_or_select_customer'.tr(),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                          suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  controller.clear();
                                  _guestNameController.clear();
                                  widget.posBloc.add(const SetGuestName(null));
                                },
                              )
                            : null,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 14),
                        onChanged: (val) {
                          _guestNameController.text = val;
                          widget.posBloc.add(SetGuestName(val.isEmpty ? null : val));
                        },
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final name = options.elementAt(index);
                                final customer = state.customers.where((c) => c.name == name).firstOrNull;
                                return ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(name[0].toUpperCase(), 
                                      style: TextStyle(fontSize: 12, color: Colors.blue.shade800)),
                                  ),
                                  title: Text(name, style: const TextStyle(fontSize: 13)),
                                  subtitle: customer?.phone != null 
                                    ? Text(customer!.phone!, style: const TextStyle(fontSize: 11))
                                    : null,
                                  onTap: () => onSelected(name),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Payment Method Selection
                  Text(
                    '${'pos.payment_method'.tr()}:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.paymentMethods.map((method) {
                      final isSelected = _selectedMethod == method.name;
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(method.name),
                            if (method.isFixPayment) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.lock, size: 12, color: isSelected ? Colors.green.shade900 : Colors.grey),
                            ],
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedMethod = method.name;
                              if (method.isFixPayment) {
                                _paymentController.text = widget.totalAmount.toString();
                              }
                            });
                            widget.posBloc.add(const SetDebt(false));
                          }
                        },
                        selectedColor: Colors.green.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.green.shade900 : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // PIUTANG / DEBT Option
                  ChoiceChip(
                    avatar: Icon(Icons.account_balance_wallet, size: 16, 
                      color: _selectedMethod == 'DEBT' ? Colors.white : Colors.red),
                    label: Text('pos.debt'.tr()),
                    selected: _selectedMethod == 'DEBT',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedMethod = 'DEBT';
                          _paymentController.text = widget.totalAmount.toString();
                        });
                        widget.posBloc.add(const SetDebt(true));
                      }
                    },
                    selectedColor: Colors.red.shade400,
                    labelStyle: TextStyle(
                      color: _selectedMethod == 'DEBT' ? Colors.white : Colors.red.shade700,
                      fontWeight: _selectedMethod == 'DEBT' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (_selectedMethod == 'DEBT')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'pos.debt_warning_split'.tr(),
                                style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Payment Amount
                  Builder(
                    builder: (context) {
                      final selectedPaymentMethod = state.paymentMethods
                          .where((m) => m.name == _selectedMethod)
                          .firstOrNull;
                      final isFixed = selectedPaymentMethod?.isFixPayment ?? false;
                      final isDebt = _selectedMethod == 'DEBT';
                      final isLocked = isFixed || isDebt;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _paymentController,
                            enabled: !isLocked,
                            decoration: InputDecoration(
                              labelText: isDebt ? 'pos.debt_amount_split'.tr() : (isFixed ? 'pos.payment_amount_fix'.tr() : 'pos.payment_amount'.tr()),
                              border: const OutlineInputBorder(),
                              prefixText: 'Rp ',
                              filled: isLocked,
                              fillColor: isLocked ? Colors.grey.shade200 : null,
                              suffixIcon: isLocked ? const Icon(Icons.lock, size: 18, color: Colors.orange) : null,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          if (!isLocked) ...[
                            const SizedBox(height: 8),
                            // Quick Payment Buttons
                            Text('pos.quick_pay'.tr(), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _quickCashChip(currency, 'pos.exact_amount'.tr(), widget.totalAmount),
                                if (widget.totalAmount < 50000) _quickCashChip(currency, '50K', 50000),
                                if (widget.totalAmount < 100000) _quickCashChip(currency, '100K', 100000),
                                if (widget.totalAmount < 200000) _quickCashChip(currency, '200K', 200000),
                                if (widget.totalAmount < 500000) _quickCashChip(currency, '500K', 500000),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Process Button
                  ElevatedButton(
                    onPressed: _canProcess() ? _processPayment : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'pos.process_payment'.tr(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  if (!_canProcess())
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _getValidationMessage(),
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canProcess() {
    if (_selectedMethod == 'DEBT') {
      // Debt requires customer name
      return _guestNameController.text.trim().isNotEmpty;
    }
    final paymentAmount = int.tryParse(_paymentController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return paymentAmount >= widget.totalAmount;
  }

  String _getValidationMessage() {
    if (_selectedMethod == 'DEBT') {
      return 'pos.debt_customer_validation'.tr();
    }
    return 'pos.insufficient_payment'.tr();
  }

  void _processPayment() {
    final paymentAmount = int.tryParse(_paymentController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final state = widget.posBloc.state as PosLoaded;

    if (_selectedMethod == 'DEBT') {
      widget.posBloc.add(const SetDebt(true));
    } else {
      widget.posBloc.add(const SetDebt(false));
    }

    int? shiftId;
    int? userId;
    
    // Attempt to get current shift and user IDs
    final shiftState = context.read<ShiftBloc>().state;
    if (shiftState is ShiftActive) {
      shiftId = shiftState.shift.id;
      userId = shiftState.shift.userId;
    }

    widget.posBloc.add(ProcessPayment(
      paymentMethod: _selectedMethod,
      paymentAmount: _selectedMethod == 'DEBT' ? 0 : paymentAmount,
      shiftId: shiftId,
      userId: userId,
    ));

    Navigator.pop(context);
  }

  Widget _quickCashChip(NumberFormat currency, String label, int amount) {
    return ActionChip(
      avatar: const Icon(Icons.flash_on, size: 14, color: Colors.orange),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.amber.shade50,
      side: BorderSide(color: Colors.amber.shade200),
      onPressed: () {
        setState(() {
          _paymentController.text = amount.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _tableController.dispose();
    _noteController.dispose();
    _guestNameController.dispose();
    super.dispose();
  }
}
