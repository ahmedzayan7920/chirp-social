import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/user_model.dart';

final searchControllerProvider = StateNotifierProvider((ref) {
  return SearchController(userApi: ref.watch(userApiProvider));
});

final searchUserByNameProvider = FutureProvider.family((ref, String name) async {
  final searchController = ref.watch(searchControllerProvider.notifier);
  return searchController.searchUserByName(name: name);
});

class SearchController extends StateNotifier<bool> {
  SearchController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  final UserApi _userApi;

  Future<List<UserModel>> searchUserByName({required String name}) async {
    final documents = await _userApi.searchUserByName(name: name);
    return documents.map((document) => UserModel.fromMap(document.data)).toList();
  }
}
