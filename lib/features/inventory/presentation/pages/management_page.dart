import 'package:flutter/material.dart';
import 'category_list_page.dart';
import 'item_list_page.dart';
import 'stock_management_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../features/partners/presentation/pages/customer_list_page.dart';
import '../../../../features/partners/presentation/pages/supplier_list_page.dart';
import 'purchase_list_page.dart';
import '../../../sales/presentation/pages/promo_list_page.dart';
import '../../../settings/presentation/pages/tax_fees_page.dart';
import '../../../../features/debt/presentation/pages/debt_page.dart';
import '../../../settings/presentation/pages/payment_method_list_page.dart';
import '../../../vouchers/presentation/pages/voucher_management_page.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  _buildCategoryFilter(),
                  _buildMenuSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
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
                'inventory.management'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 48), // Spacer for balance
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Search features...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'inventory.master_data'.tr(), 'inventory.inventory_control'.tr(), 'inventory.partners'.tr(), 'inventory.commerce'.tr()];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = cat),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'category': 'inventory.master_data'.tr(),
        'title': 'inventory.categories'.tr(),
        'desc': 'inventory.categories_desc'.tr(),
        'icon': Icons.category_rounded,
        'color': Colors.orange,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryListPage())),
      },
      {
        'category': 'inventory.master_data'.tr(),
        'title': 'inventory.items'.tr(),
        'desc': 'inventory.items_desc'.tr(),
        'icon': Icons.inventory_2_rounded,
        'color': Colors.blue,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemListPage())),
      },
      {
        'category': 'inventory.inventory_control'.tr(),
        'title': 'inventory.stock_management'.tr(),
        'desc': 'inventory.stock_management_desc'.tr(),
        'icon': Icons.swap_vert_rounded,
        'color': Colors.blueGrey,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockManagementPage())),
      },
      {
        'category': 'inventory.inventory_control'.tr(),
        'title': 'inventory.stock_opname'.tr(),
        'desc': 'inventory.stock_opname_desc'.tr(),
        'icon': Icons.assignment_turned_in_rounded,
        'color': Colors.indigo,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockManagementPage(isOpname: true))),
      },
      {
        'category': 'inventory.partners'.tr(),
        'title': 'inventory.customers'.tr(),
        'desc': 'inventory.customers_desc'.tr(),
        'icon': Icons.supervisor_account_rounded,
        'color': Colors.purple,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerListPage())),
      },
      {
        'category': 'inventory.partners'.tr(),
        'title': 'inventory.suppliers'.tr(),
        'desc': 'inventory.suppliers_desc'.tr(),
        'icon': Icons.local_shipping_rounded,
        'color': Colors.deepPurple,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupplierListPage())),
      },
      {
        'category': 'inventory.commerce'.tr(),
        'title': 'inventory.purchasing'.tr(),
        'desc': 'inventory.purchasing_desc'.tr(),
        'icon': Icons.shopping_basket_rounded,
        'color': Colors.brown,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PurchaseListPage())),
      },
      {
        'category': 'inventory.commerce'.tr(),
        'title': 'inventory.debts'.tr(),
        'desc': 'inventory.debts_desc'.tr(),
        'icon': Icons.account_balance_wallet_rounded,
        'color': Colors.red,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DebtPage())),
      },
      {
        'category': 'inventory.commerce'.tr(),
        'title': 'inventory.discounts'.tr(),
        'desc': 'inventory.discounts_desc'.tr(),
        'icon': Icons.loyalty_rounded,
        'color': Colors.teal,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoListPage())),
      },
      {
        'category': 'inventory.commerce'.tr(),
        'title': 'inventory.tax_fees'.tr(),
        'desc': 'inventory.tax_fees_desc'.tr(),
        'icon': Icons.receipt_long_rounded,
        'color': Colors.teal,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxFeesPage())),
      },
      {
        'category': 'inventory.commerce'.tr(),
        'title': 'inventory.payment_methods'.tr(),
        'desc': 'inventory.payment_methods_desc'.tr(),
        'icon': Icons.payments_rounded,
        'color': Colors.green,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodListPage())),
      },
      {
        'category': 'inventory.commerce'.tr(),
        'title': 'inventory.voucher_management'.tr(),
        'desc': 'inventory.voucher_management_desc'.tr(),
        'icon': Icons.card_membership_rounded,
        'color': Colors.pink,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoucherManagementPage())),
      },
    ];

    final filteredItems = menuItems.where((item) {
      final matchesSearch = item['title'].toString().toLowerCase().contains(_searchQuery) ||
                            item['desc'].toString().toLowerCase().contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'All' || item['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    if (filteredItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('No management features found.', style: TextStyle(color: Colors.grey))),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildModernMenuCard(item);
      },
    );
  }

  Widget _buildModernMenuCard(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item['onTap'],
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item['icon'], color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'],
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

