import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/jobs_res_model/apply_job_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_categories_res_model.dart';
import 'package:app/data/models/message_model.dart';

abstract class IJobApi {
  Future<JobCategoriesResModel> getAllJobCategories();
  Future<FilteredLimitsResModel> getJobFilterLimits(Map<String, dynamic> map);
  Future<JobAdsResModel> getJobFeaturedAds();
  // Future<JobAdsResModel> getJobAllAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getJobAllAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getAppliedJobs();
  Future<JobAdsResModel> getMyJobAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getNearByJobAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getJobByCategoryAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getJobFilteredAds(Map<String, dynamic> map);
  Future<JobAdsResModel> getFavJobAds(Map<String, dynamic> map);
  Future<MessageResModel> jobActiveInactive(Map<String, dynamic> map);
  Future<MessageResModel> deleteJob(Map<String, dynamic> map);
  Future<JobAdsResModel> getJobRecommendedAds();
  Future<MessageResModel> deleteFavJob(Map<String, dynamic> map);
  Future<MessageResModel> addFavJob(Map<String, dynamic> map);
  Future<ApplyJobResModel> applyOnJob(Map<String, dynamic> map);

}
