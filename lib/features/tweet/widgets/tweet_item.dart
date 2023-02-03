import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../core/constants/app_write_constants.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_loading.dart';
import '../../user_profile/controllers/user_profile_controller.dart';
import 'tweet_item_content.dart';

class TweetItem extends ConsumerWidget {
  const TweetItem({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final TweetModel tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserDataProvider).when(
          data: (currentUser) {
            return ref.watch(userDataProvider(tweet.userId)).when(
              data: (tweetUser) {
                return ref.watch(getLatestUserDataProvider(tweetUser.id)).when(
                      data: (data) {
                        if (data.events.contains(
                            "databases.*.collections.${AppWriteConstants.usersCollectionId}.documents.${tweetUser.id}.update")) {
                          tweetUser = UserModel.fromMap(data.payload);
                        }
                        return TweetItemContent(
                            tweet: tweet, tweetUser: tweetUser, currentUser: currentUser!);
                      },
                      error: (error, stackTrace) => CustomError(error: error.toString()),
                      loading: () =>
                          TweetItemContent(tweet: tweet, tweetUser: tweetUser, currentUser: currentUser!),
                    );
              },
              error: (error, stackTrace) {
                return CustomError(error: error.toString());
              },
              loading: () {
                return const CustomLoading();
              },
            );
          },
          error: (error, stackTrace) => CustomError(error: error.toString()),
          loading: () => const CustomLoading(),
        );
  }
}

