import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/promo.dart';
import '../bloc/promo/promo_bloc.dart';
import '../bloc/promo/promo_event.dart';
import '../bloc/promo/promo_state.dart';

class PromoFormPage extends StatefulWidget {
  final Promo? promo;

  const PromoFormPage({super.key, this.promo});

  @override
  State<PromoFormPage> createState() => _PromoFormPageState();
}

class _PromoFormPageState extends State<PromoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late TextEditingController _minPurchaseController;
  late TextEditingController _maxDiscountController;
  String _type = 'percentage'; // 'percentage' or 'fixed'
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.promo?.name);
    _valueController = TextEditingController(text: widget.promo?.value.toString());
    _minPurchaseController = TextEditingController(text: widget.promo?.minPurchase.toString() ?? '0');
    _maxDiscountController = TextEditingController(text: widget.promo?.maxDiscount.toString() ?? '0');
    _type = widget.promo?.type ?? 'percentage';
    _isActive = widget.promo?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _minPurchaseController.dispose();
    _maxDiscountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.promo == null ? 'sales.add_promo'.tr() : 'sales.edit_promo'.tr(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => getIt<PromoBloc>(),
        child: BlocConsumer<PromoBloc, PromoState>(
          listener: (context, state) {
            if (state is PromoOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('sales.success'.tr())));
              Navigator.pop(context);
            } else if (state is PromoError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is PromoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'sales.promo_name'.tr(), border: const OutlineInputBorder()),
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty ? 'auth.required'.tr() : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(labelText: 'sales.type'.tr(), border: const OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(value: 'percentage', child: Text('sales.percentage'.tr())),
                        DropdownMenuItem(value: 'fixed', child: Text('sales.fixed_amount'.tr())),
                      ],
                      onChanged: (val) {
                         setState(() => _type = val!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _valueController,
                      decoration: InputDecoration(
                        labelText: _type == 'percentage' ? 'sales.percentage_value'.tr() : 'sales.amount_value'.tr(),
                        border: const OutlineInputBorder(),
                        suffixText: _type == 'percentage' ? '%' : 'Rp',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'auth.required'.tr();
                        final num = int.tryParse(val);
                        if (num == null) return 'sales.invalid_number'.tr();
                        if (_type == 'percentage' && (num < 0 || num > 100)) return 'sales.0_100_only'.tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _minPurchaseController,
                      decoration: InputDecoration(
                        labelText: 'sales.min_purchase_optional'.tr(),
                        border: const OutlineInputBorder(),
                        prefixText: 'Rp ',
                        helperText: 'sales.min_purchase_helper'.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: _type == 'percentage' ? TextInputAction.next : TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    if (_type == 'percentage') ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _maxDiscountController,
                        decoration: InputDecoration(
                          labelText: 'sales.max_discount_optional'.tr(),
                          border: const OutlineInputBorder(),
                          prefixText: 'Rp ',
                          helperText: 'sales.max_discount_helper'.tr(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ],
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('sales.active'.tr()),
                      value: _isActive,
                      onChanged: (val) => setState(() => _isActive = val),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final promo = Promo(
                              id: widget.promo?.id,
                              name: _nameController.text,
                              type: _type,
                              value: int.parse(_valueController.text),
                              isActive: _isActive,
                              minPurchase: int.tryParse(_minPurchaseController.text) ?? 0,
                              maxDiscount: int.tryParse(_maxDiscountController.text) ?? 0,
                            );

                            if (widget.promo == null) {
                              context.read<PromoBloc>().add(AddPromo(promo));
                            } else {
                               context.read<PromoBloc>().add(UpdatePromo(promo));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(widget.promo == null ? 'sales.create'.tr() : 'sales.update'.tr(), style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
