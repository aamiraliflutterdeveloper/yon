class PropertyFilterAdsEntities{
  int? minPrice;
  int? maxPrice;
  String? areaUnit;
  String? category;
  int? minArea;
  int? maxArea;
  String? currency;
  int? bedrooms;
  int? baths;
  String? furnished;

  PropertyFilterAdsEntities({
    this.minPrice,
    this.maxPrice,
    this.areaUnit,
    this.minArea,
    this.maxArea,
    this.currency,
    this.category,
    this.bedrooms,
    this.baths,
    this.furnished,
  });

  Map<String, dynamic> toMap() {
    return {
      'min_price': minPrice,
      'max_price': maxPrice,
      'area_unit': areaUnit,
      'min_area': minArea,
      'max_area': maxArea,
      'currency': currency,
      'category' : category,
      'bedrooms' : bedrooms,
      'baths' : baths,
      'furnished' : furnished,
    };
  }

  /*@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyFilterAdsEntities &&
          runtimeType == other.runtimeType &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          areaUnit == other.areaUnit &&
          minArea == other.minArea &&
          currency == other.currency &&
          maxArea == other.maxArea;

  @override
  int get hashCode => minPrice.hashCode ^ maxPrice.hashCode ^ areaUnit.hashCode ^ minArea.hashCode ^ currency.hashCode ^ maxArea.hashCode;
*/}