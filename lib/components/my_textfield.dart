import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isPasswordField;
  final IconData? prefixIcon;
  final String labelText;
  final String? Function(String?)? validator;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.labelText,
    this.isPasswordField = false,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Access the theme
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText:
            widget.isPasswordField ? !isPasswordVisible : widget.obscureText,
        style: textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.onBackground), // Text color
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: theme.colorScheme.onSurface)
              : null, // Add prefixIcon
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: theme.colorScheme.outline, // Dynamic border color
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: theme.colorScheme.primary, // Focused border color
            ),
          ),
          fillColor: theme.colorScheme.surface, // Dynamic background color
          filled: true,
          hintText: widget.hintText,
          hintStyle: textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface), // Hint color
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: theme.colorScheme.onSurface, // Icon color
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
