import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/notification_type.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/notification/controllers/notification_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../auth/controllers/auth_controller.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetApi: ref.watch(tweetApiProvider),
    storageApi: ref.watch(storageApiProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id: id);
});
final getLatestTweetProvider = StreamProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getLatestTweet();
});

final getRepliesToTweetProvider = FutureProvider.family((ref, TweetModel tweet) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet: tweet);
});

final getTweetsByHashtagProvider = FutureProvider.family((ref, String hashtag) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetsByHashtag(hashtag: hashtag);
});

class TweetController extends StateNotifier<bool> {
  TweetController({
    required Ref ref,
    required TweetApi tweetApi,
    required StorageApi storageApi,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetApi = tweetApi,
        _storageApi = storageApi,
        _notificationController = notificationController,
        super(false);

  final Ref _ref;
  final TweetApi _tweetApi;
  final StorageApi _storageApi;
  final NotificationController _notificationController;

  Future<TweetModel> getTweetById({required String id}) async {
    final document = await _tweetApi.getTweetById(id: id);
    return TweetModel.fromMap(document.data);
  }

  likeTweet({required TweetModel tweet, required UserModel currentUser}) async {
    List<String> likes = tweet.likes;
    if (tweet.likes.contains(currentUser.id)) {
      likes.remove(currentUser.id);
    } else {
      likes.add(currentUser.id);
    }
    tweet = tweet.copyWith(likes: likes);
    final result = await _tweetApi.likeTweet(tweet: tweet);
    result.fold(
      (l) {},
      (r) {
        if (tweet.userId != currentUser.id && tweet.likes.contains(currentUser.id)) {
          _notificationController.createNotification(
            text: "${currentUser.name} Liked your tweet!",
            tweetId: tweet.id,
            receiverId: tweet.userId,
            type: NotificationType.like,
          );
        }
      },
    );
  }

  retweet({required TweetModel tweet, required UserModel currentUser, required BuildContext context}) async {
    tweet = tweet.copyWith(retweetCount: tweet.retweetCount + 1);
    final result1 = await _tweetApi.updateRetweetCount(tweet: tweet);
    result1.fold(
      (failure) {
        AppUtils.showSnackBar(context: context, content: failure.message);
      },
      (document) async {
        final newTweet = tweet.copyWith(
          likes: [],
          commentIds: [],
          id: ID.unique(),
          retweetCount: 0,
          retweetedBy: currentUser.name,
          tweetedAt: DateTime.now().millisecondsSinceEpoch,
        );
        final result2 = await _tweetApi.shareTweet(tweetModel: newTweet);
        result2.fold(
          (l) {},
          (r) {
            if (newTweet.userId != currentUser.id && newTweet.retweetedBy.isNotEmpty) {
              _notificationController.createNotification(
                text: "${currentUser.name} Retweeted your tweet!",
                tweetId: r.$id,
                receiverId: tweet.userId,
                type: NotificationType.retweet,
              );
            }
          },
        );
      },
    );
  }

  Stream<RealtimeMessage> getLatestTweet() {
    return _tweetApi.getLatestTweet();
  }

  Future<List<TweetModel>> getTweets() async {
    final documentList = await _tweetApi.getTweets();
    return documentList.map((document) => TweetModel.fromMap(document.data)).toList();
  }

  Future<List<TweetModel>> getRepliesToTweet({required TweetModel tweet}) async {
    final documentList = await _tweetApi.getRepliesToTweet(tweet: tweet);
    return documentList.map((document) => TweetModel.fromMap(document.data)).toList();
  }

  Future<List<TweetModel>> getTweetsByHashtag({required String hashtag}) async {
    final documentList = await _tweetApi.getTweetsByHashtag(hashtag: hashtag);
    return documentList.map((document) => TweetModel.fromMap(document.data)).toList();
  }

  shareTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
    required String replayedToTweetId,
    required String replayedToUserId,
  }) async {
    if (images.isNotEmpty) {
      await _shareImageTweet(
        text: text,
        images: images,
        context: context,
        replayedToTweetId: replayedToTweetId,
        replayedToUserId: replayedToUserId,
      );
    } else {
      if (text.isNotEmpty) {
        await _shareTextTweet(
          text: text,
          context: context,
          replayedToTweetId: replayedToTweetId,
          replayedToUserId: replayedToUserId,
        );
      } else {
        AppUtils.showSnackBar(context: context, content: "Please Enter Tweet Content");
      }
    }
  }

  _shareImageTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
    required String replayedToTweetId,
    required String replayedToUserId,
  }) async {
    state = true;
    final urls = await _storageApi.uploadImages(images: images);
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final currentUser = _ref.read(currentUserDataProvider).value;
    TweetModel tweetModel = TweetModel.newImage(
      userId: currentUser!.id,
      text: text,
      link: link,
      hashtags: hashtags,
      images: urls,
      replayedToTweetId: replayedToTweetId,
    );
    final result = await _tweetApi.shareTweet(tweetModel: tweetModel);
    state = false;
    result.fold(
      (failure) {
        AppUtils.showSnackBar(context: context, content: failure.message);
      },
      (document) {
        if (replayedToUserId != currentUser.id && replayedToUserId.isNotEmpty) {
          _notificationController.createNotification(
            text: "${currentUser.name} Replied to your tweet!",
            tweetId: document.$id,
            receiverId: replayedToUserId,
            type: NotificationType.retweet,
          );
        }
      },
    );
  }

  _shareTextTweet({
    required String text,
    required BuildContext context,
    required String replayedToTweetId,
    required String replayedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final currentUser = _ref.read(currentUserDataProvider).value;
    TweetModel tweetModel = TweetModel.newText(
      userId: currentUser!.id,
      text: text,
      link: link,
      hashtags: hashtags,
      replayedToTweetId: replayedToTweetId,
    );
    final result = await _tweetApi.shareTweet(tweetModel: tweetModel);
    state = false;
    result.fold(
      (failure) {
        AppUtils.showSnackBar(context: context, content: failure.message);
      },
      (document) {
        if (replayedToUserId != currentUser.id && replayedToUserId.isNotEmpty) {
          _notificationController.createNotification(
            text: "${currentUser.name} Replied to your tweet!",
            tweetId: document.$id,
            receiverId: replayedToUserId,
            type: NotificationType.retweet,
          );
        }
      },
    );
  }

  String _getLinkFromText(String text) {
    String link = "";
    final result = text.split(" ");
    for (String word in result) {
      if (word.startsWith("https://") || word.startsWith("www.")) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    final result = text.split(" ");
    for (String word in result) {
      if (word.startsWith("#")) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
