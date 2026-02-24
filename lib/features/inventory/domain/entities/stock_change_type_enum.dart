enum StockChangeType {
  sale('Sale', 'Deducted from POS transaction'),
  purchase('Purchase', 'Added from Supplier'),
  adjustment('Adjustment', 'Manual correction'),
  opname('Opname', 'Stock taking reconciliation'),
  initial('Initial', 'Initial stock setup'),
  refund('Refund', 'Item returned by customer'),
  recipe('Production', 'Deducted as ingredient');

  final String label;
  final String description;
  const StockChangeType(this.label, this.description);
}
