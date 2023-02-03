import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
     this.foregroundColor= AppColors.blueColor,
    required this.buttonText,
  });

  final void Function()? onPressed;
  final Color foregroundColor ;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
      ),
      child: Text(buttonText),
    );
  }
}