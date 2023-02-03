import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_write_constants.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_loading.dart';
import '../../../models/tweet_model.dart';
import '../../tweet/controllers/tweet_controller.dart';
import '../widgets/home_tweets_list_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
      data: (tweets) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: ref.watch(getLatestTweetProvider).when(
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
              }else if (data.events.contains(
                  "databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.update")) {
                final newTweet = TweetModel.fromMap(data.payload);
                final tweetIndex = tweets.indexWhere((element) => element.id == newTweet.id);
                tweets.removeAt(tweetIndex);
                tweets.insert(tweetIndex, newTweet);
              }
              return  HomeTweetsListView(tweets: tweets);
            },
            error: (error, stackTrace) => CustomError(error: error.toString()),
            loading: () {
              return  HomeTweetsListView(tweets: tweets);
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

