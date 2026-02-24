import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../presentation/bloc/purchasing/purchasing_bloc.dart';
import '../../presentation/bloc/purchasing/purchasing_event.dart';
import '../../presentation/bloc/purchasing/purchasing_state.dart';
import 'package:easy_localization/easy_localization.dart';

class PurchaseDetailPage extends StatelessWidget {
  final Purchase purchase;
  final String supplierName;

  const PurchaseDetailPage({super.key, required this.purchase, required this.supplierName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('inventory.purchase_detail'.tr()),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2962FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<PurchasingBloc>()..add(LoadPurchaseItems(purchase.id!)),
        child: Column(
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  _buildInfoRow('inventory.invoice'.tr(), purchase.invoiceNumber ?? '-'),
                  const SizedBox(height: 8),
                  _buildInfoRow('inventory.date'.tr(), DateFormat('dd MMM yyyy, HH:mm').format(purchase.date)),
                  const SizedBox(height: 8),
                  _buildInfoRow('inventory.supplier'.tr(), supplierName),
                  if (purchase.note != null && purchase.note!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('inventory.note_optional'.tr().replaceAll(' (Opsional)', '').replaceAll(' (Optional)', ''), purchase.note!),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('inventory.total_amount'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(purchase.totalAmount),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2962FF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Items List
            Expanded(
              child: BlocBuilder<PurchasingBloc, PurchasingState>(
                builder: (context, state) {
                  if (state is PurchasingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PurchasingFailure) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is PurchaseItemsLoaded) {
                    if (state.items.isEmpty) {
                      return Center(child: Text('inventory.no_items_added_yet'.tr()));
                    }
                    
                    return FutureBuilder<List<Item>>(
                      future: _fetchItemDetails(state.items.map((e) => e.itemId).toList()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                           return const Center(child: CircularProgressIndicator());
                        }
                        
                        final itemMap = {for (var i in snapshot.data!) i.id!: i};
                        
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final pItem = state.items[index];
                            final itemDetail = itemMap[pItem.itemId];
                            
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(itemDetail?.name ?? 'inventory.unknown_item'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${pItem.quantity} ${itemDetail?.unit ?? ''} x ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(pItem.cost)}'),
                                  if (pItem.serialNumbers.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.qr_code, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            'inventory.serials_count'.tr(args: [pItem.serialNumbers.length.toString()]), 
                                            style: const TextStyle(fontSize: 12, color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Text(
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(pItem.quantity * pItem.cost),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: pItem.serialNumbers.isNotEmpty 
                                ? () => _showSerialsDialog(context, itemDetail?.name ?? 'Item', pItem.serialNumbers) 
                                : null,
                            );
                          },
                        );
                      }
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Future<List<Item>> _fetchItemDetails(List<int> itemIds) async {
    final repo = getIt<InventoryRepository>();
    // Fetch all items and filter. 
    // In a real app with many items, we should implement getItemsByIds(List<int> ids) in repository.
    final result = await repo.getItems(); 
    return result.fold(
      (l) => [], 
      (allItems) => allItems.where((i) => itemIds.contains(i.id)).toList(),
    );
  }

  void _showSerialsDialog(BuildContext context, String itemName, List<String> serials) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('inventory.serials_of'.tr(args: [itemName])),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: serials.length,
            itemBuilder: (context, index) => ListTile(
              dense: true,
              leading: Text('#${index + 1}'),
              title: Text(serials[index], style: const TextStyle(fontFamily: 'Monospace')),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('inventory.close'.tr())),
        ],
      ),
    );
  }
}
