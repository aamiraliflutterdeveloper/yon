class FilterLimitsEntities{
  late final String currencyId;

  FilterLimitsEntities({required this.currencyId});

  Map<String, dynamic> toMap() {
    return {
      'currency': currencyId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FilterLimitsEntities && runtimeType == other.runtimeType && currencyId == other.currencyId;

  @override
  int get hashCode => currencyId.hashCode;
}