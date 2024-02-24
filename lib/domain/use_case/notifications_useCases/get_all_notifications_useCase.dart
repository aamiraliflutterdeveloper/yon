import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/notification_models/notification_model.dart';
import 'package:app/domain/entities/notifications_entities/get_all_noti_entities.dart';
import 'package:app/domain/repo_interface/notification_repo/notification_interface.dart';
import 'package:dartz/dartz.dart';

class GetAllNotificationsUseCase implements UseCase<NotificationResModel, GetNotificationEntities> {
  GetAllNotificationsUseCase(this.repository);
  final INotification repository;

  @override
  Future<Either<Failure, NotificationResModel>> call(GetNotificationEntities params) async => await repository.getNotifications(params.toMap());
}
