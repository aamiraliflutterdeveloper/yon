import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/models/search_models/suggested_ads_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/serach_entities/get_suggested_ads_entities.dart';
import 'package:app/domain/entities/serach_entities/search_ads_entities.dart';
import 'package:app/domain/repo_interface/search_repo/search_interface.dart';
import 'package:app/domain/use_case/search_useCases/get_searched_ads_useCase.dart';
import 'package:app/domain/use_case/search_useCases/get_suggested_ads_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  ISearch repo = inject<ISearch>();
  List<AutomotiveProductModel> searchedAutomotiveAds = [];
  List<PropertyProductModel> searchedPropertyAds = [];
  List<ClassifiedProductModel> searchedClassifiedAds = [];
  List<JobProductModel> searchedJobAds = [];

  changeSearchedClassifiedAds(List<ClassifiedProductModel> newSearchedClassifiedAds) {
    searchedClassifiedAds = newSearchedClassifiedAds;
    notifyListeners();
  }

  changeSearchedAutomotiveAds(List<AutomotiveProductModel> newSearchedAutomotiveAds) {
    searchedAutomotiveAds = newSearchedAutomotiveAds;
    notifyListeners();
  }

  changeSearchedPropertyAds(List<PropertyProductModel> newSearchedPropertyAds) {
    searchedPropertyAds = newSearchedPropertyAds;
    notifyListeners();
  }

  changeSearchedJobAds(List<JobProductModel> newSearchedJobAds) {
    searchedJobAds = newSearchedJobAds;
    notifyListeners();
  }

  Future<Either<Failure, AllAdsResModel>> getSearchedAds({required String title}) {
    final searchedAds = GetSearchAdsUseCase(repo);
    final result = searchedAds(SearchAdsEntities(title: title));
    return result;
  }

  List<AutomotiveProductModel> suggestedAutomotiveAds = [];
  List<PropertyProductModel> suggestedPropertyAds = [];
  List<ClassifiedProductModel> suggestedClassifiedAds = [];
  List<JobProductModel> suggestedJobAds = [];

  changeSuggestedAds({
    required List<AutomotiveProductModel> automotiveAds,
    required List<PropertyProductModel> propertyAds,
    required List<ClassifiedProductModel> classifiedAds,
    required List<JobProductModel> jobAds,
  }) {
    suggestedAutomotiveAds = automotiveAds;
    suggestedPropertyAds = propertyAds;
    suggestedClassifiedAds = classifiedAds;
    suggestedJobAds = jobAds;
    notifyListeners();
  }

  Future<Either<Failure, SuggestedAdsResModel>> getSuggestedAds({String? categoryId, String? moduleName, String? adId}) {
    final suggestedAds = GetSuggestedAdsUseCase(repo);
    final result = suggestedAds(GetSuggestedAdsEntities(categoryId: categoryId, adId: adId, moduleName: moduleName));
    return result;
  }
}
