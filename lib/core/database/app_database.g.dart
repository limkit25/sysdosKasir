// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String? description;
  const Category({required this.id, required this.name, this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String?>? description}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
      'price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
      'cost', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
      'stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isTrackStockMeta =
      const VerificationMeta('isTrackStock');
  @override
  late final GeneratedColumn<bool> isTrackStock = GeneratedColumn<bool>(
      'is_track_stock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_track_stock" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isVisibleMeta =
      const VerificationMeta('isVisible');
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
      'is_visible', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_visible" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
      'discount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'item_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SINGLE'));
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _purchaseUnitMeta =
      const VerificationMeta('purchaseUnit');
  @override
  late final GeneratedColumn<String> purchaseUnit = GeneratedColumn<String>(
      'purchase_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conversionFactorMeta =
      const VerificationMeta('conversionFactor');
  @override
  late final GeneratedColumn<int> conversionFactor = GeneratedColumn<int>(
      'conversion_factor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        name,
        barcode,
        price,
        cost,
        stock,
        isTrackStock,
        imagePath,
        isVisible,
        discount,
        itemType,
        parentId,
        weight,
        unit,
        purchaseUnit,
        conversionFactor
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    }
    if (data.containsKey('is_track_stock')) {
      context.handle(
          _isTrackStockMeta,
          isTrackStock.isAcceptableOrUnknown(
              data['is_track_stock']!, _isTrackStockMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_visible')) {
      context.handle(_isVisibleMeta,
          isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta));
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('item_type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('purchase_unit')) {
      context.handle(
          _purchaseUnitMeta,
          purchaseUnit.isAcceptableOrUnknown(
              data['purchase_unit']!, _purchaseUnitMeta));
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
          _conversionFactorMeta,
          conversionFactor.isAcceptableOrUnknown(
              data['conversion_factor']!, _conversionFactorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost'])!,
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock'])!,
      isTrackStock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_track_stock'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isVisible: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_visible'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_type'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      purchaseUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_unit']),
      conversionFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}conversion_factor'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final int categoryId;
  final String name;
  final String? barcode;
  final int price;
  final int cost;
  final int stock;
  final bool isTrackStock;
  final String? imagePath;
  final bool isVisible;
  final int discount;
  final String itemType;
  final int? parentId;
  final int weight;
  final String unit;
  final String? purchaseUnit;
  final int conversionFactor;
  const Item(
      {required this.id,
      required this.categoryId,
      required this.name,
      this.barcode,
      required this.price,
      required this.cost,
      required this.stock,
      required this.isTrackStock,
      this.imagePath,
      required this.isVisible,
      required this.discount,
      required this.itemType,
      this.parentId,
      required this.weight,
      required this.unit,
      this.purchaseUnit,
      required this.conversionFactor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['price'] = Variable<int>(price);
    map['cost'] = Variable<int>(cost);
    map['stock'] = Variable<int>(stock);
    map['is_track_stock'] = Variable<bool>(isTrackStock);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_visible'] = Variable<bool>(isVisible);
    map['discount'] = Variable<int>(discount);
    map['item_type'] = Variable<String>(itemType);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['weight'] = Variable<int>(weight);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || purchaseUnit != null) {
      map['purchase_unit'] = Variable<String>(purchaseUnit);
    }
    map['conversion_factor'] = Variable<int>(conversionFactor);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      price: Value(price),
      cost: Value(cost),
      stock: Value(stock),
      isTrackStock: Value(isTrackStock),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isVisible: Value(isVisible),
      discount: Value(discount),
      itemType: Value(itemType),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      weight: Value(weight),
      unit: Value(unit),
      purchaseUnit: purchaseUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseUnit),
      conversionFactor: Value(conversionFactor),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      price: serializer.fromJson<int>(json['price']),
      cost: serializer.fromJson<int>(json['cost']),
      stock: serializer.fromJson<int>(json['stock']),
      isTrackStock: serializer.fromJson<bool>(json['isTrackStock']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      discount: serializer.fromJson<int>(json['discount']),
      itemType: serializer.fromJson<String>(json['itemType']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      weight: serializer.fromJson<int>(json['weight']),
      unit: serializer.fromJson<String>(json['unit']),
      purchaseUnit: serializer.fromJson<String?>(json['purchaseUnit']),
      conversionFactor: serializer.fromJson<int>(json['conversionFactor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'price': serializer.toJson<int>(price),
      'cost': serializer.toJson<int>(cost),
      'stock': serializer.toJson<int>(stock),
      'isTrackStock': serializer.toJson<bool>(isTrackStock),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isVisible': serializer.toJson<bool>(isVisible),
      'discount': serializer.toJson<int>(discount),
      'itemType': serializer.toJson<String>(itemType),
      'parentId': serializer.toJson<int?>(parentId),
      'weight': serializer.toJson<int>(weight),
      'unit': serializer.toJson<String>(unit),
      'purchaseUnit': serializer.toJson<String?>(purchaseUnit),
      'conversionFactor': serializer.toJson<int>(conversionFactor),
    };
  }

  Item copyWith(
          {int? id,
          int? categoryId,
          String? name,
          Value<String?> barcode = const Value.absent(),
          int? price,
          int? cost,
          int? stock,
          bool? isTrackStock,
          Value<String?> imagePath = const Value.absent(),
          bool? isVisible,
          int? discount,
          String? itemType,
          Value<int?> parentId = const Value.absent(),
          int? weight,
          String? unit,
          Value<String?> purchaseUnit = const Value.absent(),
          int? conversionFactor}) =>
      Item(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        barcode: barcode.present ? barcode.value : this.barcode,
        price: price ?? this.price,
        cost: cost ?? this.cost,
        stock: stock ?? this.stock,
        isTrackStock: isTrackStock ?? this.isTrackStock,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isVisible: isVisible ?? this.isVisible,
        discount: discount ?? this.discount,
        itemType: itemType ?? this.itemType,
        parentId: parentId.present ? parentId.value : this.parentId,
        weight: weight ?? this.weight,
        unit: unit ?? this.unit,
        purchaseUnit:
            purchaseUnit.present ? purchaseUnit.value : this.purchaseUnit,
        conversionFactor: conversionFactor ?? this.conversionFactor,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      price: data.price.present ? data.price.value : this.price,
      cost: data.cost.present ? data.cost.value : this.cost,
      stock: data.stock.present ? data.stock.value : this.stock,
      isTrackStock: data.isTrackStock.present
          ? data.isTrackStock.value
          : this.isTrackStock,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      discount: data.discount.present ? data.discount.value : this.discount,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      weight: data.weight.present ? data.weight.value : this.weight,
      unit: data.unit.present ? data.unit.value : this.unit,
      purchaseUnit: data.purchaseUnit.present
          ? data.purchaseUnit.value
          : this.purchaseUnit,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('stock: $stock, ')
          ..write('isTrackStock: $isTrackStock, ')
          ..write('imagePath: $imagePath, ')
          ..write('isVisible: $isVisible, ')
          ..write('discount: $discount, ')
          ..write('itemType: $itemType, ')
          ..write('parentId: $parentId, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit, ')
          ..write('purchaseUnit: $purchaseUnit, ')
          ..write('conversionFactor: $conversionFactor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      categoryId,
      name,
      barcode,
      price,
      cost,
      stock,
      isTrackStock,
      imagePath,
      isVisible,
      discount,
      itemType,
      parentId,
      weight,
      unit,
      purchaseUnit,
      conversionFactor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.price == this.price &&
          other.cost == this.cost &&
          other.stock == this.stock &&
          other.isTrackStock == this.isTrackStock &&
          other.imagePath == this.imagePath &&
          other.isVisible == this.isVisible &&
          other.discount == this.discount &&
          other.itemType == this.itemType &&
          other.parentId == this.parentId &&
          other.weight == this.weight &&
          other.unit == this.unit &&
          other.purchaseUnit == this.purchaseUnit &&
          other.conversionFactor == this.conversionFactor);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<int> price;
  final Value<int> cost;
  final Value<int> stock;
  final Value<bool> isTrackStock;
  final Value<String?> imagePath;
  final Value<bool> isVisible;
  final Value<int> discount;
  final Value<String> itemType;
  final Value<int?> parentId;
  final Value<int> weight;
  final Value<String> unit;
  final Value<String?> purchaseUnit;
  final Value<int> conversionFactor;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
    this.stock = const Value.absent(),
    this.isTrackStock = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.discount = const Value.absent(),
    this.itemType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.weight = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchaseUnit = const Value.absent(),
    this.conversionFactor = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.barcode = const Value.absent(),
    required int price,
    required int cost,
    this.stock = const Value.absent(),
    this.isTrackStock = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.discount = const Value.absent(),
    this.itemType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.weight = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchaseUnit = const Value.absent(),
    this.conversionFactor = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name),
        price = Value(price),
        cost = Value(cost);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<int>? price,
    Expression<int>? cost,
    Expression<int>? stock,
    Expression<bool>? isTrackStock,
    Expression<String>? imagePath,
    Expression<bool>? isVisible,
    Expression<int>? discount,
    Expression<String>? itemType,
    Expression<int>? parentId,
    Expression<int>? weight,
    Expression<String>? unit,
    Expression<String>? purchaseUnit,
    Expression<int>? conversionFactor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (price != null) 'price': price,
      if (cost != null) 'cost': cost,
      if (stock != null) 'stock': stock,
      if (isTrackStock != null) 'is_track_stock': isTrackStock,
      if (imagePath != null) 'image_path': imagePath,
      if (isVisible != null) 'is_visible': isVisible,
      if (discount != null) 'discount': discount,
      if (itemType != null) 'item_type': itemType,
      if (parentId != null) 'parent_id': parentId,
      if (weight != null) 'weight': weight,
      if (unit != null) 'unit': unit,
      if (purchaseUnit != null) 'purchase_unit': purchaseUnit,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
    });
  }

  ItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<String?>? barcode,
      Value<int>? price,
      Value<int>? cost,
      Value<int>? stock,
      Value<bool>? isTrackStock,
      Value<String?>? imagePath,
      Value<bool>? isVisible,
      Value<int>? discount,
      Value<String>? itemType,
      Value<int?>? parentId,
      Value<int>? weight,
      Value<String>? unit,
      Value<String?>? purchaseUnit,
      Value<int>? conversionFactor}) {
    return ItemsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      stock: stock ?? this.stock,
      isTrackStock: isTrackStock ?? this.isTrackStock,
      imagePath: imagePath ?? this.imagePath,
      isVisible: isVisible ?? this.isVisible,
      discount: discount ?? this.discount,
      itemType: itemType ?? this.itemType,
      parentId: parentId ?? this.parentId,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      conversionFactor: conversionFactor ?? this.conversionFactor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (isTrackStock.present) {
      map['is_track_stock'] = Variable<bool>(isTrackStock.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (purchaseUnit.present) {
      map['purchase_unit'] = Variable<String>(purchaseUnit.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<int>(conversionFactor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('stock: $stock, ')
          ..write('isTrackStock: $isTrackStock, ')
          ..write('imagePath: $imagePath, ')
          ..write('isVisible: $isVisible, ')
          ..write('discount: $discount, ')
          ..write('itemType: $itemType, ')
          ..write('parentId: $parentId, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit, ')
          ..write('purchaseUnit: $purchaseUnit, ')
          ..write('conversionFactor: $conversionFactor')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, email, address];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  const Customer(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent()}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, address);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cashier'));
  static const VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String> pin = GeneratedColumn<String>(
      'pin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, password, role, pin, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('pin')) {
      context.handle(
          _pinMeta, pin.isAcceptableOrUnknown(data['pin']!, _pinMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      pin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? pin;
  final bool isActive;
  final DateTime createdAt;
  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      this.pin,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || pin != null) {
      map['pin'] = Variable<String>(pin);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      password: Value(password),
      role: Value(role),
      pin: pin == null && nullToAbsent ? const Value.absent() : Value(pin),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      pin: serializer.fromJson<String?>(json['pin']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'pin': serializer.toJson<String?>(pin),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          String? email,
          String? password,
          String? role,
          Value<String?> pin = const Value.absent(),
          bool? isActive,
          DateTime? createdAt}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        pin: pin.present ? pin.value : this.pin,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      pin: data.pin.present ? data.pin.value : this.pin,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('pin: $pin, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, password, role, pin, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.password == this.password &&
          other.role == this.role &&
          other.pin == this.pin &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> password;
  final Value<String> role;
  final Value<String?> pin;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.pin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String password,
    this.role = const Value.absent(),
    this.pin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        email = Value(email),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? pin,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (pin != null) 'pin': pin,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? password,
      Value<String>? role,
      Value<String?>? pin,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      pin: pin ?? this.pin,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('pin: $pin, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _startingCashMeta =
      const VerificationMeta('startingCash');
  @override
  late final GeneratedColumn<int> startingCash = GeneratedColumn<int>(
      'starting_cash', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expectedEndingCashMeta =
      const VerificationMeta('expectedEndingCash');
  @override
  late final GeneratedColumn<int> expectedEndingCash = GeneratedColumn<int>(
      'expected_ending_cash', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _actualEndingCashMeta =
      const VerificationMeta('actualEndingCash');
  @override
  late final GeneratedColumn<int> actualEndingCash = GeneratedColumn<int>(
      'actual_ending_cash', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        startTime,
        endTime,
        startingCash,
        expectedEndingCash,
        actualEndingCash,
        note,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(Insertable<Shift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('starting_cash')) {
      context.handle(
          _startingCashMeta,
          startingCash.isAcceptableOrUnknown(
              data['starting_cash']!, _startingCashMeta));
    } else if (isInserting) {
      context.missing(_startingCashMeta);
    }
    if (data.containsKey('expected_ending_cash')) {
      context.handle(
          _expectedEndingCashMeta,
          expectedEndingCash.isAcceptableOrUnknown(
              data['expected_ending_cash']!, _expectedEndingCashMeta));
    }
    if (data.containsKey('actual_ending_cash')) {
      context.handle(
          _actualEndingCashMeta,
          actualEndingCash.isAcceptableOrUnknown(
              data['actual_ending_cash']!, _actualEndingCashMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      startingCash: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}starting_cash'])!,
      expectedEndingCash: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_ending_cash']),
      actualEndingCash: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_ending_cash']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final int id;
  final int userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int startingCash;
  final int? expectedEndingCash;
  final int? actualEndingCash;
  final String? note;
  final String status;
  const Shift(
      {required this.id,
      required this.userId,
      required this.startTime,
      this.endTime,
      required this.startingCash,
      this.expectedEndingCash,
      this.actualEndingCash,
      this.note,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['starting_cash'] = Variable<int>(startingCash);
    if (!nullToAbsent || expectedEndingCash != null) {
      map['expected_ending_cash'] = Variable<int>(expectedEndingCash);
    }
    if (!nullToAbsent || actualEndingCash != null) {
      map['actual_ending_cash'] = Variable<int>(actualEndingCash);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      userId: Value(userId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      startingCash: Value(startingCash),
      expectedEndingCash: expectedEndingCash == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedEndingCash),
      actualEndingCash: actualEndingCash == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEndingCash),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      startingCash: serializer.fromJson<int>(json['startingCash']),
      expectedEndingCash: serializer.fromJson<int?>(json['expectedEndingCash']),
      actualEndingCash: serializer.fromJson<int?>(json['actualEndingCash']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'startingCash': serializer.toJson<int>(startingCash),
      'expectedEndingCash': serializer.toJson<int?>(expectedEndingCash),
      'actualEndingCash': serializer.toJson<int?>(actualEndingCash),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
    };
  }

  Shift copyWith(
          {int? id,
          int? userId,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          int? startingCash,
          Value<int?> expectedEndingCash = const Value.absent(),
          Value<int?> actualEndingCash = const Value.absent(),
          Value<String?> note = const Value.absent(),
          String? status}) =>
      Shift(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        startingCash: startingCash ?? this.startingCash,
        expectedEndingCash: expectedEndingCash.present
            ? expectedEndingCash.value
            : this.expectedEndingCash,
        actualEndingCash: actualEndingCash.present
            ? actualEndingCash.value
            : this.actualEndingCash,
        note: note.present ? note.value : this.note,
        status: status ?? this.status,
      );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      startingCash: data.startingCash.present
          ? data.startingCash.value
          : this.startingCash,
      expectedEndingCash: data.expectedEndingCash.present
          ? data.expectedEndingCash.value
          : this.expectedEndingCash,
      actualEndingCash: data.actualEndingCash.present
          ? data.actualEndingCash.value
          : this.actualEndingCash,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('startingCash: $startingCash, ')
          ..write('expectedEndingCash: $expectedEndingCash, ')
          ..write('actualEndingCash: $actualEndingCash, ')
          ..write('note: $note, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, startTime, endTime, startingCash,
      expectedEndingCash, actualEndingCash, note, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.startingCash == this.startingCash &&
          other.expectedEndingCash == this.expectedEndingCash &&
          other.actualEndingCash == this.actualEndingCash &&
          other.note == this.note &&
          other.status == this.status);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> startingCash;
  final Value<int?> expectedEndingCash;
  final Value<int?> actualEndingCash;
  final Value<String?> note;
  final Value<String> status;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.startingCash = const Value.absent(),
    this.expectedEndingCash = const Value.absent(),
    this.actualEndingCash = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
  });
  ShiftsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    required int startingCash,
    this.expectedEndingCash = const Value.absent(),
    this.actualEndingCash = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
  })  : userId = Value(userId),
        startTime = Value(startTime),
        startingCash = Value(startingCash);
  static Insertable<Shift> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? startingCash,
    Expression<int>? expectedEndingCash,
    Expression<int>? actualEndingCash,
    Expression<String>? note,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (startingCash != null) 'starting_cash': startingCash,
      if (expectedEndingCash != null)
        'expected_ending_cash': expectedEndingCash,
      if (actualEndingCash != null) 'actual_ending_cash': actualEndingCash,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
    });
  }

  ShiftsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<int>? startingCash,
      Value<int?>? expectedEndingCash,
      Value<int?>? actualEndingCash,
      Value<String?>? note,
      Value<String>? status}) {
    return ShiftsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startingCash: startingCash ?? this.startingCash,
      expectedEndingCash: expectedEndingCash ?? this.expectedEndingCash,
      actualEndingCash: actualEndingCash ?? this.actualEndingCash,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (startingCash.present) {
      map['starting_cash'] = Variable<int>(startingCash.value);
    }
    if (expectedEndingCash.present) {
      map['expected_ending_cash'] = Variable<int>(expectedEndingCash.value);
    }
    if (actualEndingCash.present) {
      map['actual_ending_cash'] = Variable<int>(actualEndingCash.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('startingCash: $startingCash, ')
          ..write('expectedEndingCash: $expectedEndingCash, ')
          ..write('actualEndingCash: $actualEndingCash, ')
          ..write('note: $note, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paymentAmountMeta =
      const VerificationMeta('paymentAmount');
  @override
  late final GeneratedColumn<int> paymentAmount = GeneratedColumn<int>(
      'payment_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changeAmountMeta =
      const VerificationMeta('changeAmount');
  @override
  late final GeneratedColumn<int> changeAmount = GeneratedColumn<int>(
      'change_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CASH'));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<int> discountAmount = GeneratedColumn<int>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<int> taxAmount = GeneratedColumn<int>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _serviceFeeAmountMeta =
      const VerificationMeta('serviceFeeAmount');
  @override
  late final GeneratedColumn<int> serviceFeeAmount = GeneratedColumn<int>(
      'service_fee_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('success'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _tableNumberMeta =
      const VerificationMeta('tableNumber');
  @override
  late final GeneratedColumn<String> tableNumber = GeneratedColumn<String>(
      'table_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paxMeta = const VerificationMeta('pax');
  @override
  late final GeneratedColumn<int> pax = GeneratedColumn<int>(
      'pax', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDebtMeta = const VerificationMeta('isDebt');
  @override
  late final GeneratedColumn<bool> isDebt = GeneratedColumn<bool>(
      'is_debt', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_debt" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _guestNameMeta =
      const VerificationMeta('guestName');
  @override
  late final GeneratedColumn<String> guestName = GeneratedColumn<String>(
      'guest_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentDetailsMeta =
      const VerificationMeta('paymentDetails');
  @override
  late final GeneratedColumn<String> paymentDetails = GeneratedColumn<String>(
      'payment_details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shifts (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionDate,
        totalAmount,
        paymentAmount,
        changeAmount,
        paymentMethod,
        discountAmount,
        taxAmount,
        serviceFeeAmount,
        status,
        customerId,
        tableNumber,
        pax,
        note,
        isDebt,
        guestName,
        paymentDetails,
        userId,
        shiftId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('payment_amount')) {
      context.handle(
          _paymentAmountMeta,
          paymentAmount.isAcceptableOrUnknown(
              data['payment_amount']!, _paymentAmountMeta));
    } else if (isInserting) {
      context.missing(_paymentAmountMeta);
    }
    if (data.containsKey('change_amount')) {
      context.handle(
          _changeAmountMeta,
          changeAmount.isAcceptableOrUnknown(
              data['change_amount']!, _changeAmountMeta));
    } else if (isInserting) {
      context.missing(_changeAmountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('service_fee_amount')) {
      context.handle(
          _serviceFeeAmountMeta,
          serviceFeeAmount.isAcceptableOrUnknown(
              data['service_fee_amount']!, _serviceFeeAmountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('table_number')) {
      context.handle(
          _tableNumberMeta,
          tableNumber.isAcceptableOrUnknown(
              data['table_number']!, _tableNumberMeta));
    }
    if (data.containsKey('pax')) {
      context.handle(
          _paxMeta, pax.isAcceptableOrUnknown(data['pax']!, _paxMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_debt')) {
      context.handle(_isDebtMeta,
          isDebt.isAcceptableOrUnknown(data['is_debt']!, _isDebtMeta));
    }
    if (data.containsKey('guest_name')) {
      context.handle(_guestNameMeta,
          guestName.isAcceptableOrUnknown(data['guest_name']!, _guestNameMeta));
    }
    if (data.containsKey('payment_details')) {
      context.handle(
          _paymentDetailsMeta,
          paymentDetails.isAcceptableOrUnknown(
              data['payment_details']!, _paymentDetailsMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_amount'])!,
      paymentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_amount'])!,
      changeAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}change_amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      discountAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_amount'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_amount'])!,
      serviceFeeAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}service_fee_amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      tableNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_number']),
      pax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pax']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isDebt: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_debt'])!,
      guestName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_name']),
      paymentDetails: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_details']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final DateTime transactionDate;
  final int totalAmount;
  final int paymentAmount;
  final int changeAmount;
  final String paymentMethod;
  final int discountAmount;
  final int taxAmount;
  final int serviceFeeAmount;
  final String status;
  final int? customerId;
  final String? tableNumber;
  final int? pax;
  final String? note;
  final bool isDebt;
  final String? guestName;
  final String? paymentDetails;
  final int? userId;
  final int? shiftId;
  const Transaction(
      {required this.id,
      required this.transactionDate,
      required this.totalAmount,
      required this.paymentAmount,
      required this.changeAmount,
      required this.paymentMethod,
      required this.discountAmount,
      required this.taxAmount,
      required this.serviceFeeAmount,
      required this.status,
      this.customerId,
      this.tableNumber,
      this.pax,
      this.note,
      required this.isDebt,
      this.guestName,
      this.paymentDetails,
      this.userId,
      this.shiftId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['total_amount'] = Variable<int>(totalAmount);
    map['payment_amount'] = Variable<int>(paymentAmount);
    map['change_amount'] = Variable<int>(changeAmount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['discount_amount'] = Variable<int>(discountAmount);
    map['tax_amount'] = Variable<int>(taxAmount);
    map['service_fee_amount'] = Variable<int>(serviceFeeAmount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    if (!nullToAbsent || tableNumber != null) {
      map['table_number'] = Variable<String>(tableNumber);
    }
    if (!nullToAbsent || pax != null) {
      map['pax'] = Variable<int>(pax);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_debt'] = Variable<bool>(isDebt);
    if (!nullToAbsent || guestName != null) {
      map['guest_name'] = Variable<String>(guestName);
    }
    if (!nullToAbsent || paymentDetails != null) {
      map['payment_details'] = Variable<String>(paymentDetails);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      transactionDate: Value(transactionDate),
      totalAmount: Value(totalAmount),
      paymentAmount: Value(paymentAmount),
      changeAmount: Value(changeAmount),
      paymentMethod: Value(paymentMethod),
      discountAmount: Value(discountAmount),
      taxAmount: Value(taxAmount),
      serviceFeeAmount: Value(serviceFeeAmount),
      status: Value(status),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      tableNumber: tableNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(tableNumber),
      pax: pax == null && nullToAbsent ? const Value.absent() : Value(pax),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isDebt: Value(isDebt),
      guestName: guestName == null && nullToAbsent
          ? const Value.absent()
          : Value(guestName),
      paymentDetails: paymentDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDetails),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      paymentAmount: serializer.fromJson<int>(json['paymentAmount']),
      changeAmount: serializer.fromJson<int>(json['changeAmount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
      taxAmount: serializer.fromJson<int>(json['taxAmount']),
      serviceFeeAmount: serializer.fromJson<int>(json['serviceFeeAmount']),
      status: serializer.fromJson<String>(json['status']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      tableNumber: serializer.fromJson<String?>(json['tableNumber']),
      pax: serializer.fromJson<int?>(json['pax']),
      note: serializer.fromJson<String?>(json['note']),
      isDebt: serializer.fromJson<bool>(json['isDebt']),
      guestName: serializer.fromJson<String?>(json['guestName']),
      paymentDetails: serializer.fromJson<String?>(json['paymentDetails']),
      userId: serializer.fromJson<int?>(json['userId']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'paymentAmount': serializer.toJson<int>(paymentAmount),
      'changeAmount': serializer.toJson<int>(changeAmount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'discountAmount': serializer.toJson<int>(discountAmount),
      'taxAmount': serializer.toJson<int>(taxAmount),
      'serviceFeeAmount': serializer.toJson<int>(serviceFeeAmount),
      'status': serializer.toJson<String>(status),
      'customerId': serializer.toJson<int?>(customerId),
      'tableNumber': serializer.toJson<String?>(tableNumber),
      'pax': serializer.toJson<int?>(pax),
      'note': serializer.toJson<String?>(note),
      'isDebt': serializer.toJson<bool>(isDebt),
      'guestName': serializer.toJson<String?>(guestName),
      'paymentDetails': serializer.toJson<String?>(paymentDetails),
      'userId': serializer.toJson<int?>(userId),
      'shiftId': serializer.toJson<int?>(shiftId),
    };
  }

  Transaction copyWith(
          {int? id,
          DateTime? transactionDate,
          int? totalAmount,
          int? paymentAmount,
          int? changeAmount,
          String? paymentMethod,
          int? discountAmount,
          int? taxAmount,
          int? serviceFeeAmount,
          String? status,
          Value<int?> customerId = const Value.absent(),
          Value<String?> tableNumber = const Value.absent(),
          Value<int?> pax = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? isDebt,
          Value<String?> guestName = const Value.absent(),
          Value<String?> paymentDetails = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          Value<int?> shiftId = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        transactionDate: transactionDate ?? this.transactionDate,
        totalAmount: totalAmount ?? this.totalAmount,
        paymentAmount: paymentAmount ?? this.paymentAmount,
        changeAmount: changeAmount ?? this.changeAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        discountAmount: discountAmount ?? this.discountAmount,
        taxAmount: taxAmount ?? this.taxAmount,
        serviceFeeAmount: serviceFeeAmount ?? this.serviceFeeAmount,
        status: status ?? this.status,
        customerId: customerId.present ? customerId.value : this.customerId,
        tableNumber: tableNumber.present ? tableNumber.value : this.tableNumber,
        pax: pax.present ? pax.value : this.pax,
        note: note.present ? note.value : this.note,
        isDebt: isDebt ?? this.isDebt,
        guestName: guestName.present ? guestName.value : this.guestName,
        paymentDetails:
            paymentDetails.present ? paymentDetails.value : this.paymentDetails,
        userId: userId.present ? userId.value : this.userId,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      paymentAmount: data.paymentAmount.present
          ? data.paymentAmount.value
          : this.paymentAmount,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      serviceFeeAmount: data.serviceFeeAmount.present
          ? data.serviceFeeAmount.value
          : this.serviceFeeAmount,
      status: data.status.present ? data.status.value : this.status,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      tableNumber:
          data.tableNumber.present ? data.tableNumber.value : this.tableNumber,
      pax: data.pax.present ? data.pax.value : this.pax,
      note: data.note.present ? data.note.value : this.note,
      isDebt: data.isDebt.present ? data.isDebt.value : this.isDebt,
      guestName: data.guestName.present ? data.guestName.value : this.guestName,
      paymentDetails: data.paymentDetails.present
          ? data.paymentDetails.value
          : this.paymentDetails,
      userId: data.userId.present ? data.userId.value : this.userId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('serviceFeeAmount: $serviceFeeAmount, ')
          ..write('status: $status, ')
          ..write('customerId: $customerId, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('pax: $pax, ')
          ..write('note: $note, ')
          ..write('isDebt: $isDebt, ')
          ..write('guestName: $guestName, ')
          ..write('paymentDetails: $paymentDetails, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      transactionDate,
      totalAmount,
      paymentAmount,
      changeAmount,
      paymentMethod,
      discountAmount,
      taxAmount,
      serviceFeeAmount,
      status,
      customerId,
      tableNumber,
      pax,
      note,
      isDebt,
      guestName,
      paymentDetails,
      userId,
      shiftId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.transactionDate == this.transactionDate &&
          other.totalAmount == this.totalAmount &&
          other.paymentAmount == this.paymentAmount &&
          other.changeAmount == this.changeAmount &&
          other.paymentMethod == this.paymentMethod &&
          other.discountAmount == this.discountAmount &&
          other.taxAmount == this.taxAmount &&
          other.serviceFeeAmount == this.serviceFeeAmount &&
          other.status == this.status &&
          other.customerId == this.customerId &&
          other.tableNumber == this.tableNumber &&
          other.pax == this.pax &&
          other.note == this.note &&
          other.isDebt == this.isDebt &&
          other.guestName == this.guestName &&
          other.paymentDetails == this.paymentDetails &&
          other.userId == this.userId &&
          other.shiftId == this.shiftId);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<DateTime> transactionDate;
  final Value<int> totalAmount;
  final Value<int> paymentAmount;
  final Value<int> changeAmount;
  final Value<String> paymentMethod;
  final Value<int> discountAmount;
  final Value<int> taxAmount;
  final Value<int> serviceFeeAmount;
  final Value<String> status;
  final Value<int?> customerId;
  final Value<String?> tableNumber;
  final Value<int?> pax;
  final Value<String?> note;
  final Value<bool> isDebt;
  final Value<String?> guestName;
  final Value<String?> paymentDetails;
  final Value<int?> userId;
  final Value<int?> shiftId;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentAmount = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.serviceFeeAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.customerId = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.pax = const Value.absent(),
    this.note = const Value.absent(),
    this.isDebt = const Value.absent(),
    this.guestName = const Value.absent(),
    this.paymentDetails = const Value.absent(),
    this.userId = const Value.absent(),
    this.shiftId = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime transactionDate,
    required int totalAmount,
    required int paymentAmount,
    required int changeAmount,
    this.paymentMethod = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.serviceFeeAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.customerId = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.pax = const Value.absent(),
    this.note = const Value.absent(),
    this.isDebt = const Value.absent(),
    this.guestName = const Value.absent(),
    this.paymentDetails = const Value.absent(),
    this.userId = const Value.absent(),
    this.shiftId = const Value.absent(),
  })  : transactionDate = Value(transactionDate),
        totalAmount = Value(totalAmount),
        paymentAmount = Value(paymentAmount),
        changeAmount = Value(changeAmount);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<DateTime>? transactionDate,
    Expression<int>? totalAmount,
    Expression<int>? paymentAmount,
    Expression<int>? changeAmount,
    Expression<String>? paymentMethod,
    Expression<int>? discountAmount,
    Expression<int>? taxAmount,
    Expression<int>? serviceFeeAmount,
    Expression<String>? status,
    Expression<int>? customerId,
    Expression<String>? tableNumber,
    Expression<int>? pax,
    Expression<String>? note,
    Expression<bool>? isDebt,
    Expression<String>? guestName,
    Expression<String>? paymentDetails,
    Expression<int>? userId,
    Expression<int>? shiftId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (serviceFeeAmount != null) 'service_fee_amount': serviceFeeAmount,
      if (status != null) 'status': status,
      if (customerId != null) 'customer_id': customerId,
      if (tableNumber != null) 'table_number': tableNumber,
      if (pax != null) 'pax': pax,
      if (note != null) 'note': note,
      if (isDebt != null) 'is_debt': isDebt,
      if (guestName != null) 'guest_name': guestName,
      if (paymentDetails != null) 'payment_details': paymentDetails,
      if (userId != null) 'user_id': userId,
      if (shiftId != null) 'shift_id': shiftId,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? transactionDate,
      Value<int>? totalAmount,
      Value<int>? paymentAmount,
      Value<int>? changeAmount,
      Value<String>? paymentMethod,
      Value<int>? discountAmount,
      Value<int>? taxAmount,
      Value<int>? serviceFeeAmount,
      Value<String>? status,
      Value<int?>? customerId,
      Value<String?>? tableNumber,
      Value<int?>? pax,
      Value<String?>? note,
      Value<bool>? isDebt,
      Value<String?>? guestName,
      Value<String?>? paymentDetails,
      Value<int?>? userId,
      Value<int?>? shiftId}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      transactionDate: transactionDate ?? this.transactionDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      serviceFeeAmount: serviceFeeAmount ?? this.serviceFeeAmount,
      status: status ?? this.status,
      customerId: customerId ?? this.customerId,
      tableNumber: tableNumber ?? this.tableNumber,
      pax: pax ?? this.pax,
      note: note ?? this.note,
      isDebt: isDebt ?? this.isDebt,
      guestName: guestName ?? this.guestName,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      userId: userId ?? this.userId,
      shiftId: shiftId ?? this.shiftId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (paymentAmount.present) {
      map['payment_amount'] = Variable<int>(paymentAmount.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<int>(changeAmount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<int>(taxAmount.value);
    }
    if (serviceFeeAmount.present) {
      map['service_fee_amount'] = Variable<int>(serviceFeeAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<String>(tableNumber.value);
    }
    if (pax.present) {
      map['pax'] = Variable<int>(pax.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isDebt.present) {
      map['is_debt'] = Variable<bool>(isDebt.value);
    }
    if (guestName.present) {
      map['guest_name'] = Variable<String>(guestName.value);
    }
    if (paymentDetails.present) {
      map['payment_details'] = Variable<String>(paymentDetails.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('serviceFeeAmount: $serviceFeeAmount, ')
          ..write('status: $status, ')
          ..write('customerId: $customerId, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('pax: $pax, ')
          ..write('note: $note, ')
          ..write('isDebt: $isDebt, ')
          ..write('guestName: $guestName, ')
          ..write('paymentDetails: $paymentDetails, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, TransactionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
      'price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
      'cost', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, transactionId, itemId, quantity, price, cost];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost'])!,
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class TransactionItem extends DataClass implements Insertable<TransactionItem> {
  final int id;
  final int transactionId;
  final int itemId;
  final int quantity;
  final int price;
  final int cost;
  const TransactionItem(
      {required this.id,
      required this.transactionId,
      required this.itemId,
      required this.quantity,
      required this.price,
      required this.cost});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['item_id'] = Variable<int>(itemId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<int>(price);
    map['cost'] = Variable<int>(cost);
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      itemId: Value(itemId),
      quantity: Value(quantity),
      price: Value(price),
      cost: Value(cost),
    );
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItem(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<int>(json['price']),
      cost: serializer.fromJson<int>(json['cost']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'itemId': serializer.toJson<int>(itemId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<int>(price),
      'cost': serializer.toJson<int>(cost),
    };
  }

  TransactionItem copyWith(
          {int? id,
          int? transactionId,
          int? itemId,
          int? quantity,
          int? price,
          int? cost}) =>
      TransactionItem(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        itemId: itemId ?? this.itemId,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        cost: cost ?? this.cost,
      );
  TransactionItem copyWithCompanion(TransactionItemsCompanion data) {
    return TransactionItem(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      cost: data.cost.present ? data.cost.value : this.cost,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItem(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('cost: $cost')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, itemId, quantity, price, cost);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItem &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.itemId == this.itemId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.cost == this.cost);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItem> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> itemId;
  final Value<int> quantity;
  final Value<int> price;
  final Value<int> cost;
  const TransactionItemsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int itemId,
    required int quantity,
    required int price,
    required int cost,
  })  : transactionId = Value(transactionId),
        itemId = Value(itemId),
        quantity = Value(quantity),
        price = Value(price),
        cost = Value(cost);
  static Insertable<TransactionItem> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? itemId,
    Expression<int>? quantity,
    Expression<int>? price,
    Expression<int>? cost,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (itemId != null) 'item_id': itemId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (cost != null) 'cost': cost,
    });
  }

  TransactionItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int>? itemId,
      Value<int>? quantity,
      Value<int>? price,
      Value<int>? cost}) {
    return TransactionItemsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      cost: cost ?? this.cost,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('cost: $cost')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactPersonMeta =
      const VerificationMeta('contactPerson');
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
      'contact_person', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phone, email, address, contactPerson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('contact_person')) {
      context.handle(
          _contactPersonMeta,
          contactPerson.isAcceptableOrUnknown(
              data['contact_person']!, _contactPersonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      contactPerson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_person']),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? contactPerson;
  const Supplier(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.contactPerson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'contactPerson': serializer.toJson<String?>(contactPerson),
    };
  }

  Supplier copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> contactPerson = const Value.absent()}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        contactPerson:
            contactPerson.present ? contactPerson.value : this.contactPerson,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('contactPerson: $contactPerson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, email, address, contactPerson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.contactPerson == this.contactPerson);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> contactPerson;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.contactPerson = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.contactPerson = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? contactPerson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (contactPerson != null) 'contact_person': contactPerson,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? contactPerson}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      contactPerson: contactPerson ?? this.contactPerson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('contactPerson: $contactPerson')
          ..write(')'))
        .toString();
  }
}

class $ItemCompositionsTable extends ItemCompositions
    with TableInfo<$ItemCompositionsTable, ItemComposition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemCompositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _parentItemIdMeta =
      const VerificationMeta('parentItemId');
  @override
  late final GeneratedColumn<int> parentItemId = GeneratedColumn<int>(
      'parent_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _childItemIdMeta =
      const VerificationMeta('childItemId');
  @override
  late final GeneratedColumn<int> childItemId = GeneratedColumn<int>(
      'child_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, parentItemId, childItemId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_compositions';
  @override
  VerificationContext validateIntegrity(Insertable<ItemComposition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_item_id')) {
      context.handle(
          _parentItemIdMeta,
          parentItemId.isAcceptableOrUnknown(
              data['parent_item_id']!, _parentItemIdMeta));
    } else if (isInserting) {
      context.missing(_parentItemIdMeta);
    }
    if (data.containsKey('child_item_id')) {
      context.handle(
          _childItemIdMeta,
          childItemId.isAcceptableOrUnknown(
              data['child_item_id']!, _childItemIdMeta));
    } else if (isInserting) {
      context.missing(_childItemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemComposition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemComposition(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      parentItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_item_id'])!,
      childItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}child_item_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $ItemCompositionsTable createAlias(String alias) {
    return $ItemCompositionsTable(attachedDatabase, alias);
  }
}

class ItemComposition extends DataClass implements Insertable<ItemComposition> {
  final int id;
  final int parentItemId;
  final int childItemId;
  final int quantity;
  const ItemComposition(
      {required this.id,
      required this.parentItemId,
      required this.childItemId,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_item_id'] = Variable<int>(parentItemId);
    map['child_item_id'] = Variable<int>(childItemId);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  ItemCompositionsCompanion toCompanion(bool nullToAbsent) {
    return ItemCompositionsCompanion(
      id: Value(id),
      parentItemId: Value(parentItemId),
      childItemId: Value(childItemId),
      quantity: Value(quantity),
    );
  }

  factory ItemComposition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemComposition(
      id: serializer.fromJson<int>(json['id']),
      parentItemId: serializer.fromJson<int>(json['parentItemId']),
      childItemId: serializer.fromJson<int>(json['childItemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentItemId': serializer.toJson<int>(parentItemId),
      'childItemId': serializer.toJson<int>(childItemId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  ItemComposition copyWith(
          {int? id, int? parentItemId, int? childItemId, int? quantity}) =>
      ItemComposition(
        id: id ?? this.id,
        parentItemId: parentItemId ?? this.parentItemId,
        childItemId: childItemId ?? this.childItemId,
        quantity: quantity ?? this.quantity,
      );
  ItemComposition copyWithCompanion(ItemCompositionsCompanion data) {
    return ItemComposition(
      id: data.id.present ? data.id.value : this.id,
      parentItemId: data.parentItemId.present
          ? data.parentItemId.value
          : this.parentItemId,
      childItemId:
          data.childItemId.present ? data.childItemId.value : this.childItemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemComposition(')
          ..write('id: $id, ')
          ..write('parentItemId: $parentItemId, ')
          ..write('childItemId: $childItemId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentItemId, childItemId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemComposition &&
          other.id == this.id &&
          other.parentItemId == this.parentItemId &&
          other.childItemId == this.childItemId &&
          other.quantity == this.quantity);
}

class ItemCompositionsCompanion extends UpdateCompanion<ItemComposition> {
  final Value<int> id;
  final Value<int> parentItemId;
  final Value<int> childItemId;
  final Value<int> quantity;
  const ItemCompositionsCompanion({
    this.id = const Value.absent(),
    this.parentItemId = const Value.absent(),
    this.childItemId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  ItemCompositionsCompanion.insert({
    this.id = const Value.absent(),
    required int parentItemId,
    required int childItemId,
    required int quantity,
  })  : parentItemId = Value(parentItemId),
        childItemId = Value(childItemId),
        quantity = Value(quantity);
  static Insertable<ItemComposition> custom({
    Expression<int>? id,
    Expression<int>? parentItemId,
    Expression<int>? childItemId,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentItemId != null) 'parent_item_id': parentItemId,
      if (childItemId != null) 'child_item_id': childItemId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  ItemCompositionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? parentItemId,
      Value<int>? childItemId,
      Value<int>? quantity}) {
    return ItemCompositionsCompanion(
      id: id ?? this.id,
      parentItemId: parentItemId ?? this.parentItemId,
      childItemId: childItemId ?? this.childItemId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentItemId.present) {
      map['parent_item_id'] = Variable<int>(parentItemId.value);
    }
    if (childItemId.present) {
      map['child_item_id'] = Variable<int>(childItemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemCompositionsCompanion(')
          ..write('id: $id, ')
          ..write('parentItemId: $parentItemId, ')
          ..write('childItemId: $childItemId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $StockHistoriesTable extends StockHistories
    with TableInfo<$StockHistoriesTable, StockHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _oldStockMeta =
      const VerificationMeta('oldStock');
  @override
  late final GeneratedColumn<int> oldStock = GeneratedColumn<int>(
      'old_stock', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _newStockMeta =
      const VerificationMeta('newStock');
  @override
  late final GeneratedColumn<int> newStock = GeneratedColumn<int>(
      'new_stock', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changeAmountMeta =
      const VerificationMeta('changeAmount');
  @override
  late final GeneratedColumn<int> changeAmount = GeneratedColumn<int>(
      'change_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serialsMeta =
      const VerificationMeta('serials');
  @override
  late final GeneratedColumn<String> serials = GeneratedColumn<String>(
      'serials', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, itemId, oldStock, newStock, changeAmount, type, date, note, serials];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_histories';
  @override
  VerificationContext validateIntegrity(Insertable<StockHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('old_stock')) {
      context.handle(_oldStockMeta,
          oldStock.isAcceptableOrUnknown(data['old_stock']!, _oldStockMeta));
    } else if (isInserting) {
      context.missing(_oldStockMeta);
    }
    if (data.containsKey('new_stock')) {
      context.handle(_newStockMeta,
          newStock.isAcceptableOrUnknown(data['new_stock']!, _newStockMeta));
    } else if (isInserting) {
      context.missing(_newStockMeta);
    }
    if (data.containsKey('change_amount')) {
      context.handle(
          _changeAmountMeta,
          changeAmount.isAcceptableOrUnknown(
              data['change_amount']!, _changeAmountMeta));
    } else if (isInserting) {
      context.missing(_changeAmountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('serials')) {
      context.handle(_serialsMeta,
          serials.isAcceptableOrUnknown(data['serials']!, _serialsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockHistory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      oldStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}old_stock'])!,
      newStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_stock'])!,
      changeAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}change_amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      serials: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serials']),
    );
  }

  @override
  $StockHistoriesTable createAlias(String alias) {
    return $StockHistoriesTable(attachedDatabase, alias);
  }
}

class StockHistory extends DataClass implements Insertable<StockHistory> {
  final int id;
  final int itemId;
  final int oldStock;
  final int newStock;
  final int changeAmount;
  final String type;
  final DateTime date;
  final String? note;
  final String? serials;
  const StockHistory(
      {required this.id,
      required this.itemId,
      required this.oldStock,
      required this.newStock,
      required this.changeAmount,
      required this.type,
      required this.date,
      this.note,
      this.serials});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['old_stock'] = Variable<int>(oldStock);
    map['new_stock'] = Variable<int>(newStock);
    map['change_amount'] = Variable<int>(changeAmount);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || serials != null) {
      map['serials'] = Variable<String>(serials);
    }
    return map;
  }

  StockHistoriesCompanion toCompanion(bool nullToAbsent) {
    return StockHistoriesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      oldStock: Value(oldStock),
      newStock: Value(newStock),
      changeAmount: Value(changeAmount),
      type: Value(type),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      serials: serials == null && nullToAbsent
          ? const Value.absent()
          : Value(serials),
    );
  }

  factory StockHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockHistory(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      oldStock: serializer.fromJson<int>(json['oldStock']),
      newStock: serializer.fromJson<int>(json['newStock']),
      changeAmount: serializer.fromJson<int>(json['changeAmount']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      serials: serializer.fromJson<String?>(json['serials']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'oldStock': serializer.toJson<int>(oldStock),
      'newStock': serializer.toJson<int>(newStock),
      'changeAmount': serializer.toJson<int>(changeAmount),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'serials': serializer.toJson<String?>(serials),
    };
  }

  StockHistory copyWith(
          {int? id,
          int? itemId,
          int? oldStock,
          int? newStock,
          int? changeAmount,
          String? type,
          DateTime? date,
          Value<String?> note = const Value.absent(),
          Value<String?> serials = const Value.absent()}) =>
      StockHistory(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        oldStock: oldStock ?? this.oldStock,
        newStock: newStock ?? this.newStock,
        changeAmount: changeAmount ?? this.changeAmount,
        type: type ?? this.type,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
        serials: serials.present ? serials.value : this.serials,
      );
  StockHistory copyWithCompanion(StockHistoriesCompanion data) {
    return StockHistory(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      oldStock: data.oldStock.present ? data.oldStock.value : this.oldStock,
      newStock: data.newStock.present ? data.newStock.value : this.newStock,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      serials: data.serials.present ? data.serials.value : this.serials,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockHistory(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('oldStock: $oldStock, ')
          ..write('newStock: $newStock, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('serials: $serials')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, itemId, oldStock, newStock, changeAmount, type, date, note, serials);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockHistory &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.oldStock == this.oldStock &&
          other.newStock == this.newStock &&
          other.changeAmount == this.changeAmount &&
          other.type == this.type &&
          other.date == this.date &&
          other.note == this.note &&
          other.serials == this.serials);
}

class StockHistoriesCompanion extends UpdateCompanion<StockHistory> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<int> oldStock;
  final Value<int> newStock;
  final Value<int> changeAmount;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> serials;
  const StockHistoriesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.oldStock = const Value.absent(),
    this.newStock = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.serials = const Value.absent(),
  });
  StockHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required int oldStock,
    required int newStock,
    required int changeAmount,
    required String type,
    required DateTime date,
    this.note = const Value.absent(),
    this.serials = const Value.absent(),
  })  : itemId = Value(itemId),
        oldStock = Value(oldStock),
        newStock = Value(newStock),
        changeAmount = Value(changeAmount),
        type = Value(type),
        date = Value(date);
  static Insertable<StockHistory> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? oldStock,
    Expression<int>? newStock,
    Expression<int>? changeAmount,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? serials,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (oldStock != null) 'old_stock': oldStock,
      if (newStock != null) 'new_stock': newStock,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (serials != null) 'serials': serials,
    });
  }

  StockHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? itemId,
      Value<int>? oldStock,
      Value<int>? newStock,
      Value<int>? changeAmount,
      Value<String>? type,
      Value<DateTime>? date,
      Value<String?>? note,
      Value<String?>? serials}) {
    return StockHistoriesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      oldStock: oldStock ?? this.oldStock,
      newStock: newStock ?? this.newStock,
      changeAmount: changeAmount ?? this.changeAmount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      serials: serials ?? this.serials,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (oldStock.present) {
      map['old_stock'] = Variable<int>(oldStock.value);
    }
    if (newStock.present) {
      map['new_stock'] = Variable<int>(newStock.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<int>(changeAmount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (serials.present) {
      map['serials'] = Variable<String>(serials.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('oldStock: $oldStock, ')
          ..write('newStock: $newStock, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('serials: $serials')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, supplierId, date, totalAmount, invoiceNumber, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(Insertable<Purchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_amount'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final int supplierId;
  final DateTime date;
  final int totalAmount;
  final String? invoiceNumber;
  final String? note;
  const Purchase(
      {required this.id,
      required this.supplierId,
      required this.date,
      required this.totalAmount,
      this.invoiceNumber,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['date'] = Variable<DateTime>(date);
    map['total_amount'] = Variable<int>(totalAmount);
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      date: Value(date),
      totalAmount: Value(totalAmount),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Purchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'date': serializer.toJson<DateTime>(date),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'note': serializer.toJson<String?>(note),
    };
  }

  Purchase copyWith(
          {int? id,
          int? supplierId,
          DateTime? date,
          int? totalAmount,
          Value<String?> invoiceNumber = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      Purchase(
        id: id ?? this.id,
        supplierId: supplierId ?? this.supplierId,
        date: date ?? this.date,
        totalAmount: totalAmount ?? this.totalAmount,
        invoiceNumber:
            invoiceNumber.present ? invoiceNumber.value : this.invoiceNumber,
        note: note.present ? note.value : this.note,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      date: data.date.present ? data.date.value : this.date,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, supplierId, date, totalAmount, invoiceNumber, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.date == this.date &&
          other.totalAmount == this.totalAmount &&
          other.invoiceNumber == this.invoiceNumber &&
          other.note == this.note);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<DateTime> date;
  final Value<int> totalAmount;
  final Value<String?> invoiceNumber;
  final Value<String?> note;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.note = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required DateTime date,
    required int totalAmount,
    this.invoiceNumber = const Value.absent(),
    this.note = const Value.absent(),
  })  : supplierId = Value(supplierId),
        date = Value(date),
        totalAmount = Value(totalAmount);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<DateTime>? date,
    Expression<int>? totalAmount,
    Expression<String>? invoiceNumber,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (date != null) 'date': date,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (note != null) 'note': note,
    });
  }

  PurchasesCompanion copyWith(
      {Value<int>? id,
      Value<int>? supplierId,
      Value<DateTime>? date,
      Value<int>? totalAmount,
      Value<String?>? invoiceNumber,
      Value<String?>? note}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES purchases (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
      'cost', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchaseId, itemId, quantity, cost];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost'])!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseId;
  final int itemId;
  final int quantity;
  final int cost;
  const PurchaseItem(
      {required this.id,
      required this.purchaseId,
      required this.itemId,
      required this.quantity,
      required this.cost});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['item_id'] = Variable<int>(itemId);
    map['quantity'] = Variable<int>(quantity);
    map['cost'] = Variable<int>(cost);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      itemId: Value(itemId),
      quantity: Value(quantity),
      cost: Value(cost),
    );
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      cost: serializer.fromJson<int>(json['cost']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'itemId': serializer.toJson<int>(itemId),
      'quantity': serializer.toJson<int>(quantity),
      'cost': serializer.toJson<int>(cost),
    };
  }

  PurchaseItem copyWith(
          {int? id, int? purchaseId, int? itemId, int? quantity, int? cost}) =>
      PurchaseItem(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        itemId: itemId ?? this.itemId,
        quantity: quantity ?? this.quantity,
        cost: cost ?? this.cost,
      );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      cost: data.cost.present ? data.cost.value : this.cost,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('cost: $cost')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseId, itemId, quantity, cost);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.itemId == this.itemId &&
          other.quantity == this.quantity &&
          other.cost == this.cost);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> itemId;
  final Value<int> quantity;
  final Value<int> cost;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.cost = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int itemId,
    required int quantity,
    required int cost,
  })  : purchaseId = Value(purchaseId),
        itemId = Value(itemId),
        quantity = Value(quantity),
        cost = Value(cost);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? itemId,
    Expression<int>? quantity,
    Expression<int>? cost,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (itemId != null) 'item_id': itemId,
      if (quantity != null) 'quantity': quantity,
      if (cost != null) 'cost': cost,
    });
  }

  PurchaseItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? purchaseId,
      Value<int>? itemId,
      Value<int>? quantity,
      Value<int>? cost}) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      cost: cost ?? this.cost,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity, ')
          ..write('cost: $cost')
          ..write(')'))
        .toString();
  }
}

class $ItemSerialsTable extends ItemSerials
    with TableInfo<$ItemSerialsTable, ItemSerial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemSerialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _serialNumberMeta =
      const VerificationMeta('serialNumber');
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
      'serial_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dateAddedMeta =
      const VerificationMeta('dateAdded');
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateSoldMeta =
      const VerificationMeta('dateSold');
  @override
  late final GeneratedColumn<DateTime> dateSold = GeneratedColumn<DateTime>(
      'date_sold', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'));
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
      'purchase_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES purchases (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemId,
        serialNumber,
        status,
        dateAdded,
        dateSold,
        transactionId,
        purchaseId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_serials';
  @override
  VerificationContext validateIntegrity(Insertable<ItemSerial> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('serial_number')) {
      context.handle(
          _serialNumberMeta,
          serialNumber.isAcceptableOrUnknown(
              data['serial_number']!, _serialNumberMeta));
    } else if (isInserting) {
      context.missing(_serialNumberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta,
          dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
    }
    if (data.containsKey('date_sold')) {
      context.handle(_dateSoldMeta,
          dateSold.isAcceptableOrUnknown(data['date_sold']!, _dateSoldMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemSerial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemSerial(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      serialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serial_number'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      dateSold: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_sold']),
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id']),
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_id']),
    );
  }

  @override
  $ItemSerialsTable createAlias(String alias) {
    return $ItemSerialsTable(attachedDatabase, alias);
  }
}

class ItemSerial extends DataClass implements Insertable<ItemSerial> {
  final int id;
  final int itemId;
  final String serialNumber;
  final int status;
  final DateTime dateAdded;
  final DateTime? dateSold;
  final int? transactionId;
  final int? purchaseId;
  const ItemSerial(
      {required this.id,
      required this.itemId,
      required this.serialNumber,
      required this.status,
      required this.dateAdded,
      this.dateSold,
      this.transactionId,
      this.purchaseId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['serial_number'] = Variable<String>(serialNumber);
    map['status'] = Variable<int>(status);
    map['date_added'] = Variable<DateTime>(dateAdded);
    if (!nullToAbsent || dateSold != null) {
      map['date_sold'] = Variable<DateTime>(dateSold);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    if (!nullToAbsent || purchaseId != null) {
      map['purchase_id'] = Variable<int>(purchaseId);
    }
    return map;
  }

  ItemSerialsCompanion toCompanion(bool nullToAbsent) {
    return ItemSerialsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      serialNumber: Value(serialNumber),
      status: Value(status),
      dateAdded: Value(dateAdded),
      dateSold: dateSold == null && nullToAbsent
          ? const Value.absent()
          : Value(dateSold),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      purchaseId: purchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseId),
    );
  }

  factory ItemSerial.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemSerial(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      status: serializer.fromJson<int>(json['status']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      dateSold: serializer.fromJson<DateTime?>(json['dateSold']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      purchaseId: serializer.fromJson<int?>(json['purchaseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'status': serializer.toJson<int>(status),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'dateSold': serializer.toJson<DateTime?>(dateSold),
      'transactionId': serializer.toJson<int?>(transactionId),
      'purchaseId': serializer.toJson<int?>(purchaseId),
    };
  }

  ItemSerial copyWith(
          {int? id,
          int? itemId,
          String? serialNumber,
          int? status,
          DateTime? dateAdded,
          Value<DateTime?> dateSold = const Value.absent(),
          Value<int?> transactionId = const Value.absent(),
          Value<int?> purchaseId = const Value.absent()}) =>
      ItemSerial(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        serialNumber: serialNumber ?? this.serialNumber,
        status: status ?? this.status,
        dateAdded: dateAdded ?? this.dateAdded,
        dateSold: dateSold.present ? dateSold.value : this.dateSold,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
        purchaseId: purchaseId.present ? purchaseId.value : this.purchaseId,
      );
  ItemSerial copyWithCompanion(ItemSerialsCompanion data) {
    return ItemSerial(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      status: data.status.present ? data.status.value : this.status,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      dateSold: data.dateSold.present ? data.dateSold.value : this.dateSold,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemSerial(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('status: $status, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateSold: $dateSold, ')
          ..write('transactionId: $transactionId, ')
          ..write('purchaseId: $purchaseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, serialNumber, status, dateAdded,
      dateSold, transactionId, purchaseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemSerial &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.serialNumber == this.serialNumber &&
          other.status == this.status &&
          other.dateAdded == this.dateAdded &&
          other.dateSold == this.dateSold &&
          other.transactionId == this.transactionId &&
          other.purchaseId == this.purchaseId);
}

class ItemSerialsCompanion extends UpdateCompanion<ItemSerial> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> serialNumber;
  final Value<int> status;
  final Value<DateTime> dateAdded;
  final Value<DateTime?> dateSold;
  final Value<int?> transactionId;
  final Value<int?> purchaseId;
  const ItemSerialsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateSold = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.purchaseId = const Value.absent(),
  });
  ItemSerialsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required String serialNumber,
    this.status = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateSold = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.purchaseId = const Value.absent(),
  })  : itemId = Value(itemId),
        serialNumber = Value(serialNumber);
  static Insertable<ItemSerial> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? serialNumber,
    Expression<int>? status,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? dateSold,
    Expression<int>? transactionId,
    Expression<int>? purchaseId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (status != null) 'status': status,
      if (dateAdded != null) 'date_added': dateAdded,
      if (dateSold != null) 'date_sold': dateSold,
      if (transactionId != null) 'transaction_id': transactionId,
      if (purchaseId != null) 'purchase_id': purchaseId,
    });
  }

  ItemSerialsCompanion copyWith(
      {Value<int>? id,
      Value<int>? itemId,
      Value<String>? serialNumber,
      Value<int>? status,
      Value<DateTime>? dateAdded,
      Value<DateTime?>? dateSold,
      Value<int?>? transactionId,
      Value<int?>? purchaseId}) {
    return ItemSerialsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      serialNumber: serialNumber ?? this.serialNumber,
      status: status ?? this.status,
      dateAdded: dateAdded ?? this.dateAdded,
      dateSold: dateSold ?? this.dateSold,
      transactionId: transactionId ?? this.transactionId,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (dateSold.present) {
      map['date_sold'] = Variable<DateTime>(dateSold.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemSerialsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('status: $status, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateSold: $dateSold, ')
          ..write('transactionId: $transactionId, ')
          ..write('purchaseId: $purchaseId')
          ..write(')'))
        .toString();
  }
}

class $PromosTable extends Promos with TableInfo<$PromosTable, Promo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _minPurchaseMeta =
      const VerificationMeta('minPurchase');
  @override
  late final GeneratedColumn<int> minPurchase = GeneratedColumn<int>(
      'min_purchase', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxDiscountMeta =
      const VerificationMeta('maxDiscount');
  @override
  late final GeneratedColumn<int> maxDiscount = GeneratedColumn<int>(
      'max_discount', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, value, isActive, minPurchase, maxDiscount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promos';
  @override
  VerificationContext validateIntegrity(Insertable<Promo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('min_purchase')) {
      context.handle(
          _minPurchaseMeta,
          minPurchase.isAcceptableOrUnknown(
              data['min_purchase']!, _minPurchaseMeta));
    }
    if (data.containsKey('max_discount')) {
      context.handle(
          _maxDiscountMeta,
          maxDiscount.isAcceptableOrUnknown(
              data['max_discount']!, _maxDiscountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Promo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Promo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      minPurchase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_purchase']),
      maxDiscount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_discount']),
    );
  }

  @override
  $PromosTable createAlias(String alias) {
    return $PromosTable(attachedDatabase, alias);
  }
}

class Promo extends DataClass implements Insertable<Promo> {
  final int id;
  final String name;
  final String type;
  final int value;
  final bool isActive;
  final int? minPurchase;
  final int? maxDiscount;
  const Promo(
      {required this.id,
      required this.name,
      required this.type,
      required this.value,
      required this.isActive,
      this.minPurchase,
      this.maxDiscount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<int>(value);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || minPurchase != null) {
      map['min_purchase'] = Variable<int>(minPurchase);
    }
    if (!nullToAbsent || maxDiscount != null) {
      map['max_discount'] = Variable<int>(maxDiscount);
    }
    return map;
  }

  PromosCompanion toCompanion(bool nullToAbsent) {
    return PromosCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      value: Value(value),
      isActive: Value(isActive),
      minPurchase: minPurchase == null && nullToAbsent
          ? const Value.absent()
          : Value(minPurchase),
      maxDiscount: maxDiscount == null && nullToAbsent
          ? const Value.absent()
          : Value(maxDiscount),
    );
  }

  factory Promo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Promo(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<int>(json['value']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      minPurchase: serializer.fromJson<int?>(json['minPurchase']),
      maxDiscount: serializer.fromJson<int?>(json['maxDiscount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<int>(value),
      'isActive': serializer.toJson<bool>(isActive),
      'minPurchase': serializer.toJson<int?>(minPurchase),
      'maxDiscount': serializer.toJson<int?>(maxDiscount),
    };
  }

  Promo copyWith(
          {int? id,
          String? name,
          String? type,
          int? value,
          bool? isActive,
          Value<int?> minPurchase = const Value.absent(),
          Value<int?> maxDiscount = const Value.absent()}) =>
      Promo(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        value: value ?? this.value,
        isActive: isActive ?? this.isActive,
        minPurchase: minPurchase.present ? minPurchase.value : this.minPurchase,
        maxDiscount: maxDiscount.present ? maxDiscount.value : this.maxDiscount,
      );
  Promo copyWithCompanion(PromosCompanion data) {
    return Promo(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      minPurchase:
          data.minPurchase.present ? data.minPurchase.value : this.minPurchase,
      maxDiscount:
          data.maxDiscount.present ? data.maxDiscount.value : this.maxDiscount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Promo(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('isActive: $isActive, ')
          ..write('minPurchase: $minPurchase, ')
          ..write('maxDiscount: $maxDiscount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, value, isActive, minPurchase, maxDiscount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Promo &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.value == this.value &&
          other.isActive == this.isActive &&
          other.minPurchase == this.minPurchase &&
          other.maxDiscount == this.maxDiscount);
}

class PromosCompanion extends UpdateCompanion<Promo> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> value;
  final Value<bool> isActive;
  final Value<int?> minPurchase;
  final Value<int?> maxDiscount;
  const PromosCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.isActive = const Value.absent(),
    this.minPurchase = const Value.absent(),
    this.maxDiscount = const Value.absent(),
  });
  PromosCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required int value,
    this.isActive = const Value.absent(),
    this.minPurchase = const Value.absent(),
    this.maxDiscount = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        value = Value(value);
  static Insertable<Promo> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? value,
    Expression<bool>? isActive,
    Expression<int>? minPurchase,
    Expression<int>? maxDiscount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (isActive != null) 'is_active': isActive,
      if (minPurchase != null) 'min_purchase': minPurchase,
      if (maxDiscount != null) 'max_discount': maxDiscount,
    });
  }

  PromosCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<int>? value,
      Value<bool>? isActive,
      Value<int?>? minPurchase,
      Value<int?>? maxDiscount}) {
    return PromosCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
      minPurchase: minPurchase ?? this.minPurchase,
      maxDiscount: maxDiscount ?? this.maxDiscount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (minPurchase.present) {
      map['min_purchase'] = Variable<int>(minPurchase.value);
    }
    if (maxDiscount.present) {
      map['max_discount'] = Variable<int>(maxDiscount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromosCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('isActive: $isActive, ')
          ..write('minPurchase: $minPurchase, ')
          ..write('maxDiscount: $maxDiscount')
          ..write(')'))
        .toString();
  }
}

class $TransactionPaymentsTable extends TransactionPayments
    with TableInfo<$TransactionPaymentsTable, TransactionPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, transactionId, paymentMethod, amount, referenceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_payments';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
    );
  }

  @override
  $TransactionPaymentsTable createAlias(String alias) {
    return $TransactionPaymentsTable(attachedDatabase, alias);
  }
}

class TransactionPayment extends DataClass
    implements Insertable<TransactionPayment> {
  final int id;
  final int transactionId;
  final String paymentMethod;
  final int amount;
  final String? referenceId;
  const TransactionPayment(
      {required this.id,
      required this.transactionId,
      required this.paymentMethod,
      required this.amount,
      this.referenceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    return map;
  }

  TransactionPaymentsCompanion toCompanion(bool nullToAbsent) {
    return TransactionPaymentsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      paymentMethod: Value(paymentMethod),
      amount: Value(amount),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
    );
  }

  factory TransactionPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionPayment(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      amount: serializer.fromJson<int>(json['amount']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'amount': serializer.toJson<int>(amount),
      'referenceId': serializer.toJson<String?>(referenceId),
    };
  }

  TransactionPayment copyWith(
          {int? id,
          int? transactionId,
          String? paymentMethod,
          int? amount,
          Value<String?> referenceId = const Value.absent()}) =>
      TransactionPayment(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        amount: amount ?? this.amount,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
      );
  TransactionPayment copyWithCompanion(TransactionPaymentsCompanion data) {
    return TransactionPayment(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      amount: data.amount.present ? data.amount.value : this.amount,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionPayment(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amount: $amount, ')
          ..write('referenceId: $referenceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, paymentMethod, amount, referenceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionPayment &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.paymentMethod == this.paymentMethod &&
          other.amount == this.amount &&
          other.referenceId == this.referenceId);
}

class TransactionPaymentsCompanion extends UpdateCompanion<TransactionPayment> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<String> paymentMethod;
  final Value<int> amount;
  final Value<String?> referenceId;
  const TransactionPaymentsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.amount = const Value.absent(),
    this.referenceId = const Value.absent(),
  });
  TransactionPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required String paymentMethod,
    required int amount,
    this.referenceId = const Value.absent(),
  })  : transactionId = Value(transactionId),
        paymentMethod = Value(paymentMethod),
        amount = Value(amount);
  static Insertable<TransactionPayment> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<String>? paymentMethod,
    Expression<int>? amount,
    Expression<String>? referenceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (amount != null) 'amount': amount,
      if (referenceId != null) 'reference_id': referenceId,
    });
  }

  TransactionPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<String>? paymentMethod,
      Value<int>? amount,
      Value<String?>? referenceId}) {
    return TransactionPaymentsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      referenceId: referenceId ?? this.referenceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amount: $amount, ')
          ..write('referenceId: $referenceId')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isFixPaymentMeta =
      const VerificationMeta('isFixPayment');
  @override
  late final GeneratedColumn<bool> isFixPayment = GeneratedColumn<bool>(
      'is_fix_payment', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_fix_payment" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, isFixPayment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentMethod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_fix_payment')) {
      context.handle(
          _isFixPaymentMeta,
          isFixPayment.isAcceptableOrUnknown(
              data['is_fix_payment']!, _isFixPaymentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMethod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethod(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isFixPayment: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_fix_payment'])!,
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethod extends DataClass implements Insertable<PaymentMethod> {
  final int id;
  final String name;
  final bool isActive;
  final bool isFixPayment;
  const PaymentMethod(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.isFixPayment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['is_fix_payment'] = Variable<bool>(isFixPayment);
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      isFixPayment: Value(isFixPayment),
    );
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethod(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isFixPayment: serializer.fromJson<bool>(json['isFixPayment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'isFixPayment': serializer.toJson<bool>(isFixPayment),
    };
  }

  PaymentMethod copyWith(
          {int? id, String? name, bool? isActive, bool? isFixPayment}) =>
      PaymentMethod(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        isFixPayment: isFixPayment ?? this.isFixPayment,
      );
  PaymentMethod copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethod(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isFixPayment: data.isFixPayment.present
          ? data.isFixPayment.value
          : this.isFixPayment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethod(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('isFixPayment: $isFixPayment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, isFixPayment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethod &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.isFixPayment == this.isFixPayment);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethod> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<bool> isFixPayment;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFixPayment = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    this.isFixPayment = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PaymentMethod> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<bool>? isFixPayment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (isFixPayment != null) 'is_fix_payment': isFixPayment,
    });
  }

  PaymentMethodsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<bool>? isFixPayment}) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      isFixPayment: isFixPayment ?? this.isFixPayment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isFixPayment.present) {
      map['is_fix_payment'] = Variable<bool>(isFixPayment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('isFixPayment: $isFixPayment')
          ..write(')'))
        .toString();
  }
}

class $VouchersTable extends Vouchers with TableInfo<$VouchersTable, Voucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, amount, isActive, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vouchers';
  @override
  VerificationContext validateIntegrity(Insertable<Voucher> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Voucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Voucher(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $VouchersTable createAlias(String alias) {
    return $VouchersTable(attachedDatabase, alias);
  }
}

class Voucher extends DataClass implements Insertable<Voucher> {
  final int id;
  final String name;
  final int amount;
  final bool isActive;
  final DateTime createdDate;
  const Voucher(
      {required this.id,
      required this.name,
      required this.amount,
      required this.isActive,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<int>(amount);
    map['is_active'] = Variable<bool>(isActive);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  VouchersCompanion toCompanion(bool nullToAbsent) {
    return VouchersCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      isActive: Value(isActive),
      createdDate: Value(createdDate),
    );
  }

  factory Voucher.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Voucher(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<int>(json['amount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<int>(amount),
      'isActive': serializer.toJson<bool>(isActive),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  Voucher copyWith(
          {int? id,
          String? name,
          int? amount,
          bool? isActive,
          DateTime? createdDate}) =>
      Voucher(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        isActive: isActive ?? this.isActive,
        createdDate: createdDate ?? this.createdDate,
      );
  Voucher copyWithCompanion(VouchersCompanion data) {
    return Voucher(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Voucher(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('isActive: $isActive, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, isActive, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Voucher &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.isActive == this.isActive &&
          other.createdDate == this.createdDate);
}

class VouchersCompanion extends UpdateCompanion<Voucher> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> amount;
  final Value<bool> isActive;
  final Value<DateTime> createdDate;
  const VouchersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  VouchersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int amount,
    this.isActive = const Value.absent(),
    this.createdDate = const Value.absent(),
  })  : name = Value(name),
        amount = Value(amount);
  static Insertable<Voucher> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? amount,
    Expression<bool>? isActive,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (isActive != null) 'is_active': isActive,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  VouchersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? amount,
      Value<bool>? isActive,
      Value<DateTime>? createdDate}) {
    return VouchersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VouchersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('isActive: $isActive, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems =
      $TransactionItemsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ItemCompositionsTable itemCompositions =
      $ItemCompositionsTable(this);
  late final $StockHistoriesTable stockHistories = $StockHistoriesTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $ItemSerialsTable itemSerials = $ItemSerialsTable(this);
  late final $PromosTable promos = $PromosTable(this);
  late final $TransactionPaymentsTable transactionPayments =
      $TransactionPaymentsTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $VouchersTable vouchers = $VouchersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        items,
        customers,
        users,
        shifts,
        transactions,
        transactionItems,
        suppliers,
        itemCompositions,
        stockHistories,
        purchases,
        purchaseItems,
        itemSerials,
        promos,
        transactionPayments,
        paymentMethods,
        vouchers
      ];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.items,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.items.categoryId));

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  Expression<bool> itemsRefs(
      Expression<bool> Function($$ItemsTableFilterComposer f) f) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
      Expression<T> Function($$ItemsTableAnnotationComposer a) f) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool itemsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable, Item>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._itemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .itemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool itemsRefs})>;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required int categoryId,
  required String name,
  Value<String?> barcode,
  required int price,
  required int cost,
  Value<int> stock,
  Value<bool> isTrackStock,
  Value<String?> imagePath,
  Value<bool> isVisible,
  Value<int> discount,
  Value<String> itemType,
  Value<int?> parentId,
  Value<int> weight,
  Value<String> unit,
  Value<String?> purchaseUnit,
  Value<int> conversionFactor,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<String?> barcode,
  Value<int> price,
  Value<int> cost,
  Value<int> stock,
  Value<bool> isTrackStock,
  Value<String?> imagePath,
  Value<bool> isVisible,
  Value<int> discount,
  Value<String> itemType,
  Value<int?> parentId,
  Value<int> weight,
  Value<String> unit,
  Value<String?> purchaseUnit,
  Value<int> conversionFactor,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias($_aliasNameGenerator(db.items.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemsTable _parentIdTable(_$AppDatabase db) => db.items
      .createAlias($_aliasNameGenerator(db.items.parentId, db.items.id));

  $$ItemsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.items.id, db.transactionItems.itemId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager =
        $$TransactionItemsTableTableManager($_db, $_db.transactionItems)
            .filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StockHistoriesTable, List<StockHistory>>
      _stockHistoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stockHistories,
              aliasName:
                  $_aliasNameGenerator(db.items.id, db.stockHistories.itemId));

  $$StockHistoriesTableProcessedTableManager get stockHistoriesRefs {
    final manager = $$StockHistoriesTableTableManager($_db, $_db.stockHistories)
        .filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName:
                  $_aliasNameGenerator(db.items.id, db.purchaseItems.itemId));

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ItemSerialsTable, List<ItemSerial>>
      _itemSerialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.itemSerials,
          aliasName: $_aliasNameGenerator(db.items.id, db.itemSerials.itemId));

  $$ItemSerialsTableProcessedTableManager get itemSerialsRefs {
    final manager = $$ItemSerialsTableTableManager($_db, $_db.itemSerials)
        .filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemSerialsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTrackStock => $composableBuilder(
      column: $table.isTrackStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVisible => $composableBuilder(
      column: $table.isVisible, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conversionFactor => $composableBuilder(
      column: $table.conversionFactor,
      builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableFilterComposer get parentId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stockHistoriesRefs(
      Expression<bool> Function($$StockHistoriesTableFilterComposer f) f) {
    final $$StockHistoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockHistories,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockHistoriesTableFilterComposer(
              $db: $db,
              $table: $db.stockHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> itemSerialsRefs(
      Expression<bool> Function($$ItemSerialsTableFilterComposer f) f) {
    final $$ItemSerialsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSerials,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSerialsTableFilterComposer(
              $db: $db,
              $table: $db.itemSerials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTrackStock => $composableBuilder(
      column: $table.isTrackStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVisible => $composableBuilder(
      column: $table.isVisible, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conversionFactor => $composableBuilder(
      column: $table.conversionFactor,
      builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableOrderingComposer get parentId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get isTrackStock => $composableBuilder(
      column: $table.isTrackStock, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit, builder: (column) => column);

  GeneratedColumn<int> get conversionFactor => $composableBuilder(
      column: $table.conversionFactor, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableAnnotationComposer get parentId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stockHistoriesRefs<T extends Object>(
      Expression<T> Function($$StockHistoriesTableAnnotationComposer a) f) {
    final $$StockHistoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockHistories,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockHistoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.stockHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> itemSerialsRefs<T extends Object>(
      Expression<T> Function($$ItemSerialsTableAnnotationComposer a) f) {
    final $$ItemSerialsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSerials,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSerialsTableAnnotationComposer(
              $db: $db,
              $table: $db.itemSerials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function(
        {bool categoryId,
        bool parentId,
        bool transactionItemsRefs,
        bool stockHistoriesRefs,
        bool purchaseItemsRefs,
        bool itemSerialsRefs})> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<int> price = const Value.absent(),
            Value<int> cost = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<bool> isTrackStock = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
            Value<int> discount = const Value.absent(),
            Value<String> itemType = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> purchaseUnit = const Value.absent(),
            Value<int> conversionFactor = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            barcode: barcode,
            price: price,
            cost: cost,
            stock: stock,
            isTrackStock: isTrackStock,
            imagePath: imagePath,
            isVisible: isVisible,
            discount: discount,
            itemType: itemType,
            parentId: parentId,
            weight: weight,
            unit: unit,
            purchaseUnit: purchaseUnit,
            conversionFactor: conversionFactor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            Value<String?> barcode = const Value.absent(),
            required int price,
            required int cost,
            Value<int> stock = const Value.absent(),
            Value<bool> isTrackStock = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
            Value<int> discount = const Value.absent(),
            Value<String> itemType = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> purchaseUnit = const Value.absent(),
            Value<int> conversionFactor = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            barcode: barcode,
            price: price,
            cost: cost,
            stock: stock,
            isTrackStock: isTrackStock,
            imagePath: imagePath,
            isVisible: isVisible,
            discount: discount,
            itemType: itemType,
            parentId: parentId,
            weight: weight,
            unit: unit,
            purchaseUnit: purchaseUnit,
            conversionFactor: conversionFactor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ItemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              parentId = false,
              transactionItemsRefs = false,
              stockHistoriesRefs = false,
              purchaseItemsRefs = false,
              itemSerialsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems,
                if (stockHistoriesRefs) db.stockHistories,
                if (purchaseItemsRefs) db.purchaseItems,
                if (itemSerialsRefs) db.itemSerials
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ItemsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ItemsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable: $$ItemsTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$ItemsTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<Item, $ItemsTable,
                            TransactionItem>(
                        currentTable: table,
                        referencedTable: $$ItemsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (stockHistoriesRefs)
                    await $_getPrefetchedData<Item, $ItemsTable, StockHistory>(
                        currentTable: table,
                        referencedTable:
                            $$ItemsTableReferences._stockHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableReferences(db, table, p0)
                                .stockHistoriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Item, $ItemsTable, PurchaseItem>(
                        currentTable: table,
                        referencedTable:
                            $$ItemsTableReferences._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items),
                  if (itemSerialsRefs)
                    await $_getPrefetchedData<Item, $ItemsTable, ItemSerial>(
                        currentTable: table,
                        referencedTable:
                            $$ItemsTableReferences._itemSerialsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableReferences(db, table, p0)
                                .itemSerialsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function(
        {bool categoryId,
        bool parentId,
        bool transactionItemsRefs,
        bool stockHistoriesRefs,
        bool purchaseItemsRefs,
        bool itemSerialsRefs})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.customers.id, db.transactions.customerId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  required String email,
  required String password,
  Value<String> role,
  Value<String?> pin,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String> password,
  Value<String> role,
  Value<String?> pin,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shifts,
          aliasName: $_aliasNameGenerator(db.users.id, db.shifts.userId));

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transactions,
          aliasName: $_aliasNameGenerator(db.users.id, db.transactions.userId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pin => $composableBuilder(
      column: $table.pin, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shiftsRefs(
      Expression<bool> Function($$ShiftsTableFilterComposer f) f) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pin => $composableBuilder(
      column: $table.pin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pin =>
      $composableBuilder(column: $table.pin, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
      Expression<T> Function($$ShiftsTableAnnotationComposer a) f) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool shiftsRefs, bool transactionsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> pin = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            email: email,
            password: password,
            role: role,
            pin: pin,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String email,
            required String password,
            Value<String> role = const Value.absent(),
            Value<String?> pin = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            email: email,
            password: password,
            role: role,
            pin: pin,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {shiftsRefs = false, transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shiftsRefs) db.shifts,
                if (transactionsRefs) db.transactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Shift>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._shiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).shiftsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool shiftsRefs, bool transactionsRefs})>;
typedef $$ShiftsTableCreateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  required int userId,
  required DateTime startTime,
  Value<DateTime?> endTime,
  required int startingCash,
  Value<int?> expectedEndingCash,
  Value<int?> actualEndingCash,
  Value<String?> note,
  Value<String> status,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<int> startingCash,
  Value<int?> expectedEndingCash,
  Value<int?> actualEndingCash,
  Value<String?> note,
  Value<String> status,
});

final class $$ShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftsTable, Shift> {
  $$ShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.shifts.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName:
                  $_aliasNameGenerator(db.shifts.id, db.transactions.shiftId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startingCash => $composableBuilder(
      column: $table.startingCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedEndingCash => $composableBuilder(
      column: $table.expectedEndingCash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualEndingCash => $composableBuilder(
      column: $table.actualEndingCash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startingCash => $composableBuilder(
      column: $table.startingCash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedEndingCash => $composableBuilder(
      column: $table.expectedEndingCash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualEndingCash => $composableBuilder(
      column: $table.actualEndingCash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get startingCash => $composableBuilder(
      column: $table.startingCash, builder: (column) => column);

  GeneratedColumn<int> get expectedEndingCash => $composableBuilder(
      column: $table.expectedEndingCash, builder: (column) => column);

  GeneratedColumn<int> get actualEndingCash => $composableBuilder(
      column: $table.actualEndingCash, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function({bool userId, bool transactionsRefs})> {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> startingCash = const Value.absent(),
            Value<int?> expectedEndingCash = const Value.absent(),
            Value<int?> actualEndingCash = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              ShiftsCompanion(
            id: id,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            startingCash: startingCash,
            expectedEndingCash: expectedEndingCash,
            actualEndingCash: actualEndingCash,
            note: note,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            required int startingCash,
            Value<int?> expectedEndingCash = const Value.absent(),
            Value<int?> actualEndingCash = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              ShiftsCompanion.insert(
            id: id,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            startingCash: startingCash,
            expectedEndingCash: expectedEndingCash,
            actualEndingCash: actualEndingCash,
            note: note,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ShiftsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false, transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$ShiftsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$ShiftsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Shift, $ShiftsTable, Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$ShiftsTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shiftId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShiftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function({bool userId, bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required DateTime transactionDate,
  required int totalAmount,
  required int paymentAmount,
  required int changeAmount,
  Value<String> paymentMethod,
  Value<int> discountAmount,
  Value<int> taxAmount,
  Value<int> serviceFeeAmount,
  Value<String> status,
  Value<int?> customerId,
  Value<String?> tableNumber,
  Value<int?> pax,
  Value<String?> note,
  Value<bool> isDebt,
  Value<String?> guestName,
  Value<String?> paymentDetails,
  Value<int?> userId,
  Value<int?> shiftId,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> transactionDate,
  Value<int> totalAmount,
  Value<int> paymentAmount,
  Value<int> changeAmount,
  Value<String> paymentMethod,
  Value<int> discountAmount,
  Value<int> taxAmount,
  Value<int> serviceFeeAmount,
  Value<String> status,
  Value<int?> customerId,
  Value<String?> tableNumber,
  Value<int?> pax,
  Value<String?> note,
  Value<bool> isDebt,
  Value<String?> guestName,
  Value<String?> paymentDetails,
  Value<int?> userId,
  Value<int?> shiftId,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
          $_aliasNameGenerator(db.transactions.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.transactions.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts
      .createAlias($_aliasNameGenerator(db.transactions.shiftId, db.shifts.id));

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<int>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.transactions.id, db.transactionItems.transactionId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager = $$TransactionItemsTableTableManager(
            $_db, $_db.transactionItems)
        .filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ItemSerialsTable, List<ItemSerial>>
      _itemSerialsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.itemSerials,
              aliasName: $_aliasNameGenerator(
                  db.transactions.id, db.itemSerials.transactionId));

  $$ItemSerialsTableProcessedTableManager get itemSerialsRefs {
    final manager = $$ItemSerialsTableTableManager($_db, $_db.itemSerials)
        .filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemSerialsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionPaymentsTable,
      List<TransactionPayment>> _transactionPaymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.transactionPayments,
          aliasName: $_aliasNameGenerator(
              db.transactions.id, db.transactionPayments.transactionId));

  $$TransactionPaymentsTableProcessedTableManager get transactionPaymentsRefs {
    final manager = $$TransactionPaymentsTableTableManager(
            $_db, $_db.transactionPayments)
        .filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serviceFeeAmount => $composableBuilder(
      column: $table.serviceFeeAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pax => $composableBuilder(
      column: $table.pax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDebt => $composableBuilder(
      column: $table.isDebt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentDetails => $composableBuilder(
      column: $table.paymentDetails,
      builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> itemSerialsRefs(
      Expression<bool> Function($$ItemSerialsTableFilterComposer f) f) {
    final $$ItemSerialsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSerials,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSerialsTableFilterComposer(
              $db: $db,
              $table: $db.itemSerials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionPaymentsRefs(
      Expression<bool> Function($$TransactionPaymentsTableFilterComposer f) f) {
    final $$TransactionPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionPayments,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.transactionPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get changeAmount => $composableBuilder(
      column: $table.changeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serviceFeeAmount => $composableBuilder(
      column: $table.serviceFeeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pax => $composableBuilder(
      column: $table.pax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDebt => $composableBuilder(
      column: $table.isDebt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentDetails => $composableBuilder(
      column: $table.paymentDetails,
      builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<int> get paymentAmount => $composableBuilder(
      column: $table.paymentAmount, builder: (column) => column);

  GeneratedColumn<int> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<int> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<int> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<int> get serviceFeeAmount => $composableBuilder(
      column: $table.serviceFeeAmount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => column);

  GeneratedColumn<int> get pax =>
      $composableBuilder(column: $table.pax, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isDebt =>
      $composableBuilder(column: $table.isDebt, builder: (column) => column);

  GeneratedColumn<String> get guestName =>
      $composableBuilder(column: $table.guestName, builder: (column) => column);

  GeneratedColumn<String> get paymentDetails => $composableBuilder(
      column: $table.paymentDetails, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> itemSerialsRefs<T extends Object>(
      Expression<T> Function($$ItemSerialsTableAnnotationComposer a) f) {
    final $$ItemSerialsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSerials,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSerialsTableAnnotationComposer(
              $db: $db,
              $table: $db.itemSerials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionPaymentsRefs<T extends Object>(
      Expression<T> Function($$TransactionPaymentsTableAnnotationComposer a)
          f) {
    final $$TransactionPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.transactionPayments,
            getReferencedColumn: (t) => t.transactionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TransactionPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.transactionPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool customerId,
        bool userId,
        bool shiftId,
        bool transactionItemsRefs,
        bool itemSerialsRefs,
        bool transactionPaymentsRefs})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<int> totalAmount = const Value.absent(),
            Value<int> paymentAmount = const Value.absent(),
            Value<int> changeAmount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<int> discountAmount = const Value.absent(),
            Value<int> taxAmount = const Value.absent(),
            Value<int> serviceFeeAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<String?> tableNumber = const Value.absent(),
            Value<int?> pax = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isDebt = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<String?> paymentDetails = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            transactionDate: transactionDate,
            totalAmount: totalAmount,
            paymentAmount: paymentAmount,
            changeAmount: changeAmount,
            paymentMethod: paymentMethod,
            discountAmount: discountAmount,
            taxAmount: taxAmount,
            serviceFeeAmount: serviceFeeAmount,
            status: status,
            customerId: customerId,
            tableNumber: tableNumber,
            pax: pax,
            note: note,
            isDebt: isDebt,
            guestName: guestName,
            paymentDetails: paymentDetails,
            userId: userId,
            shiftId: shiftId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime transactionDate,
            required int totalAmount,
            required int paymentAmount,
            required int changeAmount,
            Value<String> paymentMethod = const Value.absent(),
            Value<int> discountAmount = const Value.absent(),
            Value<int> taxAmount = const Value.absent(),
            Value<int> serviceFeeAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<String?> tableNumber = const Value.absent(),
            Value<int?> pax = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isDebt = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<String?> paymentDetails = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            transactionDate: transactionDate,
            totalAmount: totalAmount,
            paymentAmount: paymentAmount,
            changeAmount: changeAmount,
            paymentMethod: paymentMethod,
            discountAmount: discountAmount,
            taxAmount: taxAmount,
            serviceFeeAmount: serviceFeeAmount,
            status: status,
            customerId: customerId,
            tableNumber: tableNumber,
            pax: pax,
            note: note,
            isDebt: isDebt,
            guestName: guestName,
            paymentDetails: paymentDetails,
            userId: userId,
            shiftId: shiftId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false,
              userId = false,
              shiftId = false,
              transactionItemsRefs = false,
              itemSerialsRefs = false,
              transactionPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems,
                if (itemSerialsRefs) db.itemSerials,
                if (transactionPaymentsRefs) db.transactionPayments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$TransactionsTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._customerIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TransactionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable:
                        $$TransactionsTableReferences._shiftIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._shiftIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<Transaction, $TransactionsTable,
                            TransactionItem>(
                        currentTable: table,
                        referencedTable: $$TransactionsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items),
                  if (itemSerialsRefs)
                    await $_getPrefetchedData<Transaction, $TransactionsTable,
                            ItemSerial>(
                        currentTable: table,
                        referencedTable: $$TransactionsTableReferences
                            ._itemSerialsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionsTableReferences(db, table, p0)
                                .itemSerialsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items),
                  if (transactionPaymentsRefs)
                    await $_getPrefetchedData<Transaction, $TransactionsTable,
                            TransactionPayment>(
                        currentTable: table,
                        referencedTable: $$TransactionsTableReferences
                            ._transactionPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionsTableReferences(db, table, p0)
                                .transactionPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool customerId,
        bool userId,
        bool shiftId,
        bool transactionItemsRefs,
        bool itemSerialsRefs,
        bool transactionPaymentsRefs})>;
typedef $$TransactionItemsTableCreateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<int> id,
  required int transactionId,
  required int itemId,
  required int quantity,
  required int price,
  required int cost,
});
typedef $$TransactionItemsTableUpdateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<int> id,
  Value<int> transactionId,
  Value<int> itemId,
  Value<int> quantity,
  Value<int> price,
  Value<int> cost,
});

final class $$TransactionItemsTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionItemsTable, TransactionItem> {
  $$TransactionItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.transactionItems.transactionId, db.transactions.id));

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items.createAlias(
      $_aliasNameGenerator(db.transactionItems.itemId, db.items.id));

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItem,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (TransactionItem, $$TransactionItemsTableReferences),
    TransactionItem,
    PrefetchHooks Function({bool transactionId, bool itemId})> {
  $$TransactionItemsTableTableManager(
      _$AppDatabase db, $TransactionItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transactionId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> price = const Value.absent(),
            Value<int> cost = const Value.absent(),
          }) =>
              TransactionItemsCompanion(
            id: id,
            transactionId: transactionId,
            itemId: itemId,
            quantity: quantity,
            price: price,
            cost: cost,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transactionId,
            required int itemId,
            required int quantity,
            required int price,
            required int cost,
          }) =>
              TransactionItemsCompanion.insert(
            id: id,
            transactionId: transactionId,
            itemId: itemId,
            quantity: quantity,
            price: price,
            cost: cost,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable: $$TransactionItemsTableReferences
                        ._transactionIdTable(db),
                    referencedColumn: $$TransactionItemsTableReferences
                        ._transactionIdTable(db)
                        .id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$TransactionItemsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$TransactionItemsTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItem,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (TransactionItem, $$TransactionItemsTableReferences),
    TransactionItem,
    PrefetchHooks Function({bool transactionId, bool itemId})>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> contactPerson,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> contactPerson,
});

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
      _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.purchases,
          aliasName:
              $_aliasNameGenerator(db.suppliers.id, db.purchases.supplierId));

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactPerson => $composableBuilder(
      column: $table.contactPerson, builder: (column) => ColumnFilters(column));

  Expression<bool> purchasesRefs(
      Expression<bool> Function($$PurchasesTableFilterComposer f) f) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactPerson => $composableBuilder(
      column: $table.contactPerson,
      builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
      column: $table.contactPerson, builder: (column) => column);

  Expression<T> purchasesRefs<T extends Object>(
      Expression<T> Function($$PurchasesTableAnnotationComposer a) f) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool purchasesRefs})> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contactPerson = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            contactPerson: contactPerson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contactPerson = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            contactPerson: contactPerson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SuppliersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (purchasesRefs) db.purchases],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchasesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            Purchase>(
                        currentTable: table,
                        referencedTable:
                            $$SuppliersTableReferences._purchasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .purchasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool purchasesRefs})>;
typedef $$ItemCompositionsTableCreateCompanionBuilder
    = ItemCompositionsCompanion Function({
  Value<int> id,
  required int parentItemId,
  required int childItemId,
  required int quantity,
});
typedef $$ItemCompositionsTableUpdateCompanionBuilder
    = ItemCompositionsCompanion Function({
  Value<int> id,
  Value<int> parentItemId,
  Value<int> childItemId,
  Value<int> quantity,
});

final class $$ItemCompositionsTableReferences extends BaseReferences<
    _$AppDatabase, $ItemCompositionsTable, ItemComposition> {
  $$ItemCompositionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _parentItemIdTable(_$AppDatabase db) =>
      db.items.createAlias(
          $_aliasNameGenerator(db.itemCompositions.parentItemId, db.items.id));

  $$ItemsTableProcessedTableManager get parentItemId {
    final $_column = $_itemColumn<int>('parent_item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemsTable _childItemIdTable(_$AppDatabase db) =>
      db.items.createAlias(
          $_aliasNameGenerator(db.itemCompositions.childItemId, db.items.id));

  $$ItemsTableProcessedTableManager get childItemId {
    final $_column = $_itemColumn<int>('child_item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ItemCompositionsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemCompositionsTable> {
  $$ItemCompositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$ItemsTableFilterComposer get parentItemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentItemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableFilterComposer get childItemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childItemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemCompositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemCompositionsTable> {
  $$ItemCompositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$ItemsTableOrderingComposer get parentItemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentItemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableOrderingComposer get childItemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childItemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemCompositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemCompositionsTable> {
  $$ItemCompositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ItemsTableAnnotationComposer get parentItemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentItemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableAnnotationComposer get childItemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.childItemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemCompositionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemCompositionsTable,
    ItemComposition,
    $$ItemCompositionsTableFilterComposer,
    $$ItemCompositionsTableOrderingComposer,
    $$ItemCompositionsTableAnnotationComposer,
    $$ItemCompositionsTableCreateCompanionBuilder,
    $$ItemCompositionsTableUpdateCompanionBuilder,
    (ItemComposition, $$ItemCompositionsTableReferences),
    ItemComposition,
    PrefetchHooks Function({bool parentItemId, bool childItemId})> {
  $$ItemCompositionsTableTableManager(
      _$AppDatabase db, $ItemCompositionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemCompositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemCompositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemCompositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> parentItemId = const Value.absent(),
            Value<int> childItemId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              ItemCompositionsCompanion(
            id: id,
            parentItemId: parentItemId,
            childItemId: childItemId,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int parentItemId,
            required int childItemId,
            required int quantity,
          }) =>
              ItemCompositionsCompanion.insert(
            id: id,
            parentItemId: parentItemId,
            childItemId: childItemId,
            quantity: quantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemCompositionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentItemId = false, childItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentItemId,
                    referencedTable: $$ItemCompositionsTableReferences
                        ._parentItemIdTable(db),
                    referencedColumn: $$ItemCompositionsTableReferences
                        ._parentItemIdTable(db)
                        .id,
                  ) as T;
                }
                if (childItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.childItemId,
                    referencedTable:
                        $$ItemCompositionsTableReferences._childItemIdTable(db),
                    referencedColumn: $$ItemCompositionsTableReferences
                        ._childItemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ItemCompositionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemCompositionsTable,
    ItemComposition,
    $$ItemCompositionsTableFilterComposer,
    $$ItemCompositionsTableOrderingComposer,
    $$ItemCompositionsTableAnnotationComposer,
    $$ItemCompositionsTableCreateCompanionBuilder,
    $$ItemCompositionsTableUpdateCompanionBuilder,
    (ItemComposition, $$ItemCompositionsTableReferences),
    ItemComposition,
    PrefetchHooks Function({bool parentItemId, bool childItemId})>;
typedef $$StockHistoriesTableCreateCompanionBuilder = StockHistoriesCompanion
    Function({
  Value<int> id,
  required int itemId,
  required int oldStock,
  required int newStock,
  required int changeAmount,
  required String type,
  required DateTime date,
  Value<String?> note,
  Value<String?> serials,
});
typedef $$StockHistoriesTableUpdateCompanionBuilder = StockHistoriesCompanion
    Function({
  Value<int> id,
  Value<int> itemId,
  Value<int> oldStock,
  Value<int> newStock,
  Value<int> changeAmount,
  Value<String> type,
  Value<DateTime> date,
  Value<String?> note,
  Value<String?> serials,
});

final class $$StockHistoriesTableReferences
    extends BaseReferences<_$AppDatabase, $StockHistoriesTable, StockHistory> {
  $$StockHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items
      .createAlias($_aliasNameGenerator(db.stockHistories.itemId, db.items.id));

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StockHistoriesTable> {
  $$StockHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get oldStock => $composableBuilder(
      column: $table.oldStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newStock => $composableBuilder(
      column: $table.newStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serials => $composableBuilder(
      column: $table.serials, builder: (column) => ColumnFilters(column));

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockHistoriesTable> {
  $$StockHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get oldStock => $composableBuilder(
      column: $table.oldStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newStock => $composableBuilder(
      column: $table.newStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get changeAmount => $composableBuilder(
      column: $table.changeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serials => $composableBuilder(
      column: $table.serials, builder: (column) => ColumnOrderings(column));

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockHistoriesTable> {
  $$StockHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get oldStock =>
      $composableBuilder(column: $table.oldStock, builder: (column) => column);

  GeneratedColumn<int> get newStock =>
      $composableBuilder(column: $table.newStock, builder: (column) => column);

  GeneratedColumn<int> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get serials =>
      $composableBuilder(column: $table.serials, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockHistoriesTable,
    StockHistory,
    $$StockHistoriesTableFilterComposer,
    $$StockHistoriesTableOrderingComposer,
    $$StockHistoriesTableAnnotationComposer,
    $$StockHistoriesTableCreateCompanionBuilder,
    $$StockHistoriesTableUpdateCompanionBuilder,
    (StockHistory, $$StockHistoriesTableReferences),
    StockHistory,
    PrefetchHooks Function({bool itemId})> {
  $$StockHistoriesTableTableManager(
      _$AppDatabase db, $StockHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> oldStock = const Value.absent(),
            Value<int> newStock = const Value.absent(),
            Value<int> changeAmount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> serials = const Value.absent(),
          }) =>
              StockHistoriesCompanion(
            id: id,
            itemId: itemId,
            oldStock: oldStock,
            newStock: newStock,
            changeAmount: changeAmount,
            type: type,
            date: date,
            note: note,
            serials: serials,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int itemId,
            required int oldStock,
            required int newStock,
            required int changeAmount,
            required String type,
            required DateTime date,
            Value<String?> note = const Value.absent(),
            Value<String?> serials = const Value.absent(),
          }) =>
              StockHistoriesCompanion.insert(
            id: id,
            itemId: itemId,
            oldStock: oldStock,
            newStock: newStock,
            changeAmount: changeAmount,
            type: type,
            date: date,
            note: note,
            serials: serials,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$StockHistoriesTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$StockHistoriesTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StockHistoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockHistoriesTable,
    StockHistory,
    $$StockHistoriesTableFilterComposer,
    $$StockHistoriesTableOrderingComposer,
    $$StockHistoriesTableAnnotationComposer,
    $$StockHistoriesTableCreateCompanionBuilder,
    $$StockHistoriesTableUpdateCompanionBuilder,
    (StockHistory, $$StockHistoriesTableReferences),
    StockHistory,
    PrefetchHooks Function({bool itemId})>;
typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  required int supplierId,
  required DateTime date,
  required int totalAmount,
  Value<String?> invoiceNumber,
  Value<String?> note,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<int> supplierId,
  Value<DateTime> date,
  Value<int> totalAmount,
  Value<String?> invoiceNumber,
  Value<String?> note,
});

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
          $_aliasNameGenerator(db.purchases.supplierId, db.suppliers.id));

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: $_aliasNameGenerator(
                  db.purchases.id, db.purchaseItems.purchaseId));

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ItemSerialsTable, List<ItemSerial>>
      _itemSerialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.itemSerials,
          aliasName:
              $_aliasNameGenerator(db.purchases.id, db.itemSerials.purchaseId));

  $$ItemSerialsTableProcessedTableManager get itemSerialsRefs {
    final manager = $$ItemSerialsTableTableManager($_db, $_db.itemSerials)
        .filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemSerialsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> itemSerialsRefs(
      Expression<bool> Function($$ItemSerialsTableFilterComposer f) f) {
    final $$ItemSerialsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSerials,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSerialsTableFilterComposer(
              $db: $db,
              $table: $db.itemSerials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> itemSerialsRefs<T extends Object>(
      Expression<T> Function($$ItemSerialsTableAnnotationComposer a) f) {
    final $$ItemSerialsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSerials,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSerialsTableAnnotationComposer(
              $db: $db,
              $table: $db.itemSerials,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function(
        {bool supplierId, bool purchaseItemsRefs, bool itemSerialsRefs})> {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> totalAmount = const Value.absent(),
            Value<String?> invoiceNumber = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            supplierId: supplierId,
            date: date,
            totalAmount: totalAmount,
            invoiceNumber: invoiceNumber,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int supplierId,
            required DateTime date,
            required int totalAmount,
            Value<String?> invoiceNumber = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            supplierId: supplierId,
            date: date,
            totalAmount: totalAmount,
            invoiceNumber: invoiceNumber,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchasesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {supplierId = false,
              purchaseItemsRefs = false,
              itemSerialsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseItemsRefs) db.purchaseItems,
                if (itemSerialsRefs) db.itemSerials
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$PurchasesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$PurchasesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Purchase, $PurchasesTable,
                            PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$PurchasesTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchasesTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseId == item.id),
                        typedResults: items),
                  if (itemSerialsRefs)
                    await $_getPrefetchedData<Purchase, $PurchasesTable,
                            ItemSerial>(
                        currentTable: table,
                        referencedTable: $$PurchasesTableReferences
                            ._itemSerialsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchasesTableReferences(db, table, p0)
                                .itemSerialsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function(
        {bool supplierId, bool purchaseItemsRefs, bool itemSerialsRefs})>;
typedef $$PurchaseItemsTableCreateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  required int purchaseId,
  required int itemId,
  required int quantity,
  required int cost,
});
typedef $$PurchaseItemsTableUpdateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  Value<int> purchaseId,
  Value<int> itemId,
  Value<int> quantity,
  Value<int> cost,
});

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias(
          $_aliasNameGenerator(db.purchaseItems.purchaseId, db.purchases.id));

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items
      .createAlias($_aliasNameGenerator(db.purchaseItems.itemId, db.items.id));

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableOrderingComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseId, bool itemId})> {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> purchaseId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> cost = const Value.absent(),
          }) =>
              PurchaseItemsCompanion(
            id: id,
            purchaseId: purchaseId,
            itemId: itemId,
            quantity: quantity,
            cost: cost,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int purchaseId,
            required int itemId,
            required int quantity,
            required int cost,
          }) =>
              PurchaseItemsCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            itemId: itemId,
            quantity: quantity,
            cost: cost,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchaseItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchaseId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (purchaseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._purchaseIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._purchaseIdTable(db).id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PurchaseItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseId, bool itemId})>;
typedef $$ItemSerialsTableCreateCompanionBuilder = ItemSerialsCompanion
    Function({
  Value<int> id,
  required int itemId,
  required String serialNumber,
  Value<int> status,
  Value<DateTime> dateAdded,
  Value<DateTime?> dateSold,
  Value<int?> transactionId,
  Value<int?> purchaseId,
});
typedef $$ItemSerialsTableUpdateCompanionBuilder = ItemSerialsCompanion
    Function({
  Value<int> id,
  Value<int> itemId,
  Value<String> serialNumber,
  Value<int> status,
  Value<DateTime> dateAdded,
  Value<DateTime?> dateSold,
  Value<int?> transactionId,
  Value<int?> purchaseId,
});

final class $$ItemSerialsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemSerialsTable, ItemSerial> {
  $$ItemSerialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items
      .createAlias($_aliasNameGenerator(db.itemSerials.itemId, db.items.id));

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.itemSerials.transactionId, db.transactions.id));

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias(
          $_aliasNameGenerator(db.itemSerials.purchaseId, db.purchases.id));

  $$PurchasesTableProcessedTableManager? get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id');
    if ($_column == null) return null;
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ItemSerialsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemSerialsTable> {
  $$ItemSerialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateSold => $composableBuilder(
      column: $table.dateSold, builder: (column) => ColumnFilters(column));

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemSerialsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemSerialsTable> {
  $$ItemSerialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateSold => $composableBuilder(
      column: $table.dateSold, builder: (column) => ColumnOrderings(column));

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableOrderingComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemSerialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemSerialsTable> {
  $$ItemSerialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get dateSold =>
      $composableBuilder(column: $table.dateSold, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemSerialsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemSerialsTable,
    ItemSerial,
    $$ItemSerialsTableFilterComposer,
    $$ItemSerialsTableOrderingComposer,
    $$ItemSerialsTableAnnotationComposer,
    $$ItemSerialsTableCreateCompanionBuilder,
    $$ItemSerialsTableUpdateCompanionBuilder,
    (ItemSerial, $$ItemSerialsTableReferences),
    ItemSerial,
    PrefetchHooks Function(
        {bool itemId, bool transactionId, bool purchaseId})> {
  $$ItemSerialsTableTableManager(_$AppDatabase db, $ItemSerialsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemSerialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemSerialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemSerialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String> serialNumber = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
            Value<DateTime?> dateSold = const Value.absent(),
            Value<int?> transactionId = const Value.absent(),
            Value<int?> purchaseId = const Value.absent(),
          }) =>
              ItemSerialsCompanion(
            id: id,
            itemId: itemId,
            serialNumber: serialNumber,
            status: status,
            dateAdded: dateAdded,
            dateSold: dateSold,
            transactionId: transactionId,
            purchaseId: purchaseId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int itemId,
            required String serialNumber,
            Value<int> status = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
            Value<DateTime?> dateSold = const Value.absent(),
            Value<int?> transactionId = const Value.absent(),
            Value<int?> purchaseId = const Value.absent(),
          }) =>
              ItemSerialsCompanion.insert(
            id: id,
            itemId: itemId,
            serialNumber: serialNumber,
            status: status,
            dateAdded: dateAdded,
            dateSold: dateSold,
            transactionId: transactionId,
            purchaseId: purchaseId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemSerialsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {itemId = false, transactionId = false, purchaseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$ItemSerialsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$ItemSerialsTableReferences._itemIdTable(db).id,
                  ) as T;
                }
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable:
                        $$ItemSerialsTableReferences._transactionIdTable(db),
                    referencedColumn:
                        $$ItemSerialsTableReferences._transactionIdTable(db).id,
                  ) as T;
                }
                if (purchaseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseId,
                    referencedTable:
                        $$ItemSerialsTableReferences._purchaseIdTable(db),
                    referencedColumn:
                        $$ItemSerialsTableReferences._purchaseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ItemSerialsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemSerialsTable,
    ItemSerial,
    $$ItemSerialsTableFilterComposer,
    $$ItemSerialsTableOrderingComposer,
    $$ItemSerialsTableAnnotationComposer,
    $$ItemSerialsTableCreateCompanionBuilder,
    $$ItemSerialsTableUpdateCompanionBuilder,
    (ItemSerial, $$ItemSerialsTableReferences),
    ItemSerial,
    PrefetchHooks Function({bool itemId, bool transactionId, bool purchaseId})>;
typedef $$PromosTableCreateCompanionBuilder = PromosCompanion Function({
  Value<int> id,
  required String name,
  required String type,
  required int value,
  Value<bool> isActive,
  Value<int?> minPurchase,
  Value<int?> maxDiscount,
});
typedef $$PromosTableUpdateCompanionBuilder = PromosCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<int> value,
  Value<bool> isActive,
  Value<int?> minPurchase,
  Value<int?> maxDiscount,
});

class $$PromosTableFilterComposer
    extends Composer<_$AppDatabase, $PromosTable> {
  $$PromosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minPurchase => $composableBuilder(
      column: $table.minPurchase, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxDiscount => $composableBuilder(
      column: $table.maxDiscount, builder: (column) => ColumnFilters(column));
}

class $$PromosTableOrderingComposer
    extends Composer<_$AppDatabase, $PromosTable> {
  $$PromosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minPurchase => $composableBuilder(
      column: $table.minPurchase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxDiscount => $composableBuilder(
      column: $table.maxDiscount, builder: (column) => ColumnOrderings(column));
}

class $$PromosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromosTable> {
  $$PromosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get minPurchase => $composableBuilder(
      column: $table.minPurchase, builder: (column) => column);

  GeneratedColumn<int> get maxDiscount => $composableBuilder(
      column: $table.maxDiscount, builder: (column) => column);
}

class $$PromosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PromosTable,
    Promo,
    $$PromosTableFilterComposer,
    $$PromosTableOrderingComposer,
    $$PromosTableAnnotationComposer,
    $$PromosTableCreateCompanionBuilder,
    $$PromosTableUpdateCompanionBuilder,
    (Promo, BaseReferences<_$AppDatabase, $PromosTable, Promo>),
    Promo,
    PrefetchHooks Function()> {
  $$PromosTableTableManager(_$AppDatabase db, $PromosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int?> minPurchase = const Value.absent(),
            Value<int?> maxDiscount = const Value.absent(),
          }) =>
              PromosCompanion(
            id: id,
            name: name,
            type: type,
            value: value,
            isActive: isActive,
            minPurchase: minPurchase,
            maxDiscount: maxDiscount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String type,
            required int value,
            Value<bool> isActive = const Value.absent(),
            Value<int?> minPurchase = const Value.absent(),
            Value<int?> maxDiscount = const Value.absent(),
          }) =>
              PromosCompanion.insert(
            id: id,
            name: name,
            type: type,
            value: value,
            isActive: isActive,
            minPurchase: minPurchase,
            maxDiscount: maxDiscount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PromosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PromosTable,
    Promo,
    $$PromosTableFilterComposer,
    $$PromosTableOrderingComposer,
    $$PromosTableAnnotationComposer,
    $$PromosTableCreateCompanionBuilder,
    $$PromosTableUpdateCompanionBuilder,
    (Promo, BaseReferences<_$AppDatabase, $PromosTable, Promo>),
    Promo,
    PrefetchHooks Function()>;
typedef $$TransactionPaymentsTableCreateCompanionBuilder
    = TransactionPaymentsCompanion Function({
  Value<int> id,
  required int transactionId,
  required String paymentMethod,
  required int amount,
  Value<String?> referenceId,
});
typedef $$TransactionPaymentsTableUpdateCompanionBuilder
    = TransactionPaymentsCompanion Function({
  Value<int> id,
  Value<int> transactionId,
  Value<String> paymentMethod,
  Value<int> amount,
  Value<String?> referenceId,
});

final class $$TransactionPaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionPaymentsTable, TransactionPayment> {
  $$TransactionPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.transactionPayments.transactionId, db.transactions.id));

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionPaymentsTable> {
  $$TransactionPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionPaymentsTable> {
  $$TransactionPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionPaymentsTable> {
  $$TransactionPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionPaymentsTable,
    TransactionPayment,
    $$TransactionPaymentsTableFilterComposer,
    $$TransactionPaymentsTableOrderingComposer,
    $$TransactionPaymentsTableAnnotationComposer,
    $$TransactionPaymentsTableCreateCompanionBuilder,
    $$TransactionPaymentsTableUpdateCompanionBuilder,
    (TransactionPayment, $$TransactionPaymentsTableReferences),
    TransactionPayment,
    PrefetchHooks Function({bool transactionId})> {
  $$TransactionPaymentsTableTableManager(
      _$AppDatabase db, $TransactionPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionPaymentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transactionId = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
          }) =>
              TransactionPaymentsCompanion(
            id: id,
            transactionId: transactionId,
            paymentMethod: paymentMethod,
            amount: amount,
            referenceId: referenceId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transactionId,
            required String paymentMethod,
            required int amount,
            Value<String?> referenceId = const Value.absent(),
          }) =>
              TransactionPaymentsCompanion.insert(
            id: id,
            transactionId: transactionId,
            paymentMethod: paymentMethod,
            amount: amount,
            referenceId: referenceId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable: $$TransactionPaymentsTableReferences
                        ._transactionIdTable(db),
                    referencedColumn: $$TransactionPaymentsTableReferences
                        ._transactionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionPaymentsTable,
    TransactionPayment,
    $$TransactionPaymentsTableFilterComposer,
    $$TransactionPaymentsTableOrderingComposer,
    $$TransactionPaymentsTableAnnotationComposer,
    $$TransactionPaymentsTableCreateCompanionBuilder,
    $$TransactionPaymentsTableUpdateCompanionBuilder,
    (TransactionPayment, $$TransactionPaymentsTableReferences),
    TransactionPayment,
    PrefetchHooks Function({bool transactionId})>;
typedef $$PaymentMethodsTableCreateCompanionBuilder = PaymentMethodsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<bool> isActive,
  Value<bool> isFixPayment,
});
typedef $$PaymentMethodsTableUpdateCompanionBuilder = PaymentMethodsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<bool> isActive,
  Value<bool> isFixPayment,
});

class $$PaymentMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFixPayment => $composableBuilder(
      column: $table.isFixPayment, builder: (column) => ColumnFilters(column));
}

class $$PaymentMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFixPayment => $composableBuilder(
      column: $table.isFixPayment,
      builder: (column) => ColumnOrderings(column));
}

class $$PaymentMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isFixPayment => $composableBuilder(
      column: $table.isFixPayment, builder: (column) => column);
}

class $$PaymentMethodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethod,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableAnnotationComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder,
    (
      PaymentMethod,
      BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethod>
    ),
    PaymentMethod,
    PrefetchHooks Function()> {
  $$PaymentMethodsTableTableManager(
      _$AppDatabase db, $PaymentMethodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isFixPayment = const Value.absent(),
          }) =>
              PaymentMethodsCompanion(
            id: id,
            name: name,
            isActive: isActive,
            isFixPayment: isFixPayment,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<bool> isActive = const Value.absent(),
            Value<bool> isFixPayment = const Value.absent(),
          }) =>
              PaymentMethodsCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            isFixPayment: isFixPayment,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentMethodsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethod,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableAnnotationComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder,
    (
      PaymentMethod,
      BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethod>
    ),
    PaymentMethod,
    PrefetchHooks Function()>;
typedef $$VouchersTableCreateCompanionBuilder = VouchersCompanion Function({
  Value<int> id,
  required String name,
  required int amount,
  Value<bool> isActive,
  Value<DateTime> createdDate,
});
typedef $$VouchersTableUpdateCompanionBuilder = VouchersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> amount,
  Value<bool> isActive,
  Value<DateTime> createdDate,
});

class $$VouchersTableFilterComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$VouchersTableOrderingComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$VouchersTableAnnotationComposer
    extends Composer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$VouchersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VouchersTable,
    Voucher,
    $$VouchersTableFilterComposer,
    $$VouchersTableOrderingComposer,
    $$VouchersTableAnnotationComposer,
    $$VouchersTableCreateCompanionBuilder,
    $$VouchersTableUpdateCompanionBuilder,
    (Voucher, BaseReferences<_$AppDatabase, $VouchersTable, Voucher>),
    Voucher,
    PrefetchHooks Function()> {
  $$VouchersTableTableManager(_$AppDatabase db, $VouchersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VouchersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VouchersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VouchersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              VouchersCompanion(
            id: id,
            name: name,
            amount: amount,
            isActive: isActive,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int amount,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              VouchersCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            isActive: isActive,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VouchersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VouchersTable,
    Voucher,
    $$VouchersTableFilterComposer,
    $$VouchersTableOrderingComposer,
    $$VouchersTableAnnotationComposer,
    $$VouchersTableCreateCompanionBuilder,
    $$VouchersTableUpdateCompanionBuilder,
    (Voucher, BaseReferences<_$AppDatabase, $VouchersTable, Voucher>),
    Voucher,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(_db, _db.transactionItems);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ItemCompositionsTableTableManager get itemCompositions =>
      $$ItemCompositionsTableTableManager(_db, _db.itemCompositions);
  $$StockHistoriesTableTableManager get stockHistories =>
      $$StockHistoriesTableTableManager(_db, _db.stockHistories);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$ItemSerialsTableTableManager get itemSerials =>
      $$ItemSerialsTableTableManager(_db, _db.itemSerials);
  $$PromosTableTableManager get promos =>
      $$PromosTableTableManager(_db, _db.promos);
  $$TransactionPaymentsTableTableManager get transactionPayments =>
      $$TransactionPaymentsTableTableManager(_db, _db.transactionPayments);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$VouchersTableTableManager get vouchers =>
      $$VouchersTableTableManager(_db, _db.vouchers);
}
