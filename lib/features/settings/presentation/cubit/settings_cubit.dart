import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  SettingsCubit(this._prefs) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final storeSettings = {
        'name': _prefs.getString('store_name') ?? 'My Store',
        'address': _prefs.getString('store_address') ?? '',
        'phone': _prefs.getString('store_phone') ?? '',
        'email': _prefs.getString('store_email') ?? '',
        'website': _prefs.getString('store_website') ?? '',
        'logo_path': _prefs.getString('store_logo_path') ?? '',
        'footer': _prefs.getString('store_footer') ?? '',
      };

      final profileSettings = {
        'name': _prefs.getString('user_name') ?? 'Admin',
        'email': _prefs.getString('user_email') ?? 'admin@sysdos.com',
        'role': _prefs.getString('user_role') ?? 'Administrator',
        'profile_path': _prefs.getString('user_profile_path') ?? '',
      };

      final bool isShiftEnabled = _prefs.getBool('is_shift_enabled') ?? true;

      emit(SettingsLoaded(
        storeSettings: storeSettings,
        profileSettings: profileSettings,
        isShiftEnabled: isShiftEnabled,
      ));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateStoreSettings(Map<String, String> newSettings) async {
    try {
      if (state is SettingsLoaded) {
        final currentProfile = (state as SettingsLoaded).profileSettings;
        
        await _prefs.setString('store_name', newSettings['name'] ?? '');
        await _prefs.setString('store_address', newSettings['address'] ?? '');
        await _prefs.setString('store_phone', newSettings['phone'] ?? '');
        await _prefs.setString('store_email', newSettings['email'] ?? '');
        await _prefs.setString('store_website', newSettings['website'] ?? '');
        await _prefs.setString('store_logo_path', newSettings['logo_path'] ?? '');
        await _prefs.setString('store_footer', newSettings['footer'] ?? '');

        emit(SettingsLoaded(
          storeSettings: newSettings,
          profileSettings: currentProfile,
          isShiftEnabled: (state as SettingsLoaded).isShiftEnabled,
        ));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
      loadSettings(); // Reload on error
    }
  }

  Future<void> updateProfileSettings(Map<String, String> newSettings) async {
    try {
       if (state is SettingsLoaded) {
        final currentStore = (state as SettingsLoaded).storeSettings;

        await _prefs.setString('user_name', newSettings['name'] ?? '');
        await _prefs.setString('user_email', newSettings['email'] ?? '');
        await _prefs.setString('user_profile_path', newSettings['profile_path'] ?? '');
        
        emit(SettingsLoaded(
          storeSettings: currentStore,
          profileSettings: newSettings,
          isShiftEnabled: (state as SettingsLoaded).isShiftEnabled,
        ));
       }
    } catch (e) {
      emit(SettingsError(e.toString()));
      loadSettings();
    }
  }
  Future<void> toggleShiftEnabled(bool isEnabled) async {
    try {
      if (state is SettingsLoaded) {
        final currentStore = (state as SettingsLoaded).storeSettings;
        final currentProfile = (state as SettingsLoaded).profileSettings;

        await _prefs.setBool('is_shift_enabled', isEnabled);
        
        emit(SettingsLoaded(
          storeSettings: currentStore,
          profileSettings: currentProfile,
          isShiftEnabled: isEnabled,
        ));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
      loadSettings();
    }
  }
}
