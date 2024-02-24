import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_categories_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/classified_entities/brands_by_subCategory_entities.dart';
import 'package:app/domain/entities/classified_entities/filter_ads_entities.dart';
import 'package:app/domain/entities/classified_entities/filter_limit_entities.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/entities/id_with_sort_entities.dart';
import 'package:app/domain/entities/page_no_entity.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:app/domain/use_case/classified_useCases/add_fav_classified_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/classified_active_inactive_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/classified_by_category_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/classsified_filtered_ads_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_all_classified_ads_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_all_classified_cate_usecase.dart';
import 'package:app/domain/use_case/classified_useCases/get_brands_by_subCategory_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_classi_featured_brands_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_classified_Deal_ads_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_classified_featured_ads_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_classified_filter_limits_useCase.dart';
import 'package:app/domain/use_case/classified_useCases/get_classified_recommended_ads_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class ClassifiedViewModel extends ChangeNotifier {
  IClassified repo = inject<IClassified>();
  List<CategoriesResModel>? classifiedAllCategories = [];
  ClassifiedFilterModel? classifiedFilterData = ClassifiedFilterModel();
  Map<String, String>? classifiedFilterMap = {};
  List<String>? classifiedFilterList = [];

  changeClassifiedFilterMap(Map<String, String>? updatedClassifiedFilterMap) {
    classifiedFilterMap = updatedClassifiedFilterMap;
    d('MAP LENGTH : ${classifiedFilterMap!.length.toString()}');
    d('UPDATED CLASSIFIED FILTER MAP : $classifiedFilterMap');
    notifyListeners();
  }

  changeClassifiedFilters(ClassifiedFilterModel filterList) {
    classifiedFilterData = filterList;
    classifiedFilterList = [];
    if (classifiedFilterData!.category != null) {
      classifiedFilterList!.add(classifiedFilterData!.category.toString());
    }
    notifyListeners();
  }

  changeClassifiedFiltersList(List<String> updatedClassifiedFilterList) {
    classifiedFilterList = updatedClassifiedFilterList;
    d('UPDATED CLASSIFIED FILTER LIST : $classifiedFilterList');
    notifyListeners();
  }

  changeClassifiedAllCategories(
      List<CategoriesResModel> updatedClassifiedAllCategories) {
    classifiedAllCategories = updatedClassifiedAllCategories;
    d('UPDATED CLASSIFIED ALL CATEGORIES : ' +
        classifiedAllCategories.toString());
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedCategoriesResModel>>
      getAllClassifiedCategories() async {
    final getAllCat = GetAllClassifiedCategoryUseCase(repository: repo);
    final result = await getAllCat(NoParams());
    d('getAllClassifiedCategories : ' + result.toString());
    return result;
  }

  List<ClassifiedBrandsModel>? brandsBySubCategory = [];

  changeBrandsBySubCategory(
      List<ClassifiedBrandsModel> newBrandsBySubCategory) {
    brandsBySubCategory = newBrandsBySubCategory;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedBrandsResModel>> getBrandsBySubCategory(
      {required String subCategoryId}) async {
    final getBrandsBySubCat = GetBrandsBySubCategoriesUseCase(repo);
    final result =
        await getBrandsBySubCat(BrandsBySubCategoryEntities(subCategoryId: ""));
    d('GetBrandsBySubCategoriesUseCase : ' + result.toString());
    return result;
  }

  List<FilteredLimitModel>? classifiedFilteredLimits = [];

  changeClassifiedFilterLimits(
      List<FilteredLimitModel>? changedClassifiedFilteredLimits) {
    classifiedFilteredLimits = changedClassifiedFilteredLimits;
    notifyListeners();
  }

  Future<Either<Failure, FilteredLimitsResModel>> getClassifiedFilterLimits(
      {required String currencyId}) async {
    final getFilterLimits = GetClassifiedFilterLimitsUseCase(repo);
    final result =
        await getFilterLimits(FilterLimitsEntities(currencyId: currencyId));
    d('GetClassifiedFilterLimitsUseCase : ' + result.toString());
    return result;
  }

  List<ClassifiedProductModel>? classifiedFeaturedAds = [];

  changeClassifiedFeaturedAds(
      List<ClassifiedProductModel>? newClassifiedFeaturedAds) {
    classifiedFeaturedAds = newClassifiedFeaturedAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>>
      getClassifiedFeaturedAds() async {
    final getFeaturedAds = GetClassifiedFeaturedAdsUseCase(repository: repo);
    final result = await getFeaturedAds(NoParams());
    return result;
  }

  int allClassifiedPageNo = 1;

  changeAllClassifiedPageNo(int pageNo) {
    allClassifiedPageNo = pageNo;
    notifyListeners();
  }

  int allClassifiedTotalPages = 1;

  List<ClassifiedProductModel>? classifiedAllAds = [];

  changeClassifiedAllAds(List<ClassifiedProductModel>? newClassifiedAllAds) {
    classifiedAllAds = newClassifiedAllAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedAllAds(
      {int? pageNo}) async {
    final getAllAds = GetClassifiedAllAdsUseCase(repository: repo);
    // final result = await getAllAds(PageNoEntity(pageNo: pageNo ?? 1));
    final result = await getAllAds(PageNoEntity(pageNo));
    d('GetAllCategoriesAdsUseCase : ' + result.toString());
    return result;
  }

  List<ClassifiedProductModel>? classifiedDealAds = [];

  changeClassifiedDealAds(List<ClassifiedProductModel>? newClassifiedDealAds) {
    classifiedDealAds = newClassifiedDealAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedDealAds() async {
    final getFeaturedDeals = GetClassifiedDealAdsUseCase(repository: repo);
    final result = await getFeaturedDeals(NoParams());
    return result;
  }

  List<ClassifiedProductModel>? classifiedFilteredAds = [];

  changeClassifiedFilteredAds(
      List<ClassifiedProductModel>? newClassifiedFilteredAds) {
    classifiedFilteredAds = newClassifiedFilteredAds;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>>
      getClassifiedFilteredAds() async {
    final filteredAds = ClassifiedFilteredAdsUseCase(repo);
    final result = await filteredAds(ClassifiedFilterAdsEntities(
      categoryId: classifiedFilterData!.category,
      subCategoryId: classifiedFilterData!.subCategory,
      brandId: classifiedFilterData!.brand,
      condition: classifiedFilterData!.condition,
      currencyId: classifiedFilterData!.currency,
      maxPrice: classifiedFilterData!.maxPrice,
      minPrice: classifiedFilterData!.minPrice,
      title: classifiedFilterData!.title,
    ));
    return result;
  }

  List<BrandsModel>? classifiedFeaturedBrands = [];

  changeClassifiedFeaturedBrands(
      List<BrandsModel>? newClassifiedFeaturedBrands) {
    classifiedFeaturedBrands = newClassifiedFeaturedBrands;
    notifyListeners();
  }

  Future<Either<Failure, BrandsResModel>> getClassifiedFeaturedBrands() async {
    final getFeaturedBrands =
        GetClassifiedFeaturedBrandsUseCase(repository: repo);
    final result = await getFeaturedBrands(NoParams());
    return result;
  }

  List<ClassifiedProductModel>? classifiedRecommendedAds = [];

  changeClassifiedRecommendedAds(
      List<ClassifiedProductModel>? newClassifiedRecommendedAds) {
    classifiedRecommendedAds = newClassifiedRecommendedAds;
    notifyListeners();
  }

  List<ClassifiedProductModel> classifiedByCategory = [];

  changeClassifiedByCategory(
      List<ClassifiedProductModel> newClassifiedByCategory) {
    classifiedByCategory = newClassifiedByCategory;
    notifyListeners();
  }

  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedByCategory(
      {required String categoryId, String? sortedBy}) async {
    final classifiedAds = GetClassifiedByCategoryUseCase(repo);
    final result = await classifiedAds(
        IdWithSortedByEntities(id: categoryId, sortedBy: sortedBy));
    result.fold((l) {}, (r) {
      d('RESULT R : ${r.results}');
    });
    return result;
  }

  Future<Either<Failure, ClassifiedAdsResModel>>
      getClassifiedRecommendedAds() async {
    final getAds = GetClassifiedRecommendedAdsUseCase(repository: repo);
    final result = await getAds(NoParams());
    return result;
  }

  void classifiedActiveInactive({required String adId}) async {
    final activeInactive = ClassifiedActiveInactiveUseCase(repo);
    await activeInactive(IdEntities(id: adId));
  }

  void addFavClassified({required String adId}) async {
    final addFav = AddFavClassifiedUseCase(repo);
    await addFav(IdEntities(id: adId));
  }
}

class ClassifiedFilterModel {
  String? title;
  String? category;
  String? subCategory;
  String? brand;
  String? condition;
  String? currency;
  int? maxPrice;
  int? minPrice;
  int? page;

  ClassifiedFilterModel({
    this.category,
    this.subCategory,
    this.brand,
    this.condition,
    this.currency,
    this.minPrice,
    this.maxPrice,
    this.title,
    this.page,
  });
}
