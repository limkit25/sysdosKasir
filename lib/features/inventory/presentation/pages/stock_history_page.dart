import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/stock_change_type_enum.dart';
import '../bloc/stock/stock_bloc.dart';
import '../bloc/stock/stock_event.dart';
import '../bloc/stock/stock_state.dart';
import 'package:easy_localization/easy_localization.dart';

class StockHistoryPage extends StatefulWidget {
  final int itemId;
  final String itemName;

  const StockHistoryPage({super.key, required this.itemId, required this.itemName});

  @override
  State<StockHistoryPage> createState() => _StockHistoryPageState();
}

class _StockHistoryPageState extends State<StockHistoryPage> {
  StockChangeType? _selectedFilter;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'inventory.history_of'.tr(args: [widget.itemName]),
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
      body: BlocProvider(
        create: (context) => getIt<StockBloc>()..add(LoadStockHistory(widget.itemId)),
        child: BlocBuilder<StockBloc, StockState>(
          builder: (context, state) {
            if (state is StockLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is StockHistoryLoaded) {
              // Filter logic
              final history = _selectedFilter == null 
                  ? state.history 
                  : state.history.where((item) => item.type == _selectedFilter).toList();

              if (history.isEmpty) {
                 return Column(
                   children: [
                     _buildFilterDropdown(),
                     Expanded(child: Center(child: Text('inventory.no_history_found'.tr()))),
                   ],
                 );
              }
              
              return Column(
                children: [
                  _buildFilterDropdown(),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: history.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final log = history[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getTypeColor(log.type),
                            child: Icon(_getTypeIcon(log.type), color: Colors.white, size: 20),
                          ),
                          title: Text(
                            log.type.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('dd MMM yyyy, HH:mm').format(log.date)),
                              if (log.note != null && log.note!.isNotEmpty)
                                Text('inventory.note_label'.tr(args: [log.note!]), style: const TextStyle(fontStyle: FontStyle.italic)),
                              if (log.serials != null && log.serials!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('inventory.serials_label'.tr(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      Wrap(
                                        spacing: 4,
                                        children: (log.serials ?? '').split(',').where((s) => s.isNotEmpty).map((s) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.blue.withOpacity(0.2) 
                                                : Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.blue.shade100),
                                          ),
                                          child: Text(s, style: TextStyle(
                                            fontSize: 10, 
                                            color: Theme.of(context).brightness == Brightness.dark 
                                                ? Colors.blue.shade200 
                                                : Colors.blue.shade900
                                          )),
                                        )).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${log.changeAmount > 0 ? '+' : ''}${log.changeAmount}',
                                style: TextStyle(
                                  color: log.changeAmount > 0 ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'inventory.stock_label'.tr(args: [log.newStock.toString()]),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).cardTheme.color ?? Colors.grey[50],
      child: Column(
        children: [
          // 1. Transaction Type Filter
          Row(
            children: [
              const Icon(Icons.filter_list, color: Colors.grey),
              const SizedBox(width: 8),
              Text('inventory.type_label'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<StockChangeType?>(
                  value: _selectedFilter,
                  isExpanded: true,
                  underline: Container(height: 1, color: Colors.grey),
                  hint: Text('inventory.all_transactions'.tr()),
                  items: [
                    DropdownMenuItem(value: null, child: Text('inventory.all_transactions'.tr())),
                    ...StockChangeType.values.map((type) => DropdownMenuItem(
                      value: type, 
                      child: Row(
                        children: [
                          Icon(_getTypeIcon(type), size: 16, color: _getTypeColor(type)),
                          const SizedBox(width: 8),
                          Text(type.label),
                        ],
                      ),
                    )),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedFilter = val;
                      // Keep date range if selected
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // 2. Date Range Filter
          InkWell(
            onTap: _pickDateRange,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDateRange == null
                        ? 'inventory.select_date_range'.tr()
                        : '${DateFormat('dd MMM yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_selectedDateRange!.end)}',
                     style: TextStyle(
                       fontWeight: FontWeight.w500,
                       color: _selectedDateRange == null 
                           ? Colors.grey 
                           : Theme.of(context).textTheme.bodyLarge?.color,
                     ),
                  ),
                  const Spacer(),
                  if (_selectedDateRange != null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDateRange = null;
                        });
                        context.read<StockBloc>().add(LoadStockHistory(widget.itemId));
                      },
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    )
                  else
                     const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2962FF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      // Trigger load with date range
      context.read<StockBloc>().add(LoadStockHistory(
        widget.itemId,
        startDate: picked.start,
        endDate: picked.end,
      ));
    }
  }

  Color _getTypeColor(StockChangeType type) {
    switch (type) {
      case StockChangeType.sale: return Colors.green;
      case StockChangeType.purchase: return Colors.blue;
      case StockChangeType.adjustment: return Colors.orange;
      case StockChangeType.opname: return Colors.purple;
      case StockChangeType.initial: return Colors.grey;
      case StockChangeType.refund: return Colors.teal;
      case StockChangeType.recipe: return Colors.brown;
    }
  }

  IconData _getTypeIcon(StockChangeType type) {
    switch (type) {
      case StockChangeType.sale: return Icons.shopping_cart;
      case StockChangeType.purchase: return Icons.local_shipping;
      case StockChangeType.adjustment: return Icons.edit;
      case StockChangeType.opname: return Icons.checklist;
      case StockChangeType.initial: return Icons.star;
      case StockChangeType.refund: return Icons.replay;
      case StockChangeType.recipe: return Icons.soup_kitchen;
    }
  }
}
