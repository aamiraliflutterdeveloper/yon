

import 'package:app/application/core/failure/failure.dart';
import 'package:app/application/core/usecases/use_case.dart';
import 'package:app/data/models/classified_res_models/classified_brands_res_model.dart';
import 'package:app/domain/entities/classified_entities/brands_by_subCategory_entities.dart';
import 'package:app/domain/repo_interface/classified_repo_interface/classified_interface.dart';
import 'package:dartz/dartz.dart';

class GetBrandsBySubCategoriesUseCase implements UseCase<ClassifiedBrandsResModel, BrandsBySubCategoryEntities> {
  GetBrandsBySubCategoriesUseCase(this.repository);

  final IClassified repository;

  @override
  Future<Either<Failure, ClassifiedBrandsResModel>> call(BrandsBySubCategoryEntities params) async => await repository.getBrandsBySubCategory(params.toMap());
}