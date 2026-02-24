import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/customer.dart';
import '../entities/supplier.dart';

abstract class PartnerRepository {
  // Customers
  Future<Either<Failure, List<Customer>>> getCustomers({String? query});
  Future<Either<Failure, int>> addCustomer(Customer customer);
  Future<Either<Failure, void>> updateCustomer(Customer customer);
  Future<Either<Failure, void>> deleteCustomer(int id);

  // Suppliers
  Future<Either<Failure, List<Supplier>>> getSuppliers({String? query});
  Future<Either<Failure, int>> addSupplier(Supplier supplier);
  Future<Either<Failure, void>> updateSupplier(Supplier supplier);
  Future<Either<Failure, void>> deleteSupplier(int id);
}
