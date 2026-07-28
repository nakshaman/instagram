import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObsecureText;
  final TextInputType textInputType;

  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    this.isObsecureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
      ),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(16),
      ),
      keyboardType: textInputType,
      obscureText: isObsecureText,
    );
  }
}
