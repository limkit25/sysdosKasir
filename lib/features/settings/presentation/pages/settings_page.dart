import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'profile_settings_page.dart';
import 'store_settings_page.dart';
import 'user_management_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 0),
                children: [
                  _buildProfileHeader(),
                  _buildSettingsGroup(
                    title: 'settings.general'.tr(),
                    items: [
                      _SettingsCardItem(
                        title: 'settings.profile'.tr(),
                        subtitle: 'settings.manage_profile'.tr(),
                        icon: Icons.person_outline_rounded,
                        color: Colors.blue,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSettingsPage())),
                      ),
                      _SettingsCardItem(
                        title: 'settings.store'.tr(),
                        subtitle: 'settings.store_info'.tr(),
                        icon: Icons.storefront_rounded,
                        color: Colors.orange,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreSettingsPage())),
                      ),
                      _SettingsCardItem(
                        title: 'settings.staff'.tr(),
                        subtitle: 'settings.manage_staff'.tr(),
                        icon: Icons.badge_outlined,
                        color: Colors.teal,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementPage())),
                      ),
                    ],
                  ),
                  _buildSettingsGroup(
                    title: 'settings.appearance'.tr(),
                    items: [
                      _buildDarkModeToggle(context),
                      _buildLanguageSelector(context),
                    ],
                  ),
                  _buildSettingsGroup(
                    title: 'settings.system'.tr(),
                    items: [
                      _SettingsCardItem(
                        title: 'settings.database'.tr(),
                        subtitle: 'settings.manage_database'.tr(),
                        icon: Icons.storage_rounded,
                        color: Colors.blueGrey,
                      ),
                      _SettingsCardItem(
                        title: 'settings.sync'.tr(),
                        subtitle: 'settings.sync_cloud'.tr(),
                        icon: Icons.cloud_sync_rounded,
                        color: Colors.indigo,
                      ),
                      _SettingsCardItem(
                        title: 'settings.printer'.tr(),
                        subtitle: 'settings.config_printer'.tr(),
                        icon: Icons.print_rounded,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildLogoutButton(context),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'settings.title'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'User';
        String role = 'Role';
        if (state is AuthAuthenticated) {
          name = state.user.name;
          role = state.user.role;
        }
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', 
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue, letterSpacing: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 16, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildDarkModeToggle(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: Colors.blue),
          ),
          title: Text('settings.dark_mode'.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: Switch(
            value: isDark,
            activeColor: Colors.blue,
            onChanged: (val) => context.read<ThemeCubit>().toggleTheme(val),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.translate_rounded, color: Colors.purple),
      ),
      title: const Text('Language / Bahasa', style: TextStyle(fontWeight: FontWeight.w600)),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: context.locale,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
          items: const [
            DropdownMenuItem(value: Locale('id', 'ID'), child: Text('Indonesia')),
            DropdownMenuItem(value: Locale('en', 'US'), child: Text('English')),
          ],
          onChanged: (Locale? newLocale) {
            if (newLocale != null) context.setLocale(newLocale);
          },
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => _showLogoutDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(
              'settings.logout'.tr(),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('settings.logout'.tr()),
        content: Text('settings.logout_confirm'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('settings.cancel'.tr())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('settings.logout'.tr()),
          ),
        ],
      ),
    );
  }
}

class _SettingsCardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SettingsCardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('settings.feature_coming_soon'.tr())));
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}

