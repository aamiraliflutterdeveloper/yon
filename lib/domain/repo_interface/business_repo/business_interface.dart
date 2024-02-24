import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:dartz/dartz.dart';

abstract class IBusiness {
  Future<Either<Failure, GetBusinessResModel>> getMyBusinessProfiles();

  Future<Either<Failure, ClassifiedAdsResModel>> getMyBusinessClassifiedAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getMyBusinessAutomotiveAds(Map<String, dynamic> map);

  Future<Either<Failure, PropertyAdsResModel>> getMyBusinessPropertyAds(Map<String, dynamic> map);

  Future<Either<Failure, JobAdsResModel>> getMyBusinessJobAds(Map<String, dynamic> map);

  Future<Either<Failure, BusinessStatsResModel>> getBusinessStats(Map<String, dynamic> map);
}
