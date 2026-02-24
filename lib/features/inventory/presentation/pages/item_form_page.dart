import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../core/widgets/barcode_scanner_page.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_composition.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../bloc/item/item_bloc.dart';
import '../bloc/item/item_event.dart';
import '../bloc/item/item_state.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/item_type_enum.dart';

class ItemFormPage extends StatefulWidget {
  final Item? item; // If null, create new

  const ItemFormPage({super.key, this.item});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _priceController;
  late TextEditingController _costController;
  late TextEditingController _stockController;
  late TextEditingController _discountController;
  late TextEditingController _weightController;
  late TextEditingController _unitController;
  late TextEditingController _purchaseUnitController;
  late TextEditingController _conversionFactorController;

  List<Category> _categories = [];
  List<Item> _potentialParents = [];
  List<ItemComposition> _compositions = [];
  List<Item> _generatedVariants = []; // Store variants to be created
  int? _selectedCategoryId;
  int? _selectedParentId;
  bool _isTrackStock = true;
  bool _isVisible = true;
  String? _imagePath;
  ItemType _itemType = ItemType.single;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _nameController = TextEditingController(text: widget.item?.name);
    _barcodeController = TextEditingController(text: widget.item?.barcode);
    _priceController = TextEditingController(text: widget.item?.price.toString());
    _costController = TextEditingController(text: widget.item?.cost.toString());
    _stockController = TextEditingController(text: widget.item?.stock.toString() ?? '0');
    _discountController = TextEditingController(text: widget.item?.discount.toString() ?? '0');
    _weightController = TextEditingController(text: widget.item?.weight.toString() ?? '0');
    _unitController = TextEditingController(text: widget.item?.unit ?? 'pcs');
    _purchaseUnitController = TextEditingController(text: widget.item?.purchaseUnit);
    _conversionFactorController = TextEditingController(text: widget.item?.conversionFactor.toString() ?? '1');
    
    // _selectedCategoryId handled in fetchData
    _isTrackStock = widget.item?.isTrackStock ?? true;
    _isVisible = widget.item?.isVisible ?? true;
    _imagePath = widget.item?.imagePath;
    _itemType = widget.item?.itemType ?? ItemType.single;
    _selectedParentId = widget.item?.parentId;
  }

  Future<void> _fetchData() async {
    final repository = getIt<InventoryRepository>();
    
    // Fetch Categories
    final catResult = await repository.getCategories();
    catResult.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (categories) {
        setState(() {
          _categories = categories;
          if (widget.item != null) {
            _selectedCategoryId = widget.item!.categoryId;
          } else if (_categories.isNotEmpty) {
            _selectedCategoryId = _categories.first.id;
          }
        });
      },
    );

    // Fetch Potential Parents (All items for now, ideally filter out current item and variants)
    final itemResult = await repository.getItems();
    itemResult.fold(
      (failure) {}, // Ignore items fetch failure or handle silently
      (items) {
        setState(() {
          // Filter out the current item (if editing) to prevent self-parenting
          _potentialParents = items.where((i) => i.id != widget.item?.id).toList();
        });
      },
    );

    // Fetch Compositions if editing
    if (widget.item != null) {
      final compResult = await repository.getCompositions(widget.item!.id!);
      compResult.fold(
        (failure) {}, // Ignore
        (comps) {
          setState(() {
            _compositions = comps;
            // Optional: Update cost on load if it's 0 or we want to enforce it?
            // User might have manually set a different cost (e.g. overhead).
            // Let's only update if cost is 0 to be safe, OR just let user trigger it by adding/removing.
            // But user asked for "automatic".
            // Let's safe check: if Cost is 0, update it.
            if (_costController.text == '0' || _costController.text.isEmpty) {
               _updateCostFromComposition();
            }
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    _weightController.dispose();
    _unitController.dispose();
    _purchaseUnitController.dispose();
    _conversionFactorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // Save image to local storage
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(pickedFile.path);
      final String localPath = path.join(directory.path, 'items', fileName);
      
      // Ensure directory exists
      await Directory(path.join(directory.path, 'items')).create(recursive: true);
      
      await pickedFile.saveTo(localPath);

      setState(() {
        _imagePath = localPath;
      });
    }
  }

  void _updateCostFromComposition() {
    int totalCost = 0;
    for (var comp in _compositions) {
      final child = _potentialParents.firstWhere((i) => i.id == comp.childItemId, orElse: () => const Item(categoryId: 0, name: '', price: 0, cost: 0, stock: 0));
      totalCost += child.cost * comp.quantity;
    }
    _costController.text = totalCost.toString();
  }

  void _showAddCompositionDialog() {
    int? selectedChildId;
    Item? selectedChildItem;
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('inventory.add_component'.tr()),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'inventory.select_item'.tr()),
                    isExpanded: true,
                    items: _potentialParents.map((item) => DropdownMenuItem(
                      value: item.id,
                      child: Text('${item.name} (${item.unit})'),
                    )).toList(),
                    onChanged: (val) {
                       setDialogState(() {
                         selectedChildId = val;
                         selectedChildItem = _potentialParents.firstWhere((i) => i.id == val);
                       });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: qtyController,
                    decoration: InputDecoration(
                      labelText: 'inventory.quantity'.tr(),
                      suffixText: selectedChildItem?.unit,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('sales.cancel'.tr())),
            ElevatedButton(
              onPressed: () {
                if (selectedChildId != null && qtyController.text.isNotEmpty) {
                  setState(() {
                    _compositions.add(ItemComposition(
                      parentItemId: 0, // Placeholder
                      childItemId: selectedChildId!,
                      quantity: int.parse(qtyController.text),
                    ));
                    _updateCostFromComposition(); // Auto-update cost
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('sales.add'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'inventory.add_item'.tr() : 'inventory.edit_item'.tr()),
      ),
      body: BlocProvider(
        create: (context) => getIt<ItemBloc>(),
        child: BlocConsumer<ItemBloc, ItemState>(
          listener: (context, state) {
            if (state is ItemOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('sales.success'.tr())));
              Navigator.pop(context);
            } else if (state is ItemError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
             if (state is ItemLoading) {
               return const Center(child: CircularProgressIndicator());
             }
             return SingleChildScrollView(
               padding: const EdgeInsets.all(16.0),
               child: Form(
                 key: _formKey,
                 child: Column(
                   children: [
                     // Image Picker
                     GestureDetector(
                       onTap: () {
                         showModalBottomSheet(
                           context: context,
                           builder: (context) => Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               ListTile(
                                 leading: const Icon(Icons.camera_alt),
                                 title: Text('inventory.camera'.tr()),
                                 onTap: () {
                                   Navigator.pop(context);
                                   _pickImage(ImageSource.camera);
                                 },
                               ),
                               ListTile(
                                 leading: const Icon(Icons.photo_library),
                                 title: Text('inventory.gallery'.tr()),
                                 onTap: () {
                                   Navigator.pop(context);
                                   _pickImage(ImageSource.gallery);
                                 },
                               ),
                             ],
                           ),
                         );
                       },
                       child: Container(
                         height: 150,
                         width: 150,
                         decoration: BoxDecoration(
                           color: Colors.grey[200],
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(color: Colors.grey),
                         ),
                         child: _imagePath != null
                             ? ClipRRect(
                                 borderRadius: BorderRadius.circular(10),
                                 child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                               )
                             : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                       ),
                     ),
                     const SizedBox(height: 24),

                     DropdownButtonFormField<int>(
                       value: _selectedCategoryId,
                       decoration: InputDecoration(labelText: 'inventory.category'.tr()),
                       items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                       onChanged: (val) => setState(() => _selectedCategoryId = val),
                       validator: (val) => val == null ? 'sales.required'.tr() : null,
                     ),
                     const SizedBox(height: 16),

                     TextFormField(
                       controller: _nameController,
                       decoration: InputDecoration(labelText: 'inventory.item_name'.tr()),
                       textInputAction: TextInputAction.next,
                       validator: (val) => val!.isEmpty ? 'sales.required'.tr() : null,
                     ),
                     TextFormField(
                       controller: _barcodeController,
                       decoration: InputDecoration(
                         labelText: 'inventory.barcode'.tr(),
                         suffixIcon: IconButton(
                           icon: const Icon(Icons.qr_code_scanner),
                           onPressed: () async {
                              final code = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
                              );
                              if (code != null) {
                                setState(() {
                                  _barcodeController.text = code;
                                });
                              }
                           },
                         ),
                       ),
                       textInputAction: TextInputAction.next,
                     ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'inventory.price'.tr(),
                            border: const OutlineInputBorder(),
                            prefixText: 'Rp ',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) =>
                              value == null || value.isEmpty ? 'inventory.please_enter_price'.tr() : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _costController,
                          decoration: InputDecoration(
                            labelText: 'inventory.cost'.tr(),
                            border: const OutlineInputBorder(),
                            prefixText: 'Rp ',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next, // Contextually usually works even in Row
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) =>
                              value == null || value.isEmpty ? 'inventory.please_enter_cost'.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_itemType != ItemType.bundle && _itemType != ItemType.recipe && _itemType != ItemType.service)
                  SwitchListTile(
                    title: Text('inventory.track_stock'.tr()),
                    value: _isTrackStock,
                    onChanged: (val) => setState(() => _isTrackStock = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_isTrackStock)
                    TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: 'inventory.stock_quantity'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          value == null || value.isEmpty ? 'inventory.please_enter_stock'.tr() : null,
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: 'inventory.weight'.tr(),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _unitController,
                          decoration: InputDecoration(
                            labelText: 'inventory.unit'.tr(),
                            border: const OutlineInputBorder(),
                            hintText: 'inventory.unit_hint'.tr(),
                            helperText: 'inventory.unit_helper'.tr(),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),


                  TextFormField(
                    initialValue: _discountController.text, // Use controller's text as initial value
                    decoration: InputDecoration(
                      labelText: 'inventory.discount_percentage'.tr(),
                      border: const OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        final val = int.tryParse(value) ?? 0;
                        _discountController.text = val.clamp(0, 100).toString(); // Update controller and clamp
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Item Type Dropdown (Moved to bottom for better UX)
                  DropdownButtonFormField<ItemType>(
                    value: _itemType,
                    decoration: InputDecoration(
                      labelText: 'inventory.item_type'.tr(),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    isExpanded: true,
                    items: ItemType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(type.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            type.description,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    )).toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return ItemType.values.map<Widget>((ItemType type) {
                        return Text(type.label, style: const TextStyle(fontWeight: FontWeight.w500));
                      }).toList();
                    },
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _itemType = val;
                          if (_itemType == ItemType.service || _itemType == ItemType.bundle || _itemType == ItemType.recipe) {
                            _isTrackStock = false;
                          } else {
                            _isTrackStock = true;
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Parent Item Dropdown (Only for Variants)
                  if (_itemType == ItemType.variant) ...[
                    DropdownButtonFormField<int>(
                      value: _selectedParentId,
                      decoration: InputDecoration(
                        labelText: 'inventory.parent_item_optional'.tr(),
                        border: const OutlineInputBorder(),
                        helperText: 'inventory.select_main_product_helper'.tr(),
                      ),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text('inventory.none_independent_variant'.tr()),
                        ),
                        ..._potentialParents.map((item) => DropdownMenuItem(
                          value: item.id,
                          child: Text('${item.name} (${item.barcode ?? "No Code"})'),
                        )),
                      ],
                      onChanged: (val) => setState(() => _selectedParentId = val),
                    ),
                    const SizedBox(height: 24),
                  ],
                     const SizedBox(height: 24),
                  
                  // Composition Editor (For Bundles/Recipes)
                  // Composition Editor (For Bundles/Recipes)
                  if (_itemType == ItemType.bundle || _itemType == ItemType.recipe) ...[
                    const SizedBox(height: 24),
                    Text('inventory.item_composition'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ..._compositions.map((comp) {
                            final childItem = _potentialParents.firstWhere(
                              (i) => i.id == comp.childItemId, 
                              orElse: () => const Item(categoryId: 0, name: 'Unknown', price: 0, cost: 0)
                            );
                            return ListTile(
                              title: Text(childItem.name),
                              subtitle: Text('${comp.quantity} ${childItem.unit}'), // Use child item unit
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _compositions.remove(comp);
                                    _updateCostFromComposition(); // Auto-update cost
                                  });
                                },
                              ),
                            );
                          }),
                          const Divider(),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: Text('inventory.add_component'.tr()),
                            onPressed: () {
                              _showAddCompositionDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Variant Editor
                  if (_itemType == ItemType.variant) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('inventory.variants'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: Text('inventory.add_variant'.tr()),
                          onPressed: _showAddVariantDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _generatedVariants.isEmpty
                          ? Center(child: Text('inventory.no_variants_added_yet'.tr()))
                          : Column(
                              children: _generatedVariants.map((variant) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(variant.name),
                                    subtitle: Text('${variant.stock} units • Rp ${variant.price}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _generatedVariants.remove(variant);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                     const SizedBox(height: 24),
                  ],

                     /* Track Stock moved up */
                     if (_itemType != ItemType.variant) // Hide Show POS switch for Parent if desired, or keep it.
                     SwitchListTile(
                       title: Text('inventory.show_in_pos_active'.tr()),
                       value: _isVisible,
                       onChanged: (val) => setState(() => _isVisible = val),
                     ),

                     const SizedBox(height: 20),
                     ElevatedButton(
                       onPressed: () {
                         if (_formKey.currentState!.validate()) {
                           // Validation for Variants
                           if (_itemType == ItemType.variant && _generatedVariants.isEmpty) {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('inventory.please_add_at_least_one_variant'.tr())));
                             return;
                           }

                           final item = Item(
                             id: widget.item?.id,
                             categoryId: _selectedCategoryId!,
                             name: _nameController.text,
                             barcode: _barcodeController.text.isEmpty ? null : _barcodeController.text,
                             price: int.tryParse(_priceController.text) ?? 0, // Parent might have 0 price
                             cost: int.tryParse(_costController.text) ?? 0,
                             stock: int.tryParse(_stockController.text) ?? 0,
                             isTrackStock: _isTrackStock,
                             imagePath: _imagePath,
                             isVisible: _isVisible,
                             discount: int.tryParse(_discountController.text) ?? 0,
                             itemType: _itemType,
                             parentId: _itemType == ItemType.variant ? _selectedParentId : null,
                             weight: int.tryParse(_weightController.text) ?? 0,
                             unit: _unitController.text.isNotEmpty ? _unitController.text : 'pcs',
                             purchaseUnit: _purchaseUnitController.text.isNotEmpty ? _purchaseUnitController.text : null,
                             conversionFactor: int.tryParse(_conversionFactorController.text) ?? 1,
                           );

                           if (widget.item == null) {
                             if (_itemType == ItemType.variant) {
                               context.read<ItemBloc>().add(AddParentWithVariantsEvent(item, _generatedVariants));
                             } else {
                               context.read<ItemBloc>().add(AddItemEvent(item, compositions: _compositions));
                             }
                           } else {
                             // Update logic (Complex for variants, for now stick to simple update)
                             context.read<ItemBloc>().add(UpdateItemEvent(item, compositions: _compositions));
                           }
                         }
                       },
                       child: Text(widget.item == null ? 'sales.create'.tr() : 'sales.update'.tr()),
                     ),
                   ],
                 ),
               ),
             );
          },
        ),
      ),
    );
  }

  void _showAddVariantDialog() {
    final nameController = TextEditingController(text: '${_nameController.text} ');
    final priceController = TextEditingController(text: _priceController.text);
    final costController = TextEditingController(text: _costController.text);
    final stockController = TextEditingController(text: '0');
    final barcodeController = TextEditingController(); // Unique per variant
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('inventory.add_variant'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'inventory.variant_name_example'.tr()),
                ),
                TextFormField(
                  controller: barcodeController,
                  decoration: InputDecoration(
                    labelText: 'inventory.barcode'.tr(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                         final code = await Navigator.push(context, MaterialPageRoute(builder: (_) => const BarcodeScannerPage()));
                         if (code != null) barcodeController.text = code;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'inventory.price'.tr()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: costController,
                        decoration: InputDecoration(labelText: 'inventory.cost'.tr()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: stockController,
                  decoration: InputDecoration(labelText: 'inventory.initial_stock'.tr()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('sales.cancel'.tr())),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _generatedVariants.add(Item(
                      categoryId: _selectedCategoryId ?? 0,
                      name: nameController.text,
                      barcode: barcodeController.text.isEmpty ? null : barcodeController.text,
                      price: int.tryParse(priceController.text) ?? 0,
                      cost: int.tryParse(costController.text) ?? 0,
                      stock: int.tryParse(stockController.text) ?? 0,
                      isTrackStock: true,
                      isVisible: true,
                      itemType: ItemType.single,
                      parentId: 0, // Placeholder, will be linked in Bloc
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('sales.add'.tr()),
            ),
          ],
        );
      },
    );
  }
}
