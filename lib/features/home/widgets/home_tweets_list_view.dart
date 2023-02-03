import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/tweet_model.dart';
import '../../tweet/widgets/tweet_item.dart';

class HomeTweetsListView extends StatelessWidget {
  const HomeTweetsListView({
    super.key,
    required this.tweets,
  });

  final List<TweetModel> tweets;

  @override
  Widget build(BuildContext context) {
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
  }
}