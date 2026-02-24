import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/di/injection.dart';
import '../bloc/shift/shift_bloc.dart';

class ShiftHistoryPage extends StatelessWidget {
  const ShiftHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ShiftBloc>()..add(LoadShifts()),
      child: const _ShiftHistoryView(),
    );
  }
}

class _ShiftHistoryView extends StatelessWidget {
  const _ShiftHistoryView();

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('shift.history_title'.tr()),
        elevation: 0,
      ),
      body: BlocConsumer<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state is ShiftError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is ShiftLoading) {
             return const Center(child: CircularProgressIndicator());
          }

          if (state is ShiftsLoaded) {
            if (state.shifts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('shift.no_history'.tr(), style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.shifts.length,
              itemBuilder: (context, index) {
                final shift = state.shifts[index];
                
                final isClosed = shift.status == 'closed';
                final expectedCash = shift.expectedEndingCash ?? 0;
                final actualCash = shift.actualEndingCash ?? 0;
                final diff = actualCash - expectedCash;
                final isMatch = diff == 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header: Date & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateFormat.format(shift.startTime),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isClosed ? Colors.grey.shade200 : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                isClosed ? 'shift.closed'.tr() : 'shift.active'.tr(),
                                style: TextStyle(
                                  color: isClosed ? Colors.grey.shade700 : Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // Details
                        _buildRow('shift.end_time'.tr(), isClosed && shift.endTime != null ? dateFormat.format(shift.endTime!) : '-'),
                        _buildRow('shift.starting_cash_label'.tr(), currencyFormat.format(shift.startingCash)),
                        
                        if (isClosed) ...[
                          const SizedBox(height: 8),
                          _buildRow('shift.system_expected'.tr(), currencyFormat.format(expectedCash)),
                          _buildRow('shift.actual_cash'.tr(), currencyFormat.format(actualCash)),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('shift.difference'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                currencyFormat.format(diff),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isMatch ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          if (!isMatch)
                             Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                               child: Text(
                                 diff < 0 ? 'shift.cash_shortage'.tr() : 'shift.cash_overage'.tr(),
                                 style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.bold),
                                 textAlign: TextAlign.right,
                               ),
                             ),
                        ],
                        
                        if (shift.note != null && shift.note!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.note, size: 16, color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(child: Text(shift.note!, style: const TextStyle(fontSize: 12, color: Colors.black87))),
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink(); // Initial or Error fallback
        }
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
