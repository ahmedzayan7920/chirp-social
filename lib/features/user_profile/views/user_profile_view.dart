import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/core/constants/app_strings.dart';
import 'package:twitter_clone/core/widgets/custom_elevated_button.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';
import 'package:twitter_clone/routes_manager.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_write_constants.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../core/widgets/custom_loading.dart';
import '../../../models/tweet_model.dart';
import '../../../models/user_model.dart';
import '../../tweet/controllers/tweet_controller.dart';
import '../../tweet/widgets/tweet_item.dart';
import '../widgets/follow_count.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel newUser = user;
    return Scaffold(
      body: ref.watch(getLatestUserDataProvider(user.id)).when(
            data: (data) {
              print(data.events);
              if (data.events.contains(
                  "databases.*.collections.${AppWriteConstants.usersCollectionId}.documents.${newUser.id}.update")) {
                print("in");
                newUser = UserModel.fromMap(data.payload);
              }
              return UserProfileViewBody(user: newUser);
            },
            error: (error, stackTrace) => CustomError(error: error.toString()),
            loading: () => UserProfileViewBody(user: newUser),
          ),
    );
  }
}

class UserProfileViewBody extends ConsumerWidget {
  const UserProfileViewBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            collapsedHeight: 150,
            expandedHeight: 150,
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: user.coverPicture.isEmpty
                      ? Container(color: AppColors.blueColor)
                      : CachedNetworkImage(imageUrl: user.coverPicture, fit: BoxFit.fitWidth),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 33,
                        backgroundColor: AppColors.whiteColor,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(user.profilePicture),
                        ),
                      ),
                      CustomElevatedButton(
                        width: double.minPositive,
                        buttonText: user.id == currentUser!.id
                            ? AppStrings.editProfile
                            : currentUser.followings.contains(user.id)
                                ? AppStrings.unfollow
                                : AppStrings.follow,
                        onPressed: () {
                          if (user.id == currentUser.id) {
                            Navigator.pushNamed(context, AppRoutes.editProfile, arguments: currentUser);
                          } else {
                            ref.read(userProfileControllerProvider.notifier).followUser(
                                  user: user,
                                  currentUser: currentUser,
                                  context: context,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (user.isVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: SvgPicture.asset(
                            AppAssets.verifiedIcon,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '@${user.name}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.greyColor,
                    ),
                  ),
                  Text(
                    user.bio,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FollowCount(
                        count: user.followings.length,
                        text: 'Following',
                      ),
                      const SizedBox(width: 15),
                      FollowCount(
                        count: user.followers.length,
                        text: 'Followers',
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Divider(color: AppColors.whiteColor),
                ],
              ),
            ),
          ),
        ];
      },
      body: ref.watch(getUserTweetsProvider(user.id)).when(
        data: (tweets) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ref.watch(getLatestTweetProvider).when(
                  skipError: true,
                  data: (data) {
                    if (data.events.contains(
                        "databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.create")) {
                      final newTweet = TweetModel.fromMap(data.payload);
                      if (newTweet.userId == user.id) {
                        bool isTweetExist = false;
                        for (final i in tweets) {
                          if (i.id == newTweet.id) {
                            isTweetExist = true;
                            break;
                          }
                        }
                        if (!isTweetExist) {
                          tweets.insert(0, newTweet);
                        }
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
    );
  }
}
