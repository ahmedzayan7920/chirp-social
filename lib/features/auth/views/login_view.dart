import 'package:flutter/material.dart';
import 'package:twitter_clone/core/widgets/custom_app_bar.dart';
import 'package:twitter_clone/features/auth/widgets/login_view/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: LoginViewBody(),
    );
  }
}
