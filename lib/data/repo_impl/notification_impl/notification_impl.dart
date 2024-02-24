import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/network/error_handlers/error_handler.dart';
import 'package:app/data/models/notification_models/notification_model.dart';
import 'package:app/data/remote_data_source/notifications_api/i_notification_api.dart';
import 'package:app/domain/repo_interface/notification_repo/notification_interface.dart';
import 'package:dartz/dartz.dart';

class NotificationRepo implements INotification {
  NotificationRepo({required this.api});
  INotificationApi api;

  @override
  Future<Either<Failure, NotificationResModel>> getNotifications(Map<String, dynamic> map) async {
    try {
      final result = await api.getNotifications(map);
      return Right(result);
    } catch (e) {
      return Left(getFailure(e as Exception));
    }
  }
}
