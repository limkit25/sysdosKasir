import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../partners/domain/repositories/partner_repository.dart';


import '../bloc/purchasing/purchasing_bloc.dart';
import '../bloc/purchasing/purchasing_event.dart';
import '../bloc/purchasing/purchasing_state.dart';
import 'purchase_form_page.dart';
import 'purchase_detail_page.dart';
import 'package:easy_localization/easy_localization.dart';

class PurchaseListPage extends StatelessWidget {
  const PurchaseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PurchasingBloc>()..add(LoadPurchases()),
      child: const PurchaseListView(),
    );
  }
}

class PurchaseListView extends StatefulWidget {
  const PurchaseListView({super.key});

  @override
  State<PurchaseListView> createState() => _PurchaseListViewState();
}

class _PurchaseListViewState extends State<PurchaseListView> {
  // Simple cache for supplier names
  Map<int, String> _supplierNames = {};
  
  // Filters
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSuppliers() async {
    final repo = getIt<PartnerRepository>();
    final result = await repo.getSuppliers();
    result.fold(
      (l) => null,
      (suppliers) {
        if (mounted) {
          setState(() {
            _supplierNames = {for (var s in suppliers) s.id!: s.name};
          });
        }
      },
    );
  }
  
  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null 
          ? DateTimeRange(start: _startDate!, end: _endDate!) 
          : null,
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'inventory.purchasing_history'.tr(),
          style: TextStyle(
            color: Color(0xFF2962FF), // Blue
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
             padding: const EdgeInsets.all(16),
             color: Colors.white,
             child: Column(
               children: [
                 // Search Bar
                 TextField(
                   controller: _searchController,
                   decoration: InputDecoration(
                     hintText: 'inventory.search_supplier_or_invoice'.tr(),
                     prefixIcon: const Icon(Icons.search),
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                   ),
                   onChanged: (val) => setState(() {}),
                 ),
                 const SizedBox(height: 12),
                 
                 // Date Filter
                 InkWell(
                   onTap: _pickDateRange,
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Row(
                       children: [
                         const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                         const SizedBox(width: 8),
                         Expanded(
                           child: Text(
                             _startDate != null && _endDate != null
                                 ? '${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}'
                                 : 'inventory.filter_by_date_range'.tr(),
                             style: TextStyle(
                               color: _startDate != null ? Colors.black : Colors.grey,
                             ),
                           ),
                         ),
                         if (_startDate != null)
                           InkWell(
                             onTap: () {
                               setState(() {
                                 _startDate = null;
                                 _endDate = null;
                               });
                             },
                             child: const Icon(Icons.close, color: Colors.grey, size: 20),
                           )
                         else
                           const Icon(Icons.arrow_drop_down, color: Colors.grey),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
          ),
          
          Expanded(
            child: BlocBuilder<PurchasingBloc, PurchasingState>(
              builder: (context, state) {
                if (state is PurchasingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PurchasingFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is PurchasingLoaded) {
                  var purchases = state.purchases;
                  
                  // Apply Filters
                  // 1. Search
                  final query = _searchController.text.toLowerCase();
                  if (query.isNotEmpty) {
                    purchases = purchases.where((p) {
                      final supplier = (_supplierNames[p.supplierId] ?? '').toLowerCase();
                      final invoice = (p.invoiceNumber ?? '').toLowerCase();
                      return supplier.contains(query) || invoice.contains(query);
                    }).toList();
                  }
                  
                  // 2. Date Range
                  if (_startDate != null && _endDate != null) {
                    // Include the entire end date
                    final end = _endDate!.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
                    purchases = purchases.where((p) {
                      return p.date.isAfter(_startDate!.subtract(const Duration(seconds: 1))) && 
                             p.date.isBefore(end);
                    }).toList();
                  }

                  if (purchases.isEmpty) {
                    return Center(child: Text('inventory.no_purchases_found_matching_filter'.tr()));
                  }
                  
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: purchases.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final purchase = purchases[index];
                      final supplierName = _supplierNames[purchase.supplierId] ?? '${'inventory.supplier'.tr()} #${purchase.supplierId}';
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: const Icon(Icons.local_shipping, color: Color(0xFF2962FF)), // Blue icon
                          ),
                          title: Text(supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${'inventory.invoice'.tr()}: ${purchase.invoiceNumber ?? '-'}', style: const TextStyle(fontSize: 12)),
                              Text(DateFormat('dd MMM yyyy, HH:mm').format(purchase.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              if (purchase.note != null && purchase.note!.isNotEmpty)
                                Text('${'inventory.note_optional'.tr().replaceAll(' (Opsional)', '').replaceAll(' (Optional)', '')}: ${purchase.note}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(purchase.totalAmount),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2962FF)),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PurchaseDetailPage(
                                  purchase: purchase, 
                                  supplierName: supplierName
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2962FF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PurchaseFormPage()),
          );
          if (context.mounted) context.read<PurchasingBloc>().add(LoadPurchases());
        },
      ),
    );
  }
}
