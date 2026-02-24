enum SortOption {
  nameAsc('Name (A-Z)'),
  nameDesc('Name (Z-A)'),
  priceLow('Price (Low-High)'),
  priceHigh('Price (High-Low)'),
  stockLow('Stock (Low-High)'),
  stockHigh('Stock (High-Low)'),
  newest('Newest First');

  final String label;
  const SortOption(this.label);
}
