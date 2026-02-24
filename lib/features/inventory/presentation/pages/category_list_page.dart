import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'category_form_page.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>()..add(const LoadCategories()),
      child: const CategoryListView(),
    );
  }
}

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<CategoryBloc>().add(LoadCategories(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2962FF)), // Blue back
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'inventory.categories'.tr(),
          style: const TextStyle(
            color: Color(0xFF2962FF), // Blue
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2962FF), // Blue
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryFormPage()),
          ).then((_) {
             if (context.mounted) context.read<CategoryBloc>().add(const LoadCategories());
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'inventory.search_categories'.tr(),
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
              const Divider(height: 1),

              // Category List
              Expanded(
                child: state is CategoryLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is CategoryLoaded
                        ? (state.categories.isEmpty
                            ? Center(child: Text('inventory.no_categories_found'.tr()))
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.categories.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey.shade300,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final category = state.categories[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    leading: const CircleAvatar(
                                      backgroundColor: Color(0xFFE3F2FD), // Light blue bg
                                      child: Icon(Icons.category, color: Color(0xFF2962FF)), // Blue icon
                                    ),
                                    title: Text(
                                      category.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    subtitle: Text(category.description ?? '-'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('inventory.delete_category'.tr()),
                                            content: Text('inventory.confirm_delete_category'.tr(args: [category.name])),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('sales.cancel'.tr()),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context.read<CategoryBloc>().add(DeleteCategoryEvent(category.id!));
                                                },
                                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                                child: Text('sales.delete'.tr()),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    onTap: () {
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryFormPage(category: category),
                                        ),
                                      ).then((_) {
                                         if (context.mounted) context.read<CategoryBloc>().add(const LoadCategories());
                                      });
                                    },
                                  );
                                },
                              ))
                        : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
