import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor = AppColors.whiteColor,
    this.foregroundColor = AppColors.backgroundColor,
    this.width = double.infinity,
  });

  final String buttonText;
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize:  Size(width, double.minPositive),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20)
      ),
      child: Text(buttonText),
    );
  }
}
