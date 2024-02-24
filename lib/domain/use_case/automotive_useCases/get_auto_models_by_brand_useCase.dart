import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/automotive_models/brandModels_res_model.dart';
import 'package:app/domain/entities/automotive_entities/models_by_brand_useCase.dart';
import 'package:app/domain/repo_interface/automotive_repo/automotive_interface.dart';
import 'package:dartz/dartz.dart';

class GetAutoModelsByBrandUseCase implements UseCase<AutoBrandModelsResModel, ModelsByBrandEntities> {
  GetAutoModelsByBrandUseCase({required this.repository});

  IAutomotive repository;

  @override
  Future<Either<Failure, AutoBrandModelsResModel>> call(ModelsByBrandEntities prams) async => await repository.getAutomotiveModelsByBrand(prams.toMap());
}
