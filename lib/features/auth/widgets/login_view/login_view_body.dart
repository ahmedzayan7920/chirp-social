import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/widgets/login_or_sign_up_row.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../routes_manager.dart';
import 'login_view_form.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LoginViewForm(),
              const SizedBox(height: 16),
              LoginOrSignUpRow(
                labelText: AppStrings.doNotHaveAccount,
                buttonText: AppStrings.signUp,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signUp);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
