import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../inventory/presentation/pages/management_page.dart';
import '../../../../features/pos/presentation/pages/pos_page.dart';
import '../../../../features/settings/presentation/pages/settings_page.dart';
import '../../../../features/shift/presentation/bloc/shift/shift_bloc.dart';
import '../../../../features/shift/presentation/pages/shift_management_page.dart';
import '../../../../features/shift/presentation/pages/open_shift_page.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../features/settings/presentation/cubit/settings_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime? currentBackPressTime;
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DashboardBloc>()..add(LoadDashboardData())),
        BlocProvider(create: (context) => getIt<ShiftBloc>()..add(CheckActiveShift())),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          final now = DateTime.now();
          if (currentBackPressTime == null || 
              now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
            currentBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('dashboard.exit_warning'.tr()),
                duration: const Duration(seconds: 2),
              ),
            );
            return;
          }
          
          SystemNavigator.pop();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/splash.png',
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'dashboard.welcome'.tr()}, ${state.user.name}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              state.user.role,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    
                    // Turnover Slides
                    SizedBox(
                      height: 140,
                      child: BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          if (state is DashboardLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is DashboardLoaded) {
                            return PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              children: [
                                _TurnoverCard(
                                  title: 'Hari Ini',
                                  amount: state.turnoverStats['today'] ?? 0,
                                  color: Colors.blue,
                                  icon: Icons.today,
                                ),
                                _TurnoverCard(
                                  title: 'Bulan Ini',
                                  amount: state.turnoverStats['thisMonth'] ?? 0,
                                  color: Colors.green,
                                  icon: Icons.calendar_month,
                                ),
                                _TurnoverCard(
                                  title: 'Bulan Lalu',
                                  amount: state.turnoverStats['lastMonth'] ?? 0,
                                  color: Colors.orange,
                                  icon: Icons.history,
                                ),
                              ],
                            );
                          } else if (state is DashboardError) {
                            return Center(child: Text('Error: ${state.message}'));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 12.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index ? Colors.blue : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'dashboard.main_menu'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              
              // Grid Menu
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    // Use a safe width if constraints are weird, but usually infinite in sliver cross axis?
                    // Actually SliverLayoutBuilder constraints gives scrolling axis info. 
                    // Cross axis logic needs BoxConstraints from LayoutBuilder usually.
                    // But here we can just perform logic based on MediaQuery or LayoutBuilder up top?
                     // A safe default for SliverGrid.
                     
                     // We can use SliverGrid.count directly.
                     return SliverGrid.count(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          BlocConsumer<ShiftBloc, ShiftState>(
                            listener: (context, shiftState) {
                              if (shiftState is ShiftError) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(shiftState.message)));
                              }
                            },
                            builder: (context, shiftState) {
                              return _DashboardMenuCard(
                                title: 'dashboard.pos_kasir'.tr(),
                                icon: Icons.point_of_sale,
                                color: Colors.blue,
                                onTap: () {
                                  // Check settings state
                                  final settingsState = context.read<SettingsCubit>().state;
                                  final isShiftEnabled = settingsState is SettingsLoaded ? settingsState.isShiftEnabled : true; // Default to true if not loaded
                                  
                                  if (!isShiftEnabled || shiftState is ShiftActive) {
                                    // Shift is active OR Shift requirement disabled, go to POS
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PosPage())).then((_) {
                                      if (context.mounted) {
                                        context.read<DashboardBloc>().add(LoadDashboardData());
                                      }
                                    });
                                  } else if (shiftState is ShiftNone) {
                                    // No active shift, ask to open shift
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => AlertDialog(
                                        title: Text('dashboard.shift_belum_dibuka'.tr()),
                                        content: Text('dashboard.harus_buka_shift'.tr()),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('dashboard.batal'.tr())),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext); // Close dialog
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => const OpenShiftPage())).then((opened) {
                                                if (opened == true && context.mounted) {
                                                  // Shift opened successfully, refresh shift state
                                                  context.read<ShiftBloc>().add(CheckActiveShift());
                                                }
                                              });
                                            },
                                            child: Text('dashboard.buka_kasir_sekarang'.tr()),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (shiftState is ShiftLoading) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memeriksa status shift...')));
                                  }
                                },
                              );
                            },
                          ),
                          _DashboardMenuCard(
                            title: 'dashboard.management'.tr(),
                            icon: Icons.inventory_2,
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ManagementPage()),
                              ).then((_) {
                                if (context.mounted) {
                                  context.read<DashboardBloc>().add(LoadDashboardData());
                                }
                              });
                            },
                          ),
                          _DashboardMenuCard(
                            title: 'dashboard.reports'.tr(),
                            icon: Icons.bar_chart,
                            color: Colors.green,
                            onTap: () {},
                          ),
                          _DashboardMenuCard(
                            title: 'dashboard.settings'.tr(),
                            icon: Icons.settings,
                            color: Colors.grey,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SettingsPage()),
                              );
                            },
                          ),
                          _DashboardMenuCard(
                            title: 'dashboard.shift_management'.tr(),
                            icon: Icons.account_balance_wallet,
                            color: Colors.teal,
                            onTap: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ShiftManagementPage()),
                              );
                            },
                          ),
                        ],
                     );
                  }
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)), 
            ],
          ),
        ),
      ),
    );
  }
}

class _TurnoverCard extends StatelessWidget {
  final String title;
  final int amount;
  final Color color;
  final IconData icon;

  const _TurnoverCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currency.format(amount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardMenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
