import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_categories_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/remote_data_source/classified_api/i_classified_api.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class ClassifiedRepo implements IClassified {
  ClassifiedRepo({required this.api});
  IClassifiedApi api;

  @override
  Future<Either<Failure, ClassifiedCategoriesResModel>> getClassifiedCategories() async {
    try {
      final result = await api.getAllClassifiedCategories();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, FilteredLimitsResModel>> getClassifiedFilterLimits(Map<String, dynamic> map) async {
    try {
      final result = await api.getClassifiedFilterLimits(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedBrandsResModel>> getBrandsBySubCategory(Map<String, dynamic> map) async {
    try {
      final result = await api.getBrandsBySubCategory(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedFeaturedAds() async {
    try {
      final result = await api.getClassifiedFeaturedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedDealAds() async {
    try {
      final result = await api.getClassifiedDealsAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, BrandsResModel>> getClassifiedFeaturedBrands() async {
    try {
      final result = await api.getClassifiedFeaturedBrands();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedAllAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getClassifiedAllAds(map);
      print("classified results $result");
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedRecommendedAds() async {
    try {
      final result = await api.getRecommendedClassifiedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getMyClassifiedAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyClassifiedAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> classifiedActiveInactive(Map<String, dynamic> map) async {
    try {
      final result = await api.classifiedActiveInactive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteClassified(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteClassified(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedFilteredAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getClassifiedFilteredAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> addFavClassified(Map<String, dynamic> map) async {
    try {
      final result = await api.addFavClassified(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteFavClassified(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteFavClassified(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getFavClassifiedAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getFavClassifiedAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, ClassifiedAdsResModel>> getClassifiedByCategoryAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getClassifiedByCategoryAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
    ;
  }
}
