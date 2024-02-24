import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/models/properties_res_models/properties_categories_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/data/remote_data_source/properties_api/i_properties_api.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:dartz/dartz.dart';

class PropertiesRepo implements IProperties {
  PropertiesRepo({required this.api});

  IPropertiesApi api;

  @override
  Future<Either<Failure, PropertiesCategoriesResModel>> getPropertiesCategories() async {
    try {
      final result = await api.getAllPropertiesCategories();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, FilteredLimitsResModel>> getPropertiesFilterLimits(Map<String, dynamic> map) async {
    try {
      final result = await api.getPropertyFilterLimits(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getPropertyFeaturedAds() async {
    try {
      final result = await api.getPropertyFeaturedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getPropertyAllAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getPropertyAllAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getPropertyRecommendedAds() async {
    try {
      final result = await api.getPropertyRecommendedAds();
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getMyPropertyAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getMyPropertyAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> propertyActiveInactive(Map<String, dynamic> map) async {
    try {
      final result = await api.propertyActiveInactive(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteProperty(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteProperty(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getPropertyFilteredAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getPropertyFilteredAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> addFavProperty(Map<String, dynamic> map) async {
    try {
      final result = await api.addFavProperty(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, MessageResModel>> deleteFavProperty(Map<String, dynamic> map) async {
    try {
      final result = await api.deleteFavProperty(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getFavPropertyAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getFavPropertyAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getNearByPropertyAds(Map<String, dynamic> map) async {
    try {
      final result = await api.nearByPropertyAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }

  @override
  Future<Either<Failure, PropertyAdsResModel>> getPropertyByCategoryAds(Map<String, dynamic> map) async {
    try {
      final result = await api.getPropertyByCategoryAds(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
