class IdWithSortedByEntities {
  final String? id;
  final String? sortedBy;

  IdWithSortedByEntities({this.id, this.sortedBy});

  Map<String, dynamic> toMap() {
    return {
      'sorted_by': sortedBy,
      'id': id,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is IdWithSortedByEntities && runtimeType == other.runtimeType && id == other.id && sortedBy == other.sortedBy;

  @override
  int get hashCode => id.hashCode ^ sortedBy.hashCode;
}
