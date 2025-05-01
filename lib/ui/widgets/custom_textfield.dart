import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? errorText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsets contentPadding;
  final VoidCallback? onTap;
  final bool readOnly;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.errorText,
    this.maxLength,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.onTap,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _hasFocus = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _hasFocus) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(_hasFocus ? 0.15 : 0.08),
                blurRadius: _hasFocus ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            validator: widget.validator,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.3, // Control the line height to prevent text going below
            ),
            minLines: 1,
            maxLines: widget.keyboardType == TextInputType.multiline ? 5 : 1,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 16,
              ),
              errorText: null, // Handle error text separately below
              counterText: "", // Hide the counter for maxLength
              isDense: true, // Make the field more compact
              alignLabelWithHint: true, // Align label properly
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                widget.prefixIcon,
                color: _hasFocus ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              suffixIcon: widget.obscureText
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              )
                  : widget.suffixIcon != null
                  ? IconButton(
                icon: Icon(
                  widget.suffixIcon,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: widget.onSuffixIconPressed,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              )
                  : null,
              contentPadding: widget.contentPadding,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: Color(0xFFEBEDEF), // Light gray border
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}