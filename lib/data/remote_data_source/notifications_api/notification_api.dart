import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/network/client/iApiService.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/notification_models/notification_model.dart';
import 'package:app/data/remote_data_source/notifications_api/i_notification_api.dart';
import 'package:dio/dio.dart';

class NotificationApi implements INotificationApi {
  NotificationApi(IApiService api) : dio = api.get();
  Dio dio;

  @override
  Future<NotificationResModel> getNotifications(Map<String, dynamic> map) async {
    try {
      final responseData = await dio.get("", queryParameters: map);
      return NotificationResModel.fromJson(responseData.data);
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      throw ResponseException(msg: e.toString());
    }
  }
}
