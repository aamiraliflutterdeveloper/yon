import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/jobs_res_model/apply_job_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_categories_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/remote_data_source/jobs_api/i_job_api.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:dartz/dartz.dart';

class JobsRepo implements IJobs {
  JobsRepo({required this.api});
  IJobApi api;

  @override
  Future<Either<Failure, JobCategoriesResModel>> getJobsCategories() async {
    try {
      final result = await api.getAllJobCategories();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, FilteredLimitsResModel>> getJobFilterLimits(Map<String, dynamic> map) async {
    try {
      final result = await api.getJobFilterLimits(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getJobFeaturedAds() async {
    try {
      final result = await api.getJobFeaturedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getJobAllAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getJobAllAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getJobRecommendedAds() async {
    try {
      final result = await api.getJobRecommendedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getMyJobAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyJobAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> jobActiveInactive(Map<String, dynamic> map) async {
    try {
      final result = await api.jobActiveInactive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteJob(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteJob(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getJobFilteredAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getJobFilteredAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> addFavJob(Map<String, dynamic> map) async {
    try {
      final result = await api.addFavJob(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteFavJob(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteFavJob(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getFavJobAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getFavJobAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ApplyJobResModel>> applyOnJob(Map<String, dynamic> map) async {
    try {
      final result = await api.applyOnJob(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getAppliedJobs() async {
    try {
      final result = await api.getAppliedJobs();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getJobByCategoryAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getJobByCategoryAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, JobAdsResModel>> getNearByJobAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getNearByJobAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
