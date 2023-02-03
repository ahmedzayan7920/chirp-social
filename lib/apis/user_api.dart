import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/constants/app_write_constants.dart';
import 'package:twitter_clone/core/error/failure.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../core/constants/app_strings.dart';
import '../core/providers.dart';

final userApiProvider = Provider((ref) {
  return UserApi(
    databases: ref.watch(appWriteDatabasesProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract class IUserApi {
  FutureEitherVoid saveUserData({required UserModel userModel});

  Future<model.Document> getUserData({required String id});

  Future<List<model.Document>> searchUserByName({required String name});

  FutureEitherVoid updateUserData({required UserModel userModel});

  Stream<RealtimeMessage> getLatestUserData({required String id});

  FutureEitherVoid updateUserIsVerified({required UserModel userModel});
}

class UserApi implements IUserApi {
  final Databases _databases;
  final Realtime _realtime;

  UserApi({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUserData({required UserModel userModel}) async {
    try {
      await _databases.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollectionId,
        documentId: userModel.id,
        data: userModel.toMap(),
      );
      return const Right(null);
    } on AppwriteException catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.message ?? AppStrings.unExpectedError,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<model.Document> getUserData({required String id}) async {
    return await _databases.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.usersCollectionId,
      documentId: id,
    );
  }

  @override
  Future<List<model.Document>> searchUserByName({required String name}) async {
    final document = await _databases.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollectionId,
        queries: [
          Query.search("name", name),
        ]);
    return document.documents;
  }

  @override
  FutureEitherVoid updateUserData({required UserModel userModel}) async {
    try {
      await _databases.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollectionId,
        documentId: userModel.id,
        data: userModel.toMap(),
      );
      return const Right(null);
    } on AppwriteException catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.message ?? AppStrings.unExpectedError,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  FutureEitherVoid updateUserIsVerified({required UserModel userModel}) async {
    try {
      await _databases.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollectionId,
        documentId: userModel.id,
        data: {
          "isVerified" : userModel.isVerified,
        },
      );
      return const Right(null);
    } on AppwriteException catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.message ?? AppStrings.unExpectedError,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserData({required String id}) {
    return _realtime.subscribe([
      "databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.usersCollectionId}.documents.$id",
    ]).stream;
  }
}
