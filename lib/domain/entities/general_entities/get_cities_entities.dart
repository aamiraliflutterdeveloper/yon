class GetCitiesEntities {
  late final String stateId;

  GetCitiesEntities({required this.stateId});

  Map<String, dynamic> toMap() {
    return {
      'state': stateId,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCitiesEntities && runtimeType == other.runtimeType && stateId == other.stateId;

  @override
  int get hashCode => stateId.hashCode;
}
