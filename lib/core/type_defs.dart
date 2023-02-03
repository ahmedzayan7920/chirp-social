
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/error/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = Future<Either<Failure, void>>;