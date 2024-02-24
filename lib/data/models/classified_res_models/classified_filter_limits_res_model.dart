class FilteredLimitsResModel {
  bool? success;
  List<FilteredLimitModel>? response;

  FilteredLimitsResModel({success, response});

  FilteredLimitsResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = <FilteredLimitModel>[];
      json['response'].forEach((v) {
        response!.add(FilteredLimitModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilteredLimitModel {
  int? firstValue;
  int? secondValue;
  int? totalCount;

  FilteredLimitModel({firstValue, secondValue, totalCount});

  FilteredLimitModel.fromJson(Map<String, dynamic> json) {
    firstValue = json['first_value'];
    secondValue = json['second_value'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_value'] = firstValue;
    data['second_value'] = secondValue;
    data['total_count'] = totalCount;
    return data;
  }
}
