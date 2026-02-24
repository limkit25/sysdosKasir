import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();
  Future<Either<Failure, void>> addPaymentMethod(String name);
  Future<Either<Failure, void>> deletePaymentMethod(int id);
  Future<Either<Failure, void>> togglePaymentMethod(int id, bool isActive);
  Future<Either<Failure, void>> toggleFixPayment(int id, bool isFixPayment);
}
