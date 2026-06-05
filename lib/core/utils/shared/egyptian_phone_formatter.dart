import 'package:flutter/services.dart';

class EgyptianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 1. Get the raw numbers (remove anything that isn't a digit)
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 2. Prevent typing more than 11 numbers (Egyptian format length)
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    // 3. Add the spaces at the correct positions: 0 100 123 4567
    String formattedText = '';
    for (int i = 0; i < digits.length; i++) {
      // Add a space before the 2nd, 5th, and 8th digits
      if (i == 1 || i == 4 || i == 7) {
        formattedText += ' ';
      }
      formattedText += digits[i];
    }

    // 4. Calculate where the blinking cursor should go
    int cursorPosition = formattedText.length;

    // This part ensures the cursor stays in the right place if the user edits the middle of the number
    if (newValue.selection.end < newValue.text.length) {
      int digitsBeforeCursor = newValue.text
          .substring(0, newValue.selection.end)
          .replaceAll(RegExp(r'\D'), '')
          .length;

      cursorPosition = digitsBeforeCursor;
      if (digitsBeforeCursor > 1) cursorPosition++; // Account for 1st space
      if (digitsBeforeCursor > 4) cursorPosition++; // Account for 2nd space
      if (digitsBeforeCursor > 7) cursorPosition++; // Account for 3rd space
    }

    // 5. Return the new formatted text to the UI
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
