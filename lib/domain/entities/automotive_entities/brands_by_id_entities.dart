class BrandsByIdEntities {
  late final String categoryId;
  late final String subCategoryId;

  BrandsByIdEntities({
    required this.categoryId,
    required this.subCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': categoryId,
      'sub_category': subCategoryId,
    };
  }



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BrandsByIdEntities &&
              runtimeType == other.runtimeType &&
              categoryId == other.categoryId &&
              subCategoryId == other.subCategoryId;

  @override
  int get hashCode => categoryId.hashCode ^ subCategoryId.hashCode;
}