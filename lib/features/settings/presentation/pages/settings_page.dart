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
      appBar: AppBar(
        title: Text('settings.title'.tr()),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
             Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: ListView(
          children: [
            _buildSettingsItem(
              context, 
              'settings.profile'.tr(), 
              'settings.manage_profile'.tr(), 
              Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
                );
              },
            ),
            _buildSettingsItem(
              context, 
              'settings.store'.tr(), 
              'settings.store_info'.tr(), 
              Icons.store,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StoreSettingsPage()),
                );
              },
            ),
            _buildSettingsItem(context, 'settings.database'.tr(), 'settings.manage_database'.tr(), Icons.storage),
            _buildSettingsItem(context, 'settings.sync'.tr(), 'settings.sync_cloud'.tr(), Icons.sync),
            _buildSettingsItem(context, 'settings.printer'.tr(), 'settings.config_printer'.tr(), Icons.print),
            _buildSettingsItem(
              context, 
              'settings.staff'.tr(), 
              'settings.manage_staff'.tr(), 
              Icons.badge,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserManagementPage()),
                );
              },
            ),


            const Divider(),
            _buildSectionHeader(context, 'settings.appearance'.tr()),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark = mode == ThemeMode.dark;
                return SwitchListTile(
                  secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.blue),
                  title: Text('settings.dark_mode'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(isDark ? 'settings.dark_theme_desc'.tr() : 'settings.light_theme_desc'.tr()),
                  value: isDark,
                  onChanged: (val) {
                    context.read<ThemeCubit>().toggleTheme(val);
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text('Language / Bahasa', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: DropdownButton<Locale>(
                value: context.locale,
                items: const [
                  DropdownMenuItem(value: Locale('id', 'ID'), child: Text('Indonesia')),
                  DropdownMenuItem(value: Locale('en', 'US'), child: Text('English')),
                ],
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    context.setLocale(newLocale);
                  }
                },
              ),
            ),
            
            const Divider(),
            _buildSectionHeader(context, 'settings.other'.tr()),
            
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.orange),
              title: Text('settings.reset_data'.tr()),
              subtitle: Text('settings.clear_data'.tr()),
              onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('settings.feature_coming_soon'.tr())),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('settings.logout'.tr()),
              onTap: () {
                _showLogoutDialog(context);
              },
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
        title: Text('settings.logout'.tr()),
        content: Text('settings.logout_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('settings.cancel'.tr())
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            }, 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('settings.logout'.tr())
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon,
    {VoidCallback? onTap}
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('settings.feature_coming_soon'.tr())),
        );
      },
    );
  }
}
