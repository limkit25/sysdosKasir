import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../../../core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/repositories/partner_repository.dart';

@LazySingleton(as: PartnerRepository)
class PartnerRepositoryImpl implements PartnerRepository {
  final db.AppDatabase database;

  PartnerRepositoryImpl(this.database);

  @override
  Future<Either<Failure, List<Customer>>> getCustomers({String? query}) async {
    try {
      final statement = database.select(database.customers);
      if (query != null && query.isNotEmpty) {
        statement.where((tbl) => tbl.name.contains(query));
      }
      final rows = await statement.get();
      final customers = rows.map((row) => Customer(
        id: row.id,
        name: row.name,
        phone: row.phone,
        email: row.email,
        address: row.address,
      )).toList();
      return Right(customers);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addCustomer(Customer customer) async {
    try {
      final id = await database.into(database.customers).insert(
        db.CustomersCompanion(
          name: Value(customer.name),
          phone: Value(customer.phone),
          email: Value(customer.email),
          address: Value(customer.address),
        ),
      );
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomer(Customer customer) async {
    try {
      await (database.update(database.customers)
            ..where((tbl) => tbl.id.equals(customer.id!)))
          .write(
        db.CustomersCompanion(
          name: Value(customer.name),
          phone: Value(customer.phone),
          email: Value(customer.email),
          address: Value(customer.address),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(int id) async {
    try {
      await (database.delete(database.customers)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  // Suppliers

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliers({String? query}) async {
    try {
      final statement = database.select(database.suppliers);
      if (query != null && query.isNotEmpty) {
        statement.where((tbl) => tbl.name.contains(query));
      }
      final rows = await statement.get();
      final suppliers = rows.map((row) => Supplier(
        id: row.id,
        name: row.name,
        phone: row.phone,
        email: row.email,
        address: row.address,
        contactPerson: row.contactPerson,
      )).toList();
      return Right(suppliers);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addSupplier(Supplier supplier) async {
    try {
      final id = await database.into(database.suppliers).insert(
        db.SuppliersCompanion(
          name: Value(supplier.name),
          phone: Value(supplier.phone),
          email: Value(supplier.email),
          address: Value(supplier.address),
          contactPerson: Value(supplier.contactPerson),
        ),
      );
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSupplier(Supplier supplier) async {
    try {
      await (database.update(database.suppliers)
            ..where((tbl) => tbl.id.equals(supplier.id!)))
          .write(
        db.SuppliersCompanion(
          name: Value(supplier.name),
          phone: Value(supplier.phone),
          email: Value(supplier.email),
          address: Value(supplier.address),
          contactPerson: Value(supplier.contactPerson),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(int id) async {
    try {
      await (database.delete(database.suppliers)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
