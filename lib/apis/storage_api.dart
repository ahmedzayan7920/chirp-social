import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/constants/app_write_constants.dart';

import '../core/providers.dart';

final storageApiProvider = Provider((ref) {
  return StorageApi(storage: ref.watch(appWriteStorageProvider));
});

abstract class IStorageApi {
  Future<List<String>> uploadImages({required List<File> images});
}

class StorageApi implements IStorageApi {
  final Storage _storage;

  StorageApi({required Storage storage}) : _storage = storage;

  @override
  Future<List<String>> uploadImages({required List<File> images}) async {
      List<String> urls = [];
      for (final image in images) {
        final uploadedFile = await _storage.createFile(
          bucketId: AppWriteConstants.imagesBucketId,
          fileId: ID.unique(),
          file: InputFile(path: image.path),
        );
        urls.add(AppWriteConstants.imageUrl(imageId: uploadedFile.$id));
      }
      return urls;
  }
}
