import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/business_module_models/business_profile_stats_res_model.dart';
import 'package:app/domain/entities/module_entities.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:dartz/dartz.dart';

class GetBusinessStatsUseCase implements UseCase<BusinessStatsResModel, ModuleEntities> {
  GetBusinessStatsUseCase({required this.repository});

  IBusiness repository;

  @override
  Future<Either<Failure, BusinessStatsResModel>> call(ModuleEntities prams) async => await repository.getBusinessStats(prams.toMap());
}
