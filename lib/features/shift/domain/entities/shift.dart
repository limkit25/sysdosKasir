import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  final int id;
  final int userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int startingCash;
  final int? expectedEndingCash;
  final int? actualEndingCash;
  final String? note;
  final String status;

  const Shift({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.startingCash,
    this.expectedEndingCash,
    this.actualEndingCash,
    this.note,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        startTime,
        endTime,
        startingCash,
        expectedEndingCash,
        actualEndingCash,
        note,
        status,
      ];
}
