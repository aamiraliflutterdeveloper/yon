import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/models/properties_res_models/properties_categories_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:dartz/dartz.dart';

abstract class IProperties {
  Future<Either<Failure, PropertiesCategoriesResModel>> getPropertiesCategories();
  Future<Either<Failure, FilteredLimitsResModel>> getPropertiesFilterLimits(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getPropertyFeaturedAds();
  Future<Either<Failure, PropertyAdsResModel>> getPropertyAllAds(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getPropertyByCategoryAds(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getPropertyFilteredAds(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getNearByPropertyAds(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getFavPropertyAds(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getMyPropertyAds(Map<String, dynamic> map);
  Future<Either<Failure, PropertyAdsResModel>> getPropertyRecommendedAds();
  Future<Either<Failure, MessageResModel>> propertyActiveInactive(Map<String, dynamic> map);
  Future<Either<Failure, MessageResModel>> deleteProperty(Map<String, dynamic> map);
  Future<Either<Failure, MessageResModel>> deleteFavProperty(Map<String, dynamic> map);
  Future<Either<Failure, MessageResModel>> addFavProperty(Map<String, dynamic> map);
}
