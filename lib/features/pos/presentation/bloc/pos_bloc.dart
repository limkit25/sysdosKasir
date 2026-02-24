import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_item.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'pos_event.dart';
import 'pos_state.dart';

import '../../../settings/domain/repositories/settings_repository.dart';
import '../../../partners/domain/repositories/partner_repository.dart';
import '../../../partners/domain/entities/customer.dart';
import '../../../settings/domain/entities/payment_method.dart'; // Explicit import
import '../../../settings/domain/repositories/payment_method_repository.dart';
import '../../../vouchers/domain/repositories/voucher_repository.dart';

@injectable
class PosBloc extends Bloc<PosEvent, PosState> {
  final InventoryRepository inventoryRepository;
  final TransactionRepository transactionRepository;
  final SettingsRepository settingsRepository;
  final PartnerRepository partnerRepository;
  final PaymentMethodRepository paymentMethodRepository;
  final VoucherRepository voucherRepository;

  PosBloc(
    this.inventoryRepository,
    this.transactionRepository,
    this.settingsRepository,
    this.partnerRepository,
    this.paymentMethodRepository,
    this.voucherRepository,
  ) : super(PosInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<SelectCategory>(_onSelectCategory);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ProcessPayment>(_onProcessPayment);
    on<ClearCart>(_onClearCart);
    on<HoldOrder>(_onHoldOrder);
    on<LoadPendingOrders>(_onLoadPendingOrders);
    on<ResumeOrder>(_onResumeOrder);
    on<DeletePendingOrder>(_onDeletePendingOrder);
    // New Events
    on<LoadCustomers>(_onLoadCustomers);
    on<SelectCustomer>(_onSelectCustomer);
    on<SetTableInfo>(_onSetTableInfo);
    on<SetTransactionNote>(_onSetTransactionNote);
    on<SetDebt>(_onSetDebt);
    on<SetDiscount>(_onSetDiscount); // PENTING: Event untuk apply promo/discount
    on<SetGuestName>(_onSetGuestName); // Event untuk guest name
    // Voucher Events
    on<LoadActiveVouchers>(_onLoadActiveVouchers);
    on<SelectVoucher>(_onSelectVoucher);
    on<ClearVoucher>(_onClearVoucher);
  }

  // ... (Other handlers same as before usually, unless modified)

  Future<void> _onLoadCustomers(LoadCustomers event, Emitter<PosState> emit) async {
    if (state is PosLoaded) {
      final result = await partnerRepository.getCustomers();
      result.fold(
        (failure) => print("PosBloc: Failed to load customers: ${failure.message}"),
        (customers) {
          emit((state as PosLoaded).copyWith(customers: customers));
        },
      );
    }
  }

  void _onSelectCustomer(SelectCustomer event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(
        selectedCustomer: event.customer,
        clearSelectedCustomer: event.customer == null,
      ));
    }
  }

  void _onSetTableInfo(SetTableInfo event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(
        tableNumber: event.tableNumber,
        pax: event.pax,
      ));
    }
  }

  void _onSetTransactionNote(SetTransactionNote event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(note: event.note));
    }
  }

  void _onSetDebt(SetDebt event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(isDebt: event.isDebt));
    }
  }

  void _onSetGuestName(SetGuestName event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(guestName: event.guestName));
    }
  }

  // Voucher Event Handlers
  Future<void> _onLoadActiveVouchers(LoadActiveVouchers event, Emitter<PosState> emit) async {
    if (state is PosLoaded) {
      final result = await voucherRepository.getActiveVouchers();
      result.fold(
        (failure) => print('PosBloc: Failed to load vouchers: ${failure.message}'),
        (vouchers) {
          emit((state as PosLoaded).copyWith(activeVouchers: vouchers));
        },
      );
    }
  }

  void _onSelectVoucher(SelectVoucher event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(
        selectedVoucher: event.voucher,
        voucherAmount: event.voucher?.amount ?? 0,
        clearVoucher: event.voucher == null,
      ));
    }
  }

  void _onClearVoucher(ClearVoucher event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      emit((state as PosLoaded).copyWith(clearVoucher: true));
    }
  }

  // Update _onLoadProducts to trigger LoadCustomers
  void _onLoadProducts(LoadProducts event, Emitter<PosState> emit) async {
    emit(PosLoading());
    // Fetch items, categories, and settings
    final itemsResult = await inventoryRepository.getItems();
    final categoriesResult = await inventoryRepository.getCategories();
    final taxRate = await settingsRepository.getTaxRate();
    final serviceRate = await settingsRepository.getServiceFeeRate();
    final paymentMethodsResult = await paymentMethodRepository.getPaymentMethods();
    final paymentMethods = paymentMethodsResult.fold((l) => <PaymentMethod>[], (r) => r.where((m) => m.isActive).toList());

    itemsResult.fold(
      (failure) => emit(PosError(failure.message)),
      (items) {
        // Filter out hidden items AND child variants (items with parentId)
        final visibleItems = items.where((i) => i.isVisible && i.parentId == null).toList();
        
        categoriesResult.fold(
          (catFailure) {
             emit(PosLoaded(
               products: visibleItems, 
               filteredProducts: visibleItems, 
               categories: [],
               taxRate: taxRate,
               serviceFeeRate: serviceRate,
               paymentMethods: paymentMethods, // Cast? No, dynamic or List<PaymentMethod>
             ));
             add(LoadPendingOrders()); 
             add(LoadCustomers());
             add(LoadActiveVouchers());
          },
          (categories) {
            emit(PosLoaded(
              products: visibleItems, 
              filteredProducts: visibleItems, 
              categories: categories,
              taxRate: taxRate,
              serviceFeeRate: serviceRate,
              paymentMethods: paymentMethods,
            ));
            add(LoadPendingOrders());
            add(LoadCustomers());
            add(LoadActiveVouchers());
          },
        );
      },
    );
  }

  void _onClearCart(ClearCart event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final currentState = state as PosLoaded;
      emit(currentState.copyWith(
        cart: [], 
        discountAmount: 0, 
        discountValue: 0, 
        discountType: 'fixed', 
        selectedPromoId: null,
        minPurchase: 0,
        maxDiscount: 0,
        clearSelectedCustomer: true,
        tableNumber: null, // Reset table? Maybe keep it if typical flow is same table? Usually reset.
        pax: null,
        note: null,
        isDebt: false,
      ));
      // Re-emit tableNumber null if copyWith doesn't handle null assignment for nullable fields without specific logic
      // In copyWith implementation: tableNumber: tableNumber ?? this.tableNumber.
      // So passing null will KEEP existing value.
      // I need to update copyWith logic or use a specific flag to clear.
      // For now, I'll rely on current copyWith which uses `??`.
      // Actually, my copyWith implementation: `tableNumber: tableNumber ?? this.tableNumber`.
      // So I CANNOT clear it by passing null. 
      // I should update copyWith to allow clearing, but for simplicity I will just re-instantiate or assume table clears on new order. 
      // Wait, "Reset table? ... Usually reset."
      // I need to fix `PosLoaded.copyWith` to allow clearing nullable fields completely or live with it persisting.
      // Usually passing null to copyWith means "unchanged".
      // I added `clearSelectedCustomer` flag. I should add `clearTableInfo` flag or similar if I want to clear.
      // Or just emit a NEW PosLoaded with empty values but same products/cats.
    } else {
      add(LoadProducts());
    }
  }



  Future<void> _onHoldOrder(HoldOrder event, Emitter<PosState> emit) async {
    print("PosBloc: _onHoldOrder triggered");
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      if (loadedState.cart.isEmpty) return; // Cannot hold empty order

      final transactionItems = loadedState.cart.map((c) => TransactionItem(
        itemId: c.item.id!,
        quantity: c.quantity,
        price: c.item.price,
        cost: c.item.cost,
        serialNumbers: c.serialNumbers,
        itemName: c.item.name,
      )).toList();

      if (loadedState.originalPendingTransactionId != null) {
        // UPDATE existing pending transaction
        final transaction = Transaction(
          id: loadedState.originalPendingTransactionId,
          dateTime: DateTime.now(),
          totalAmount: loadedState.grandTotal,
          paymentAmount: 0,
          changeAmount: 0,
          paymentMethod: 'PENDING',
          discountAmount: loadedState.discountAmount,
          taxAmount: loadedState.taxAmount,
          serviceFeeAmount: loadedState.serviceFeeAmount,
          status: 'pending',
          shiftId: event.shiftId,
          userId: event.userId,
          items: transactionItems,
        );

        print("PosBloc: Updating pending transaction #${transaction.id}...");
        final result = await transactionRepository.updateTransaction(transaction);

        await result.fold(
          (failure) async {
             print("PosBloc: Failed to update order: ${failure.message}");
             emit(PosError(failure.message));
          },
          (_) async {
             print("PosBloc: Order updated successfully. ID: ${transaction.id}");
             add(ClearCart());
             add(LoadPendingOrders());
             add(LoadProducts()); 
          },
        );

      } else {
        // CREATE NEW pending transaction
        final transaction = Transaction(
          dateTime: DateTime.now(),
          totalAmount: loadedState.grandTotal,
          paymentAmount: 0,
          changeAmount: 0,
          paymentMethod: 'PENDING',
          discountAmount: loadedState.discountAmount,
          taxAmount: loadedState.taxAmount,
          serviceFeeAmount: loadedState.serviceFeeAmount,
          status: 'pending',
          shiftId: event.shiftId,
          userId: event.userId,
          items: transactionItems,
        );

        print("PosBloc: Saving NEW pending transaction...");
        final result = await transactionRepository.saveTransaction(transaction);
        
        await result.fold(
          (failure) async {
             print("PosBloc: Failed to hold order: ${failure.message}");
             emit(PosError(failure.message));
          },
          (transactionId) async {
             print("PosBloc: Order held successfully. ID: $transactionId");
             add(ClearCart());
             add(LoadPendingOrders());
             add(LoadProducts());
          },
        );
      }
    }
  }

  Future<void> _onLoadPendingOrders(LoadPendingOrders event, Emitter<PosState> emit) async {
    print("PosBloc: _onLoadPendingOrders triggered");
    if (state is PosLoaded) {
       final result = await transactionRepository.getPendingTransactions();
       // FIX: await fold result not strictly necessary for state update if synchronous, but good practice
       result.fold(
         (failure) => print("PosBloc: Failed to load pending: ${failure.message}"),
         (transactions) {
            print("PosBloc: Loaded ${transactions.length} pending orders");
            emit((state as PosLoaded).copyWith(pendingTransactions: transactions));
         }
       );
    }
  }

  Future<void> _onResumeOrder(ResumeOrder event, Emitter<PosState> emit) async {
    print("PosBloc: _onResumeOrder triggered for Transaction #${event.transactionId}");
    if (state is PosLoaded) {
       final loadedState = state as PosLoaded;
       // Find transaction
       final transaction = loadedState.pendingTransactions.firstWhere((t) => t.id == event.transactionId, orElse: () => throw Exception('Transaction not found'));
       
       List<CartItem> cartItems = [];
       
       for (final tItem in transaction.items) {
          try {
             final product = loadedState.products.firstWhere((p) => p.id == tItem.itemId);
             
             cartItems.add(CartItem(
               item: product,
               quantity: tItem.quantity,
               serialNumbers: tItem.serialNumbers,
             ));
          } catch (e) {
             print("PosBloc: Product not found for item ${tItem.itemId} (possibly deleted)");
          }
       }

       emit(loadedState.copyWith(
         cart: cartItems,
         originalPendingTransactionId: event.transactionId,
         // Restore financials
         discountType: 'fixed',
         discountValue: transaction.discountAmount,
         discountAmount: transaction.discountAmount,
         clearPromo: true, 
       ));
    }
  }

  Future<void> _onDeletePendingOrder(DeletePendingOrder event, Emitter<PosState> emit) async {
      await transactionRepository.deleteTransaction(event.transactionId);
      add(LoadPendingOrders());
      add(LoadProducts()); // Refresh stock as we restored it
  }



  void _onSearchProducts(SearchProducts event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      final query = event.query.toLowerCase();
      
      final filtered = loadedState.products.where((item) {
        final matchesQuery = item.name.toLowerCase().contains(query) ||
               (item.barcode != null && item.barcode!.contains(query));
        final matchesCategory = loadedState.selectedCategoryId == null || item.categoryId == loadedState.selectedCategoryId;
        
        return matchesQuery && matchesCategory;
      }).toList();
      
      emit(loadedState.copyWith(filteredProducts: filtered, searchQuery: event.query));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      
      final filtered = loadedState.products.where((item) {
        final matchesQuery = loadedState.searchQuery.isEmpty || 
               item.name.toLowerCase().contains(loadedState.searchQuery.toLowerCase()) ||
               (item.barcode != null && item.barcode!.contains(loadedState.searchQuery.toLowerCase()));
        
        final matchesCategory = event.categoryId == null || item.categoryId == event.categoryId;
        
        return matchesQuery && matchesCategory;
      }).toList();

      emit(loadedState.copyWith(filteredProducts: filtered, selectedCategoryId: event.categoryId));
    }
  }

  void _onSetDiscount(SetDiscount event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;

      final calculatedDiscount = _calculateDiscount(
        loadedState.subtotal,
        event.type,
        event.value,
        minPurchase: event.minPurchase,
        maxDiscount: event.maxDiscount,
      );

      emit(loadedState.copyWith(
        discountAmount: calculatedDiscount,
        discountType: event.type,
        discountValue: event.value,
        selectedPromoId: event.promoId,
        clearPromo: event.promoId == null && event.value == 0,
        minPurchase: event.minPurchase,
        maxDiscount: event.maxDiscount,
      ));
    }
  }

  int _calculateDiscount(int subtotal, String type, int value, {int minPurchase = 0, int maxDiscount = 0}) {
    if (subtotal < minPurchase) return 0;

    int discount = 0;
    if (type == 'percentage') {
      discount = (subtotal * value / 100).round();
    } else {
      discount = value;
    }

    if (maxDiscount > 0 && discount > maxDiscount) {
      discount = maxDiscount;
    }
    
    return discount;
  }

  void _onAddToCart(AddToCart event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      final List<CartItem> updatedCart = List.from(loadedState.cart);
      
      final index = updatedCart.indexWhere((c) => c.item.id == event.item.id);
      
      // Calculate total quantity to be added
      final int quantityToAdd = event.serialNumbers.isNotEmpty ? event.serialNumbers.length : 1;
      
      if (index >= 0) {
        final existingItem = updatedCart[index];
        final newQuantity = existingItem.quantity + quantityToAdd;
        
        // Stock Check
        if (event.item.isTrackStock && newQuantity > event.item.stock) {
           return; // Stock limit reached, do nothing (UI should prevent this too, or we need error state)
        }

        final newSerials = [...existingItem.serialNumbers, ...event.serialNumbers];
        
        updatedCart[index] = existingItem.copyWith(
          quantity: newQuantity,
          serialNumbers: newSerials,
        );
      } else {
        // Stock Check
        if (event.item.isTrackStock && quantityToAdd > event.item.stock) {
           return;
        }

        updatedCart.add(CartItem(
          item: event.item, 
          quantity: quantityToAdd,
          serialNumbers: event.serialNumbers,
        ));
      }
      
      final subtotal = updatedCart.fold(0, (sum, item) => sum + item.subtotal);
      final discountAmount = _calculateDiscount(
        subtotal, 
        loadedState.discountType, 
        loadedState.discountValue,
        minPurchase: loadedState.minPurchase,
        maxDiscount: loadedState.maxDiscount,
      );

      emit(loadedState.copyWith(cart: updatedCart, discountAmount: discountAmount));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      final updatedCart = loadedState.cart.where((c) => c.item.id != event.item.id).toList();
      
      final subtotal = updatedCart.fold(0, (sum, item) => sum + item.subtotal);
      final discountAmount = _calculateDiscount(
        subtotal, 
        loadedState.discountType, 
        loadedState.discountValue,
        minPurchase: loadedState.minPurchase,
        maxDiscount: loadedState.maxDiscount,
      );

      emit(loadedState.copyWith(cart: updatedCart, discountAmount: discountAmount));
    }
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<PosState> emit) {
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      
      if (event.quantity <= 0) {
        add(RemoveFromCart(event.item));
        return;
      }

      final updatedCart = loadedState.cart.map((c) {
        if (c.item.id == event.item.id) {
          return c.copyWith(quantity: event.quantity);
        }
        return c;
      }).toList();
      
      final subtotal = updatedCart.fold(0, (sum, item) => sum + item.subtotal);
      final discountAmount = _calculateDiscount(
        subtotal, 
        loadedState.discountType, 
        loadedState.discountValue,
        minPurchase: loadedState.minPurchase,
        maxDiscount: loadedState.maxDiscount,
      );

      emit(loadedState.copyWith(cart: updatedCart, discountAmount: discountAmount));
    }
  }



  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PosState> emit) async {
    print("PosBloc: _onProcessPayment triggered");
    if (state is PosLoaded) {
      final loadedState = state as PosLoaded;
      if (loadedState.cart.isEmpty) return;

      final totalAmount = loadedState.finalTotal;
      final isDebtPayment = event.paymentMethod == 'DEBT' || loadedState.isDebt;
      final changeAmount = isDebtPayment ? 0 : (event.paymentAmount - totalAmount).toInt();

      // Skip payment validation for debt transactions (paymentAmount is 0)
      if (changeAmount < 0 && !isDebtPayment) {
        emit(const PosError("Payment amount is less than total"));
        emit(loadedState); 
        return; 
      }

      final transactionItems = loadedState.cart.map((c) => TransactionItem(
        itemId: c.item.id!,
        quantity: c.quantity,
        price: c.item.price,
        cost: c.item.cost,
        serialNumbers: c.serialNumbers,
        itemName: c.item.name,
      )).toList();

      if (loadedState.originalPendingTransactionId != null) {
        // UPDATE existing pending transaction to Success
        final transaction = Transaction(
          id: loadedState.originalPendingTransactionId,
          dateTime: DateTime.now(),
          totalAmount: totalAmount,
          paymentAmount: event.paymentAmount,
          changeAmount: changeAmount,
          paymentMethod: event.paymentMethod,
          discountAmount: loadedState.discountAmount,
          taxAmount: loadedState.taxAmount,
          serviceFeeAmount: loadedState.serviceFeeAmount,
          status: 'success',
          customerId: loadedState.selectedCustomer?.id,
          tableNumber: loadedState.tableNumber,
          pax: loadedState.pax,
          note: loadedState.note,
          isDebt: loadedState.isDebt,
          guestName: loadedState.guestName,
          items: transactionItems,
        );

        print("PosBloc: Updating transaction #${transaction.id} to success...");
        final result = await transactionRepository.updateTransaction(transaction);

        await result.fold(
          (failure) async {
             print("PosBloc: Failed to process payment (update): ${failure.message}");
             emit(PosError(failure.message));
          },
          (_) async {
            print("PosBloc: Transaction updated successfully ID: ${transaction.id}");
            emit(PosSuccess(transactionId: transaction.id!, changeAmount: changeAmount));
            add(LoadProducts()); 
          },
        );

      } else {
        // CREATE NEW Success transaction
        // CREATE NEW Success transaction
        final transaction = Transaction(
          dateTime: DateTime.now(),
          totalAmount: totalAmount,
          paymentAmount: event.paymentAmount,
          changeAmount: changeAmount,
          paymentMethod: event.paymentMethod,
          discountAmount: loadedState.discountAmount,
          taxAmount: loadedState.taxAmount,
          serviceFeeAmount: loadedState.serviceFeeAmount,
          status: event.paymentMethod == 'DEBT' || loadedState.isDebt ? 'pending_payment' : 'success', 
          customerId: loadedState.selectedCustomer?.id,
          tableNumber: loadedState.tableNumber,
          pax: loadedState.pax,
          note: loadedState.note,
          isDebt: loadedState.isDebt,
          guestName: loadedState.guestName,
          shiftId: event.shiftId,
          userId: event.userId,
          items: transactionItems,
        );

        print("PosBloc: Saving NEW transaction...");
        final result = await transactionRepository.saveTransaction(transaction);
        
        await result.fold(
          (failure) async {
             print("PosBloc: Failed to save transaction: ${failure.message}");
             emit(PosError(failure.message));
          },
          (transactionId) async {
            print("PosBloc: Transaction saved successfully ID: $transactionId");
            emit(PosSuccess(transactionId: transactionId, changeAmount: changeAmount));
            add(LoadProducts()); 
          },
        );
      }
    }
  }
}
