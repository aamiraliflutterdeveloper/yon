import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_filter_limits_res_model.dart';
import 'package:app/domain/entities/classified_entities/filter_limit_entities.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class GetClassifiedFilterLimitsUseCase implements UseCase<FilteredLimitsResModel, FilterLimitsEntities> {
  GetClassifiedFilterLimitsUseCase(this.repository);

  final IClassified repository;

  @override
  Future<Either<Failure, FilteredLimitsResModel>> call(FilterLimitsEntities params) async => await repository.getClassifiedFilterLimits(params.toMap());
}
