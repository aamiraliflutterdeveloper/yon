import 'package:app/application/core/failure/failure.dart';
import 'package:app/data/models/notification_models/notification_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/domain/entities/notifications_entities/get_all_noti_entities.dart';
import 'package:app/domain/repo_interface/notification_repo/notification_interface.dart';
import 'package:app/domain/use_case/notifications_useCases/get_all_notifications_useCase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class NotificationViewModel extends ChangeNotifier {
  INotification notificationRepo = inject<INotification>();

  List<NotificationModel> notificationList = [];

  changeNotificationList(List<NotificationModel> newNotificationList) {
    notificationList = newNotificationList;
    notifyListeners();
  }

  Future<Either<Failure, NotificationResModel>> getAllNotifications() async {
    final notifications = GetAllNotificationsUseCase(notificationRepo);
    final result = await notifications(const GetNotificationEntities(device: 'mobile', page: 1));
    return result;
  }
}
