class GetSuggestedAdsEntities {
  final String? moduleName;
  final String? categoryId;
  final String? adId;

  const GetSuggestedAdsEntities({
    this.moduleName,
    this.categoryId,
    this.adId,
  });

  Map<String, dynamic> toMap() {
    return {
      'module_name': moduleName,
      'category': categoryId,
      'id': adId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetSuggestedAdsEntities &&
          runtimeType == other.runtimeType &&
          moduleName == other.moduleName &&
          categoryId == other.categoryId &&
          adId == other.adId;

  @override
  int get hashCode => moduleName.hashCode ^ categoryId.hashCode ^ adId.hashCode;
}
