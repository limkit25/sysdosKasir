abstract class SettingsRepository {
  Future<void> setTaxRate(double rate);
  Future<double> getTaxRate();
  Future<void> setServiceFeeRate(double rate);
  Future<double> getServiceFeeRate();
  Future<void> setIsShiftEnabled(bool isEnabled);
  Future<bool> getIsShiftEnabled();
}
