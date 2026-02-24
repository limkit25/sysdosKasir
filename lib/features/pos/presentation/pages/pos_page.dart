import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/barcode_scanner_page.dart';
import '../bloc/pos_bloc.dart';
import '../bloc/pos_event.dart';
import '../bloc/pos_state.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../../features/sales/presentation/bloc/promo/promo_bloc.dart';
import '../../../../features/sales/presentation/bloc/promo/promo_event.dart';
import '../../../../features/sales/presentation/bloc/promo/promo_state.dart';
import '../../../../features/sales/presentation/bloc/promo/promo_state.dart';
import '../../../../features/sales/domain/entities/promo.dart';
import '../../../../features/inventory/domain/entities/item_type_enum.dart';
import '../../../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../../../core/widgets/serial_selection_dialog.dart';
import '../../../../core/widgets/variant_selection_dialog.dart';
import '../widgets/advanced_payment_dialog.dart';
import '../widgets/split_payment_dialog.dart';
import '../../../shift/presentation/bloc/shift/shift_bloc.dart';
import 'package:collection/collection.dart';
import '../../../shift/presentation/pages/close_shift_page.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PosBloc>()
        ..add(LoadProducts())
        ..add(LoadPendingOrders())
        ..add(LoadActiveVouchers()),
      child: const PosView(),
    );
  }
}

class PosView extends StatefulWidget {
  const PosView({super.key});

  @override
  State<PosView> createState() => _PosViewState();
}

class _PosViewState extends State<PosView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pos.title'.tr()),
        actions: [
          BlocBuilder<ShiftBloc, ShiftState>(
            builder: (context, shiftState) {
              if (shiftState is ShiftActive) {
                return IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  tooltip: 'pos.close_register'.tr(),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => CloseShiftPage(currentShift: shiftState.shift))
                    ).then((closed) {
                      if (closed == true && context.mounted) {
                        Navigator.pop(context); // Return to Dashboard
                      }
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               context.read<PosBloc>().add(LoadProducts());
            },
          ),
        ],
      ),
      body: BlocConsumer<PosBloc, PosState>(
        listener: (context, state) {
          if (state is PosError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          } else if (state is PosSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${'pos.transaction_success'.tr()} ${state.transactionId} ${'pos.change'.tr()} ${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(state.changeAmount)}'), backgroundColor: Colors.green),
            );
            // Reload to clear cart and start fresh
            context.read<PosBloc>().add(LoadProducts());
          }
        },
        builder: (context, state) {
          if (state is PosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PosLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  // Tablet Mode: Split View
                  return Row(
                    children: [
                      Expanded(flex: 3, child: _buildProductSection(context, state)),
                      const VerticalDivider(width: 1),
                      Expanded(flex: 2, child: _buildCartSection(context, state)),
                    ],
                  );
                } else {
                  // Phone Mode: Tabs or Stack?
                  // For now, let's use a simple column with a cart summary at bottom
                  // Or a TabView. Let's go with TabView for simplicity on small screens.
                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(icon: const Icon(Icons.grid_view), text: 'pos.products'.tr()),
                            Tab(icon: const Icon(Icons.shopping_cart), text: 'pos.cart'.tr()),
                          ],
                          labelColor: Colors.blue,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildProductSection(context, state),
                              _buildCartSection(context, state),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddedSnackBar(BuildContext context, String itemName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName ${'pos.added_to_cart'.tr()}'),
        duration: const Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildProductSection(BuildContext context, PosLoaded state) {
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return Column(
      children: [

        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text('pos.all'.tr()),
                  selected: state.selectedCategoryId == null,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<PosBloc>().add(const SelectCategory(null));
                    }
                  },
                ),
              ),
              ...state.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category.name),
                    selected: state.selectedCategoryId == category.id,
                    onSelected: (selected) {
                      if (selected) {
                        context.read<PosBloc>().add(SelectCategory(category.id));
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () async {
                  final code = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
                  );
                  if (code != null && context.mounted) {
                    final bloc = context.read<PosBloc>();
                    if (bloc.state is PosLoaded) {
                      final state = bloc.state as PosLoaded;
                      try {
                         final item = state.products.firstWhere((p) => p.barcode == code);
                         bloc.add(AddToCart(item));
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('${item.name} ${'pos.added_to_cart'.tr()}!'), backgroundColor: Colors.green),
                         );
                         // Optional: Clear search so the grid shows everything again? 
                         // Or filter to this item?
                         // Let's just add it and maybe filter to show it too?
                         // bloc.add(SearchProducts(code)); // If we want to filter
                      } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Product not found!'), backgroundColor: Colors.red),
                         );
                      }
                    }
                  }
                },
              ),
              hintText: 'pos.search_product'.tr(),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<PosBloc>().add(SearchProducts(value));
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150, // Smaller items
              childAspectRatio: 0.75, // Adjust ratio
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: state.filteredProducts.length,
            itemBuilder: (context, index) {
              final item = state.filteredProducts[index];
              return Card(
                elevation: 2,
                child: InkWell(
                  onTap: () async {
                    if (item.itemType == ItemType.imei) {
                      // Fetch available serials
                      final repo = getIt<InventoryRepository>();
                      final result = await repo.getAvailableSerials(item.id!);
                      
                        if (context.mounted) {
                        result.fold(
                          (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${'pos.error_fetching_serials'.tr()}: ${l.message}'))),
                          (serials) async {
                             // Filter out serials already in cart
                             final bloc = context.read<PosBloc>();
                             final currentState = bloc.state;
                             List<String> usedSerials = [];
                             if (currentState is PosLoaded) {
                               final cartItem = currentState.cart.firstWhereOrNull((c) => c.item.id == item.id); // Requires collection or manual lookup
                               if (cartItem != null) {
                                 usedSerials = cartItem.serialNumbers;
                               }
                             }
                             // Also checking manual lookup if firstWhereOrNull not available (it is in collection package, usually imported. Checking imports...)
                             // PosPage imports: material, bloc, intl, injection, barcode_scanner, pos_bloc/event/state, promo, item_type, inventory_repo, serial_dialog.
                             // 'collection' is likely exported by fpdart or just need to add import 'package:collection/collection.dart';
                             
                             final availableSerials = serials.where((s) => !usedSerials.contains(s)).toList();

                             if (availableSerials.isEmpty) {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pos.all_serials_in_cart'.tr())));
                               return;
                             }
                             
                             final selectedSerials = await showDialog<List<String>>(
                               context: context,
                               builder: (context) => SerialSelectionDialog(
                                 itemName: item.name,
                                 quantity: 1, 
                                 availableSerials: availableSerials,
                                 isPurchase: false,
                                 allowDynamicQuantity: true,
                               ),
                             );

                             if (selectedSerials != null && context.mounted) {
                               context.read<PosBloc>().add(AddToCart(item, serialNumbers: selectedSerials));
                               _showAddedSnackBar(context, item.name);
                             }
                          }
                        );
                      }
                    } else if (item.itemType == ItemType.variant) {
                      final selectedVariant = await showDialog<dynamic>(
                        context: context,
                        builder: (context) => VariantSelectionDialog(parentItem: item),
                      );

                      if (selectedVariant != null && context.mounted) {
                         // Check stock for variant
                         if (selectedVariant.isTrackStock && selectedVariant.stock <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Stok ${selectedVariant.name} Habis!'), backgroundColor: Colors.red),
                            );
                            return;
                         }
                         context.read<PosBloc>().add(AddToCart(selectedVariant));
                         _showAddedSnackBar(context, selectedVariant.name);
                      }
                    } else {
                      // Check stock for single/standard items
                      if (item.isTrackStock && item.stock <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${'pos.out_of_stock'.tr().replaceAll('!', '')} ${item.name}!'), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      context.read<PosBloc>().add(AddToCart(item));
                      _showAddedSnackBar(context, item.name);
                    }
                  },
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.blue.shade50,
                              child: item.imagePath != null
                                  ? Image.file(
                                      File(item.imagePath!),
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    )
                                  : const Center(
                                      child: Icon(Icons.shopping_bag, size: 50, color: Colors.blue),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (item.discount > 0) ...[
                                  Text(
                                    currencyFormat.format(item.price),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(item.price * (1 - item.discount / 100)),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ] else
                                  Text(currencyFormat.format(item.price)),
                                Text(
                                  item.itemType == ItemType.bundle
                                      ? 'pos.bundle'.tr()
                                      : item.itemType == ItemType.recipe
                                          ? 'pos.recipe'.tr()
                                          : item.itemType == ItemType.service
                                              ? 'pos.service'.tr()
                                              : item.itemType == ItemType.variant
                                                  ? 'pos.variant'.tr()
                                                  : '${'pos.stock'.tr()}: ${item.stock} ${item.unit}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: (item.itemType != ItemType.bundle &&
                                            item.itemType != ItemType.recipe &&
                                            item.itemType != ItemType.service &&
                                            item.itemType != ItemType.variant &&
                                            item.stock <= 0)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Quantity Badge Logic
                      Builder(
                        builder: (context) {
                          int quantity = 0;
                          if (item.itemType == ItemType.variant) {
                             // Sum all variants of this parent in cart
                             quantity = state.cart
                                 .where((c) => c.item.parentId == item.id)
                                 .fold(0, (sum, c) => sum + c.quantity);
                          } else {
                             // Direct match
                             final cartItem = state.cart.firstWhereOrNull((c) => c.item.id == item.id);
                             quantity = cartItem?.quantity ?? 0;
                          }

                          if (quantity > 0) {
                            return Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartSection(BuildContext context, PosLoaded state) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // If height is small (e.g. landscape phone with keyboard or just small screen),
        // we make the entire cart section scrollable instead of fixed footer.
        final bool isSmallHeight = constraints.maxHeight < 500; 

        Widget cartList = state.cart.isEmpty
            ? SizedBox(height: 200, child: Center(child: Text('pos.cart_is_empty'.tr())))
            : ListView.separated(
                shrinkWrap: isSmallHeight, // ShrinkWrap if inside SingleChildScrollView
                physics: isSmallHeight ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                itemCount: state.cart.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                    final cartItem = state.cart[index];
                    return ListTile(
                      title: Text(cartItem.item.name),
                      subtitle: Text('${currency.format(cartItem.item.price)} x ${cartItem.quantity} ${cartItem.item.unit}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Text(currency.format(cartItem.subtotal), style: const TextStyle(fontWeight: FontWeight.bold)),
                           const SizedBox(width: 8),
                           IconButton(
                             icon: const Icon(Icons.remove_circle_outline),
                             onPressed: () {
                               if (cartItem.quantity > 1) {
                                 context.read<PosBloc>().add(UpdateQuantity(cartItem.item, cartItem.quantity - 1));
                               } else {
                                  context.read<PosBloc>().add(RemoveFromCart(cartItem.item));
                               }
                             },
                           ),
                           IconButton(
                             icon: const Icon(Icons.add_circle_outline),
                             onPressed: cartItem.item.itemType == ItemType.imei 
                               ? () {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(content: Text('Please add serialized items from the product list to select serial number.')),
                                   );
                                 }
                               : () {
                                context.read<PosBloc>().add(AddToCart(cartItem.item));
                             },
                             color: cartItem.item.itemType == ItemType.imei ? Colors.grey : null,
                           ),
                        ],
                      ),
                    );
                },
              );

        Widget summarySection = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
          ),
          child: Column(
            children: [
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'pos.subtotal'.tr()}:', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(
                    currency.format(state.subtotal),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${'pos.discount'.tr()}:', style: const TextStyle(fontSize: 16, color: Colors.red)),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                        onPressed: () => _showDiscountDialog(context, state),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      if (state.discountAmount > 0 || state.discountValue > 0 || state.selectedPromoId != null)
                        IconButton(
                          icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                          onPressed: () {
                             context.read<PosBloc>().add(const SetDiscount(
                               0, 
                               type: 'fixed', 
                               minPurchase: 0, 
                               maxDiscount: 0, 
                               promoId: null
                             ));
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Text(
                          '- ${currency.format(state.discountAmount)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        
                      if (state.discountType == 'percentage')
                        Text(
                          '(${state.discountValue}%)',
                          style: const TextStyle(fontSize: 12, color: Colors.red),
                        )
                      else if (state.selectedPromoId != null)
                         Text(
                          '(${'pos.promo_applied'.tr()})', 
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                    ],
                  ),
                ],
              ),
              const Divider(),

              // Service Fee
              if (state.serviceFeeRate > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${'pos.service_fee'.tr()} (${state.serviceFeeRate.toStringAsFixed(1)}%):', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(
                        currency.format(state.serviceFeeAmount),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // Tax
              if (state.taxRate > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${'pos.tax'.tr()} (${state.taxRate.toStringAsFixed(1)}%):', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(
                        currency.format(state.taxAmount),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              
              const Divider(),
              
              // Grand Total (before voucher)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'pos.grand_total'.tr()}:', style: const TextStyle(fontSize: 18)),
                  Text(
                    currency.format(state.grandTotal),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Voucher Selection Section
              if (state.activeVouchers.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.pink, size: 20),
                    const SizedBox(width: 8),
                    Text('pos.apply_voucher'.tr(), 
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  value: state.selectedVoucher?.id,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: 'pos.select_voucher'.tr(),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text('pos.no_voucher'.tr(), style: const TextStyle(color: Colors.grey)),
                    ),
                    ...state.activeVouchers.map((v) => 
                      DropdownMenuItem<int?>(
                        value: v.id,
                        child: Text(
                          '${v.name} (- ${currency.format(v.amount)})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ),
                  ],
                  onChanged: (voucherId) {
                    if (voucherId == null) {
                      context.read<PosBloc>().add(const SelectVoucher(null));
                    } else {
                      final voucher = state.activeVouchers.firstWhere((v) => v.id == voucherId);
                      context.read<PosBloc>().add(SelectVoucher(voucher));
                    }
                  },
                ),
                if (state.selectedVoucher != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${'pos.voucher_discount'.tr()}:', 
                        style: const TextStyle(color: Colors.green, fontSize: 16)),
                      Text('- ${currency.format(state.voucherAmount)}',
                           style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('pos.total_to_pay'.tr(), 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(currency.format(state.finalTotal), 
                         style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // CHARGE Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.cart.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => SplitPaymentDialog(
                              totalAmount: state.finalTotal,
                              posBloc: context.read<PosBloc>(),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Text(
                    '${'pos.charge'.tr()} ${currency.format(state.finalTotal)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );

        if (isSmallHeight) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.pause_circle_outline),
                            tooltip: 'Hold Order',
                            onPressed: state.cart.isEmpty 
                              ? null 
                              : () {
                                  int? shiftId;
                                  int? userId;
                                  final shiftState = context.read<ShiftBloc>().state;
                                  if (shiftState is ShiftActive) {
                                    shiftId = shiftState.shift.id;
                                    userId = shiftState.shift.userId;
                                  }
                                  
                                  context.read<PosBloc>().add(HoldOrder(shiftId: shiftId, userId: userId));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('pos.order_held'.tr())),
                                  );
                                },
                          ),
                          IconButton(
                            icon: Badge(
                              label: Text('${state.pendingTransactions.length}'),
                              isLabelVisible: state.pendingTransactions.isNotEmpty,
                              child: const Icon(Icons.receipt_long),
                            ),
                             tooltip: 'Pending Orders',
                            onPressed: () {
                               _showPendingOrdersDialog(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Clear Cart',
                            onPressed: () {
                               context.read<PosBloc>().add(ClearCart());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                cartList,
                summarySection,
              ],
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text('pos.cart'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.pause_circle_outline),
                            tooltip: 'Hold Order',
                            onPressed: state.cart.isEmpty 
                              ? null 
                              : () {
                                  int? shiftId;
                                  int? userId;
                                  final shiftState = context.read<ShiftBloc>().state;
                                  if (shiftState is ShiftActive) {
                                    shiftId = shiftState.shift.id;
                                    userId = shiftState.shift.userId;
                                  }
                                  
                                  context.read<PosBloc>().add(HoldOrder(shiftId: shiftId, userId: userId));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('pos.order_held'.tr())),
                                  );
                                },
                          ),
                          IconButton(
                            icon: Badge(
                              label: Text('${state.pendingTransactions.length}'),
                              isLabelVisible: state.pendingTransactions.isNotEmpty,
                              child: const Icon(Icons.receipt_long),
                            ),
                             tooltip: 'Pending Orders',
                            onPressed: () {
                               _showPendingOrdersDialog(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Clear Cart',
                            onPressed: () {
                               context.read<PosBloc>().add(ClearCart());
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Expanded(child: cartList),
              summarySection,
            ],
          );
        }
      }
    );
  }

  void _showDiscountDialog(BuildContext context, PosLoaded state) {
    final posBloc = context.read<PosBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: posBloc),
            BlocProvider(create: (context) => getIt<PromoBloc>()..add(LoadPromos())),
          ],
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = 500;
              double height = 500;
              if (constraints.maxWidth < 600) {
                 width = constraints.maxWidth * 0.9;
                 height = constraints.maxHeight * 0.7;
              }
              
              return DefaultTabController(
                length: 3,
                initialIndex: 2, // Always default to Promo tab as requested
                child: Dialog(
                   insetPadding: const EdgeInsets.all(16),
                   child: Container(
                     width: width,
                     height: height,
                     padding: const EdgeInsets.all(16),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('pos.set_discount'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(dialogContext)),
                           ],
                         ),
                         const SizedBox(height: 16),
                         TabBar(
                           labelColor: Colors.blue,
                           unselectedLabelColor: Colors.grey,
                           tabs: [
                             Tab(text: 'pos.manual_rp'.tr()),
                             Tab(text: 'pos.manual_percent'.tr()),
                             Tab(text: 'pos.promo'.tr()),
                           ],
                         ),
                         const SizedBox(height: 16),
                         Expanded(
                           child: TabBarView(
                             children: [
                               _buildManualRpTab(context, state),
                               _buildManualPercentTab(context, state),
                               _buildPromoTab(context, state),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildManualRpTab(BuildContext context, PosLoaded state) {
    final controller = TextEditingController(text: state.discountType == 'fixed' ? state.discountValue.toString() : '');
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'pos.discount_amount'.tr(),
            prefixText: 'Rp ',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
             final amount = int.tryParse(controller.text.replaceAll('.', '')) ?? 0;
             context.read<PosBloc>().add(SetDiscount(amount, type: 'fixed'));
             Navigator.pop(context);
          },
          child: Text('pos.apply_manual_rp'.tr()),
        ),
        if (state.discountType == 'fixed' && state.discountValue > 0) ...[
           const SizedBox(height: 8),
           TextButton(
             onPressed: () {
                context.read<PosBloc>().add(const SetDiscount(0, type: 'fixed'));
                Navigator.pop(context);
             },
             child: Text('pos.remove_discount'.tr(), style: const TextStyle(color: Colors.red)),
           )
        ]
      ],
    );
  }

  Widget _buildManualPercentTab(BuildContext context, PosLoaded state) {
    final controller = TextEditingController(text: state.discountType == 'percentage' ? state.discountValue.toString() : '');
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'pos.percentage'.tr(),
            suffixText: '%',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        const SizedBox(height: 16),
         ElevatedButton(
          onPressed: () {
             final percent = int.tryParse(controller.text) ?? 0;
             if (percent < 0 || percent > 100) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pos.invalid_percentage'.tr())));
               return;
             }
             context.read<PosBloc>().add(SetDiscount(percent, type: 'percentage'));
             Navigator.pop(context);
          },
          child: Text('pos.apply_manual_percent'.tr()),
        ),
      ],
    );
  }

  Widget _buildPromoTab(BuildContext context, PosLoaded state) {
     return BlocBuilder<PromoBloc, PromoState>(
       builder: (ctx, promoState) {
         if (promoState is PromoLoading) {
           return const Center(child: CircularProgressIndicator());
         } else if (promoState is PromoLoaded) {
           final activePromos = promoState.promos.where((p) => p.isActive).toList();
           if (activePromos.isEmpty) return Center(child: Text('pos.no_active_promos'.tr()));
           
           return ListView.separated(
             itemCount: activePromos.length,
             separatorBuilder: (_, __) => const Divider(),
             itemBuilder: (context, index) {
               final promo = activePromos[index];
               final isSelected = state.selectedPromoId == promo.id;
               return ListTile(
                 leading: Icon(promo.type == 'percentage' ? Icons.percent : Icons.attach_money, color: Colors.blue),
                 title: Text(promo.name),
                 subtitle: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(promo.type == 'percentage' ? '${promo.value}% ${'pos.off'.tr()}' : 'Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(promo.value)} ${'pos.off'.tr()}'),
                     if (promo.minPurchase > 0)
                       Text('${'pos.min_purchase'.tr()}: Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(promo.minPurchase)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                     if (promo.maxDiscount > 0)
                       Text('${'pos.max_discount'.tr()}: Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(promo.maxDiscount)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                   ],
                 ),
                 trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                 tileColor: isSelected ? Colors.green.shade50 : null,
                 onTap: () {
                   // Validation: Check Minimum Purchase
                   if (state.subtotal < promo.minPurchase) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text('${'pos.min_purchase'.tr()} Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(promo.minPurchase)}'),
                         backgroundColor: Colors.red,
                       ),
                     );
                     return;
                   }

                   context.read<PosBloc>().add(SetDiscount(
                     promo.value, 
                     type: promo.type, 
                     promoId: promo.id,
                     minPurchase: promo.minPurchase,
                     maxDiscount: promo.maxDiscount,
                   ));
                   Navigator.pop(context);
                 },
               );
             },
           );
         } else if (promoState is PromoError) {
           return Center(child: Text(promoState.message));
         }
         return const SizedBox.shrink();
       },
     );
  }

  void _showPaymentDialog(BuildContext context, int totalAmount) {
     final posBloc = context.read<PosBloc>();
     showDialog(
       context: context,
       builder: (context) => AdvancedPaymentDialog(
         totalAmount: totalAmount, 
         posBloc: posBloc,
       ),
     );
  }

  Widget _quickPayButton(BuildContext context, String label, int amount, PosLoaded state) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final change = amount - state.finalTotal;
    return ActionChip(
      avatar: const Icon(Icons.flash_on, size: 16, color: Colors.orange),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.amber.shade50,
      side: BorderSide(color: Colors.amber.shade200),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('pos.confirm_cash_payment'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${'pos.total'.tr()}: ${currency.format(state.finalTotal)}'),
                Text('${'pos.pay'.tr()}: ${currency.format(amount)}'),
                if (change > 0)
                  Text('${'pos.change_amount'.tr()}: ${currency.format(change)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('pos.cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<PosBloc>().add(ProcessPayment(
                    paymentMethod: 'CASH',
                    paymentAmount: amount,
                  ));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('pos.pay'.tr(), style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPendingOrdersDialog(BuildContext context) {
    context.read<PosBloc>().add(LoadPendingOrders());
    
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<PosBloc>(),
          child: AlertDialog(
            title: Text('pos.pending_orders'.tr()),
            content: SizedBox(
              width: 500,
              height: 400,
              child: BlocBuilder<PosBloc, PosState>(
                builder: (context, state) {
                  if (state is PosLoaded) {
                    if (state.pendingTransactions.isEmpty) {
                      return Center(child: Text('pos.no_pending_orders'.tr()));
                    }
                    
                    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
                    
                    return ListView.separated(
                      itemCount: state.pendingTransactions.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final transaction = state.pendingTransactions[index];
                        return ListTile(
                          title: Text('Order #${transaction.id} - ${DateFormat('dd MMM HH:mm').format(transaction.dateTime)}'),
                          subtitle: Text('${transaction.items.length} Items - Total: ${currency.format(transaction.totalAmount)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'pos.delete_order'.tr(),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('pos.delete_pending'.tr()),
                                      content: Text('pos.stock_restored'.tr()),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('pos.cancel'.tr())),
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('pos.delete'.tr(), style: const TextStyle(color: Colors.red))),
                                      ],
                                    ),
                                  );
                                  
                                  if (confirm == true && context.mounted) {
                                     context.read<PosBloc>().add(DeletePendingOrder(transaction.id!));
                                  }
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<PosBloc>().add(ResumeOrder(transaction.id!));
                                  Navigator.pop(dialogContext); // Close dialog
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pos.order_resumed'.tr())));
                                },
                                child: Text('pos.resume'.tr()),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('pos.close'.tr())),
            ],
          ),
        );
      },
    );
  }
}
