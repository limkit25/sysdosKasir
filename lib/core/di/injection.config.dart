// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../config/theme/theme_cubit.dart' as _i223;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/debt/presentation/bloc/debt_bloc.dart' as _i893;
import '../../features/inventory/data/repositories/inventory_repository_impl.dart'
    as _i572;
import '../../features/inventory/data/repositories/purchasing_repository_impl.dart'
    as _i713;
import '../../features/inventory/domain/repositories/inventory_repository.dart'
    as _i422;
import '../../features/inventory/domain/repositories/purchasing_repository.dart'
    as _i286;
import '../../features/inventory/presentation/bloc/category/category_bloc.dart'
    as _i923;
import '../../features/inventory/presentation/bloc/item/item_bloc.dart'
    as _i886;
import '../../features/inventory/presentation/bloc/purchasing/purchasing_bloc.dart'
    as _i648;
import '../../features/inventory/presentation/bloc/stock/stock_bloc.dart'
    as _i932;
import '../../features/partners/data/repositories/partner_repository_impl.dart'
    as _i306;
import '../../features/partners/domain/repositories/partner_repository.dart'
    as _i678;
import '../../features/partners/presentation/bloc/customer/customer_bloc.dart'
    as _i440;
import '../../features/partners/presentation/bloc/supplier/supplier_bloc.dart'
    as _i654;
import '../../features/pos/data/repositories/transaction_repository_impl.dart'
    as _i772;
import '../../features/pos/domain/repositories/transaction_repository.dart'
    as _i732;
import '../../features/pos/presentation/bloc/pos_bloc.dart' as _i853;
import '../../features/sales/data/repositories/promo_repository_impl.dart'
    as _i147;
import '../../features/sales/domain/repositories/promo_repository.dart'
    as _i462;
import '../../features/sales/presentation/bloc/promo/promo_bloc.dart' as _i157;
import '../../features/settings/data/repositories/payment_method_repository_impl.dart'
    as _i249;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/payment_method_repository.dart'
    as _i710;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/presentation/bloc/payment_method/payment_method_bloc.dart'
    as _i858;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/shift/data/repositories/shift_repository_impl.dart'
    as _i139;
import '../../features/shift/domain/repositories/shift_repository.dart'
    as _i555;
import '../../features/shift/presentation/bloc/shift/shift_bloc.dart' as _i248;
import '../../features/vouchers/data/repositories/voucher_repository_impl.dart'
    as _i291;
import '../../features/vouchers/domain/repositories/voucher_repository.dart'
    as _i108;
import '../../features/vouchers/presentation/bloc/voucher_bloc.dart' as _i297;
import '../database/app_database.dart' as _i982;
import 'module.dart' as _i946;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i982.AppDatabase>(() => appModule.appDatabase);
    gh.factory<_i223.ThemeCubit>(
        () => _i223.ThemeCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i792.SettingsCubit>(
        () => _i792.SettingsCubit(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i555.ShiftRepository>(
        () => _i139.ShiftRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i678.PartnerRepository>(
        () => _i306.PartnerRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i674.SettingsRepository>(
        () => _i955.SettingsRepositoryImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i982.AppDatabase>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i108.VoucherRepository>(
        () => _i291.VoucherRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.factory<_i248.ShiftBloc>(
        () => _i248.ShiftBloc(gh<_i555.ShiftRepository>()));
    gh.lazySingleton<_i286.PurchasingRepository>(
        () => _i713.PurchasingRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i710.PaymentMethodRepository>(
        () => _i249.PaymentMethodRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.lazySingleton<_i732.TransactionRepository>(
        () => _i772.TransactionRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.factory<_i893.DebtBloc>(
        () => _i893.DebtBloc(gh<_i732.TransactionRepository>()));
    gh.lazySingleton<_i462.PromoRepository>(
        () => _i147.PromoRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.factory<_i648.PurchasingBloc>(
        () => _i648.PurchasingBloc(gh<_i286.PurchasingRepository>()));
    gh.lazySingleton<_i422.InventoryRepository>(
        () => _i572.InventoryRepositoryImpl(gh<_i982.AppDatabase>()));
    gh.factory<_i297.VoucherBloc>(
        () => _i297.VoucherBloc(gh<_i108.VoucherRepository>()));
    gh.factory<_i440.CustomerBloc>(
        () => _i440.CustomerBloc(gh<_i678.PartnerRepository>()));
    gh.factory<_i654.SupplierBloc>(
        () => _i654.SupplierBloc(gh<_i678.PartnerRepository>()));
    gh.factory<_i858.PaymentMethodBloc>(
        () => _i858.PaymentMethodBloc(gh<_i710.PaymentMethodRepository>()));
    gh.factory<_i923.CategoryBloc>(
        () => _i923.CategoryBloc(gh<_i422.InventoryRepository>()));
    gh.factory<_i886.ItemBloc>(
        () => _i886.ItemBloc(gh<_i422.InventoryRepository>()));
    gh.factory<_i932.StockBloc>(
        () => _i932.StockBloc(gh<_i422.InventoryRepository>()));
    gh.factory<_i853.PosBloc>(() => _i853.PosBloc(
          gh<_i422.InventoryRepository>(),
          gh<_i732.TransactionRepository>(),
          gh<_i674.SettingsRepository>(),
          gh<_i678.PartnerRepository>(),
          gh<_i710.PaymentMethodRepository>(),
          gh<_i108.VoucherRepository>(),
        ));
    gh.factory<_i157.PromoBloc>(
        () => _i157.PromoBloc(gh<_i462.PromoRepository>()));
    gh.factory<_i797.AuthBloc>(
        () => _i797.AuthBloc(gh<_i787.AuthRepository>()));
    gh.factory<_i652.DashboardBloc>(
        () => _i652.DashboardBloc(gh<_i732.TransactionRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$AppModule extends _i946.AppModule {}
