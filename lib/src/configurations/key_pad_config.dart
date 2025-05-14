import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class KeyPadConfig {
  const KeyPadConfig({
    this.buttonConfig,
    this.actionButtonConfig,
    this.inputStrings = _numbers,
    List<String>? displayStrings,
    this.clearOnLongPressed = false,
    this.isArabic = false,
  }) : displayStrings =
            displayStrings ?? (isArabic ? _arabicNumbers : _numbers);

  /// Config for numeric [KeyPadButton]s.
  final KeyPadButtonConfig? buttonConfig;

  /// Config for actionable [KeyPadButton]s.
  final KeyPadButtonConfig? actionButtonConfig;

  /// The strings the user can input.
  final List<String> inputStrings;

  /// The strings that are displayed to the user.
  /// Mapped 1:1 to [inputStrings].
  /// Defaults to [inputStrings].
  final List<String> displayStrings;

  /// Whether to clear the input when long pressing the clear key.
  final bool clearOnLongPressed;

  /// Whether to use Arabic numbers
  final bool isArabic;

  static const List<String> _numbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  static const List<String> _arabicNumbers = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  /// Copies a [KeyPadConfig] with new values.
  KeyPadConfig copyWith({
    KeyPadButtonConfig? buttonConfig,
    List<String>? inputStrings,
    List<String>? displayStrings,
    bool? clearOnLongPressed,
    bool? isArabic,
  }) {
    return KeyPadConfig(
      buttonConfig: buttonConfig ?? this.buttonConfig,
      inputStrings: inputStrings ?? this.inputStrings,
      displayStrings: displayStrings ?? this.displayStrings,
      clearOnLongPressed: clearOnLongPressed ?? this.clearOnLongPressed,
      isArabic: isArabic ?? this.isArabic,
    );
  }
}
