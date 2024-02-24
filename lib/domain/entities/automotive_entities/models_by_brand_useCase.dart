class ModelsByBrandEntities {
  late final String brandId;

  ModelsByBrandEntities({
    required this.brandId,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brandId,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ModelsByBrandEntities && runtimeType == other.runtimeType && brandId == other.brandId;

  @override
  int get hashCode => brandId.hashCode;
}
