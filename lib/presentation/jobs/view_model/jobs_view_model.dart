import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/jobs_res_model/apply_job_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_categories_res_model.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/classified_entities/filter_limit_entities.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/entities/id_with_sort_entities.dart';
import 'package:app/domain/entities/job_entities/apply_job_entities.dart';
import 'package:app/domain/entities/job_entities/job_filter_ads_entities.dart';
import 'package:app/domain/entities/lat_long_entities.dart';
import 'package:app/domain/entities/page_no_entity.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/job_repo/jobs_interface.dart';
import 'package:app/domain/use_case/jobs_useCases/add_fav_job_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/apply_on_job_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_all_jobs_cate_usecase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_all_jobs_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_appliedi_job_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_filtered_ads_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_job_featured_ads_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_job_filter_limits_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/get_my_jobs_ads_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/jobs_by_category_useCase.dart';
import 'package:app/domain/use_case/jobs_useCases/nearby_jobs_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class JobViewModel extends ChangeNotifier {
  IJobs repo = inject<IJobs>();
  List<CategoriesResModel>? jobAllCategories = [];
  JobFilterModel? jobFilterData = JobFilterModel();
  Map<String, dynamic>? jobFilterMap = {};
  List<String>? jobFilterList = [];

  int allJobPageNo = 1;

  int allJobTotalPages = 1;
  int myJobTotalPages = 1;

  changeJobFilterMap(Map<String, dynamic>? newJobFilterMap) {
    jobFilterMap = newJobFilterMap;
    notifyListeners();
  }

  changeJobAllCategories(List<CategoriesResModel> updatedJobAllCategories) {
    jobAllCategories = updatedJobAllCategories;
    d('UPDATED JOB ALL CATEGORIES : ' + jobAllCategories.toString());
    notifyListeners();
  }

  Future<Either<Failure, JobCategoriesResModel>> getAllJobCategories() async {
    final getAllCat = GetAllJobsCategoryUseCase(repository: repo);
    final result = await getAllCat(NoParams());
    d('GetAllJobsCategoryUseCase : ' + result.toString());
    return result;
  }

  List<FilteredLimitModel>? jobFilteredLimits = [];

  changeJobFilterLimits(List<FilteredLimitModel>? changedJobFilteredLimits) {
    jobFilteredLimits = changedJobFilteredLimits;
    notifyListeners();
  }

  Future<Either<Failure, FilteredLimitsResModel>> getJobFilterLimits(
      {required String currencyId}) async {
    final getFilterLimits = GetJobFilterLimitsUseCase(repo);
    final result =
        await getFilterLimits(FilterLimitsEntities(currencyId: currencyId));
    d('GetJobFilterLimitsUseCase : ' + result.toString());
    return result;
  }

  List<JobProductModel> nearByJobs = [];

  changeNearByJobs(List<JobProductModel> updatedNearByJobs) {
    nearByJobs = updatedNearByJobs;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getNearByJobs(
      {required double latitude, required double longitude}) async {
    final featuredAds = GetNearByJobsUseCase(repository: repo);
    final result = await featuredAds(
        LatLongEntities(latitude: latitude, longitude: longitude));
    d('GetNearByJobsUseCase : ' + result.toString());
    return result;
  }

  List<JobProductModel>? jobFeaturedAds = [];

  changeJobFeaturedAds(List<JobProductModel> newJobFeaturedAds) {
    jobFeaturedAds = newJobFeaturedAds;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getJobFeaturedProducts() async {
    final featuredAds = GetJobFeaturedAdsUseCase(repository: repo);
    final result = await featuredAds(NoParams());
    d('GetJobFeaturedAdsUseCase : ' + result.toString());
    return result;
  }

  List<JobProductModel> jobsByCategory = [];

  changeJobByCategory(List<JobProductModel> newJobsByCategory) {
    jobsByCategory = newJobsByCategory;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getJobsByCategory(
      {required String categoryId, String? sortedBy}) async {
    final allAds = GetJobsByCategoryUseCase(repository: repo);
    final result = await allAds(
        IdWithSortedByEntities(id: categoryId, sortedBy: sortedBy));
    d('GetJobsByCategoryUseCase : ' + result.toString());
    return result;
  }

  List<JobProductModel>? jobAllAds = [];

  changeJobAllAds(List<JobProductModel> newJobAllAds) {
    jobAllAds = newJobAllAds;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getJobAllProducts(
      {int? pageNo}) async {
    final allAds = GetJobAllAdsUseCase(repository: repo);
    // final result = await allAds(PageNoEntity(pageNo: pageNo ?? 1));
    // final result = await allAds(PageNoEntity(pageNo: pageNo));
    final result = await allAds(PageNoEntity(pageNo));
    d("ahaaaaaaaaaaaaaaaaaaaaaaaaaa");
    d(result.map((r) => r.jobAdsList!.map((e) => e.title)));
    d("$result ahaaaaaaaaaaaaaaaaaaaaaaaaaa");
    d("${pageNo}");

    d("this is page no $pageNo");
    d('GetJobAllAdsUseCase : ' + result.toString());
    return result;
  }

  Future<Either<Failure, JobAdsResModel>> getJobFilteredProducts() async {
    final allAds = GetJobFilteredAdsUseCase(repository: repo);
    final result = await allAds(JobFilteredAdsEntities(
      createdAt: jobFilterData!.createdAt,
      jobType: jobFilterData!.jobType,
      positionType: jobFilterData!.positionType,
      currencyId: jobFilterData!.currency,
      salaryEnd: jobFilterData!.endingSalary,
      salaryStart: jobFilterData!.startingSalary,
      page: jobFilterData!.page
    ));
    d('GetJobAllAdsUseCase : ' + result.toString());
    return result;
  }

  void addFavJob({required String adId}) async {
    final addFav = AddFavJobUseCase(repo);
    await addFav(IdEntities(id: adId));
  }

  Future<Either<Failure, ApplyJobResModel>> applyOnJob({
    required String jobId,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String dialCode,
    required String coverLetter,
    required String resumeId,
  }) async {
    final applyJob = ApplyOnJobUseCase(repo);
    final result = await applyJob(
      ApplyJobEntities(
        jobId: jobId,
        dialCode: dialCode,
        fullName: fullName,
        email: email,
        coverLetter: coverLetter,
        mobile: phoneNumber,
        resumeId: resumeId,
      ),
    );
    return result;
  }

  List<JobProductModel> appliedJobs = [];

  changeAppliedJobs(List<JobProductModel> newAppliedJobs) {
    appliedJobs = newAppliedJobs;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getAppliedJobs() async {
    final appliedJobs = GetAppliedJobsUseCase(repository: repo);
    final result = await appliedJobs(NoParams());
    d('GetAppliedJobsUseCase : ' + result.toString());
    return result;
  }

  List<JobProductModel> myJobs = [];

  changeMyJobs(List<JobProductModel> newAppliedJobs) {
    myJobs = newAppliedJobs;
    notifyListeners();
  }

  Future<Either<Failure, JobAdsResModel>> getMyJobs(
      {String? sortedBy, int? pageNo = 1}) async {
    final myJobs = GetMyJobAdsUseCase(repository: repo);
    final result =
        await myJobs(SortedByEntities(sortedBy: sortedBy, pageNo: pageNo));
    d('GetAppliedJobsUseCase : ' + result.toString());
    return result;
  }
}

class JobFilterModel {
  String? createdAt;
  String? currency;
  int? startingSalary;
  int? endingSalary;
  String? jobType;
  String? positionType;
  int? page;

  JobFilterModel(
      {this.createdAt,
      this.startingSalary,
      this.endingSalary,
      this.jobType,
      this.positionType,
      this.currency, this.page});
}
