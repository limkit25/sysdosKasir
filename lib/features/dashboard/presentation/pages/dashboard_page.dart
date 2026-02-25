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
          backgroundColor: const Color(0xFFF2F3F8), // Soft grey background
          body: Stack(
            children: [
              mainBody(context),
              _buildAppBar(context),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 1.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 8, right: 8),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: AppBar().preferredSize.height + 40,
                  height: AppBar().preferredSize.height,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/splash.png'),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Sysdos POS',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppBar().preferredSize.height + 40,
                  height: AppBar().preferredSize.height,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget mainBody(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.only(
            top: AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top +
                24,
            bottom: 62 + MediaQuery.of(context).padding.bottom,
          ),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _buildUserInfoSection(),
            _buildTurnoverSection(state),
            _buildQuickActionsTitle(),
            _buildMenuGrid(context),
          ],
        );
      },
    );
  }

  Widget _buildUserInfoSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userName = 'User';
          String userRole = 'Role';
          if (state is AuthAuthenticated) {
            userName = state.user.name;
            userRole = state.user.role;
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'dashboard.welcome'.tr(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 0.2,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      userName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.27,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   boxShadow: [
                     BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                   ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : 'U', 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildTurnoverSection(DashboardState state) {
    if (state is DashboardLoading) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (state is DashboardLoaded) {
      final today = state.turnoverStats['today'] ?? 0;
      final thisMonth = state.turnoverStats['thisMonth'] ?? 0;
      
      return Column(
        children: [
           Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'dashboard.turnover_summary'.tr(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _TurnoverSummaryCard(
            todayAmount: today,
            monthlyAmount: thisMonth,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildQuickActionsTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
      child: Text(
        'dashboard.main_menu'.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 0.5,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ShiftBloc, ShiftState>(
        builder: (context, shiftState) {
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              _DashboardMenuCard(
                title: 'dashboard.pos_kasir'.tr(),
                icon: Icons.point_of_sale_rounded,
                color: Colors.blue,
                onTap: () => _handlePosNavigation(context, shiftState),
              ),
              _DashboardMenuCard(
                title: 'dashboard.management'.tr(),
                icon: Icons.inventory_2_rounded,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ManagementPage())).then((_) {
                    if (context.mounted) context.read<DashboardBloc>().add(LoadDashboardData());
                  });
                },
              ),
              _DashboardMenuCard(
                title: 'dashboard.reports'.tr(),
                icon: Icons.insert_chart_rounded,
                color: Colors.green,
                onTap: () {},
              ),
              _DashboardMenuCard(
                title: 'dashboard.shift_management'.tr(),
                icon: Icons.account_balance_wallet_rounded,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ShiftManagementPage()));
                },
              ),
              _DashboardMenuCard(
                title: 'dashboard.settings'.tr(),
                icon: Icons.settings_suggest_rounded,
                color: Colors.blueGrey,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _handlePosNavigation(BuildContext context, ShiftState shiftState) {
    final settingsState = context.read<SettingsCubit>().state;
    final isShiftEnabled = settingsState is SettingsLoaded ? settingsState.isShiftEnabled : true;
    
    if (!isShiftEnabled || shiftState is ShiftActive) {
      final shiftBloc = context.read<ShiftBloc>();
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: shiftBloc,
            child: const PosPage(),
          ),
        ),
      ).then((_) {
        if (context.mounted) context.read<DashboardBloc>().add(LoadDashboardData());
      });
    } else if (shiftState is ShiftNone) {
      _showOpenShiftDialog(context);
    } else if (shiftState is ShiftLoading) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('dashboard.checking_shift'.tr())));
    }
  }

  void _showOpenShiftDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('dashboard.shift_belum_dibuka'.tr()),
        content: Text('dashboard.harus_buka_shift'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('dashboard.batal'.tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OpenShiftPage())).then((opened) {
                if (opened == true && context.mounted) {
                  context.read<ShiftBloc>().add(CheckActiveShift());
                }
              });
            },
            child: Text('dashboard.buka_kasir_sekarang'.tr()),
          ),
        ],
      ),
    );
  }
}

class _TurnoverSummaryCard extends StatelessWidget {
  final int todayAmount;
  final int monthlyAmount;

  const _TurnoverSummaryCard({
    required this.todayAmount,
    required this.monthlyAmount,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                   Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 3),
                    child: Text(
                      'dashboard.today'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 2, bottom: 14),
                child: Text(
                  currency.format(todayAmount),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: -0.2,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F8),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: <Widget>[
                    _buildSubMetric(
                       'dashboard.this_month'.tr(), 
                       currency.format(monthlyAmount), 
                       Colors.green
                    ),
                    const SizedBox(width: 16),
                    _buildSubMetric(
                       'dashboard.target'.tr(), 
                       '85%', 
                       Colors.orange,
                       isProgress: true
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMetric(String title, String value, Color color, {bool isProgress = false}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: -0.2,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: <Widget>[
                Container(
                  height: 38,
                  width: 2,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      if (isProgress)
                        Container(
                          width: 60,
                          height: 4,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                             alignment: Alignment.centerLeft,
                             widthFactor: 0.85,
                             child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          )
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

