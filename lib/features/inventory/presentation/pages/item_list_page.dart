import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/item/item_bloc.dart';
import '../bloc/item/item_event.dart';
import '../bloc/item/item_state.dart';
import '../../domain/entities/sort_option_enum.dart';
import '../../domain/entities/item_type_enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'item_form_page.dart';
import 'item_detail_page.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ItemBloc>()..add(const LoadItems()),
      child: const ItemListView(),
    );
  }
}

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final _searchController = TextEditingController();
  SortOption _currentSort = SortOption.nameAsc;
  ItemType? _selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<ItemBloc>().add(LoadItems(
      query: query,
      sortOption: _currentSort,
      itemType: _selectedType,
    ));
  }

  void _onSortChanged(SortOption option) {
    setState(() {
      _currentSort = option;
    });
    context.read<ItemBloc>().add(LoadItems(
      query: _searchController.text,
      sortOption: _currentSort,
      itemType: _selectedType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)), // Blue back
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'inventory.product'.tr(),
          style: const TextStyle(
            color: Color(0xFF2962FF), // Blue
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF2962FF)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2962FF), // Blue background
        foregroundColor: Colors.white, // White icon
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemFormPage()),
          ).then((_) {
            if (context.mounted) {
              context.read<ItemBloc>().add(LoadItems(
                sortOption: _currentSort,
                itemType: _selectedType,
                query: _searchController.text,
              ));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is ItemError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search & Sort Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Sort Icon
                    InkWell(
                      onTap: () {
                         // Simple Sort Toggle or Dialog
                         // For now, just toggling or showing menu (keeping existing logic)
                         showMenu<SortOption>(
                            context: context,
                            position: const RelativeRect.fromLTRB(0, 80, 0, 0), // Approx position
                            items: SortOption.values.map((SortOption option) {
                              return PopupMenuItem<SortOption>(
                                value: option,
                                child: Text(option.label),
                              );
                            }).toList(),
                          ).then((value) {
                            if (value != null) _onSortChanged(value);
                          });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.sort, color: Color(0xFF2962FF), size: 28),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search Bar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            hintText: 'inventory.find_name_or_code'.tr(),
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip(null, 'inventory.all'.tr()), // All Items
                    const SizedBox(width: 8),
                    if (state is ItemLoaded)
                      ...state.availableTypes.map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(type, type.label),
                        );
                      }),
                  ],
                ),
              ),
              const Divider(height: 1),
              
              // Item List
              Expanded(
                child: state is ItemLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is ItemLoaded
                        ? (state.items.isEmpty
                            ? Center(child: Text('inventory.no_items_found'.tr()))
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.items.length,
                                separatorBuilder: (context, index) => const Divider(height: 16, thickness: 1, color: Colors.grey),
                                itemBuilder: (context, index) {
                                  final item = state.items[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemDetailPage(item: item),
                                        ),
                                      ).then((shouldReload) {
                                        // Reload if detail page returns true (e.g. after edit or delete)
                                        if (shouldReload == true && context.mounted) {
                                           context.read<ItemBloc>().add(LoadItems(sortOption: _currentSort));
                                        }
                                      });
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
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
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
                                                        fontSize: 14, // Smaller font size (was 16)
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  // Stock Badge
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF2962FF), // Blue badge
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      '${item.stock}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              // Type & Code
                                              Row(
                                                children: [
                                                  if (!item.isVisible) ...[
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[600],
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.visibility_off, size: 8, color: Colors.white),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            'POS Hidden',
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
                                                  if (item.itemType != ItemType.single) ...[
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
                                                  if (item.barcode != null) ...[
                                                    Expanded(
                                                      child: Text(
                                                        item.barcode!,
                                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              // Price & Discount
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Price Left, Discount Right (or vice versa)
                                                children: [
                                                  if (item.discount > 0)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red[100],
                                                        borderRadius: BorderRadius.circular(4),
                                                        border: Border.all(color: Colors.red, width: 0.5),
                                                      ),
                                                      child: Text(
                                                        'Disc ${item.discount}%',
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID', 
                                                          symbol: 'Rp ', 
                                                          decimalDigits: 0
                                                        ).format(item.price), // Formatted Price
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).textTheme.bodyLarge?.color,
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
                              ))
                        : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getItemTypeColor(ItemType type) {
    switch (type) {
      case ItemType.service: return Colors.blue;
      case ItemType.recipe: return Colors.orange;
      case ItemType.bundle: return Colors.purple;
      case ItemType.imei: return Colors.teal;
      case ItemType.variant: return Colors.indigo;
      default: return Colors.grey;
    }
  }

  Widget _buildFilterChip(ItemType? type, String label) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = type;
        });
        context.read<ItemBloc>().add(LoadItems(
          query: _searchController.text,
          sortOption: _currentSort,
          itemType: _selectedType,
        ));
      },
      selectedColor: const Color(0xFF2962FF).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected 
            ? const Color(0xFF2962FF) 
            : Theme.of(context).textTheme.bodyMedium?.color, // Adapt to theme
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF2962FF) : Colors.transparent,
        ),
      ),
    );
  }
}
