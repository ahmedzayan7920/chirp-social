import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/widgets/custom_error.dart';
import 'package:twitter_clone/core/widgets/custom_loading.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/notification/controllers/notification_controller.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_write_constants.dart';
import '../../../models/notification_model.dart';
import '../widgets/notification_item.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserDataProvider).when(
          data: (currentUser) {
            return currentUser == null
                ? const CustomLoading()
                : ref.watch(getUserNotificationsProvider(currentUser.id)).when(
                      data: (notifications) {
                        return ref.watch(getLatestNotificationProvider).when(
                              skipError: true,
                              data: (data) {
                                if (data.events.contains(
                                    "databases.*.collections.${AppWriteConstants.notificationsCollectionId}.documents.*.create")) {
                                  final newNotification = NotificationModel.fromMap(data.payload);
                                  if (newNotification.receiverId == currentUser.id) {
                                    bool isNotificationExist = false;
                                    for (final i in notifications) {
                                      if (i.id == newNotification.id) {
                                        isNotificationExist = true;
                                        break;
                                      }
                                    }
                                    if (!isNotificationExist) {
                                      notifications.insert(0, newNotification);
                                    }
                                  }
                                }
                                return ListView.separated(
                                  itemCount: notifications.length,
                                  separatorBuilder: (context, index) => const Divider(
                                    color: AppColors.greyColor,
                                    height: 24,
                                  ),
                                  itemBuilder: (context, index) {
                                    return NotificationItem(notification: notifications[index]);
                                  },
                                );
                              },
                              error: (error, stackTrace) => CustomError(error: error.toString()),
                              loading: () {
                                return ListView.separated(
                                  itemCount: notifications.length,
                                  separatorBuilder: (context, index) => const Divider(
                                    color: AppColors.greyColor,
                                    height: 24,
                                  ),
                                  itemBuilder: (context, index) {
                                    return NotificationItem(notification: notifications[index]);
                                  },
                                );
                              },
                            );
                      },
                      error: (error, stackTrace) => CustomError(error: error.toString()),
                      loading: () => const CustomLoading(),
                    );
          },
          error: (error, stackTrace) => CustomError(error: error.toString()),
          loading: () => const CustomLoading(),
        );
  }
}
