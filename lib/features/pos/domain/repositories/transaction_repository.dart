import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, int>> saveTransaction(Transaction transaction);
  Future<Either<Failure, void>> updateTransaction(Transaction transaction);
  Future<Either<Failure, Map<String, int>>> getTurnoverStats();
  Future<Either<Failure, List<Transaction>>> getPendingTransactions();
  Future<Either<Failure, List<Transaction>>> getDebtTransactions();
  Future<Either<Failure, void>> payDebt(int transactionId, int paymentAmount);
  Future<Either<Failure, void>> deleteTransaction(int id);
}
