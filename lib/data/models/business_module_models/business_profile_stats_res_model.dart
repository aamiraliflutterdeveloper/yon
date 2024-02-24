class BusinessStatsResModel {
  bool? success;
  BusinessStatsModel? stats;

  BusinessStatsResModel({this.success, this.stats});

  BusinessStatsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    stats = json['response'] != null ? BusinessStatsModel.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (stats != null) {
      data['response'] = stats!.toJson();
    }
    return data;
  }
}

class BusinessStatsModel {
  int? activeAds;
  int? totalAdView;
  int? totalProfileView;

  BusinessStatsModel({this.activeAds, this.totalAdView, this.totalProfileView});

  BusinessStatsModel.fromJson(Map<String, dynamic> json) {
    activeAds = json['active_ads'] ?? 0;
    totalAdView = json['total_ad_view'] ?? 0;
    totalProfileView = json['total_profile_view'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active_ads'] = activeAds;
    data['total_ad_view'] = totalAdView;
    data['total_profile_view'] = totalProfileView;
    return data;
  }
}
