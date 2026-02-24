import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  static const String _keyTaxRate = 'tax_rate';
  static const String _keyServiceFeeRate = 'service_fee_rate';
  static const String _keyIsShiftEnabled = 'is_shift_enabled';

  @override
  Future<double> getTaxRate() async {
    return _prefs.getDouble(_keyTaxRate) ?? 0.0;
  }

  @override
  Future<double> getServiceFeeRate() async {
    return _prefs.getDouble(_keyServiceFeeRate) ?? 0.0;
  }

  @override
  Future<void> setTaxRate(double rate) async {
    await _prefs.setDouble(_keyTaxRate, rate);
  }

  @override
  Future<void> setServiceFeeRate(double rate) async {
    await _prefs.setDouble(_keyServiceFeeRate, rate);
  }

  @override
  Future<bool> getIsShiftEnabled() async {
    return _prefs.getBool(_keyIsShiftEnabled) ?? true; // Default to true
  }

  @override
  Future<void> setIsShiftEnabled(bool isEnabled) async {
    await _prefs.setBool(_keyIsShiftEnabled, isEnabled);
  }
}
