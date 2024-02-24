import 'package:app/data/models/search_models/search_ads_res_model.dart';
import 'package:app/data/models/search_models/suggested_ads_res_model.dart';

abstract class ISearchApi {
  Future<AllAdsResModel> getSearchedAds(Map<String, dynamic> map);
  Future<SuggestedAdsResModel> getSuggestedAds(Map<String, dynamic> map);
}
