import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/general_res_models/country_code_res_model.dart';
import 'package:app/domain/repo_interface/general_repo/general_interface.dart';
import 'package:dartz/dartz.dart';

class GetAllCountriesCodeUseCase implements UseCase<CountryCodeResModel, NoParams> {
  GetAllCountriesCodeUseCase({required this.repository});

  IGeneral repository;

  @override
  Future<Either<Failure, CountryCodeResModel>> call(NoParams prams) async => await repository.getCountiesCode();
}
