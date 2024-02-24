import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/general_res_models/state_and_city_res_model.dart';
import 'package:app/domain/entities/general_entities/get_states_entities.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:dartz/dartz.dart';

class GetStatesUseCase implements UseCase<StateAndCityCodeResModel, GetStateEntities> {
  GetStatesUseCase({required this.repository});

  IGeneral repository;

  @override
  Future<Either<Failure, StateAndCityCodeResModel>> call(GetStateEntities prams) async => await repository.getStates(prams.toMap());
}
