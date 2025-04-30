import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSettingsTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        if (onSettingsTap != null)
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textWhite),
            onPressed: onSettingsTap,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
