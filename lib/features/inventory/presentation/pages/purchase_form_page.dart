import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';

import '../../../partners/domain/entities/supplier.dart';
import '../../../partners/domain/repositories/partner_repository.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/purchase.dart';
import '../../domain/entities/purchase_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../bloc/purchasing/purchasing_bloc.dart';
import '../bloc/purchasing/purchasing_event.dart';
import '../bloc/purchasing/purchasing_state.dart';
import '../../domain/entities/item_type_enum.dart';
import '../../../../core/widgets/serial_selection_dialog.dart';
import '../../../../core/widgets/variant_selection_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Fields
  Supplier? _selectedSupplier;
  DateTime _date = DateTime.now();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Lists for selection
  List<Supplier> _suppliers = [];
  List<Item> _allItems = []; 
  
  // Cart (Items to purchase)
  final List<PurchaseItem> _cart = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final partnerRepo = getIt<PartnerRepository>();
    (await partnerRepo.getSuppliers()).fold((l) {}, (r) => setState(() => _suppliers = r));

    final inventoryRepo = getIt<InventoryRepository>();
    (await inventoryRepo.getItems()).fold((l) {}, (r) => setState(() => _allItems = r));
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(
        items: _allItems,
        onAdd: (item, quantity, cost, serials) {
           setState(() {
             _cart.add(PurchaseItem(
               itemId: item.id!,
               quantity: quantity,
               cost: cost,
               serialNumbers: serials,
             ));
           });
        },
      ),
    );
  }

  int get _calculateTotal {
    return _cart.fold(0, (sum, item) => sum + item.subtotal);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PurchasingBloc>(),
      child: BlocListener<PurchasingBloc, PurchasingState>(
        listener: (context, state) {
          if (state is PurchasingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('inventory.purchase_saved'.tr())));
            Navigator.pop(context);
          } else if (state is PurchasingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'inventory.new_purchase'.tr(),
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
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)), // Blue
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 1. Supplier Selection
                      DropdownButtonFormField<Supplier>(
                        value: _selectedSupplier,
                        decoration: InputDecoration(
                          labelText: 'inventory.supplier'.tr(),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.store, color: Color(0xFF2962FF)),
                        ),
                        items: _suppliers.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                        onChanged: (val) => setState(() => _selectedSupplier = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // 2. Invoice Info
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _invoiceController,
                              decoration: InputDecoration(
                                labelText: 'inventory.invoice'.tr(),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.receipt, color: Color(0xFF2962FF)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() => _date = picked);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'inventory.date'.tr(),
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF2962FF)),
                                ),
                                child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 3. Items List Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('inventory.items_to_purchase'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, size: 18),
                            label: Text('inventory.add_item'.tr()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2962FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _showAddItemDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      if (_cart.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text('inventory.no_items_added_yet'.tr(), style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _cart.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = _cart[index];
                            final product = _allItems.firstWhere((p) => p.id == item.itemId, orElse: () => const Item(categoryId: 0, name: 'Unknown', price: 0, cost: 0));
                            
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade50,
                                child: Text('${index + 1}', style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold)),
                              ),
                              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${item.quantity} ${product.unit} x ${NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0).format(item.cost)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0).format(item.subtotal),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _cart.removeAt(index);
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          labelText: 'inventory.note_optional'.tr(),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note, color: Colors.grey),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                // Footer: Total & Save
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('inventory.total_amount'.tr(), style: const TextStyle(color: Colors.grey)),
                          Text(
                            NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0).format(_calculateTotal),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2962FF)),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              backgroundColor: const Color(0xFF2962FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _cart.isEmpty || _selectedSupplier == null
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      final purchase = Purchase(
                                        supplierId: _selectedSupplier!.id!,
                                        date: _date,
                                        totalAmount: _calculateTotal,
                                        invoiceNumber: _invoiceController.text,
                                        note: _noteController.text,
                                      );
                                      context.read<PurchasingBloc>().add(SubmitPurchase(purchase: purchase, items: _cart));
                                    }
                                  },
                            child: Text('inventory.save_purchase'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final List<Item> items;
  final Function(Item item, int quantity, int cost, List<String> serials) onAdd;

  const _AddItemDialog({required this.items, required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  // Step 1: Select Item
  Item? _selectedItem;
  
  // Step 2: Input Details
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  
  // Bulk Logic
  bool _isBulkPurchase = false;
  final TextEditingController _bulkUnitNameController = TextEditingController(text: 'Dus');
  final TextEditingController _bulkSizeController = TextEditingController(text: '1'); // Default 1 is redundant if we check >0 but acts as placeholder

  // Search
  final TextEditingController _searchController = TextEditingController();
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _costController.dispose();
    _subtotalController.dispose();
    _bulkUnitNameController.dispose();
    _bulkSizeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) => 
          item.name.toLowerCase().contains(query.toLowerCase()) || 
          (item.barcode?.contains(query) ?? false)
        ).toList();
      }
    });
  }

  void _selectItem(Item item) {
    setState(() {
      _selectedItem = item;
      // Reset fields
      _qtyController.clear();
      _bulkUnitNameController.text = 'Dus';
      _bulkSizeController.text = '1';
      _isBulkPurchase = false;
      
      // Auto fill cost (default to current cost)
      if (item.purchaseUnit != null && item.purchaseUnit == item.unit) {
         _costController.text = item.cost.toString();
      } else if (item.purchaseUnit != null && item.conversionFactor > 1) {
         // If item has a default purchase unit (e.g. Dus in Item Master), we could pre-fill but logic is complex.
         // Stick to base cost to avoid confusion unless user explicitly chooses bulk.
         _costController.text = item.cost.toString();
      } else {
         _costController.text = item.cost.toString();
      }
    });
  }

  void _updateSubtotal() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    int cost = int.tryParse(_costController.text) ?? 0;
    _subtotalController.text = (qty * cost).toString();
  }

  void _updateUnitCost() {
    int qty = int.tryParse(_qtyController.text) ?? 0;
    int subtotal = int.tryParse(_subtotalController.text) ?? 0;
    if (qty > 0) {
      _costController.text = (subtotal / qty).round().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no item selected, show Search List
    if (_selectedItem == null) {
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'inventory.select_item'.tr(),
              style: TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF2962FF)),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'inventory.search_item'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: _filterItems,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredItems.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    // Hide child variants from main list
                    if (item.parentId != null) return const SizedBox.shrink(); 

                    return ListTile(
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${'inventory.stock_label'.tr(args: [item.stock.toString()])} ${item.unit} | Rp ${NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0, name: '').format(item.cost)}'),
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFF2962FF)),
                      onTap: () async {
                        if (item.itemType == ItemType.variant) {
                           final selectedVariant = await showDialog<Item>(
                             context: context,
                             builder: (context) => VariantSelectionDialog(parentItem: item),
                           );
                           if (selectedVariant != null) {
                             _selectItem(selectedVariant);
                           }
                        } else {
                           _selectItem(item);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // If item selected, show Quantity/Cost Input Form
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedItem!.name,
            style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)),
            onPressed: () => setState(() => _selectedItem = null), // Back to list
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                int inputQty = int.tryParse(_qtyController.text) ?? 0;
                int inputCost = int.tryParse(_costController.text) ?? 0;
                
                if (inputQty <= 0) return;

                int finalQty = inputQty;
                int finalCost = inputCost;

                if (_isBulkPurchase) {
                  int bulkSize = int.tryParse(_bulkSizeController.text) ?? 1;
                  if (bulkSize > 0) {
                    finalQty = inputQty * bulkSize;
                    finalCost = (inputCost / bulkSize).round(); // Cost per unit
                  }
                }

                List<String> serials = [];
                if (_selectedItem!.itemType == ItemType.imei) {
                  final result = await showDialog<List<String>>(
                    context: context,
                    builder: (context) => SerialSelectionDialog(
                      itemName: _selectedItem!.name,
                      quantity: finalQty,
                      isPurchase: true,
                    ),
                  );
                  
                  if (result == null) return; // User cancelled
                  serials = result;
                }

                widget.onAdd(_selectedItem!, finalQty, finalCost, serials);
                if (mounted) Navigator.pop(context); // Close dialog
              },
              child: Text('inventory.actions'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2962FF))),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Item Info Summary
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: Colors.blue.shade50,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Row(
                   children: [
                     const Icon(Icons.info_outline, color: Color(0xFF2962FF)),
                     const SizedBox(width: 12),
                     Expanded(
                       child: Text(
                         'inventory.current_stock_and_cost'.tr(namedArgs: {
                           'stock': _selectedItem!.stock.toString(),
                           'unit': _selectedItem!.unit,
                           'cost': NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0).format(_selectedItem!.cost)
                         }),
                         style: const TextStyle(color: Color(0xFF2962FF)),
                       ),
                     ),
                   ],
                 ),
               ),
               const SizedBox(height: 24),
               
               // BULK TOGGLE
               Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey.shade300),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: CheckboxListTile(
                   title: Text('inventory.buy_wholesale'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                   subtitle: Text('inventory.check_if_wholesale'.tr()),
                   value: _isBulkPurchase,
                   onChanged: (val) {
                     setState(() {
                       _isBulkPurchase = val ?? false;
                       _costController.clear();
                       _subtotalController.clear();
                       if (!_isBulkPurchase) {
                          _costController.text = _selectedItem!.cost.toString();
                       }
                     });
                   },
                 ),
               ),
               const SizedBox(height: 24),
               
               if (_isBulkPurchase) ...[
                 Row(
                   children: [
                     Expanded(
                       child: TextFormField(
                         controller: _bulkUnitNameController,
                         decoration: InputDecoration(
                           labelText: 'inventory.unit_name'.tr(),
                           border: OutlineInputBorder(),
                         ),
                       ),
                     ),
                     const SizedBox(width: 16),
                     Expanded(
                       child: TextFormField(
                         controller: _bulkSizeController,
                         decoration: InputDecoration(
                           labelText: 'inventory.content_per_unit'.tr(),
                           border: const OutlineInputBorder(),
                           suffixText: _selectedItem?.unit,
                         ),
                         keyboardType: TextInputType.number,
                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 16),
               ],
               
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Unit
                   Expanded(
                     flex: 2,
                     child: TextFormField(
                       initialValue: _isBulkPurchase ? _bulkUnitNameController.text : _selectedItem!.unit,
                       key: ValueKey(_isBulkPurchase ? _bulkUnitNameController.text : 'base_unit'),
                       readOnly: true,
                       decoration: InputDecoration(
                         labelText: 'inventory.unit'.tr(),
                         border: OutlineInputBorder(),
                         filled: true,
                         fillColor: Colors.black12,
                       ),
                     ),
                   ),
                   const SizedBox(width: 16),
                   // Qty
                   Expanded(
                     flex: 3,
                     child: TextFormField(
                       controller: _qtyController,
                       autofocus: true,
                       decoration: InputDecoration(
                         labelText: 'inventory.quantity'.tr(),
                         border: OutlineInputBorder(),
                       ),
                       keyboardType: TextInputType.number,
                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                       onChanged: (_) => _updateSubtotal(),
                     ),
                   ),
                 ],
               ),
               const SizedBox(height: 24),
               
               // Pricing
               Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _subtotalController,
                        decoration: InputDecoration(
                          labelText: 'inventory.total_price'.tr(), 
                          prefixText: 'Rp ',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2962FF)),
                        ),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => _updateUnitCost(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _costController,
                        decoration: InputDecoration(
                          labelText: _isBulkPurchase ? 'inventory.price_per_unit'.tr(args: [_bulkUnitNameController.text]) : 'inventory.capital_price_per_unit'.tr(args: [_selectedItem!.unit]), 
                          prefixText: 'Rp ',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => _updateSubtotal(),
                      ),
                    ],
                  ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
