import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;
  final bool useGradient;
  final double borderRadius;
  final double elevation;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56.0,
    this.icon,
    this.useGradient = true,
    this.borderRadius = AppConstants.defaultBorderRadius,
    this.elevation = AppConstants.defaultElevation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius),
        shadowColor: AppColors.shadow,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: useGradient
                ? const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : null,
            color: useGradient ? null : backgroundColor ?? AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: MaterialButton(
            onPressed: isLoading ? null : onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: textColor ?? Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}