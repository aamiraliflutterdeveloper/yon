import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_categories_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/data/models/message_model.dart';

abstract class IClassifiedApi {
  Future<ClassifiedCategoriesResModel> getAllClassifiedCategories();
  Future<FilteredLimitsResModel> getClassifiedFilterLimits(Map<String, dynamic> map);
  Future<ClassifiedBrandsResModel> getBrandsBySubCategory(Map<String, dynamic> map);
  Future<ClassifiedAdsResModel> getClassifiedFeaturedAds();
  Future<ClassifiedAdsResModel> getClassifiedAllAds(Map<String, dynamic> map);
  Future<ClassifiedAdsResModel> getClassifiedDealsAds();
  Future<ClassifiedAdsResModel> getRecommendedClassifiedAds();
  Future<ClassifiedAdsResModel> getMyClassifiedAds(Map<String, dynamic> map);
  Future<ClassifiedAdsResModel> getClassifiedByCategoryAds(Map<String, dynamic> map);
  Future<ClassifiedAdsResModel> getClassifiedFilteredAds(Map<String, dynamic> map);
  Future<ClassifiedAdsResModel> getFavClassifiedAds(Map<String, dynamic> map);
  Future<MessageResModel> classifiedActiveInactive(Map<String, dynamic> map);
  Future<MessageResModel> deleteClassified(Map<String, dynamic> map);
  Future<BrandsResModel> getClassifiedFeaturedBrands();
  Future<MessageResModel> addFavClassified(Map<String, dynamic> map);
  Future<MessageResModel> deleteFavClassified(Map<String, dynamic> map);
}
