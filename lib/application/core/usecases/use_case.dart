import 'package:equatable/equatable.dart';
import 'package:app/application/core/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params prams);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params prams);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}