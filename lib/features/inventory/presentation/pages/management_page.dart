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

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'inventory.management'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'inventory.master_data'.tr()),
          _buildMenuItem(
            context,
            'inventory.categories'.tr(),
            'inventory.categories_desc'.tr(),
            Icons.category,
            Colors.orange,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryListPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.items'.tr(),
            'inventory.items_desc'.tr(),
            Icons.inventory,
            Colors.blue,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemListPage())),
          ),
          
          _buildSectionHeader(context, 'inventory.inventory_control'.tr()),
          _buildMenuItem(
            context,
            'inventory.stock_management'.tr(),
            'inventory.stock_management_desc'.tr(),
            Icons.compare_arrows,
            Colors.blueGrey,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StockManagementPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.stock_opname'.tr(),
            'inventory.stock_opname_desc'.tr(),
            Icons.fact_check,
            Colors.blueGrey,
            () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const StockManagementPage(isOpname: true)));
            },
          ),

          _buildSectionHeader(context, 'inventory.partners'.tr()),
          _buildMenuItem(
            context,
            'inventory.customers'.tr(),
            'inventory.customers_desc'.tr(),
            Icons.people,
            Colors.purple,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.suppliers'.tr(),
            'inventory.suppliers_desc'.tr(),
            Icons.local_shipping,
            Colors.purple,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierListPage())),
          ),

          _buildSectionHeader(context, 'inventory.commerce'.tr()),
          _buildMenuItem(
            context,
            'inventory.purchasing'.tr(),
            'inventory.purchasing_desc'.tr(),
            Icons.shopping_cart,
            Colors.brown,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseListPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.debts'.tr(),
            'inventory.debts_desc'.tr(),
            Icons.credit_card_off,
            Colors.red,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DebtPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.discounts'.tr(),
            'inventory.discounts_desc'.tr(),
            Icons.discount,
            Colors.teal,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PromoListPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.tax_fees'.tr(),
            'inventory.tax_fees_desc'.tr(),
            Icons.account_balance,
            Colors.teal,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxFeesPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.payment_methods'.tr(),
            'inventory.payment_methods_desc'.tr(),
            Icons.payment,
            Colors.green,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodListPage())),
          ),
          _buildMenuItem(
            context,
            'inventory.voucher_management'.tr(),
            'inventory.voucher_management_desc'.tr(),
            Icons.card_giftcard,
            Colors.pink,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VoucherManagementPage())),
          ),

          const SizedBox(height: 20),
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

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 70),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('inventory.feature_coming_soon'.tr())),
    );
  }
}
