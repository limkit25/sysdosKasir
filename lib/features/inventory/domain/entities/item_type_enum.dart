enum ItemType {
  single('Single', 'Standard item with stock'),
  service('Service', 'No stock tracking'),
  recipe('Recipe', 'Manufactured from ingredients'),
  bundle('Bundle', 'Group of items sold together'),
  imei('Serialized', 'Tracked by unique serial/IMEI'),
  variant('Variant', 'Product with variations (Size/Color)');

  final String label;
  final String description;
  const ItemType(this.label, this.description);
}
