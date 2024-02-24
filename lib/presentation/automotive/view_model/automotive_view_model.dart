import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/auto_all_brands_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_categories_res_model.dart';
import 'package:app/data/models/automotive_models/brandModels_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/model_objects/brands_model.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/automotive_entities/auto_filter_ads_entities.dart';
import 'package:app/domain/entities/automotive_entities/brands_by_id_entities.dart';
import 'package:app/domain/entities/automotive_entities/models_by_brand_useCase.dart';
import 'package:app/domain/entities/classified_entities/filter_limit_entities.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/entities/id_with_sort_entities.dart';
import 'package:app/domain/entities/lat_long_entities.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:app/domain/use_case/automotive_useCases/add_fav_auto_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/automotive_by_category_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/automotive_filtered_ads_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_all_auto_brands_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_all_automotive_ads.dart';
import 'package:app/domain/use_case/automotive_useCases/get_all_classified_cate_usecase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_auto_brands_by_id.dart';
import 'package:app/domain/use_case/automotive_useCases/get_auto_featured_ads_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_auto_featured_brands_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_auto_filter_limits_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/get_auto_models_by_brand_useCase.dart';
import 'package:app/domain/use_case/automotive_useCases/nearby_automotive_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class AutomotiveViewModel extends ChangeNotifier {
  IAutomotive repo = inject<IAutomotive>();
  List<CategoriesResModel>? automotiveAllCategories = [];
  AutomotiveFilterModel? automotiveFilterData = AutomotiveFilterModel();
  Map<String, String>? automotiveFilterMap = {};
  List<String>? automotiveFilterList = [];

  int autoAllAdsTotalPages = 1;
  int autoAllAdsPageNo = 1;

  changeAutoFilterMap(Map<String, String> updatedAutomotiveFilterMap) {
    automotiveFilterMap = updatedAutomotiveFilterMap;
    notifyListeners();
  }

  changeAutomotiveAllCategories(
      List<CategoriesResModel> updatedClassifiedAllCategories) {
    automotiveAllCategories = updatedClassifiedAllCategories;
    d('UPDATED AUTOMOTIVE ALL CATEGORIES : ' +
        automotiveAllCategories.toString());
    notifyListeners();
  }

  Future<Either<Failure, AutoMotiveCategoriesResModel>>
      getAllAutomotiveCategories() async {
    final getAllCat = GetAllAutomotiveCategoryUseCase(repository: repo);
    final result = await getAllCat(NoParams());
    d('getAllAutomotiveCategories : ' + result.toString());
    return result;
  }

  List<BrandModel>? automotiveFeaturedBrands = [];

  changeAutoFeaturedBrands(List<BrandModel> changedAutomotiveFeaturedBrands) {
    automotiveFeaturedBrands = changedAutomotiveFeaturedBrands;
    d('AUTOMOTIVE FEATURED BRANDS : ' +
        automotiveFeaturedBrands!.length.toString());
    notifyListeners();
  }

  Future<Either<Failure, AutoAllBrandsResModel>> getAutoFeaturedBrands() async {
    final getFeaturedBrands = GetAutoFeaturedBrandsUseCase(repository: repo);
    final result = await getFeaturedBrands(NoParams());
    d('GetAutoFeaturedBrandsUseCase : ' + result.toString());
    return result;
  }

  List<BrandModel>? automotiveAllBrands = [];

  changeAutoAllBrands(List<BrandModel> changedAutomotiveAllBrands) {
    automotiveAllBrands = changedAutomotiveAllBrands;
    d('AUTOMOTIVE ALL BRANDS : ' + automotiveAllBrands!.length.toString());
    notifyListeners();
  }

  Future<Either<Failure, AutoAllBrandsResModel>> getAutoAllBrands() async {
    final getAllBrands = GetAutoAllBrandsUseCase(repository: repo);
    final result = await getAllBrands(NoParams());
    d('GetAutoAllBrandsUseCase : ' + result.toString());
    return result;
  }

  List<FilteredLimitModel>? autoFilteredLimits = [];

  changeAutoFilterLimits(List<FilteredLimitModel>? changedAutoFilteredLimits) {
    autoFilteredLimits = changedAutoFilteredLimits;
    notifyListeners();
  }

  Future<Either<Failure, FilteredLimitsResModel>> getAutoFilterLimits(
      {required String currencyId}) async {
    final getFilterLimits = GetAutoFilterLimitsUseCase(repo);
    final result =
        await getFilterLimits(FilterLimitsEntities(currencyId: currencyId));
    d('GetAutoFilterLimitsUseCase : ' + result.toString());
    return result;
  }

  List<AutomotiveProductModel> nearByAutomotiveAds = [];

  changeNearByAutomotive(
      List<AutomotiveProductModel> updatedNearByAAutomotiveAds) {
    nearByAutomotiveAds = updatedNearByAAutomotiveAds;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>> getNearByAutomotiveAds(
      {required double latitude, required double longitude}) {
    final featuredProducts = GetNearByAutomotiveUseCase(repository: repo);
    final result = featuredProducts(
        LatLongEntities(latitude: latitude, longitude: longitude));
    d('GetNearByAutomotiveUseCase : ' + result.toString());
    return result;
  }

  List<AutomotiveProductModel>? automotiveFeaturedAds = [];

  changeAutomotiveFeaturedAds(
      List<AutomotiveProductModel>? newAutomotiveFeaturedAds) {
    automotiveFeaturedAds = newAutomotiveFeaturedAds;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>>
      getAutomotiveFeaturedProducts() {
    final featuredProducts = GetAutomotiveFeaturedAdsUseCase(repository: repo);
    final result = featuredProducts(NoParams());
    d('GetAutomotiveFeaturedAdsUseCase : ' + result.toString());
    return result;
  }

  List<AutomotiveProductModel> automotiveByCategory = [];

  changeAutomotiveByCategory(
      List<AutomotiveProductModel> newAutomotiveByCategory) {
    automotiveByCategory = newAutomotiveByCategory;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveByCategory(
      {String? categoryId, String? sortedBy}) async {
    final allProducts = GetAutomotiveAdsByCategoryUseCase(repository: repo);
    final result = await allProducts(
        IdWithSortedByEntities(id: categoryId, sortedBy: sortedBy));
    return result;
  }

  List<AutomotiveProductModel> automotiveAllAds = [];

  changeAutomotiveAllAds(List<AutomotiveProductModel> newAutomotiveAllAds) {
    automotiveAllAds = newAutomotiveAllAds;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveAllProducts(
      {String? sortedBy, int? pageNo}) async {
    final allProducts = GetAllAutomotiveAdsUseCase(repository: repo);
    final result = await allProducts(
        SortedByEntities(sortedBy: sortedBy, pageNo: pageNo ?? 1));
    d('GetAllAutomotiveAdsUseCase : ' + result.toString());
    return result;
  }

  List<AutomotiveProductModel> automotiveSortedAds = [];

  changeSortedAutomotiveAds(
      List<AutomotiveProductModel> newAutomotiveSortedAds) {
    automotiveSortedAds = newAutomotiveSortedAds;
    notifyListeners();
  }

  List<BrandModel>? automotiveBrands = [];

  List<String>? automotiveBrandsList = [];

  changeAutomotiveBrandsById(List<BrandModel> newAutomotiveBrandsById) {
    automotiveBrands = newAutomotiveBrandsById;
    automotiveBrandsList = [];
    for (int i = 0; i < automotiveBrands!.length; i++) {
      automotiveBrandsList!.add(automotiveBrands![i].title.toString());
    }
    notifyListeners();
  }

  Future<Either<Failure, AutoAllBrandsResModel>> getAutomotiveBrandsById(
      {String? categoryId, String? subCategoryId}) {
    final brands = GetAutoBrandsByIdUseCase(repository: repo);
    final result = brands(
      BrandsByIdEntities(
          categoryId: categoryId ?? '', subCategoryId: subCategoryId ?? ''),
    );
    d('GetAllAutomotiveAdsUseCase : ' + result.toString());
    print(result);
    return result;
  }

  List<BrandModelsModel>? automotiveModelsByBrand = [];

  List<String>? automotiveModelsByBrandList = [];

  changeAutomotiveModelsByBrand(
      List<BrandModelsModel> newAutomotiveModelsByBrand) {
    automotiveModelsByBrand = newAutomotiveModelsByBrand;
    automotiveModelsByBrandList = [];
    for (int i = 0; i < automotiveModelsByBrand!.length; i++) {
      automotiveModelsByBrandList!
          .add(automotiveModelsByBrand![i].title.toString());
    }
    notifyListeners();
  }

  Future<Either<Failure, AutoBrandModelsResModel>> getAutomotiveModelsByBrand(
      {required String brandId}) {
    final brandModels = GetAutoModelsByBrandUseCase(repository: repo);
    final result = brandModels(ModelsByBrandEntities(brandId: brandId));
    d('GetAutoModelsByBrandUseCase : ' + result.toString());
    return result;
  }

  void addFavAutomotive({required String adId}) async {
    final addFav = AddFavAutoUseCase(repo);
    await addFav(IdEntities(id: adId));
  }

  List<AutomotiveProductModel>? automotiveFilteredAds = [];

  changeClassifiedFilteredAds(
      List<AutomotiveProductModel>? newAutomotiveFilteredAds) {
    automotiveFilteredAds = newAutomotiveFilteredAds;
    notifyListeners();
  }

  Future<Either<Failure, AutomotiveAdsResModel>>
      getAutomotiveFilteredAds() async {
    final filteredAds = GetAutomotiveFilteredAdsUseCase(repository: repo);
    final result = await filteredAds(AutoFilteredAdsEntities(
      brandId: automotiveFilterData!.brandId,
      minPrice: automotiveFilterData!.minPrice,
      maxPrice: automotiveFilterData!.maxPrice,
      currencyId: automotiveFilterData!.currency,
      fuelType: automotiveFilterData!.fuelType,
      minKm: automotiveFilterData!.minKm,
      maxKm: automotiveFilterData!.maxKm,
      minYear: automotiveFilterData!.minYear,
      maxYear: automotiveFilterData!.maxYear,
      transmissionType: automotiveFilterData!.transmissionType,
    ));
    return result;
  }
}

class AutomotiveFilterModel {
  String? brandId;
  String? modelId;
  String? condition;
  String? currency;
  String? budgetLimit;
  int? maxPrice;
  int? minPrice;
  int? maxYear;
  int? minYear;
  String? yearLimit;
  int? minKm;
  int? maxKm;
  String? fuelType;
  String? transmissionType;
  int? page;

  AutomotiveFilterModel({
    this.condition,
    this.currency,
    this.minPrice,
    this.maxPrice,
    this.modelId,
    this.brandId,
    this.fuelType,
    this.transmissionType,
    this.budgetLimit,
    this.maxKm,
    this.maxYear,
    this.minKm,
    this.minYear,
    this.yearLimit,
    this.page,
  });
}
