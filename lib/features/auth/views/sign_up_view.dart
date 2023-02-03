import 'package:flutter/material.dart';
import 'package:twitter_clone/core/widgets/custom_app_bar.dart';
import 'package:twitter_clone/features/auth/widgets/sign_up_view/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SignUpViewBody(),
    );
  }
}
