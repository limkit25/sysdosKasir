import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'barcode_scanner_page.dart';

class SerialSelectionDialog extends StatefulWidget {
  final String itemName;
  final int quantity;
  final List<String> availableSerials;
  final bool isPurchase;
  final bool allowDynamicQuantity;

  const SerialSelectionDialog({
    super.key,
    required this.itemName,
    required this.quantity,
    this.availableSerials = const [],
    this.isPurchase = false,
    this.allowDynamicQuantity = false,
  });

  @override
  State<SerialSelectionDialog> createState() => _SerialSelectionDialogState();
}

class _SerialSelectionDialogState extends State<SerialSelectionDialog> {
  final List<TextEditingController> _controllers = [];
  final Set<String> _selectedSerials = {};

  @override
  void initState() {
    super.initState();
    if (widget.isPurchase) {
      // Create controllers for each unit
      final count = widget.allowDynamicQuantity ? 1 : widget.quantity;
      for (int i = 0; i < count; i++) {
        _controllers.add(TextEditingController());
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _scanBarcode(int? index) async {
    final code = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (code != null) {
      if (widget.isPurchase) {
         if (index != null) {
            _controllers[index].text = code;
         } else if (widget.allowDynamicQuantity) {
            // Check if already exists in list
            if (_controllers.any((c) => c.text == code)) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Duplicate serial scanned')));
               return;
            }
            setState(() {
               final c = TextEditingController(text: code);
               _controllers.add(c);
            });
         }
      } else if (!widget.isPurchase) {
        // Find and select the serial if it exists in availableSerials
        if (widget.availableSerials.contains(code)) {
          setState(() {
            if (widget.allowDynamicQuantity || _selectedSerials.length < widget.quantity) {
               _selectedSerials.add(code);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All units selected')));
            }
          });
        } else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Serial not found in inventory')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isPurchase ? 'Input Serial Numbers' : 'Select Serial Numbers'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Item: ${widget.itemName}'),
            if (!widget.allowDynamicQuantity) Text('Quantity: ${widget.quantity}'),
            const SizedBox(height: 16),
            Expanded(
              child: widget.isPurchase ? _buildInputList() : _buildSelectionList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildInputList() {
    return Column(
      children: [
        if (widget.allowDynamicQuantity)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => _scanBarcode(null), 
              icon: const Icon(Icons.qr_code_scanner), 
              label: const Text('Scan to Add New')
            ),
          ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _controllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text('#${index + 1}'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          hintText: 'Serial Number / IMEI',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: () => _scanBarcode(index),
                          ),
                        ),
                      ),
                    ),
                    if (widget.allowDynamicQuantity)
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                          });
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.allowDynamicQuantity)
           TextButton.icon(
             onPressed: () {
               setState(() {
                 _controllers.add(TextEditingController());
               });
             },
             icon: const Icon(Icons.add),
             label: const Text('Add Row Manually')
           ),
      ],
    );
  }

  Widget _buildSelectionList() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scan Serial to Select'),
          onPressed: () => _scanBarcode(null),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.availableSerials.length,
            itemBuilder: (context, index) {
              final serial = widget.availableSerials[index];
              final isSelected = _selectedSerials.contains(serial);
              
              return CheckboxListTile(
                title: Text(serial),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      if (widget.allowDynamicQuantity || _selectedSerials.length < widget.quantity) {
                        _selectedSerials.add(serial);
                      }
                    } else {
                      _selectedSerials.remove(serial);
                    }
                  });
                },
                enabled: widget.allowDynamicQuantity || isSelected || _selectedSerials.length < widget.quantity,
              );
            },
          ),
        ),
        Text('Selected: ${_selectedSerials.length} ${widget.allowDynamicQuantity ? "" : "/ ${widget.quantity}"}'),
      ],
    );
  }

  void _validateAndSubmit() {
    List<String> result = [];
    
    if (widget.isPurchase) {
      // Validate all inputs are filled and unique
      final inputs = _controllers.map((c) => c.text.trim()).toList();
      inputs.removeWhere((s) => s.isEmpty); // Allow empty rows if dynamic? No, stricter.

      if (inputs.any((s) => s.isEmpty)) {
         // In dynamic mode, maybe just ignore empty?
         if (!widget.allowDynamicQuantity) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all serial numbers')));
            return;
         }
      }
      
      if (inputs.isEmpty && !widget.allowDynamicQuantity) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all serial numbers')));
         return;
      }

      if (inputs.toSet().length != inputs.length) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Duplicate serial numbers entered')));
        return;
      }
      result = inputs;
    } else {
      // Validate correct quantity selected
      if (!widget.allowDynamicQuantity && _selectedSerials.length != widget.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select exactly ${widget.quantity} serials')));
        return;
      }
      if (widget.allowDynamicQuantity && _selectedSerials.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one serial')));
        return;
      }
      result = _selectedSerials.toList();
    }

    Navigator.pop(context, result);
  }
}
