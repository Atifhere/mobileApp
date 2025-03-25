// category_model.dart

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final bool isActive;
  final bool enabled;
  final List<SubCategory> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.isActive,
    required this.enabled,
    required this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['createdBy'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedBy: json['updatedBy'],
      updatedDate: DateTime.parse(json['updatedDate']),
      isActive: json['isActive'],
      enabled: json['enabled'],
      subCategories: (json['subCategories'] as List)
          .map((subCat) => SubCategory.fromJson(subCat))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedDate': updatedDate.toIso8601String(),
      'isActive': isActive,
      'enabled': enabled,
      'subCategories': subCategories.map((subCat) => subCat.toJson()).toList(),
    };
  }
}

class SubCategory {
  late String id;
  late String name;
  late String description;
  late String categoryId;
  late String createdBy;
  late DateTime createdDate;
  late String? updatedBy;
  late DateTime updatedDate;
  late bool isActive;
  late bool enabled;
  late String code;
  late int sequence;
  late dynamic category;

  SubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    required this.updatedDate,
    required this.isActive,
    required this.enabled,
    required this.code,
    required this.sequence,
    this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['categoryId'],
      createdBy: json['createdBy'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedBy: json['updatedBy'],
      updatedDate: DateTime.parse(json['updatedDate']),
      isActive: json['isActive'],
      enabled: json['enabled'],
      code: json['code'],
      sequence: json['sequence'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedDate': updatedDate.toIso8601String(),
      'isActive': isActive,
      'enabled': enabled,
      'code': code,
      'sequence': sequence,
      'category': category,
    };
  }
}

