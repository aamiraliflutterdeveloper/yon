

import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/domain/entities/classified_entities/filter_limit_entities.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class GetAutoFilterLimitsUseCase implements UseCase<FilteredLimitsResModel, FilterLimitsEntities> {
  GetAutoFilterLimitsUseCase(this.repository);

  final IAutomotive repository;

  @override
  Future<Either<Failure, FilteredLimitsResModel>> call(FilterLimitsEntities params) async => await repository.getAutomotiveFilterLimits(params.toMap());
}