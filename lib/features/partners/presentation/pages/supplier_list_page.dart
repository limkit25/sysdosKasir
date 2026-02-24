import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

import '../bloc/supplier/supplier_bloc.dart';
import '../bloc/supplier/supplier_event.dart';
import '../bloc/supplier/supplier_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'supplier_form_page.dart';

class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SupplierBloc>()..add(const LoadSuppliers()),
      child: const SupplierListView(),
    );
  }
}

class SupplierListView extends StatefulWidget {
  const SupplierListView({super.key});

  @override
  State<SupplierListView> createState() => _SupplierListViewState();
}

class _SupplierListViewState extends State<SupplierListView> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<SupplierBloc>().add(LoadSuppliers(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)), // Blue back
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'partners.supplier'.tr(),
          style: TextStyle(
            color: Color(0xFF2962FF), // Blue
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2962FF), // Blue
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SupplierFormPage()),
          ).then((_) {
             if(context.mounted) context.read<SupplierBloc>().add(const LoadSuppliers());
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state is SupplierError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is SupplierOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search suppliers...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
              const Divider(height: 1),
              
              Expanded(
                child: state is SupplierLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is SupplierLoaded
                        ? (state.suppliers.isEmpty
                            ? Center(child: Text('partners.no_suppliers_found'.tr()))
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.suppliers.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey.shade300,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final supplier = state.suppliers[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFFE3F2FD), // Light blue bg
                                      child: Text(
                                        supplier.name[0].toUpperCase(),
                                        style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      supplier.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    subtitle: Text(supplier.contactPerson ?? '-'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                         showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('partners.delete_supplier'.tr()),
                                            content: Text('partners.confirm_delete'.tr(args: [supplier.name])),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context), child: Text('partners.cancel'.tr())),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context.read<SupplierBloc>().add(DeleteSupplier(supplier.id!));
                                                },
                                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                                child: Text('partners.delete'.tr()),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SupplierFormPage(supplier: supplier),
                                        ),
                                      ).then((_) {
                                        if(context.mounted) context.read<SupplierBloc>().add(const LoadSuppliers());
                                      });
                                    },
                                  );
                                },
                              ))
                        : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
