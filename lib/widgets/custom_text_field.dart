import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isDarkBackground;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.isDarkBackground = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final textColor = widget.isDarkBackground ? Colors.white : Colors.white;
    final hintColor = widget.isDarkBackground ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.3);
    final borderColor = widget.isDarkBackground ? Colors.white.withValues(alpha: 0.1) : Colors.transparent;
    final fillColor = widget.isDarkBackground 
        ? Colors.white.withValues(alpha: 0.05) 
        : AppTheme.secondaryColor.withValues(alpha: 0.3);
    final labelColor = widget.isDarkBackground 
        ? AppTheme.secondaryColor.withValues(alpha: 0.6) 
        : Colors.white.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            isRtl ? widget.label : widget.label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: labelColor,
              letterSpacing: isRtl ? 0 : 2.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
            validator: widget.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: _isFocused ? fillColor.withValues(alpha: 0.1) : fillColor,
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(color: hintColor),
              errorStyle: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.error),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: _isFocused ? AppTheme.accentColor : hintColor,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: hintColor,
                      ),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.5)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
