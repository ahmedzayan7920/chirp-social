import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_elevated_button.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final UserModel currentUser;

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameFieldController = TextEditingController();
  late TextEditingController bioFieldController = TextEditingController();

  File? coverFile;
  File? profileFile;

  @override
  void initState() {
    nameFieldController = TextEditingController(text: widget.currentUser.name);
    bioFieldController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(currentUserDataProvider).value;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: Stack(
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: pickCoverImage,
                    child: coverFile != null
                        ? Image.file(coverFile!, fit: BoxFit.fitWidth)
                        : widget.currentUser.coverPicture.isEmpty
                            ? Container(color: AppColors.blueColor)
                            : CachedNetworkImage(imageUrl: widget.currentUser.coverPicture, fit: BoxFit.fitWidth),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: pickProfileImage,
                        child: CircleAvatar(
                          radius: 33,
                          backgroundColor: AppColors.whiteColor,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: profileFile != null
                                ? FileImage(profileFile!) as ImageProvider
                                : CachedNetworkImageProvider(widget.currentUser.profilePicture),
                          ),
                        ),
                      ),
                      CustomElevatedButton(
                        width: double.minPositive,
                        buttonText: AppStrings.save,
                        onPressed: () {
                          ref.read(userProfileControllerProvider.notifier).updateUserProfile(
                                userModel: widget.currentUser.copyWith(
                                  name: nameFieldController.text,
                                  bio: bioFieldController.text,
                                ),
                                context: context,
                                coverFile: coverFile,
                                profileFile: profileFile,
                              );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 30,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: nameFieldController,
              decoration: const InputDecoration(
                hintText: AppStrings.name,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: bioFieldController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: AppStrings.bio,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pickCoverImage() async {
    final file = await AppUtils.pickSingleImage();
    if (file != null) {
      coverFile = file;
      setState(() {});
    }
  }

  pickProfileImage() async {
    final file = await AppUtils.pickSingleImage();
    if (file != null) {
      profileFile = file;
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    bioFieldController.dispose();
    super.dispose();
  }
}
