import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/widgets/custom_loading.dart';
import 'package:twitter_clone/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/features/auth/widgets/auth_text_field.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_elevated_button.dart';

class LoginViewForm extends ConsumerStatefulWidget {
  const LoginViewForm({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginViewForm> createState() => _LoginViewFormState();
}

class _LoginViewFormState extends ConsumerState<LoginViewForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  login() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ref.read(authControllerProvider.notifier).login(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AuthTextField(
            controller: emailController,
            hintText: AppStrings.email,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "${AppStrings.email}${AppStrings.canNotBeEmpty}";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: passwordController,
            hintText: AppStrings.password,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "${AppStrings.password}${AppStrings.canNotBeEmpty}";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ref.watch(authControllerProvider)
              ? const CustomLoading()
              : CustomElevatedButton(
                  buttonText: AppStrings.login,
                  onPressed: login,
                ),
        ],
      ),
    );
  }
}
