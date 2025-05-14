import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/src/configurations/key_pad_config.dart';

class ScreenLockConfig {
  const ScreenLockConfig({
    this.backgroundColor,
    this.titleTextStyle,
    this.textStyle,
    this.buttonStyle,
    this.themeData,
    this.textStrings = const ScreenLockTextStrings(),
    KeyPadConfig? keyPadConfig,
  }) : keyPadConfig = keyPadConfig ??
            (textStrings is _ArabicScreenLockTextStrings
                ? const KeyPadConfig(isArabic: true)
                : const KeyPadConfig());

  /// Background color of the ScreenLock.
  final Color? backgroundColor;

  /// Text style for title Texts.
  final TextStyle? titleTextStyle;

  /// Text style for other Texts.
  final TextStyle? textStyle;

  /// Button style for keypad buttons.
  final ButtonStyle? buttonStyle;

  /// Base [ThemeData] that is overridden by other specified values.
  final ThemeData? themeData;

  /// Text strings configuration
  final ScreenLockTextStrings textStrings;

  /// Keypad configuration
  final KeyPadConfig keyPadConfig;

  /// Returns this config as a [ThemeData].
  ThemeData toThemeData() {
    return (themeData ?? ThemeData()).copyWith(
      scaffoldBackgroundColor: backgroundColor,
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      textTheme: TextTheme(
        headlineSmall: titleTextStyle,
        bodyMedium: textStyle,
      ),
    );
  }

  /// Copies a [ScreenLockConfig] with new values.
  ScreenLockConfig copyWith({
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    TextStyle? textStyle,
    ButtonStyle? buttonStyle,
    ThemeData? themeData,
    ScreenLockTextStrings? textStrings,
    KeyPadConfig? keyPadConfig,
  }) {
    return ScreenLockConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      textStyle: textStyle ?? this.textStyle,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      themeData: themeData ?? this.themeData,
      textStrings: textStrings ?? this.textStrings,
      keyPadConfig: keyPadConfig ?? this.keyPadConfig,
    );
  }

  /// Default [ScreenLockConfig].
  static final ScreenLockConfig defaultConfig = ScreenLockConfig(
    backgroundColor: const Color(0x88545454),
    buttonStyle: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFFFFFFF),
      backgroundColor: const Color(0xFF808080),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(0),
      side: BorderSide.none,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
    textStrings: const ScreenLockTextStrings(
      cancel: '',
    ),
  );
}

class ScreenLockTextStrings {
  const ScreenLockTextStrings({
    this.enterNewPasscode = 'Please enter new passcode.',
    this.confirmNewPasscode = 'Please confirm new passcode.',
    this.enterPasscode = 'Please enter passcode.',
    this.cancel = 'Cancel',
  });

  /// Text shown when creating a new passcode
  final String enterNewPasscode;

  /// Text shown when confirming a new passcode
  final String confirmNewPasscode;

  /// Text shown when entering an existing passcode
  final String enterPasscode;

  /// Text shown on the cancel button
  final String cancel;

  /// Create an Arabic version of the text strings
  factory ScreenLockTextStrings.arabic() {
    return const _ArabicScreenLockTextStrings();
  }
}

class _ArabicScreenLockTextStrings extends ScreenLockTextStrings {
  const _ArabicScreenLockTextStrings()
      : super(
          enterNewPasscode: 'الرجاء إدخال رمز المرور الجديد',
          confirmNewPasscode: 'الرجاء تأكيد رمز المرور الجديد',
          enterPasscode: 'الرجاء إدخال رمز المرور',
          cancel: 'إلغاء',
        );
}
