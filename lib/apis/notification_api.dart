import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/notification_model.dart';

import '../core/constants/app_strings.dart';
import '../core/constants/app_write_constants.dart';
import '../core/error/failure.dart';

final notificationApiProvider = Provider((ref) {
  return NotificationApi(
    databases: ref.watch(appWriteDatabasesProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract class INotificationApi {
  FutureEitherVoid createNotification({required NotificationModel notification});

  Future<List<Document>> getUserNotifications({required String id});

  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationApi implements INotificationApi {
  final Databases _databases;
  final Realtime _realtime;

  NotificationApi({required Databases databases, required Realtime realtime})
      : _databases = databases,
        _realtime = realtime;

  @override
  FutureEitherVoid createNotification({required NotificationModel notification}) async {
    try {
      await _databases.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.notificationsCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );

      return const Right(null);
    } on AppwriteException catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.message ?? AppStrings.unExpectedError,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        Failure(
          message: error.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getUserNotifications({required String id}) async {
    final documentList = await _databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.notificationsCollectionId,
      queries: [
        Query.equal("receiverId", id),
      ],
    );
    return documentList.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      "databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.notificationsCollectionId}.documents",
    ]).stream;
  }
}
