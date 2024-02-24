class SortedByEntities {
  final String? sortedBy;
  final int? pageNo;

  SortedByEntities({this.sortedBy, this.pageNo = 1});

  Map<String, dynamic> toMap() {
    return {
      'sorted_by': sortedBy,
      'page': pageNo,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SortedByEntities && runtimeType == other.runtimeType && sortedBy == other.sortedBy && pageNo == other.pageNo;

  @override
  int get hashCode => sortedBy.hashCode ^ pageNo.hashCode;
}
