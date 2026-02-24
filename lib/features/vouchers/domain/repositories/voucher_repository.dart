import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/voucher.dart';

abstract class VoucherRepository {
  Future<Either<Failure, List<Voucher>>> getVouchers();
  Future<Either<Failure, List<Voucher>>> getActiveVouchers();
  Future<Either<Failure, int>> saveVoucher(Voucher voucher);
  Future<Either<Failure, void>> updateVoucher(Voucher voucher);
  Future<Either<Failure, void>> deleteVoucher(int id);
  Future<Either<Failure, void>> toggleActive(int id, bool isActive);
}
