import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_type_enum.dart';
import '../bloc/item/item_bloc.dart';
import '../bloc/item/item_event.dart';
import '../widgets/stock_adjustment_dialog.dart';
import '../bloc/stock/stock_bloc.dart';
import 'stock_history_page.dart';
import 'item_form_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Determine image provider
    ImageProvider? imageProvider;
    if (item.imagePath != null && File(item.imagePath!).existsSync()) {
      imageProvider = FileImage(File(item.imagePath!));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<StockBloc>()),
        // We might need ItemBloc if we delete from here, but usually passed from list
        // actually we can just use the one from context if we wrap navigate
        // but easier to just use DI if needed or pass callbacks. 
        // For Delete, we need ItemBloc.
        BlocProvider.value(value: getIt<ItemBloc>()), 
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'inventory.product_detail'.tr(),
            style: const TextStyle(
              color: Color(0xFF2962FF), // Blue
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  // 1. Image Section (moved from AppBar)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                        image: imageProvider != null
                            ? DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imageProvider == null
                          ? const Center(
                              child: Icon(Icons.image, size: 80, color: Colors.grey),
                            )
                          : null,
                    ),
                  ),

                  // 2. Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge Row
                          Row(
                            children: [
                              _buildBadge(item.itemType.label, _getItemTypeColor(item.itemType)),
                              if (!item.isVisible) ...[
                                const SizedBox(width: 8),
                                _buildBadge('inventory.hidden'.tr(), Colors.grey),
                              ],
                              if (item.discount > 0) ...[
                                const SizedBox(width: 8),
                                _buildBadge('inventory.disc'.tr(args: ['${item.discount}%']), Colors.red),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),

                        // Name
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Price & Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(item.price),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2962FF),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: item.stock < 5 ? Colors.red.shade50 : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: item.stock < 5 ? Colors.red.shade200 : Colors.green.shade200,
                                ),
                              ),
                              child: Text(
                                'inventory.stock_label'.tr(args: ['${item.stock} ${item.unit}']),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: item.stock < 5 ? Colors.red.shade700 : Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        
                        // Financial / Stock Details
                        Text(
                          'inventory.detail_of_stock_remaining'.tr(),
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.blue.withOpacity(0.1) 
                              : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.blue.withOpacity(0.3) 
                                : Colors.blue.shade100
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(context, 'inventory.residual_capital'.tr(),
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.stock * item.cost)
                              ),
                              const Divider(height: 16),
                              _buildInfoRow(context, 'inventory.basic_price_hpp'.tr(),
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.cost)
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(context, 'inventory.last_base_price'.tr(),
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.cost) // Using current Cost as logic for now
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Details Grid
                        _buildDetailRow(Icons.qr_code, 'inventory.barcode'.tr(), item.barcode ?? '-'),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.scale, 'inventory.weight'.tr(), '${item.weight} ${'inventory.gram_unit'.tr()}'),
                        // Removed distinct Cost row as it is now in the Financial block
                        
                        const SizedBox(height: 32),
                        
                        // Actions Label
                        Text(
                          'inventory.actions'.tr(),
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action Buttons
                        Row(
                          children: [
                             Expanded(
                              child: _buildActionButton(
                                context,
                                label: 'inventory.edit_item'.tr(),
                                icon: Icons.edit,
                                color: Colors.orange,
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemFormPage(item: item),
                                    ),
                                  ).then((_) {
                                    if (!context.mounted) return;
                                    // If edited, we should probably reload or pop
                                    // For simplicity, let's pop with result true to reload list
                                    Navigator.pop(context, true); 
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                context,
                                label: 'inventory.stock_management_title'.tr(),
                                icon: Icons.inventory,
                                color: Colors.blue,
                                onTap: () {
                                  _showStockOptions(context, item);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: _buildActionButton(
                            context,
                            label: 'inventory.delete_product_question'.tr(),
                            icon: Icons.delete,
                            color: Colors.red,
                            isOutlined: true,
                            onTap: () => _confirmDelete(context, item),
                          ),
                        ),
                        const SizedBox(height: 40), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color),
        label: Text(label, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  void _showStockOptions(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Text(
                  'inventory.stock_management_title'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'inventory.purchasing_advice'.tr(),
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (item.itemType == ItemType.imei)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.teal.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.qr_code, color: Colors.teal),
                  ),
                  title: Text('inventory.view_available_serials'.tr()),
                  subtitle: Text('inventory.list_of_unsold_serial_numbers'.tr()),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showSerialsDialog(context, item.id!);
                  },
                ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.compare_arrows, color: Colors.blue),
                ),
                title: Text('inventory.adjust_stock'.tr()),
                subtitle: Text('inventory.add_subtract_stock_desc'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                   showDialog(
                    context: context,
                    builder: (dCtx) {
                      return BlocProvider.value(
                        value: context.read<StockBloc>(), // Use parent bloc (need to ensure it is provided)
                        child: StockAdjustmentDialog(item: item),
                      );
                    },
                  ).then((val) {
                     if (val == true) {
                        if (!context.mounted) return;
                        Navigator.pop(context, true); // Pop detail page to refresh list
                     }
                  });
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.history, color: Colors.orange),
                ),
                title: Text('inventory.stock_history'.tr()),
                subtitle: Text('inventory.view_logic_stock_changes'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockHistoryPage(
                        itemId: item.id!,
                        itemName: item.name,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSerialsDialog(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('inventory.available_serials'.tr()),
          content: FutureBuilder(
            future: getIt<InventoryRepository>().getAvailableSerials(itemId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return snapshot.data!.fold(
                  (failure) => Text('Error: ${failure.message}'),
                  (serials) {
                    if (serials.isEmpty) {
                      return Text('inventory.no_serial_numbers_available'.tr());
                    }
                    return SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: serials.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.qr_code, size: 20),
                            title: Text(serials[index], style: const TextStyle(fontFamily: 'Monospace')),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('inventory.close'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Item item) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('inventory.delete_product_question'.tr()),
        content: Text('inventory.confirm_delete_product'.tr(args: [item.name])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('sales.cancel'.tr())),
          TextButton(
            onPressed: () {
              // We need access to ItemBloc here. 
              // Since we might not have it in context if passed from list,
              // we can rely on the BlocProvider wrapped above, BUT that one is a NEW instance 
              // created via GetIt if we use getIt<ItemBloc>().
              // To properly delete and update list, we should ideally callback or use the existing bloc.
              // simplified: fire event to the global/injected bloc then pop with refresh signal.
              
              getIt<ItemBloc>().add(DeleteItemEvent(item.id!));
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Close detail page and signal refresh
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('sales.delete'.tr()),
          ),
        ],
      ),
    );
  }

  Color _getItemTypeColor(ItemType type) {
    switch (type) {
      case ItemType.service: return Colors.blue;
      case ItemType.recipe: return Colors.orange;
      case ItemType.bundle: return Colors.purple;
      case ItemType.imei: return Colors.teal;
      default: return Colors.grey;
    }
  }
}
