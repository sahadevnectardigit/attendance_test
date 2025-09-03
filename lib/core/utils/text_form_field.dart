import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onToggleVisibility;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool enabled;
  final int? maxLines;
  final int? minLines;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onToggleVisibility,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.grey.shade600,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: enabled ? Color(0xFFF5F6FA) : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFFC8E6C9),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFF4CAF50),
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFFF44336),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFFF44336),
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        // Prefix Icon
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  prefixIcon,
                  color: enabled ? Color(0xFF4CAF50) : Colors.grey.shade400,
                  size: 22,
                ),
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        // Suffix Icon for password visibility
        suffixIcon: _buildSuffixIcon(),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16,
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xFF4CAF50),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: TextStyle(
          color: Color(0xFFF44336),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (onToggleVisibility != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Color(0xFF4CAF50),
            size: 22,
          ),
          onPressed: onToggleVisibility,
        ),
      );
    } else if (suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
          icon: Icon(
            suffixIcon,
            color: Color(0xFF4CAF50),
            size: 22,
          ),
          onPressed: onSuffixIconPressed,
        ),
      );
    }
    return null;
  }
}