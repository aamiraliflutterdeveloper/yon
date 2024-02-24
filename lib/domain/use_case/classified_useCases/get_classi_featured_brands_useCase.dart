import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/general_res_models/brands_res_models.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class GetClassifiedFeaturedBrandsUseCase implements UseCase<BrandsResModel, NoParams> {
  GetClassifiedFeaturedBrandsUseCase({required this.repository});

  IClassified repository;

  @override
  Future<Either<Failure, BrandsResModel>> call(NoParams prams) async => await repository.getClassifiedFeaturedBrands();
}
