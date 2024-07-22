import 'package:blog_app_clean_arch/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppPallete.gradient2,
        strokeWidth: 1.5,
      ),
    );
  }
}
