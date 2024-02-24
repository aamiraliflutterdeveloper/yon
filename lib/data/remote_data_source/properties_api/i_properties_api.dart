import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/models/properties_res_models/properties_categories_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';

abstract class IPropertiesApi {
  Future<PropertiesCategoriesResModel> getAllPropertiesCategories();
  Future<FilteredLimitsResModel> getPropertyFilterLimits(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getPropertyFeaturedAds();
  Future<PropertyAdsResModel> getPropertyAllAds(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getPropertyByCategoryAds(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getMyPropertyAds(Map<String, dynamic> map);
  Future<PropertyAdsResModel> nearByPropertyAds(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getPropertyFilteredAds(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getFavPropertyAds(Map<String, dynamic> map);
  Future<MessageResModel> propertyActiveInactive(Map<String, dynamic> map);
  Future<MessageResModel> deleteProperty(Map<String, dynamic> map);
  Future<PropertyAdsResModel> getPropertyRecommendedAds();
  Future<MessageResModel> deleteFavProperty(Map<String, dynamic> map);
  Future<MessageResModel> addFavProperty(Map<String, dynamic> map);
}
