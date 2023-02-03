import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/constants/app_write_constants.dart';
import 'package:twitter_clone/core/error/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../core/constants/app_strings.dart';

final tweetApiProvider = Provider((ref) {
  return TweetApi(
    databases: ref.watch(appWriteDatabasesProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract class ITweetApi {
  FutureEither<Document> shareTweet({required TweetModel tweetModel});

  Future<List<Document>> getTweets();

  Stream<RealtimeMessage> getLatestTweet();

  FutureEither<Document> likeTweet({required TweetModel tweet});

  FutureEither<Document> updateRetweetCount({required TweetModel tweet});

  Future<List<Document>> getRepliesToTweet({required TweetModel tweet});

  Future<Document> getTweetById({required String id});

  Future<List<Document>> getUserTweets({required String id});
  Future<List<Document>> getTweetsByHashtag({required String hashtag});
}

class TweetApi implements ITweetApi {
  final Databases _databases;
  final Realtime _realtime;

  TweetApi({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTweet({required TweetModel tweetModel}) async {
    try {
      final document = await _databases.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweetModel.toMap(),
      );

      return Right(document);
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
  Future<List<Document>> getTweets() async {
    final documentList = await _databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.orderDesc("tweetedAt"),
      ],
    );
    return documentList.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      "databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollectionId}.documents",
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet({required TweetModel tweet}) async {
    try {
      final document = await _databases.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          "likes": tweet.likes,
        },
      );
      return Right(document);
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
  FutureEither<Document> updateRetweetCount({required TweetModel tweet}) async {
    try {
      final document = await _databases.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          "retweetCount": tweet.retweetCount,
        },
      );
      return Right(document);
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
  Future<List<Document>> getRepliesToTweet({required TweetModel tweet}) async {
    final document = await _databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.equal("replayedToTweetId", tweet.id),
        Query.orderDesc("tweetedAt"),
      ],
    );

    return document.documents;
  }

  @override
  Future<Document> getTweetById({required String id}) async {
    return await _databases.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserTweets({required String id}) async {
    final documentList = await _databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.equal("userId", id),
        Query.orderDesc("tweetedAt"),
      ],
    );
    return documentList.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashtag({required String hashtag}) async {
    final documentList = await _databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [
        Query.search("hashtags", hashtag),
      ],
    );
    return documentList.documents;
  }
}
