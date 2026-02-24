import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

import '../bloc/customer/customer_bloc.dart';
import '../bloc/customer/customer_event.dart';
import '../bloc/customer/customer_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'customer_form_page.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CustomerBloc>()..add(const LoadCustomers()),
      child: const CustomerListView(),
    );
  }
}

class CustomerListView extends StatefulWidget {
  const CustomerListView({super.key});

  @override
  State<CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<CustomerBloc>().add(LoadCustomers(query: query));
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
          'partners.customer'.tr(),
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
            MaterialPageRoute(builder: (context) => const CustomerFormPage()),
          ).then((_) {
             if(context.mounted) context.read<CustomerBloc>().add(const LoadCustomers());
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is CustomerOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search Bar
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
                      hintText: 'Search customers...',
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

              // Customer List
              Expanded(
                child: state is CustomerLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is CustomerLoaded
                        ? (state.customers.isEmpty
                            ? Center(child: Text('partners.no_customers_found'.tr()))
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.customers.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey.shade300,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final customer = state.customers[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFFE3F2FD), // Light blue bg
                                      child: Text(
                                        customer.name[0].toUpperCase(),
                                        style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      customer.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    subtitle: Text(customer.phone ?? '-'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                         showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('partners.delete_customer'.tr()),
                                            content: Text('partners.confirm_delete'.tr(args: [customer.name])),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context), child: Text('partners.cancel'.tr())),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context.read<CustomerBloc>().add(DeleteCustomer(customer.id!));
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
                                          builder: (context) => CustomerFormPage(customer: customer),
                                        ),
                                      ).then((_) {
                                        if(context.mounted) context.read<CustomerBloc>().add(const LoadCustomers());
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
