import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/stock_change_type_enum.dart';
import '../../domain/entities/item_type_enum.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../../../core/widgets/serial_selection_dialog.dart';
import '../bloc/stock/stock_bloc.dart';
import '../bloc/stock/stock_event.dart';

class StockAdjustmentDialog extends StatefulWidget {
  final Item item;
  final bool isOpname;

  const StockAdjustmentDialog({
    super.key, 
    required this.item, 
    this.isOpname = false,
  });

  @override
  State<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<StockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _qtyController;
  late TextEditingController _noteController;
  late StockChangeType _selectedType;
  late String _action;

  List<String> _availableSerials = [];
  List<String> _selectedSerials = [];
  bool _isLoadingSerials = false;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController();
    _noteController = TextEditingController();
    
    // Default action based on mode
    _action = widget.isOpname ? 'Set (Opname)' : 'Add';
    
    if (_action == 'Set (Opname)') {
      _selectedType = StockChangeType.opname;
    } else {
      _selectedType = StockChangeType.adjustment;
    }

    if (widget.item.itemType == ItemType.imei) {
      _fetchAvailableSerials();
    }
  }

  Future<void> _fetchAvailableSerials() async {
    setState(() => _isLoadingSerials = true);
    final result = await getIt<InventoryRepository>().getAvailableSerials(widget.item.id!);
    result.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
      (r) => setState(() => _availableSerials = r),
    );
    setState(() => _isLoadingSerials = false);
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _manageSerials() async {
    // Determined mode based on Action
    bool isInputMode = true; // Add or Opname
    List<String> sourceSerials = [];

    if (_action == 'Subtract') {
      isInputMode = false;
      if (_availableSerials.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No serials available to subtract')));
        return;
      }
      sourceSerials = _availableSerials;
    }

    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => SerialSelectionDialog(
        itemName: widget.item.name,
        quantity: 0, // Ignored because allowDynamicQuantity is true
        allowDynamicQuantity: true,
        isPurchase: isInputMode,
        availableSerials: sourceSerials,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedSerials = result;
        _qtyController.text = result.length.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter options based on mode
    final List<String> options = widget.isOpname 
        ? ['Set (Opname)'] 
        : ['Add', 'Subtract'];

    return AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      surfaceTintColor: Theme.of(context).dialogTheme.surfaceTintColor,
      title: Text('Adjust Stock: ${widget.item.name}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.blue.withOpacity(0.1) 
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.blue.withOpacity(0.3) 
                      : Colors.blue.shade200
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Untuk penambahan stok dari supplier, disarankan melalui menu Purchasing.',
                        style: TextStyle(
                          fontSize: 12, 
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.blue.shade200 
                              : Colors.blue.shade900
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('Current Stock: ${widget.item.stock} ${widget.item.unit}'),
              const SizedBox(height: 16),
              
              // Action Selector
              DropdownButtonFormField<String>(
                value: _action,
                decoration: const InputDecoration(labelText: 'Action'),
                items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _action = val;
                    // Reset selected serials if action changes logic (Add -> Subtract)
                    _selectedSerials.clear();
                    _qtyController.clear();
                    
                    if (_action == 'Set (Opname)') {
                      _selectedType = StockChangeType.opname;
                    } else {
                      _selectedType = StockChangeType.adjustment;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              
              if (widget.item.itemType == ItemType.imei) ...[
                 if (_isLoadingSerials)
                   const LinearProgressIndicator()
                 else
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: [
                       ElevatedButton.icon(
                         onPressed: _manageSerials,
                         icon: const Icon(Icons.qr_code),
                         label: Text(_selectedSerials.isEmpty ? 'Scan/Select Serials' : 'Manage Serials (${_selectedSerials.length})'),
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.teal,
                           foregroundColor: Colors.white,
                         ),
                       ),
                       if (_selectedSerials.isNotEmpty)
                         Padding(
                           padding: const EdgeInsets.only(top: 8.0),
                           child: Text(
                             'Selected: ${_selectedSerials.join(", ")}',
                             style: const TextStyle(fontSize: 12, color: Colors.grey),
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                           ),
                         ),
                     ],
                   ),
              ] else ...[
                // Simple Quantity Input
                TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(
                    labelText: _action == 'Set (Opname)' ? 'New Actual Stock' : 'Quantity to $_action',
                    suffixText: widget.item.unit,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
              ],
              
              const SizedBox(height: 16),
              // Note Input
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (Reason)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (widget.item.itemType == ItemType.imei && _selectedSerials.isEmpty) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select serial numbers')));
               return;
            }
            
            if (_formKey.currentState!.validate() || widget.item.itemType == ItemType.imei) {
               // For serialized, qty is derived from list length, set controller for consistency
               if (widget.item.itemType == ItemType.imei) {
                  _qtyController.text = _selectedSerials.length.toString();
               }

               final qty = int.parse(_qtyController.text);
               int newStock = widget.item.stock;
               
               if (_action == 'Add') {
                 newStock += qty;
               } else if (_action == 'Subtract') {
                 newStock -= qty;
               } else {
                 newStock = qty;
               }

              context.read<StockBloc>().add(AdjustStock(
                itemId: widget.item.id!,
                newStock: newStock,
                note: _noteController.text.isEmpty ? _action : _noteController.text,
                type: _selectedType,
                serials: widget.item.itemType == ItemType.imei ? _selectedSerials : null,
              ));

              Navigator.pop(context); // Close dialog
              // Parent page should handle BlocListener for success/refresh
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
