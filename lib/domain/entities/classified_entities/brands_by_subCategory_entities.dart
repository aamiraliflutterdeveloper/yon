class BrandsBySubCategoryEntities{
  late final String subCategoryId;

  BrandsBySubCategoryEntities({required this.subCategoryId});

  Map<String, dynamic> toMap() {
    return {
      'subcategory': subCategoryId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BrandsBySubCategoryEntities && runtimeType == other.runtimeType && subCategoryId == other.subCategoryId;

  @override
  int get hashCode => subCategoryId.hashCode;
}