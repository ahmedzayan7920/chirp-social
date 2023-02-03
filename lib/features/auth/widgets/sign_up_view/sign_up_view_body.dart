import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/widgets/login_or_sign_up_row.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../routes_manager.dart';
import 'sign_up_view_form.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children:  [
              const SignUpViewForm(),
              const SizedBox(height: 16),
              LoginOrSignUpRow(
                labelText: AppStrings.alreadyHaveAccount,
                buttonText: AppStrings.login,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
