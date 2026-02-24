import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/max_width_container.dart';
import '../../domain/entities/supplier.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/supplier/supplier_bloc.dart';
import '../bloc/supplier/supplier_event.dart';


class SupplierFormPage extends StatefulWidget {
  final Supplier? supplier;

  const SupplierFormPage({super.key, this.supplier});

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _contactPersonController;
  late SupplierBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<SupplierBloc>();
    _nameController = TextEditingController(text: widget.supplier?.name ?? '');
    _phoneController = TextEditingController(text: widget.supplier?.phone ?? '');
    _emailController = TextEditingController(text: widget.supplier?.email ?? '');
    _addressController = TextEditingController(text: widget.supplier?.address ?? '');
    _contactPersonController = TextEditingController(text: widget.supplier?.contactPerson ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final supplier = Supplier(
        id: widget.supplier?.id,
        name: _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        address: _addressController.text.isEmpty ? null : _addressController.text,
        contactPerson: _contactPersonController.text.isEmpty ? null : _contactPersonController.text,
      );

      if (widget.supplier == null) {
        _bloc.add(AddSupplier(supplier));
      } else {
        _bloc.add(UpdateSupplier(supplier));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.supplier == null ? 'partners.add_supplier'.tr() : 'partners.edit_supplier'.tr(),
            style: const TextStyle(
              color: Color(0xFF2962FF), // Blue
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)), // Blue back
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Color(0xFF2962FF)),
              onPressed: _save,
            ),
          ],
        ),
        body: MaxWidthContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                   TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${'partners.name'.tr()} *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.business, color: Color(0xFF2962FF)),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (val) => val!.isEmpty ? 'partners.please_enter_name'.tr() : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactPersonController,
                    decoration: InputDecoration(
                      labelText: 'partners.contact_person'.tr(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF2962FF)),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'partners.phone'.tr(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.phone, color: Color(0xFF2962FF)),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'partners.email'.tr(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email, color: Color(0xFF2962FF)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'partners.address'.tr(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on, color: Color(0xFF2962FF)),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
