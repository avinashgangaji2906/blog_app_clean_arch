import 'package:blog_app_clean_arch/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPress;
  const AuthGradientButton(
      {super.key, required this.buttonName, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
          ], begin: Alignment.bottomLeft, end: Alignment.topRight),
          borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(390, 55),
              backgroundColor: AppPallete.transparentColor,
              shadowColor: AppPallete.transparentColor),
          child: Text(
            buttonName,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          )),
    );
  }
}
