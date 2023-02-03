import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/constants/app_strings.dart';
import 'package:twitter_clone/core/widgets/custom_elevated_button.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_item.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_write_constants.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_loading.dart';
import '../../auth/controllers/auth_controller.dart';

class TweetReplayView extends ConsumerStatefulWidget {
  const TweetReplayView({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  final TweetModel tweet;

  @override
  ConsumerState createState() => _TweetReplayViewState();
}

class _TweetReplayViewState extends ConsumerState<TweetReplayView> {
  TextEditingController replayFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tweet),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TweetItem(tweet: widget.tweet),
            const Divider(color: AppColors.greyColor, height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: currentUser?.profilePicture != null
                          ? CachedNetworkImageProvider(currentUser!.profilePicture)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: replayFieldController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Tweet you replay",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomElevatedButton(
                  width: double.minPositive,
                  buttonText: AppStrings.replay,
                  onPressed: () {
                    ref.read(tweetControllerProvider.notifier).shareTweet(
                          text: replayFieldController.text,
                          images: [],
                          context: context,
                          replayedToTweetId: widget.tweet.id,
                          replayedToUserId: widget.tweet.userId,
                        );
                    replayFieldController.clear();
                  },
                ),
              ],
            ),
            Expanded(
              child: ref.watch(getRepliesToTweetProvider(widget.tweet)).when(
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
                              if(!isTweetExist && newTweet.replayedToTweetId == widget.tweet.id){
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
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    replayFieldController.dispose();
    super.dispose();
  }
}
