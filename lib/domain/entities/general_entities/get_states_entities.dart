class GetStateEntities{
  late final String countryId;

  GetStateEntities({required this.countryId});

  Map<String, dynamic> toMap() {
    return {
      'country': countryId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GetStateEntities && runtimeType == other.runtimeType && countryId == other.countryId;

  @override
  int get hashCode => countryId.hashCode;
}