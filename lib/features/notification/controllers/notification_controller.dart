import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/enums/notification_type.dart';

import '../../../apis/notification_api.dart';
import '../../../models/notification_model.dart';

final notificationControllerProvider = StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(notificationApi: ref.watch(notificationApiProvider));
});



final getUserNotificationsProvider = FutureProvider.family((ref, String id) {
  final notificationController = ref.watch(notificationControllerProvider.notifier);
  return notificationController.getUserNotifications(id: id);
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationController = ref.watch(notificationControllerProvider.notifier);
  return notificationController.getLatestNotification();
});

class NotificationController extends StateNotifier<bool> {
  NotificationController({
    required NotificationApi notificationApi,
  })  : _notificationApi = notificationApi,
        super(false);
  final NotificationApi _notificationApi;

  createNotification({
    required String text,
    required String tweetId,
    required String receiverId,
    required NotificationType type,
  }) async {
    NotificationModel notification = NotificationModel(
      id: "",
      text: text,
      tweetId: tweetId,
      receiverId: receiverId,
      type: type,
    );
    await _notificationApi.createNotification(notification: notification);
  }

  Stream<RealtimeMessage> getLatestNotification() {
    return _notificationApi.getLatestNotification();
  }

  Future<List<NotificationModel>> getUserNotifications({required String id}) async {
    final documentList = await _notificationApi.getUserNotifications(id: id);
    return documentList.map((document) => NotificationModel.fromMap(document.data)).toList();
  }
}
