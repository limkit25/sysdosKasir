import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/shift.dart';

abstract class ShiftRepository {
  Future<Either<Failure, Shift?>> getActiveShift();
  Future<Either<Failure, Shift>> openShift(int userId, int startingCash, String? note);
  Future<Either<Failure, Shift>> closeShift(int shiftId, int actualEndingCash, String? note);
  Future<Either<Failure, List<Shift>>> getShifts({DateTime? startDate, DateTime? endDate});
}
