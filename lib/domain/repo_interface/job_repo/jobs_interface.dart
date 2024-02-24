import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/jobs_res_model/apply_job_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_categories_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class IJobs {
  Future<Either<Failure, JobCategoriesResModel>> getJobsCategories();

  Future<Either<Failure, FilteredLimitsResModel>> getJobFilterLimits(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getJobFeaturedAds();

  // Future<Either<Failure, JobAdsResModel>> getJobAllAds();

  Future<Either<Failure, JobAdsResModel>> getJobAllAds(Map<String, dynamic> map);

  // Future<Either<Failure, JobAdsResModel>> getJobAllAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getAppliedJobs();

  Future<Either<Failure, JobAdsResModel>> getJobFilteredAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getFavJobAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getJobByCategoryAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getMyJobAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getNearByJobAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getJobRecommendedAds();

  Future<Either<Failure, MessageResModel>> jobActiveInactive(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> deleteJob(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> deleteFavJob(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> addFavJob(Map<String, dynamic> map);

  Future<Either<Failure, ApplyJobResModel>> applyOnJob(Map<String, dynamic> map);
}
