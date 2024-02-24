import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/model_objects/categories_res_object.dart';
import 'package:app/data/models/properties_res_models/properties_categories_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/classified_entities/filter_limit_entities.dart';
import 'package:app/domain/entities/id_entites.dart';
import 'package:app/domain/entities/id_with_sort_entities.dart';
import 'package:app/domain/entities/lat_long_entities.dart';
import 'package:app/domain/entities/property_entities/property-filter_ads_entities.dart';
import 'package:app/domain/entities/sorted_by_entities.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:app/domain/use_case/properties_useCases/add_fav_property_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/get_all_properties_cate_usecase.dart';
import 'package:app/domain/use_case/properties_useCases/get_nearby_property_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/get_properties_all_ads_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/get_properties_filter_limits_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/get_property_featured_ads_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/properties_by_category_useCase.dart';
import 'package:app/domain/use_case/properties_useCases/property_filtered_ads_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class PropertiesViewModel extends ChangeNotifier {
  IProperties repo = inject<IProperties>();
  List<CategoriesResModel>? propertiesAllCategories = [];
  PropertyFilterModel? propertyFilterData = PropertyFilterModel();
  Map<String, String>? propertyFilterMap = {};
  List<String>? propertyFilterList = [];

  int allPropertiesTotalPages = 1;

  int allPropertiesPageNo = 1;

  changePropertyFilterMap(Map<String, String>? newPropertyFilterMap) {
    propertyFilterMap = newPropertyFilterMap;
    notifyListeners();
  }

  changeClassifiedAllCategories(List<CategoriesResModel> updatedPropertiesAllCategories) {
    propertiesAllCategories = updatedPropertiesAllCategories;
    d('UPDATED PROPERTIES ALL CATEGORIES : ' + propertiesAllCategories.toString());
    notifyListeners();
  }

  Future<Either<Failure, PropertiesCategoriesResModel>> getAllPropertiesCategories() async {
    final getAllCat = GetAllPropertiesCategoryUseCase(repository: repo);
    final result = await getAllCat(NoParams());
    d('GetAllPropertiesCategoryUseCase : ' + result.toString());
    return result;
  }

  List<FilteredLimitModel>? propertiesFilteredLimits = [];

  changePropertiesFilterLimits(List<FilteredLimitModel>? changedPropertiesFilteredLimits) {
    propertiesFilteredLimits = changedPropertiesFilteredLimits;
    notifyListeners();
  }

  Future<Either<Failure, FilteredLimitsResModel>> getPropertiesFilterLimits({required String currencyId}) async {
    final getFilterLimits = GetPropertiesFilterLimitsUseCase(repo);
    final result = await getFilterLimits(FilterLimitsEntities(currencyId: currencyId));
    d('GetPropertiesFilterLimitsUseCase : ' + result.toString());
    return result;
  }

  List<PropertyProductModel> propertiesByCategory = [];
  changePropertiesByCategory(List<PropertyProductModel> newPropertiesByCategory) {
    propertiesByCategory = newPropertiesByCategory;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getPropertiesByCategory({required String categoryId, String? sortedBy}) async {
    final propertiesByCategory = GetPropertiesAdsByCategoryUseCase(repository: repo);
    final result = await propertiesByCategory(IdWithSortedByEntities(id: categoryId, sortedBy: sortedBy));
    d('GetPropertiesAdsByCategoryUseCase : ' + result.toString());
    return result;
  }

  List<PropertyProductModel>? propertyFeaturedAds = [];

  changePropertyFeaturedAds(List<PropertyProductModel>? newPropertyFeaturedAds) {
    propertyFeaturedAds = newPropertyFeaturedAds;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getPropertyFeaturedProducts() async {
    final featuredAds = GetPropertyFeaturedAdsUseCase(repository: repo);
    final result = await featuredAds(NoParams());
    d('GetPropertyFeaturedAdsUseCase : ' + result.toString());
    return result;
  }

  List<PropertyProductModel>? propertySortedAds = [];

  changePropertiesSortedAds(List<PropertyProductModel>? newPropertySortedAds) {
    propertySortedAds = newPropertySortedAds;
    notifyListeners();
  }

  List<PropertyProductModel>? propertyAllAds = [];

  changePropertiesAllAds(List<PropertyProductModel>? newPropertyAllAds) {
    propertyAllAds = newPropertyAllAds;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getPropertyAllProducts({String? sortedBy, int? pageNo}) async {
    final allAds = GetPropertyAllAdsUseCase(repository: repo);
    final result = await allAds(SortedByEntities(sortedBy: sortedBy, pageNo: pageNo ?? 1));
    d('GetPropertyAllAdsUseCase : ' + result.toString());
    return result;
  }

  List<PropertyProductModel> nearByProperties = [];

  changeNearByPropertiesAds(List<PropertyProductModel> updatedNearByProperties) {
    nearByProperties = updatedNearByProperties;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getNearByPropertyProducts({required double latitude, required double longitude}) async {
    final allAds = GetNearByPropertyAdsUseCase(repository: repo);
    final result = await allAds(LatLongEntities(longitude: longitude, latitude: latitude));
    d('GetNearByPropertyAdsUseCase : ' + result.toString());
    return result;
  }

  void addFavProperty({required String adId}) async {
    final addFav = AddFavPropertyUseCase(repo);
    await addFav(IdEntities(id: adId));
  }

  List<PropertyProductModel>? propertyFilteredAds = [];

  changeClassifiedFilteredAds(List<PropertyProductModel>? newPropertyFilteredAds) {
    propertyFilteredAds = newPropertyFilteredAds;
    notifyListeners();
  }

  Future<Either<Failure, PropertyAdsResModel>> getPropertyFilteredAds() async {
    final filteredAds = PropertyFilteredAdsUseCase(repository: repo);
    final result = await filteredAds(PropertyFilterAdsEntities(
      areaUnit: propertyFilterData!.areaUnit,
      maxArea: propertyFilterData!.maxArea,
      minArea: propertyFilterData!.minArea,
      minPrice: propertyFilterData!.minPrice,
      maxPrice: propertyFilterData!.maxPrice,
      currency: propertyFilterData!.currency,
      category: propertyFilterData!.type,
      bedrooms: propertyFilterData!.bedrooms,
      baths: propertyFilterData!.baths,
      furnished: propertyFilterData!.furnished,
    ));
    return result;
  }
}

class PropertyFilterModel {
  String? currency;
  int? maxPrice;
  int? minPrice;
  int? minArea;
  int? maxArea;
  String? areaUnit;
  String? type;
  int? bedrooms;
  int? baths;
  String? furnished;
  int? page;


  PropertyFilterModel({this.currency, this.minPrice, this.maxPrice, this.minArea, this.maxArea, this.areaUnit, this.type, this.bedrooms, this.baths, this.furnished, this.page});
}
