import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/constants/app_write_constants.dart';

final appWriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppWriteConstants.endPoint)
      .setProject(AppWriteConstants.projectId)
      .setSelfSigned(status: true);
});


final appWriteAccountProvider = Provider((ref){
  final client = ref.watch(appWriteClientProvider);
  return Account(client);
});

final appWriteDatabasesProvider = Provider((ref){
  final client = ref.watch(appWriteClientProvider);
  return Databases(client);
});

final appWriteStorageProvider = Provider((ref) {
  return Storage(ref.watch(appWriteClientProvider));
});
final appWriteRealtimeProvider = Provider((ref) {
  return Realtime(ref.watch(appWriteClientProvider));
});