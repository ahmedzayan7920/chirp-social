import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/core/constants/app_write_constants.dart';
import 'package:twitter_clone/core/widgets/custom_error.dart';
import 'package:twitter_clone/core/widgets/custom_loading.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_item.dart';

import '../../../models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
      data: (tweets) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: ref.watch(getLatestTweetProvider).when(
                skipError: true,
                data: (data) {
                  if (data.events.contains(
                      "databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.create")) {
                    final newTweet = TweetModel.fromMap(data.payload);
                    bool isTweetExist = false;
                    for(final i in tweets){
                      if (i.id == newTweet.id){
                        isTweetExist = true;
                        break;
                      }
                    }
                    if(!isTweetExist){
                      tweets.insert(0, newTweet);
                    }
                  } else if (data.events.contains(
                      "databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.update")) {
                    final newTweet = TweetModel.fromMap(data.payload);
                    final tweetIndex = tweets.indexWhere((element) => element.id == newTweet.id);
                    tweets.removeAt(tweetIndex);
                    tweets.insert(tweetIndex, newTweet);
                  }
                  return ListView.separated(
                    itemCount: tweets.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.greyColor,
                      height: 24,
                    ),
                    itemBuilder: (context, index) {
                      return TweetItem(tweet: tweets[index]);
                    },
                  );
                },
                error: (error, stackTrace) => CustomError(error: error.toString()),
                loading: () {
                  return ListView.separated(
                    itemCount: tweets.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.greyColor,
                      height: 24,
                    ),
                    itemBuilder: (context, index) {
                      return TweetItem(tweet: tweets[index]);
                    },
                  );
                },
              ),
        );
      },
      error: (error, stackTrace) {
        return CustomError(error: error.toString());
      },
      loading: () {
        return const CustomLoading();
      },
    );
  }
}
