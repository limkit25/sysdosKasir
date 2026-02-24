import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get barcode => text().nullable()();
  IntColumn get price => integer()(); // Stored in smallest unit (e.g. Rupiah)
  IntColumn get cost => integer()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  BoolColumn get isTrackStock => boolean().withDefault(const Constant(true))();
  
  // New Columns for Phase 3 Advanced Features
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))(); // Show in POS
  IntColumn get discount => integer().withDefault(const Constant(0))(); // Fixed amount discount
  TextColumn get itemType => text().withDefault(const Constant('SINGLE'))(); // SINGLE, VARIANT, etc.
  IntColumn get parentId => integer().nullable().references(Items, #id)(); // Recursive relationship
  IntColumn get weight => integer().withDefault(const Constant(0))(); // in grams
  TextColumn get unit => text().withDefault(const Constant('pcs'))(); // pcs, kg, etc.
  // New Columns for Phase 3.1 Unit Conversion
  TextColumn get purchaseUnit => text().nullable()(); // e.g. Dus, Pack
  IntColumn get conversionFactor => integer().withDefault(const Constant(1))(); // e.g. 24, 12

}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get transactionDate => dateTime()();
  IntColumn get totalAmount => integer()();
  IntColumn get paymentAmount => integer()();
  IntColumn get changeAmount => integer()();
  TextColumn get paymentMethod => text().withDefault(const Constant('CASH'))();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();
  IntColumn get taxAmount => integer().withDefault(const Constant(0))();
  IntColumn get serviceFeeAmount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('success'))(); // 'success', 'pending', 'cancelled'
  
  // Phase 3: Advanced Payment Features
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  TextColumn get tableNumber => text().nullable()();
  IntColumn get pax => integer().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get isDebt => boolean().withDefault(const Constant(false))();
  TextColumn get guestName => text().nullable()(); // Ad-hoc customer name
  TextColumn get paymentDetails => text().nullable()(); // JSON: [{method: "VOUCHER", amount: 50000}]
  
  // Phase 4: User & Shift Management
  IntColumn get userId => integer().nullable().references(Users, #id)();
  IntColumn get shiftId => integer().nullable().references(Shifts, #id)();
}

class Vouchers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get amount => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get quantity => integer()();
  IntColumn get price => integer()();
  IntColumn get cost => integer()();
}

class ItemCompositions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentItemId => integer().references(Items, #id)();
  IntColumn get childItemId => integer().references(Items, #id)();
  IntColumn get quantity => integer()();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get contactPerson => text().nullable()();
}

class StockHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get oldStock => integer()();
  IntColumn get newStock => integer()();
  IntColumn get changeAmount => integer()();
  TextColumn get type => text()(); // Store Enum name
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get serials => text().nullable()();
}

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalAmount => integer()();
  TextColumn get invoiceNumber => text().nullable()();
  TextColumn get note => text().nullable()();
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().references(Purchases, #id)();
  IntColumn get itemId => integer().references(Items, #id)();
  IntColumn get quantity => integer()();
  IntColumn get cost => integer()(); // Cost per unit at time of purchase
}

class Promos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'percentage', 'fixed'
  IntColumn get value => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get minPurchase => integer().nullable().withDefault(const Constant(0))();
  IntColumn get maxDiscount => integer().nullable().withDefault(const Constant(0))();
}

class TransactionPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  TextColumn get paymentMethod => text().withLength(min: 1, max: 50)(); // Cash, QRIS, etc.
  IntColumn get amount => integer()();
  TextColumn get referenceId => text().nullable()(); // Trace no, Auth code
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().withLength(min: 1, max: 100).unique()();
  TextColumn get password => text()();
  TextColumn get role => text().withDefault(const Constant('Cashier'))(); // Admin, Cashier
  TextColumn get pin => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Shifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get startingCash => integer()();
  IntColumn get expectedEndingCash => integer().nullable()();
  IntColumn get actualEndingCash => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))(); // open, closed
}

@DriftDatabase(tables: [Categories, Items, Transactions, TransactionItems, Customers, Suppliers, ItemCompositions, StockHistories, Purchases, PurchaseItems, ItemSerials, Promos, TransactionPayments, PaymentMethods, Vouchers, Users, Shifts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 23; // Bump version to 23 for User & Shift Management
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        
        // Insert default admin user on fresh install
        await into(users).insert(UsersCompanion.insert(
          name: 'Admin',
          email: 'admin',
          password: '1234',
          role: const Value('Administrator'),
        ));
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(transactions);
          await m.createTable(transactionItems);
        }
        if (from < 3) {
          await m.addColumn(items, items.imagePath);
          await m.addColumn(items, items.isVisible);
          await m.addColumn(items, items.discount);
          await m.addColumn(items, items.itemType);
        }
        if (from < 4) {
          await m.createTable(customers);
          await m.createTable(suppliers);
        }
        if (from < 5) {
          await m.addColumn(items, items.parentId);
        }
        if (from < 6) {
          await m.addColumn(items, items.weight);
          await m.addColumn(items, items.unit);
        }
        if (from < 7) {
          await m.createTable(itemCompositions);
        }
        if (from < 8) {
          await m.createTable(stockHistories);
        }
        if (from < 9) {
          await m.createTable(purchases);
          await m.createTable(purchaseItems);
        }
        if (from < 10) {
          await m.addColumn(items, items.purchaseUnit);
          await m.addColumn(items, items.conversionFactor);
        }
        if (from < 11) {
          await m.addColumn(transactions, transactions.discountAmount);
        }
        if (from < 12) {
          await m.createTable(promos);
        }
        if (from < 13) {
          await m.addColumn(promos, promos.minPurchase);
          await m.addColumn(promos, promos.maxDiscount);
        }
        if (from < 14) {
          await m.addColumn(transactions, transactions.taxAmount);
          await m.addColumn(transactions, transactions.serviceFeeAmount);
        }
        if (from < 15) {
          await m.createTable(itemSerials);
        }
        if (from < 16) {
          await m.addColumn(stockHistories, stockHistories.serials);
        }
        if (from < 17) {
          await m.addColumn(transactions, transactions.status);
        }
        if (from < 18) {
          // Version 18: Advanced Payment Features
          await m.addColumn(transactions, transactions.customerId);
          await m.addColumn(transactions, transactions.tableNumber);
          await m.addColumn(transactions, transactions.pax);
          await m.addColumn(transactions, transactions.note);
          await m.addColumn(transactions, transactions.isDebt);
          await m.addColumn(transactions, transactions.isDebt);
          await m.createTable(transactionPayments);
        }
        if (from < 19) {
          // Version 19: Payment Enhancements
          await m.createTable(paymentMethods);
          await m.addColumn(transactions, transactions.guestName);
          
          // Insert default payment methods
          await into(paymentMethods).insert(const PaymentMethodsCompanion(name: Value('CASH'), isActive: Value(true)));
          await into(paymentMethods).insert(const PaymentMethodsCompanion(name: Value('QRIS'), isActive: Value(true)));
          await into(paymentMethods).insert(const PaymentMethodsCompanion(name: Value('DEBIT'), isActive: Value(true)));
          await into(paymentMethods).insert(const PaymentMethodsCompanion(name: Value('CREDIT'), isActive: Value(true)));
          await into(paymentMethods).insert(const PaymentMethodsCompanion(name: Value('TRANSFER'), isActive: Value(true)));
        }
        if (from < 20) {
          // Version 20: Split Payment Support
          await m.addColumn(transactions, transactions.paymentDetails);
        }
        if (from < 21) {
          // Version 21: Voucher Management
          await m.createTable(vouchers);
        }
        if (from < 22) {
          // Version 22: Fix Payment flag for payment methods
          await m.addColumn(paymentMethods, paymentMethods.isFixPayment);
        }
        if (from < 23) {
          // Version 23: User & Shift Management
          await m.createTable(users);
          await m.createTable(shifts);
          await m.addColumn(transactions, transactions.userId);
          await m.addColumn(transactions, transactions.shiftId);
          
          // Insert default admin user if migrating to version 23
          await into(users).insert(UsersCompanion.insert(
            name: 'Admin',
            email: 'admin',
            password: '1234',
            role: const Value('Administrator'),
          ));
        }
      },
    );
  }
}

class PaymentMethods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isFixPayment => boolean().withDefault(const Constant(false))();
}

class ItemSerials extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  TextColumn get serialNumber => text()();
  // Status: 0=Available, 1=Sold, 2=Defective, 3=Returned, 4=Reserved (in cart)
  IntColumn get status => integer().withDefault(const Constant(0))(); 
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateSold => dateTime().nullable()();
  IntColumn get transactionId => integer().nullable().references(Transactions, #id)(); // Sold in this transaction
  IntColumn get purchaseId => integer().nullable().references(Purchases, #id)(); // Bought in this purchase

  @override
  List<String> get customConstraints => [
    'UNIQUE(item_id, serial_number)' // Prevent duplicate serials for same item
  ];
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
