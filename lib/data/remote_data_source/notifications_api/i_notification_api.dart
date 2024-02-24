import 'package:app/data/models/notification_models/notification_model.dart';

abstract class INotificationApi {
  Future<NotificationResModel> getNotifications(Map<String, dynamic> map);
}
