import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/automotive_models/auto_all_brands_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/automotive_models/automotive_categories_res_model.dart';
import 'package:app/data/models/automotive_models/brandModels_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/remote_data_source/automotive_api/i_automotive_api.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class AutomotiveRepo implements IAutomotive {
  AutomotiveRepo({required this.api});

  IAutomotiveApi api;

  @override
  Future<Either<Failure, AutoMotiveCategoriesResModel>> getAutomotiveCategories() async {
    try {
      final result = await api.getAllAutomotiveCategories();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutoAllBrandsResModel>> getAutoFeaturedBrands() async {
    try {
      final result = await api.getAutoFeaturedBrands();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutoAllBrandsResModel>> getAutoAllBrands() async {
    try {
      final result = await api.getAutoAllBrands();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, FilteredLimitsResModel>> getAutomotiveFilterLimits(Map<String, dynamic> map) async {
    try {
      final result = await api.getAutomotiveFilterLimits(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveFeaturedAds() async {
    try {
      final result = await api.getAutomotiveFeaturedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveAllAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getAutomotiveAllAds(map);
      print("automotive results $result");
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveRecommendedAds() async {
    try {
      final result = await api.getAutomotiveRecommendedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutoAllBrandsResModel>> getAutoBrandsById(Map<String, dynamic> map) async {
    try {
      final result = await api.getAutoBrandsById(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutoBrandModelsResModel>> getAutomotiveModelsByBrand(Map<String, dynamic> map) async {
    try {
      final result = await api.getAutomotiveBrandModels(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getMyAutomotiveAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyAutomotiveAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> automotiveActiveInactive(Map<String, dynamic> map) async {
    try {
      final result = await api.automotiveActiveInactive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteAutomotive(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteAutomotive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveFilteredAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getAutomotiveFilteredAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> addFavAutomotive(Map<String, dynamic> map) async {
    try {
      final result = await api.addFavAutomotive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteFavAutomotive(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteFavAutomotive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getFavAutomotiveAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getFavAutomotiveAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getAutomotiveByCategoryAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getAutomotiveByCategoryAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, AutomotiveAdsResModel>> getNearByAutomotiveAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getNearByAutomotiveAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
