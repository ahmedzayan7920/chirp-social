import 'package:flutter/material.dart';

import '../../../core/widgets/custom_text_button.dart';

class LoginOrSignUpRow extends StatelessWidget {
  const LoginOrSignUpRow({
    Key? key,
    required this.labelText,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(labelText),
        CustomTextButton(onPressed: onPressed, buttonText: buttonText),
      ],
    );
  }
}


