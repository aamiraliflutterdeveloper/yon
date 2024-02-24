import 'package:app/data/models/automotive_models/auto_all_brands_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_categories_res_model.dart';
import 'package:app/data/models/automotive_models/brandModels_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';

abstract class IAutomotiveApi {
  Future<AutoMotiveCategoriesResModel> getAllAutomotiveCategories();
  Future<AutoAllBrandsResModel> getAutoFeaturedBrands();
  Future<AutoAllBrandsResModel> getAutoAllBrands();
  Future<AutoAllBrandsResModel> getAutoBrandsById(Map<String, dynamic> map);
  Future<FilteredLimitsResModel> getAutomotiveFilterLimits(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getAutomotiveFeaturedAds();
  Future<AutomotiveAdsResModel> getAutomotiveRecommendedAds();
  Future<AutomotiveAdsResModel> getAutomotiveAllAds(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getAutomotiveByCategoryAds(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getNearByAutomotiveAds(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getMyAutomotiveAds(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getAutomotiveFilteredAds(Map<String, dynamic> map);
  Future<AutomotiveAdsResModel> getFavAutomotiveAds(Map<String, dynamic> map);
  Future<MessageResModel> automotiveActiveInactive(Map<String, dynamic> map);
  Future<MessageResModel> deleteAutomotive(Map<String, dynamic> map);
  Future<AutoBrandModelsResModel> getAutomotiveBrandModels(Map<String, dynamic> map);
  Future<MessageResModel> addFavAutomotive(Map<String, dynamic> map);
  Future<MessageResModel> deleteFavAutomotive(Map<String, dynamic> map);
}
