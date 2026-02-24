import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/voucher.dart';

class VoucherFormDialog extends StatefulWidget {
  final Voucher? voucher; // null = create new, otherwise edit

  const VoucherFormDialog({Key? key, this.voucher}) : super(key: key);

  @override
  State<VoucherFormDialog> createState() => _VoucherFormDialogState();
}

class _VoucherFormDialogState extends State<VoucherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.voucher != null) {
      _nameController.text = widget.voucher!.name;
      _amountController.text = widget.voucher!.amount.toString();
      _isActive = widget.voucher!.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.voucher != null;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
                    isEdit ? 'Edit Voucher' : 'vouchers.add_voucher'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Voucher Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'vouchers.voucher_code'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.card_giftcard),
                  hintText: 'vouchers.voucher_code_hint'.tr(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter voucher name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'vouchers.discount_value'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = int.tryParse(val);
                  if (amount == null || amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Active Status
              SwitchListTile(
                title: Text('vouchers.active'.tr()),
                subtitle: Text(_isActive ? 'vouchers.voucher_is_active'.tr() : 'vouchers.voucher_is_inactive'.tr()),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Preview
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('vouchers.preview'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      _nameController.text.isEmpty ? '-' : _nameController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(int.tryParse(_amountController.text) ?? 0),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  isEdit ? 'UPDATE VOUCHER' : 'vouchers.add_voucher'.tr().toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
         ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final voucher = Voucher(
        id: widget.voucher?.id,
        name: _nameController.text.trim(),
        amount: int.parse(_amountController.text),
        isActive: _isActive,
        createdDate: widget.voucher?.createdDate ?? DateTime.now(),
      );
      Navigator.pop(context, voucher);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
