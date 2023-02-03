import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/constants/app_strings.dart';
import 'package:twitter_clone/core/error/failure.dart';
import 'package:twitter_clone/core/type_defs.dart';

import '../core/providers.dart';

final authApiProvider = Provider((ref) {
  final account = ref.watch(appWriteAccountProvider);
  return AuthApi(account: account);
});

abstract class IAuthApi {
  FutureEither<model.Account> signUp({required String email, required String password});

  FutureEither<model.Session> login({required String email, required String password});

  Future<model.Account?> currentUserAccount();

  FutureEitherVoid logout();
}

class AuthApi implements IAuthApi {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  @override
  FutureEither<model.Account> signUp({required String email, required String password}) async {
    try {
      final account = await _account.create(userId: ID.unique(), email: email, password: password);
      return Right(account);
    } on AppwriteException catch (error, stackTrace) {
      return Left(Failure(message: error.message ?? AppStrings.unExpectedError, stackTrace: stackTrace));
    } catch (error, stackTrace) {
      return Left(Failure(message: error.toString(), stackTrace: stackTrace));
    }
  }

  @override
  FutureEither<model.Session> login({required String email, required String password}) async {
    try {
      final session = await _account.createEmailSession(email: email, password: password);
      return Right(session);
    } on AppwriteException catch (error, stackTrace) {
      return Left(Failure(message: error.message ?? AppStrings.unExpectedError, stackTrace: stackTrace));
    } catch (error, stackTrace) {
      return Left(Failure(message: error.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      final account = await _account.get();
      return account;
    } catch (error) {
      return null;
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(sessionId: "current");
      return const Right(null);
    } on AppwriteException catch (error, stackTrace) {
      return Left(Failure(message: error.message ?? AppStrings.unExpectedError, stackTrace: stackTrace));
    } catch (error, stackTrace) {
      return Left(Failure(message: error.toString(), stackTrace: stackTrace));
    }
  }
}
