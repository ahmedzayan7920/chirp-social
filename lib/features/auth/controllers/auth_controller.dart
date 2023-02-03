import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/routes_manager.dart';

import '../../../apis/user_api.dart';
import '../../../core/utils.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  final authApi = ref.watch(authApiProvider);
  final userApi = ref.watch(userApiProvider);
  return AuthController(authApi: authApi, userApi: userApi);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUserAccount();
});

final userDataProvider = FutureProvider.family((ref, String id) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(id: id);
});

final currentUserDataProvider = FutureProvider((ref) {
  final id = ref.watch(currentUserAccountProvider).value!.$id;
  final userData = ref.watch(userDataProvider(id));
  return userData.value;
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;

  AuthController({
    required AuthApi authApi,
    required UserApi userApi,
  })  : _authApi = authApi,
        _userApi = userApi,
        super(false);

  signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authApi.signUp(email: email, password: password);
    state = false;
    result.fold(
      (failure) {
        AppUtils.showSnackBar(context: context, content: failure.message);
      },
      (account) {
        _saveUserData(email: email, id: account.$id, context: context);
      },
    );
  }

  _saveUserData({
    required String email,
    required String id,
    required BuildContext context,
  }) async {
    final result = await _userApi.saveUserData(userModel: UserModel.empty(email: email, id: id));
    result.fold(
      (failure) {
        AppUtils.showSnackBar(context: context, content: failure.message);
      },
      (_) async {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      },
    );
  }

  login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authApi.login(email: email, password: password);
    state = false;
    result.fold(
      (failure) {
        AppUtils.showSnackBar(context: context, content: failure.message);
      },
      (session) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      },
    );
  }

  Future<model.Account?> currentUserAccount() => _authApi.currentUserAccount();

  Future<UserModel> getUserData({required String id}) async {
      final document = await _userApi.getUserData(id: id);
      return UserModel.fromMap(document.data);

  }

  void logout({required BuildContext context})async{
    final result = await _authApi.logout();
    result.fold((l) => null, (r){
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signUp, (route) => false);
    },);
  }
}
