import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/debt/presentation/bloc/debt_bloc.dart';
import '../../features/settings/presentation/bloc/payment_method/payment_method_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
  // Manual registration for SettingsCubit since we can't run build_runner easily in this environment
  if (!getIt.isRegistered<SettingsCubit>()) {
     getIt.registerFactory(() => SettingsCubit(getIt()));
  }
  if (!getIt.isRegistered<DebtBloc>()) {
     getIt.registerFactory(() => DebtBloc(getIt())); 
  }
  if (!getIt.isRegistered<PaymentMethodBloc>()) {
     getIt.registerFactory(() => PaymentMethodBloc(getIt())); 
  }
}
