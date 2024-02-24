import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_categories_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/data/models/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class IClassified {
  Future<Either<Failure, ClassifiedCategoriesResModel>> getClassifiedCategories();
  Future<Either<Failure, FilteredLimitsResModel>> getClassifiedFilterLimits(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedBrandsResModel>> getBrandsBySubCategory(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedFeaturedAds();
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedAllAds(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedAdsResModel>> getMyClassifiedAds(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedDealAds();
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedFilteredAds(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedByCategoryAds(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedAdsResModel>> getFavClassifiedAds(Map<String, dynamic> map);
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedRecommendedAds();
  Future<Either<Failure, BrandsResModel>> getClassifiedFeaturedBrands();
  Future<Either<Failure, MessageResModel>> classifiedActiveInactive(Map<String, dynamic> map);
  Future<Either<Failure, MessageResModel>> deleteClassified(Map<String, dynamic> map);
  Future<Either<Failure, MessageResModel>> deleteFavClassified(Map<String, dynamic> map);
  Future<Either<Failure, MessageResModel>> addFavClassified(Map<String, dynamic> map);
}
