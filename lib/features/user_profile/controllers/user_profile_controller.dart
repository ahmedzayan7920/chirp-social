import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/features/notification/controllers/notification_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../core/enums/notification_type.dart';
import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(
    tweetApi: ref.watch(tweetApiProvider),
    userApi: ref.watch(userApiProvider),
    storageApi: ref.watch(storageApiProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier)
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String id) async {
  final userProfileController = ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(id: id);
});

final getLatestUserDataProvider = StreamProvider.family((ref, String id) {
  final userProfileController = ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getLatestUserData(id: id);
});

class UserProfileController extends StateNotifier<bool> {
  UserProfileController({
    required TweetApi tweetApi,
    required UserApi userApi,
    required StorageApi storageApi,
    required NotificationController notificationController,
  })  : _tweetApi = tweetApi,
        _userApi = userApi,
        _storageApi = storageApi,
        _notificationController = notificationController,
        super(false);

  final TweetApi _tweetApi;
  final UserApi _userApi;
  final StorageApi _storageApi;
  final NotificationController _notificationController;

  Future<List<TweetModel>> getUserTweets({required String id}) async {
    final documents = await _tweetApi.getUserTweets(id: id);
    return documents.map((document) => TweetModel.fromMap(document.data)).toList();
  }

  updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? coverFile,
    required File? profileFile,
  }) async {
    state = true;
    if (coverFile != null) {
      final coverUrl = await _storageApi.uploadImages(images: [coverFile]);
      userModel = userModel.copyWith(
        coverPicture: coverUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageApi.uploadImages(images: [profileFile]);
      userModel = userModel.copyWith(
        profilePicture: profileUrl[0],
      );
    }

    final res = await _userApi.updateUserData(userModel: userModel);
    state = false;
    res.fold(
      (failure) => AppUtils.showSnackBar(context: context, content: failure.message),
      (r) => Navigator.pop(context),
    );
  }

  updateUserIsVerified({
    required UserModel currentUser,
  }) async {
     await _userApi.updateUserData(userModel: currentUser);
  }

  Stream<RealtimeMessage> getLatestUserData({required String id}) {
    return _userApi.getLatestUserData(id: id);
  }

  followUser({
    required UserModel user,
    required UserModel currentUser,
    required BuildContext context,
  }) async {
    if (currentUser.followings.contains(user.id)) {
      currentUser.followings.remove(user.id);
      user.followers.remove(currentUser.id);
    } else {
      currentUser.followings.add(user.id);
      user.followers.add(currentUser.id);
    }
    final result1 = await _userApi.updateUserData(userModel: currentUser);
    result1.fold(
      (l) => AppUtils.showSnackBar(context: context, content: l.message),
      (r) async {
        final result2 = await _userApi.updateUserData(userModel: user);
        result2.fold(
          (l) => AppUtils.showSnackBar(context: context, content: l.message),
          (r) {
            if (currentUser.followings.contains(user.id)) {
              _notificationController.createNotification(
                text: "${currentUser.name} Followed you!",
                tweetId: "",
                receiverId: user.id,
                type: NotificationType.follow,
              );
            }
          },
        );
      },
    );
  }
}
