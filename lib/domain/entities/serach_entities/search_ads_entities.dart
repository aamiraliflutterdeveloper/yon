class SearchAdsEntities {
  late final String title;

  SearchAdsEntities({required this.title});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SearchAdsEntities && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;
}