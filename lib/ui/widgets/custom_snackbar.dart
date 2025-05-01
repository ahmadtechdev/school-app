import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class CustomSnackbar extends StatelessWidget {
  final String message;
  final String? title;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final Widget? actionButton;

  const CustomSnackbar({
    super.key,
    required this.message,
    this.title,
    this.backgroundColor = AppColors.info,
    this.textColor = Colors.white,
    this.icon,
    this.actionButton,
  });

  factory CustomSnackbar.success({
    required String message,
    String? title,
    Widget? actionButton,
  }) {
    return CustomSnackbar(
      message: message,
      title: title ?? 'Success',
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
      actionButton: actionButton,
    );
  }

  factory CustomSnackbar.error({
    required String message,
    String? title,
    Widget? actionButton,
  }) {
    return CustomSnackbar(
      message: message,
      title: title ?? 'Error',
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
      actionButton: actionButton,
    );
  }

  factory CustomSnackbar.warning({
    required String message,
    String? title,
    Widget? actionButton,
  }) {
    return CustomSnackbar(
      message: message,
      title: title ?? 'Warning',
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_outlined,
      actionButton: actionButton,
    );
  }

  factory CustomSnackbar.info({
    required String message,
    String? title,
    Widget? actionButton,
  }) {
    return CustomSnackbar(
      message: message,
      title: title ?? 'Info',
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
      actionButton: actionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: textColor,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (title != null) const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (actionButton != null) ...[
            const SizedBox(width: 8),
            actionButton!,
          ],
        ],
      ),
    );
  }
}