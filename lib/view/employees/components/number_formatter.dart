import 'package:flutter/services.dart';

class NumberFormatter extends TextInputFormatter {
  final int maxLength;
  final int decimalPlaces;

  NumberFormatter({
    this.maxLength = 255,
    this.decimalPlaces = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the input is empty, just return it as is
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove any non-digit and non-decimal point characters
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Ensure there is only one decimal point
    List<String> parts = cleanedText.split('.');
    if (parts.length > 2) {
      cleanedText = '${parts[0]}.${parts.sublist(1).join()}';
    }

    // Limit decimal places
    if (parts.length == 2 && parts[1].length > decimalPlaces) {
      cleanedText = '${parts[0]}.${parts[1].substring(0, decimalPlaces)}';
    }

    // Limit the total length including decimal point
    if (cleanedText.length > maxLength) {
      cleanedText = cleanedText.substring(0, maxLength);
    }

    // Create new text editing value with updated text and selection
    final newText = TextEditingValue(
      text: cleanedText,
      selection: TextSelection.collapsed(offset: cleanedText.length),
    );

    return newText;
  }
}
