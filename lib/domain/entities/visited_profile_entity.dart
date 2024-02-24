class VisitedProfileEntity {
  late final String userId;

  VisitedProfileEntity({required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'visited_profile': userId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VisitedProfileEntity && runtimeType == other.runtimeType && userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
