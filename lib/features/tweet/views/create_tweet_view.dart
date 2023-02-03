import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/core/constants/app_assets.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/core/constants/app_strings.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/core/widgets/custom_elevated_button.dart';
import 'package:twitter_clone/core/widgets/custom_loading.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controllers/tweet_controller.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  const CreateTweetView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final TextEditingController tweetFieldController = TextEditingController();
  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_outlined),
              iconSize: 30,
            ),
            actions: [
              CustomElevatedButton(
                buttonText: AppStrings.tweet,
                onPressed: shareTweet,
                width: double.minPositive,
                backgroundColor: AppColors.blueColor,
                foregroundColor: AppColors.whiteColor,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: currentUser?.profilePicture != null
                          ? CachedNetworkImageProvider(currentUser!.profilePicture)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: tweetFieldController,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: AppStrings.whatIsHappening,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
                CarouselSlider(
                  items: images.map((image) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: FileImage(image), fit: BoxFit.cover)),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 300,
                    enableInfiniteScroll: false,
                  ),
                ),
                const Spacer(),
                const Divider(
                  color: AppColors.greyColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: pickImages,
                      child: SvgPicture.asset(AppAssets.galleryIcon, width: 36),
                    ),
                    SvgPicture.asset(AppAssets.gifIcon, width: 36),
                    SvgPicture.asset(AppAssets.emojiIcon, width: 36),
                  ],
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.whiteColor.withOpacity(.1),
                child: const CustomLoading(),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  shareTweet() async {
    await ref.read(tweetControllerProvider.notifier).shareTweet(
          text: tweetFieldController.text,
          images: images,
          context: context,
          replayedToTweetId: "",
          replayedToUserId: "",
        );
    if (mounted) Navigator.pop(context);
  }

  void pickImages() async {
    images = await AppUtils.pickMultiImages();
    setState(() {});
  }

  @override
  void dispose() {
    tweetFieldController.dispose();
    super.dispose();
  }
}
