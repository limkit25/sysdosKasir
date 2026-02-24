import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/promo.dart';
import '../bloc/promo/promo_bloc.dart';
import '../bloc/promo/promo_event.dart';
import '../bloc/promo/promo_state.dart';
import 'promo_form_page.dart';

class PromoListPage extends StatelessWidget {
  const PromoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PromoBloc>()..add(LoadPromos()),
      child: const PromoListView(),
    );
  }
}

class PromoListView extends StatefulWidget {
  const PromoListView({super.key});

  @override
  State<PromoListView> createState() => _PromoListViewState();
}

class _PromoListViewState extends State<PromoListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'Name A-Z'; // 'Name A-Z', 'Name Z-A', 'Value High-Low', 'Value Low-High'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sales.promo_management'.tr(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.blue),
            onSelected: (value) {
              setState(() {
                _sortOption = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Name A-Z', child: Text('sales.name_a_z'.tr())),
              PopupMenuItem(value: 'Name Z-A', child: Text('sales.name_z_a'.tr())),
              PopupMenuItem(value: 'Value High-Low', child: Text('sales.value_high_low'.tr())),
              PopupMenuItem(value: 'Value Low-High', child: Text('sales.value_low_high'.tr())),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PromoFormPage()),
          ).then((_) => context.read<PromoBloc>().add(LoadPromos()));
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<PromoBloc, PromoState>(
        listener: (context, state) {
          if (state is PromoError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is PromoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
          }
        },
        builder: (context, state) {
          if (state is PromoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PromoLoaded) {
            // Filter
            var filteredPromos = state.promos.where((promo) {
              return promo.name.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

            // Sort
            filteredPromos.sort((a, b) {
              switch (_sortOption) {
                case 'Name A-Z':
                  return a.name.compareTo(b.name);
                case 'Name Z-A':
                  return b.name.compareTo(a.name);
                case 'Value High-Low':
                  return b.value.compareTo(a.value);
                case 'Value Low-High':
                  return a.value.compareTo(b.value);
                default:
                  return 0;
              }
            });

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'sales.search_promo'.tr(),
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: filteredPromos.isEmpty
                      ? Center(child: Text('sales.no_promos_found'.tr()))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: filteredPromos.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final promo = filteredPromos[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor: promo.isActive ? Colors.blue.shade100 : Colors.grey.shade200,
                                  child: Icon(
                                    promo.type == 'percentage' ? Icons.percent : Icons.attach_money,
                                    color: promo.isActive ? Colors.blue : Colors.grey,
                                  ),
                                ),
                                title: Text(
                                  promo.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      promo.type == 'percentage'
                                          ? 'Discount: ${promo.value}%'
                                          : 'Discount: ${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(promo.value)}',
                                      style: TextStyle(color: Colors.grey.shade700),
                                    ),
                                    if (promo.minPurchase > 0)
                                      Text(
                                        'sales.min_purchase'.tr(args: [NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(promo.minPurchase)]),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Switch(
                                      value: promo.isActive,
                                      activeColor: Colors.blue,
                                      onChanged: (val) {
                                        context.read<PromoBloc>().add(UpdatePromo(Promo(
                                              id: promo.id,
                                              name: promo.name,
                                              type: promo.type,
                                              value: promo.value,
                                              isActive: val,
                                              minPurchase: promo.minPurchase,
                                              maxDiscount: promo.maxDiscount,
                                            )));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('sales.delete_promo_title'.tr()),
                                            content: Text('sales.confirm_delete_promo'.tr(args: [promo.name])),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx), child: Text('sales.cancel'.tr())),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  context.read<PromoBloc>().add(DeletePromo(promo.id!));
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                                child: Text('sales.delete'.tr()),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PromoFormPage(promo: promo)),
                                  ).then((_) => context.read<PromoBloc>().add(LoadPromos()));
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
