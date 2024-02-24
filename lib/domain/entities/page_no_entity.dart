class PageNoEntity {
  final int? pageNo;

  // PageNoEntity({this.pageNo = 1});
  PageNoEntity(this.pageNo);

  Map<String, dynamic> toMap() {
    return {
      'page': pageNo,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PageNoEntity && runtimeType == other.runtimeType && pageNo == other.pageNo;

  @override
  int get hashCode => pageNo.hashCode;
}

