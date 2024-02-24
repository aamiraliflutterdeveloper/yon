import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:dartz/dartz.dart';

class GetAllCurrenciesUseCase implements UseCase<AllCurrenciesResModel, NoParams> {
  GetAllCurrenciesUseCase({required this.repository});

  IGeneral repository;

  @override
  Future<Either<Failure, AllCurrenciesResModel>> call(NoParams prams) async => await repository.getAllCurrencies();
}
