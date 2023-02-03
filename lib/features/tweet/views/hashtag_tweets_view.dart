import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_loading.dart';
import '../widgets/tweet_item.dart';

class HashtagTweetsView extends ConsumerWidget {
  const HashtagTweetsView({
    Key? key,
    required this.hashtag,
  }) : super(key: key);

  final String hashtag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
        centerTitle: true,
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
        data: (tweets) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.separated(
              itemCount: tweets.length,
              separatorBuilder: (context, index) => const Divider(
                color: AppColors.greyColor,
                height: 24,
              ),
              itemBuilder: (context, index) {
                return TweetItem(tweet: tweets[index]);
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
      ),
    );
  }
}
