import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/module_entities.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:app/domain/use_case/business_useCases/business_stats_useCase.dart';
import 'package:app/domain/use_case/business_useCases/get_my_business_profile_useCase.dart';
import 'package:app/domain/use_case/business_useCases/my_business_auto_ads_useCase.dart';
import 'package:app/domain/use_case/business_useCases/my_business_classified_ads_useCase.dart';
import 'package:app/domain/use_case/business_useCases/my_business_job_ads_useCase.dart';
import 'package:app/domain/use_case/business_useCases/my_business_property_ads_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class BusinessViewModel extends ChangeNotifier {
  IBusiness businessRepo = inject<IBusiness>();
  BusinessProfileModel classifiedBusinessProfile = BusinessProfileModel();
  BusinessProfileModel automotiveBusinessProfile = BusinessProfileModel();
  BusinessProfileModel propertyBusinessProfile = BusinessProfileModel();
  BusinessProfileModel jobBusinessProfile = BusinessProfileModel();

  Future<Either<Failure, GetBusinessResModel>> getMyBusinessProfiles() async {
    final businessProfiles = GetMyBusinessProfilesUseCase(repository: businessRepo);
    final result = businessProfiles(NoParams());
    return result;
  }

  List<ClassifiedProductModel> classifiedBusinessAds = [];
  List<AutomotiveProductModel> automotiveBusinessAds = [];
  List<PropertyProductModel> propertyBusinessAds = [];
  List<JobProductModel> jobBusinessAds = [];

  changeClassifiedBusinessAds(List<ClassifiedProductModel> newClassifiedBusinessAds) {
    classifiedBusinessAds = newClassifiedBusinessAds;
    notifyListeners();
  }

  changeAutomotiveBusinessAds(List<AutomotiveProductModel> newAutomotiveBusinessAds) {
    automotiveBusinessAds = newAutomotiveBusinessAds;
    notifyListeners();
  }

  changePropertyBusinessAds(List<PropertyProductModel> newPropertyBusinessAds) {
    propertyBusinessAds = newPropertyBusinessAds;
    notifyListeners();
  }

  changeJobBusinessAds(List<JobProductModel> newJobBusinessAds) {
    jobBusinessAds = newJobBusinessAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>> getBusinessClassifiedAds({String? sortedBy}) async {
    final myBusinessAds = GetMyBusinessClassifiedAdsUseCase(repository: businessRepo);
    final result = myBusinessAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  Future<Either<Failure, AutomotiveAdsResModel>> getBusinessAutomotiveAds({String? sortedBy}) async {
    final myBusinessAds = GetMyBusinessAutomotiveAdsUseCase(repository: businessRepo);
    final result = myBusinessAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  Future<Either<Failure, PropertyAdsResModel>> getBusinessPropertyAds({String? sortedBy}) async {
    final myBusinessAds = GetMyBusinessPropertyAdsUseCase(repository: businessRepo);
    final result = myBusinessAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  Future<Either<Failure, JobAdsResModel>> getBusinessJobAds({String? sortedBy}) async {
    final myBusinessAds = GetMyBusinessJobAdsUseCase(repository: businessRepo);
    final result = myBusinessAds(SortedByEntities(sortedBy: sortedBy));
    return result;
  }

  Future<Either<Failure, BusinessStatsResModel>> getBusinessStats({required String module}) {
    final businessStats = GetBusinessStatsUseCase(repository: businessRepo);
    final result = businessStats(ModuleEntities(module: module));
    return result;
  }
}
