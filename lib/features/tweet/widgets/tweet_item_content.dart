import 'package:timeago/timeago.dart' as timeago;
import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../models/tweet_model.dart';
import '../../../models/user_model.dart';
import '../../../routes_manager.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/tweet_controller.dart';
import 'hashtag_text.dart';
import 'tweet_carousel_slider.dart';
import 'tweet_icon_button.dart';

class TweetItemContent extends ConsumerWidget {
  const TweetItemContent({
    Key? key,
    required this.tweet,
    required this.tweetUser,
    required this.currentUser,
  }) : super(key: key);
  final TweetModel tweet;
  final UserModel tweetUser;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.tweetReplay, arguments: tweet);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.userProfile, arguments: tweetUser);
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(tweetUser.profilePicture),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tweet.retweetedBy.isNotEmpty
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.retweetIcon,
                            width: 20,
                            color: AppColors.greyColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "${tweet.retweetedBy} retweeted",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweetUser.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "@${tweetUser.name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                    Text(
                      " · ${timeago.format(DateTime.fromMillisecondsSinceEpoch(tweet.tweetedAt), locale: 'en_short')}",
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
                tweet.replayedToTweetId.isNotEmpty
                    ? ref.watch(getTweetByIdProvider(tweet.id)).when(
                          data: (repliedToTweet) {
                            final repliedToUser = ref.watch(userDataProvider(repliedToTweet.userId)).value;
                            return RichText(
                              text: TextSpan(
                                text: AppStrings.replyingTo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.greyColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "@${repliedToUser?.name}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blueColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          error: (error, stackTrace) => CustomError(error: error.toString()),
                          loading: () => const SizedBox.shrink(),
                        )
                    : const SizedBox.shrink(),
                tweet.text.isNotEmpty ? HashtagText(text: tweet.text) : const SizedBox.shrink(),
                tweet.images.isNotEmpty ? TweetCarouselSlider(images: tweet.images) : const SizedBox.shrink(),
                tweet.link.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: AnyLinkPreview(
                          link: tweet.link,
                          displayDirection: UIDirection.uiDirectionHorizontal,
                        ),
                      )
                    : const SizedBox.shrink(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TweetIconButton(
                      path: AppAssets.viewsIcon,
                      label: (tweet.commentIds.length + tweet.retweetCount + tweet.likes.length).toString(),
                      onTap: () {},
                    ),
                    TweetIconButton(
                      path: AppAssets.commentIcon,
                      label: tweet.commentIds.length.toString(),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.tweetReplay, arguments: tweet);
                      },
                    ),
                    TweetIconButton(
                      path: AppAssets.retweetIcon,
                      label: tweet.retweetCount.toString(),
                      onTap: () {
                        ref.read(tweetControllerProvider.notifier).retweet(
                              tweet: tweet,
                              currentUser: currentUser,
                              context: context,
                            );
                      },
                    ),
                    LikeButton(
                      size: 24,
                      isLiked: tweet.likes.contains(currentUser.id),
                      likeCount: tweet.likes.length,
                      onTap: (isLiked) async {
                        ref
                            .read(tweetControllerProvider.notifier)
                            .likeTweet(tweet: tweet, currentUser: currentUser);
                        return !isLiked;
                      },
                      likeBuilder: (isLiked) {
                        return isLiked
                            ? SvgPicture.asset(
                                AppAssets.likeFilledIcon,
                                color: AppColors.redColor,
                              )
                            : SvgPicture.asset(
                                AppAssets.likeOutlinedIcon,
                                color: AppColors.greyColor,
                              );
                      },
                      countBuilder: (likeCount, isLiked, text) {
                        return Text(
                          likeCount.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.greyColor,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      color: AppColors.greyColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
