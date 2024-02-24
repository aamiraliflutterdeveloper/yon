import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/auto_all_brands_res_model.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class GetAutoAllBrandsUseCase implements UseCase<AutoAllBrandsResModel, NoParams> {
  GetAutoAllBrandsUseCase({required this.repository});

  IAutomotive repository;

  @override
  Future<Either<Failure, AutoAllBrandsResModel>> call(NoParams prams) async => await repository.getAutoAllBrands();
}
