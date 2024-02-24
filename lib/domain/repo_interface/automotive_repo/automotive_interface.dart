import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/automotive_models/auto_all_brands_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_categories_res_model.dart';
import 'package:app/data/models/automotive_models/brandModels_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class IAutomotive {
  Future<Either<Failure, AutoMotiveCategoriesResModel>> getAutomotiveCategories();

  Future<Either<Failure, AutoAllBrandsResModel>> getAutoFeaturedBrands();

  Future<Either<Failure, AutoAllBrandsResModel>> getAutoAllBrands();

  Future<Either<Failure, AutoAllBrandsResModel>> getAutoBrandsById(Map<String, dynamic> map);

  Future<Either<Failure, FilteredLimitsResModel>> getAutomotiveFilterLimits(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveByCategoryAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getNearByAutomotiveAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveFeaturedAds();

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveFilteredAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getFavAutomotiveAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveAllAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getMyAutomotiveAds(Map<String, dynamic> map);

  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveRecommendedAds();

  Future<Either<Failure, AutoBrandModelsResModel>> getAutomotiveModelsByBrand(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> automotiveActiveInactive(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> deleteAutomotive(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> deleteFavAutomotive(Map<String, dynamic> map);

  Future<Either<Failure, MessageResModel>> addFavAutomotive(Map<String, dynamic> map);
}
