class IdEntities {
  late final String id;

  IdEntities({required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is IdEntities && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}