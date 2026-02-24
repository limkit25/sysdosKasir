import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/inventory/domain/entities/item.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../core/di/injection.dart';

class VariantSelectionDialog extends StatefulWidget {
  final Item parentItem;

  const VariantSelectionDialog({super.key, required this.parentItem});

  @override
  State<VariantSelectionDialog> createState() => _VariantSelectionDialogState();
}

class _VariantSelectionDialogState extends State<VariantSelectionDialog> {
  List<Item> _variants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchVariants();
  }

  Future<void> _fetchVariants() async {
    final repository = getIt<InventoryRepository>();
    final result = await repository.getItems(parentId: widget.parentItem.id);
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (variants) => setState(() {
        _variants = variants;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Variation: ${widget.parentItem.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text('Error: $_error'))
                : _variants.isEmpty
                    ? const Center(child: Text('No variants available.'))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _variants.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final variant = _variants[index];
                          final isOutOfStock = variant.stock <= 0 && variant.isTrackStock;

                          return ListTile(
                            title: Text(variant.name), // Name usually contains variant info like "Shirt Red M"
                            subtitle: Text('Rp ${variant.price} • Stock: ${variant.stock}'),
                            enabled: !isOutOfStock,
                            onTap: isOutOfStock
                                ? null
                                : () {
                                    Navigator.pop(context, variant);
                                  },
                            trailing: isOutOfStock
                                ? const Text('Out of Stock', style: TextStyle(color: Colors.red, fontSize: 12))
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                          );
                        },
                      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
