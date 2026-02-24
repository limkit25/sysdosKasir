import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide User, Shift;
import '../../../../core/error/failures.dart';
import '../../domain/entities/shift.dart';
import '../../domain/repositories/shift_repository.dart';

@LazySingleton(as: ShiftRepository)
class ShiftRepositoryImpl implements ShiftRepository {
  final AppDatabase database;

  ShiftRepositoryImpl(this.database);

  Shift _mapToShift(dynamic dbShift) {
    if (dbShift == null) throw Exception('Shift is null');
    return Shift(
      id: dbShift.id,
      userId: dbShift.userId,
      startTime: dbShift.startTime,
      endTime: dbShift.endTime,
      startingCash: dbShift.startingCash,
      expectedEndingCash: dbShift.expectedEndingCash,
      actualEndingCash: dbShift.actualEndingCash,
      note: dbShift.note,
      status: dbShift.status,
    );
  }

  @override
  Future<Either<Failure, Shift?>> getActiveShift() async {
    try {
      final query = database.select(database.shifts)
        ..where((s) => s.status.equals('open'))
        ..limit(1);
      
      final result = await query.getSingleOrNull();
      return Right(result != null ? _mapToShift(result) : null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Shift>> openShift(int userId, int startingCash, String? note) async {
    try {
      // Check if there's already an active shift
      final activeShiftQuery = database.select(database.shifts)
        ..where((s) => s.status.equals('open'));
      final activeShift = await activeShiftQuery.getSingleOrNull();

      if (activeShift != null) {
        return const Left(ServerFailure('A shift is already open. Close it first.'));
      }

      final companion = ShiftsCompanion.insert(
        userId: userId,
        startTime: DateTime.now(),
        startingCash: startingCash,
        note: Value(note),
        status: const Value('open'),
      );
      
      final id = await database.into(database.shifts).insert(companion);
      
      final newShift = await (database.select(database.shifts)..where((s) => s.id.equals(id))).getSingle();
      return Right(_mapToShift(newShift));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Shift>> closeShift(int shiftId, int actualEndingCash, String? note) async {
    try {
      // 1. Get current shift
      final shiftQuery = database.select(database.shifts)..where((s) => s.id.equals(shiftId));
      final shift = await shiftQuery.getSingleOrNull();

      if (shift == null || shift.status != 'open') {
        return const Left(ServerFailure('Shift not found or already closed.'));
      }

      // 2. Calculate expected cash from transactions during this shift
      final txQuery = database.select(database.transactions)
        ..where((t) => t.shiftId.equals(shiftId) & t.paymentMethod.equals('CASH'));
      
      final transactions = await txQuery.get();
      int totalCashSales = 0;
      for (var tx in transactions) {
        // Simple logic: total amount paid by cash. Complex logic might involve change, refunds, etc.
        totalCashSales += tx.totalAmount; 
      }

      final expectedEndingCash = shift.startingCash + totalCashSales;

      // 3. Update the shift
      final updateCompanion = ShiftsCompanion(
        endTime: Value(DateTime.now()),
        expectedEndingCash: Value(expectedEndingCash),
        actualEndingCash: Value(actualEndingCash),
        note: note != null && note.isNotEmpty ? Value(note) : shift.note == null ? const Value.absent() : Value(shift.note),
        status: const Value('closed'),
      );

      await (database.update(database.shifts)..where((s) => s.id.equals(shiftId))).write(updateCompanion);

      final updatedShift = await (database.select(database.shifts)..where((s) => s.id.equals(shiftId))).getSingle();
      return Right(_mapToShift(updatedShift));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Shift>>> getShifts({DateTime? startDate, DateTime? endDate}) async {
    try {
      final query = database.select(database.shifts);
      // Add date filters if needed later
      query.orderBy([(t) => OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)]);
      
      final results = await query.get();
      return Right(results.map(_mapToShift).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
