import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/data/remote_data_source/business_api/i_business_api.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:dartz/dartz.dart';

class BusinessRepo implements IBusiness {
  BusinessRepo({required this.api});

  IBusinessApi api;

  @override
  Future<Either<Failure, GetBusinessResModel>> getMyBusinessProfiles() async {
    try {
      final result = await api.getMyBusinessProfile();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getMyBusinessAutomotiveAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyBusinessAutomotiveAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getMyBusinessClassifiedAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyBusinessClassifiedAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getMyBusinessJobAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyBusinessJobAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getMyBusinessPropertyAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyBusinessPropertyAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, BusinessStatsResModel>> getBusinessStats(Map<String, dynamic> map) async {
    try {
      final result = await api.getBusinessStats(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
