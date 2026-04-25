import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool autofocus;

  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        suffixText: 'сум',
      ),
    );
  }
}
