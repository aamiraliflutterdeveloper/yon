class ClassifiedFilterAdsEntities {
  final String? categoryId;
  final String? subCategoryId;
  final String? brandId;
  final String? condition;
  final int? maxPrice;
  final int? minPrice;
  final String? currencyId;
  final String? title;

  const ClassifiedFilterAdsEntities({
     this.categoryId,
     this.subCategoryId,
     this.brandId,
     this.condition,
     this.maxPrice,
     this.minPrice,
     this.currencyId,
    this.title
  });

  Map<String, dynamic> toMap() {
    return {
      'category': categoryId,
      'sub_category': subCategoryId,
      'brand': brandId,
      'condition': condition,
      'min_price': minPrice,
      'max_price': maxPrice,
      'currency': currencyId,
      'title': title,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassifiedFilterAdsEntities &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          subCategoryId == other.subCategoryId &&
          brandId == other.brandId &&
          condition == other.condition &&
          maxPrice == other.maxPrice &&
          minPrice == other.minPrice &&
          title == other.title &&
          currencyId == other.currencyId;

  @override
  int get hashCode => categoryId.hashCode ^ subCategoryId.hashCode ^ brandId.hashCode ^ title.hashCode ^ condition.hashCode ^ maxPrice.hashCode ^ minPrice.hashCode ^ currencyId.hashCode;
}
