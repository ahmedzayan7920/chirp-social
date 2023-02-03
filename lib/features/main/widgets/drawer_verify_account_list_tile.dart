import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/user_profile/controllers/user_profile_controller.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_write_constants.dart';
import '../../../core/widgets/custom_error.dart';
import '../../../models/user_model.dart';
import '../../auth/controllers/auth_controller.dart';

class DrawerVerifyAccountListTile extends ConsumerWidget {
  const DrawerVerifyAccountListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        // ref.read(authControllerProvider.notifier).logout(context: context);
      },
      leading: const Icon(
        Icons.verified_outlined,
        color: AppColors.whiteColor,
      ),
      title: const Text(AppStrings.verifyAccount, style: TextStyle(fontSize: 20)),
      trailing: ref.watch(currentUserDataProvider).when(
            data: (currentUser) {
              if (currentUser != null) {
                return ref.watch(getLatestUserDataProvider(currentUser.id)).when(
                      data: (data) {
                        if (data.events.contains(
                            "databases.*.collections.${AppWriteConstants.usersCollectionId}.documents.${currentUser!.id}.update")) {
                          currentUser = UserModel.fromMap(data.payload);
                        }
                        return Switch(
                          value: currentUser!.isVerified,
                          onChanged: (isVerified) {
                            currentUser = currentUser!.copyWith(isVerified: isVerified);
                            ref.read(userProfileControllerProvider.notifier).updateUserIsVerified(
                                  currentUser: currentUser!,
                                );
                          },
                        );
                      },
                      error: (error, stackTrace) => CustomError(error: error.toString()),
                      loading: () => Switch(
                        value: currentUser!.isVerified,
                        onChanged: (isVerified) {
                          currentUser = currentUser!.copyWith(isVerified: isVerified);
                          ref.read(userProfileControllerProvider.notifier).updateUserIsVerified(
                                currentUser: currentUser!,
                              );
                        },
                      ),
                    );
              }
              return null;
            },
            error: (error, stackTrace) => null,
            loading: () => null,
          ),
    );
  }
}
