import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/properties_res_models/properties_categories_res_model.dart';
import 'package:app/domain/repo_interface/properties_repo/properties_interface.dart';
import 'package:dartz/dartz.dart';

class GetAllPropertiesCategoryUseCase implements UseCase<PropertiesCategoriesResModel, NoParams> {
  GetAllPropertiesCategoryUseCase({required this.repository});

  IProperties repository;

  @override
  Future<Either<Failure, PropertiesCategoriesResModel>> call(NoParams prams) async => await repository.getPropertiesCategories();
}
