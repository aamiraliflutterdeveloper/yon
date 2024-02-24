import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';

abstract class IBusinessApi {
  Future<GetBusinessResModel> getMyBusinessProfile();
  Future<ClassifiedAdsResModel> getMyBusinessClassifiedAds(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getMyBusinessAutomotiveAds(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getMyBusinessPropertyAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getMyBusinessJobAds(Map<String, dynamic> map);
  Future<BusinessStatsResModel> getBusinessStats(Map<String, dynamic> map);
}
