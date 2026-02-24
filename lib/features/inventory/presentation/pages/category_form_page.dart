import 'package:flutter/material.dart';
import '../../../../core/widgets/max_width_container.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/category.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryFormPage extends StatefulWidget {
  final Category? category;
  const CategoryFormPage({super.key, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  final _bloc = getIt<CategoryBloc>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descController = TextEditingController(text: widget.category?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newCategory = Category(
        id: widget.category?.id,
        name: _nameController.text,
        description: _descController.text,
      );

      if (widget.category == null) {
        _bloc.add(AddCategoryEvent(newCategory));
      } else {
        _bloc.add(UpdateCategoryEvent(newCategory));
      }

      // Simple way: wait a bit or use BlocListener. 
      // Since we are taking a shortcut here by using a local bloc instance for the operation:
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'inventory.add_category'.tr() : 'inventory.edit_category'.tr()),
      ),
      body: MaxWidthContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'inventory.category_name'.tr()),
                  textInputAction: TextInputAction.next,
                  validator: (value) => value!.isEmpty ? 'sales.required'.tr() : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: 'inventory.description_optional'.tr()),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue, // Soft blue
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.category == null ? 'sales.create'.tr() : 'sales.update'.tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
