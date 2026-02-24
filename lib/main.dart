import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'config/theme/theme_cubit.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('id', 'ID'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus())),
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
        BlocProvider(create: (context) => getIt<SettingsCubit>()..loadSettings()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            title: 'sysdosKasir',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return const DashboardPage();
                }
                return const LoginPage();
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
