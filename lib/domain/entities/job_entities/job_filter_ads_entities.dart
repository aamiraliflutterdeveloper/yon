class JobFilteredAdsEntities{
  String? createdAt;
  int? salaryStart;
  int? salaryEnd;
  String? jobType;
  String? positionType;
  String? currencyId;
  int? page;

  JobFilteredAdsEntities({
    this.createdAt,
    this.salaryStart,
    this.salaryEnd,
    this.jobType,
    this.positionType,
    this.currencyId,
    required this.page,

  });

  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt,
      'salary_start': salaryStart,
      'salary_end': salaryEnd,
      'job_type': jobType,
      'position_type': positionType,
      'job_currency' : currencyId,
      'page' : page,

    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobFilteredAdsEntities &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          salaryStart == other.salaryStart &&
          salaryEnd == other.salaryEnd &&
          currencyId == other.currencyId &&
          jobType == other.jobType &&
          positionType == other.positionType &&
          page == other.page;

  @override
  int get hashCode => createdAt.hashCode ^ salaryStart.hashCode ^ currencyId.hashCode ^ salaryEnd.hashCode ^ jobType.hashCode ^ positionType.hashCode ^ page.hashCode;
}