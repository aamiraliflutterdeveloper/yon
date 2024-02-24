import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/business_module_models/get_business_profiles_models.dart';
import 'package:app/domain/repo_interface/business_repo/business_interface.dart';
import 'package:dartz/dartz.dart';

class GetMyBusinessProfilesUseCase implements UseCase<GetBusinessResModel, NoParams> {
  GetMyBusinessProfilesUseCase({required this.repository});

  IBusiness repository;

  @override
  Future<Either<Failure, GetBusinessResModel>> call(NoParams prams) async => await repository.getMyBusinessProfiles();
}
