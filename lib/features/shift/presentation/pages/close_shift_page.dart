import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/shift.dart';
import '../bloc/shift/shift_bloc.dart';

class CloseShiftPage extends StatefulWidget {
  final Shift currentShift;

  const CloseShiftPage({super.key, required this.currentShift});

  @override
  State<CloseShiftPage> createState() => _CloseShiftPageState();
}

class _CloseShiftPageState extends State<CloseShiftPage> {
  final _formKey = GlobalKey<FormState>();
  final _cashController = TextEditingController();
  final _noteController = TextEditingController();
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  int _actualCash = 0;

  @override
  void dispose() {
    _cashController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Basic calculation for UI display. The true source of truth is calculated in the repository
    // but we can estimate it here if needed, or rely solely on backend (which is safer).
    // For this UI, we just ask for actual cash.

    return BlocProvider(
      create: (context) => getIt<ShiftBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('shift.close_shift_title'.tr()),
          elevation: 0,
          backgroundColor: Colors.red.shade700,
        ),
      body: BlocListener<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state is ShiftClosedSuccess) {
            // Show summary dialog
            _showSummaryDialog(state.shift);
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Text('shift.shift_started'.tr(), style: const TextStyle(color: Colors.grey)),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(widget.currentShift.startTime),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(height: 24),
                      Text('shift.starting_cash_label'.tr(), style: const TextStyle(color: Colors.grey)),
                      Text(
                        currencyFormatter.format(widget.currentShift.startingCash),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                Text(
                  'shift.actual_cash_desc'.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _cashController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'shift.actual_cash_label'.tr(),
                    prefixIcon: const Icon(Icons.payments, size: 32),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _actualCash = int.tryParse(val) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'shift.must_be_filled'.tr();
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'shift.discrepancy_note_optional'.tr(),
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
                        backgroundColor: Colors.red.shade700,
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ShiftBloc>().add(CloseShift(
                            shiftId: widget.currentShift.id, 
                            actualEndingCash: _actualCash,
                            note: _noteController.text,
                          ));
                        }
                      },
                      child: Text('shift.end_shift'.tr()),
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

  void _showSummaryDialog(Shift closedShift) {
    final expected = closedShift.expectedEndingCash ?? 0;
    final actual = closedShift.actualEndingCash ?? 0;
    final diff = actual - expected;
    final isMatch = diff == 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('shift.shift_summary'.tr(), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow('shift.expected_cash'.tr(), expected),
            _buildRow('shift.actual_cash'.tr(), actual),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('shift.discrepancy'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  currencyFormatter.format(diff),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMatch ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!isMatch)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade50,
                child: Text(
                  diff < 0 ? 'shift.cash_shortage'.tr() : 'shift.cash_overage'.tr(),
                  style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green.shade50,
                child: Text(
                  'shift.cash_balanced'.tr(),
                  style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Pop dialog, then pop back to dashboard out of POS
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); // Exit POS page
            },
            child: Text('shift.ok'.tr()),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(currencyFormatter.format(amount), style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
