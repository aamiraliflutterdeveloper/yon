import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/notification_models/notification_model.dart';
import 'package:dartz/dartz.dart';

abstract class INotification {
  Future<Either<Failure, NotificationResModel>> getNotifications(Map<String, dynamic> map);
}
