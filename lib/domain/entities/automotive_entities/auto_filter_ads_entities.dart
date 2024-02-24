class AutoFilteredAdsEntities {
  String? brandId;
  int? minKm;
  int? maxKm;
  int? minPrice;
  int? maxPrice;
  int? minYear;
  int? maxYear;
  String? transmissionType;
  String? fuelType;
  String? currencyId;

  AutoFilteredAdsEntities({
    this.brandId,
    this.minKm,
    this.maxKm,
    this.minPrice,
    this.maxPrice,
    this.minYear,
    this.maxYear,
    this.transmissionType,
    this.fuelType,
    this.currencyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brandId,
      'min_km': minKm,
      'max_km': maxKm,
      'min_price': minPrice,
      'max_price': maxPrice,
      'min_year': minYear,
      'max_year': maxYear,
      'transmission_type': transmissionType,
      'fuel_type': fuelType,
      'currency': currencyId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutoFilteredAdsEntities &&
          runtimeType == other.runtimeType &&
          brandId == other.brandId &&
          minKm == other.minKm &&
          maxKm == other.maxKm &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          minYear == other.minYear &&
          maxYear == other.maxYear &&
          transmissionType == other.transmissionType &&
          fuelType == other.fuelType &&
          currencyId == other.currencyId;

  @override
  int get hashCode =>
      brandId.hashCode ^
      minKm.hashCode ^
      maxKm.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      minYear.hashCode ^
      maxYear.hashCode ^
      transmissionType.hashCode ^
      fuelType.hashCode ^
      currencyId.hashCode;
}
