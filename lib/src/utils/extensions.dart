part of '../pinput.dart';

/// Helper methods to set, delete, and append the [Pinput] value programmatically.
/// ``` dart
/// final controller = TextEditingController();
///
/// controller.setText('1234');
///
/// Pinput(
///   controller: controller,
/// );
/// ```
///
extension PinputControllerExt on TextEditingController {
  /// The length of the [Pinput] value.
  int get length => this.text.length;

  /// Sets the [Pinput] value.
  void setText(String pin) {
    this.text = pin;
    this.moveCursorToEnd();
  }

  /// Deletes the last character of the [Pinput] value.
  void delete() {
    if (text.isEmpty) return;
    final pin = this.text.substring(0, this.length - 1);
    this.text = pin;
    this.moveCursorToEnd();
  }

  /// Appends a character to the end of the [Pinput] value.
  void append(String s, int maxLength) {
    if (this.length == maxLength) return;
    this.text = '${this.text}$s';
    this.moveCursorToEnd();
  }

  /// Moves the cursor to the end.
  void moveCursorToEnd() {
    this.selection = TextSelection.collapsed(offset: this.length);
  }
}
