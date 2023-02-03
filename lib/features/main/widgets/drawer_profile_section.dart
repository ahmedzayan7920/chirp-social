import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/constants/app_colors.dart';
import 'package:twitter_clone/core/widgets/custom_error.dart';
import 'package:twitter_clone/core/widgets/custom_loading.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';

import '../../../core/constants/app_write_constants.dart';
import '../../../models/user_model.dart';
import '../../../routes_manager.dart';
import '../../user_profile/controllers/user_profile_controller.dart';

class DrawerProfileSection extends ConsumerWidget {
  const DrawerProfileSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserDataProvider).when(
          data: (currentUser) {
            if (currentUser != null) {
              return ref.watch(getLatestUserDataProvider(currentUser.id)).when(
                    data: (data) {
                      if (data.events.contains(
                          "databases.*.collections.${AppWriteConstants.usersCollectionId}.documents.${currentUser!.id}.update")) {
                        currentUser = UserModel.fromMap(data.payload);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.userProfile, arguments: currentUser);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.whiteColor,
                                radius: 50,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: CachedNetworkImageProvider(currentUser!.profilePicture),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentUser!.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) => CustomError(error: error.toString()),
                    loading: () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.userProfile, arguments: currentUser);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.whiteColor,
                              radius: 50,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: CachedNetworkImageProvider(currentUser!.profilePicture),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentUser!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
            }
            return const CustomLoading();
          },
          error: (error, stackTrace) => CustomError(error: error.toString()),
          loading: () => const CustomLoading(),
        );
  }
}
