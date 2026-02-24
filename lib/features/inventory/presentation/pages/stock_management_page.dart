import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_type_enum.dart';
import '../bloc/item/item_bloc.dart';
import '../bloc/item/item_event.dart';
import '../bloc/item/item_state.dart';
import '../bloc/stock/stock_bloc.dart';
import '../bloc/stock/stock_state.dart';
import '../widgets/stock_adjustment_dialog.dart';
import 'stock_history_page.dart';
import 'package:easy_localization/easy_localization.dart';

class StockManagementPage extends StatefulWidget {
  final bool isOpname;
  
  const StockManagementPage({super.key, this.isOpname = false});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ItemBloc>()..add(const LoadItems())),
        BlocProvider(create: (_) => getIt<StockBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<StockBloc, StockState>(
            listener: (context, state) {
              if (state is StockOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                // Refresh items to show new stock
                context.read<ItemBloc>().add(const LoadItems());
              } else if (state is StockError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.isOpname ? 'inventory.stock_opname'.tr() : 'inventory.stock_management_title'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF2962FF), // Blue
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)), // Blue back
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'inventory.search_item'.tr(),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (val) {
                        context.read<ItemBloc>().add(LoadItems(query: val));
                      },
                    ),
                  ),
                  Expanded(
                      child: BlocBuilder<ItemBloc, ItemState>(
                        builder: (context, state) {
                          if (state is ItemLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is ItemLoaded) {
                            // Filter: Only show items that track stock (Physical items)
                            final stockableItems = state.items.where((i) => i.isTrackStock).toList();
                            
                            if (stockableItems.isEmpty) {
                              return Center(child: Text('inventory.no_stockable_items_found'.tr()));
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: stockableItems.length,
                              separatorBuilder: (context, index) => const Divider(height: 16, thickness: 1, color: Colors.grey),
                              itemBuilder: (context, index) {
                                final item = stockableItems[index];
                                return InkWell(
                                  onTap: () {
                                    _showAdjustmentDialog(context, item);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product Image
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.grey[200],
                                          image: item.imagePath != null
                                              ? DecorationImage(
                                                  image: FileImage(File(item.imagePath!)),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: item.imagePath == null
                                            ? const Icon(Icons.image, color: Colors.grey)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      
                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                 // Name
                                                Expanded(
                                                  child: Text(
                                                    item.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                // History Button
                                                InkWell(
                                                  onTap: () {
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
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Icon(Icons.history, size: 20, color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Code
                                            if (item.barcode != null)
                                              Text(
                                                item.barcode!,
                                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            const SizedBox(height: 8),
                                            
                                            // Stock Limit / Status
                                            Row(
                                              children: [
                                                // POS Hidden Badge
                                                if (!item.isVisible) ...[
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[600],
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.visibility_off, size: 8, color: Colors.white),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          'inventory.hidden'.tr(),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                ],

                                                // Item Type Badge
                                                if (item.itemType != ItemType.single && item.itemType != ItemType.variant) ...[
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: _getItemTypeColor(item.itemType),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      item.itemType.label,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                ],
                                              
                                                // Stock Level Display
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: item.stock < 5 ? Colors.red.shade100 : Colors.green.shade100,
                                                        borderRadius: BorderRadius.circular(4),
                                                        border: Border.all(
                                                          color: item.stock < 5 ? Colors.red : Colors.green,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'inventory.stock_label'.tr(args: ['']).replaceAll('{}', ''),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: item.stock < 5 ? Colors.red.shade900 : Colors.green.shade900,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${item.stock} ${item.unit}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: item.stock < 5 ? Colors.red.shade900 : Colors.green.shade900,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
            );
          }
        ),
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext parentContext, Item item) {
    showDialog(
      context: parentContext,
      builder: (context) {
        // Provide the SAME StockBloc instance to the dialog
        return BlocProvider.value(
          value: parentContext.read<StockBloc>(), 
          child: StockAdjustmentDialog(
            item: item,
            isOpname: widget.isOpname,
          ),
        );
      },
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
