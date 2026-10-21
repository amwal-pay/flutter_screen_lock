/// Configuration for PIN validation and security policies
class PinValidationConfig {
  const PinValidationConfig({
    this.minLength = 6,
    this.maxLength = 8,
    this.requireUniqueDigits = false,
    this.disallowCommonSequences = true,
    this.disallowRepeatingDigits = false,
    this.disallowAscendingSequences = true,
    this.disallowDescendingSequences = true,
    this.disallowKeyboardPatterns = true,
    this.customValidationRules = const [],
  });

  /// Minimum PIN length (default: 6)
  final int minLength;

  /// Maximum PIN length (default: 8)
  final int maxLength;

  /// Require all digits to be unique (e.g., 1234 but not 1123)
  final bool requireUniqueDigits;

  /// Disallow common sequences like 123456, 000000, etc.
  final bool disallowCommonSequences;

  /// Disallow repeating digits (e.g., 1111, 2222)
  final bool disallowRepeatingDigits;

  /// Disallow ascending sequences (e.g., 1234, 2345)
  final bool disallowAscendingSequences;

  /// Disallow descending sequences (e.g., 4321, 5432)
  final bool disallowDescendingSequences;

  /// Disallow keyboard patterns (e.g., 1470, 2580)
  final bool disallowKeyboardPatterns;

  /// Custom validation rules
  final List<PinValidationRule> customValidationRules;

  /// Validates a PIN according to all configured rules
  PinValidationResult validatePin(String pin) {
    // Check length
    if (pin.length < minLength) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN must be at least $minLength digits long',
        errorType: PinValidationErrorType.tooShort,
      );
    }

    if (pin.length > maxLength) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN must be no more than $maxLength digits long',
        errorType: PinValidationErrorType.tooLong,
      );
    }

    // Check for repeating digits
    if (disallowRepeatingDigits && _hasRepeatingDigits(pin)) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN cannot contain repeating digits',
        errorType: PinValidationErrorType.repeatingDigits,
      );
    }

    // Check for unique digits requirement
    if (requireUniqueDigits && !_hasUniqueDigits(pin)) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN must contain unique digits only',
        errorType: PinValidationErrorType.nonUniqueDigits,
      );
    }

    // Check for ascending sequences
    if (disallowAscendingSequences && _isAscendingSequence(pin)) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN cannot be an ascending sequence',
        errorType: PinValidationErrorType.ascendingSequence,
      );
    }

    // Check for descending sequences
    if (disallowDescendingSequences && _isDescendingSequence(pin)) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN cannot be a descending sequence',
        errorType: PinValidationErrorType.descendingSequence,
      );
    }

    // Check for keyboard patterns
    if (disallowKeyboardPatterns && _isKeyboardPattern(pin)) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN cannot follow keyboard patterns',
        errorType: PinValidationErrorType.keyboardPattern,
      );
    }

    // Check for common sequences
    if (disallowCommonSequences && _isCommonSequence(pin)) {
      return PinValidationResult(
        isValid: false,
        errorMessage: 'PIN cannot be a common sequence',
        errorType: PinValidationErrorType.commonSequence,
      );
    }

    // Apply custom validation rules
    for (final rule in customValidationRules) {
      final result = rule.validate(pin);
      if (!result.isValid) {
        return result;
      }
    }

    return PinValidationResult(isValid: true);
  }

  bool _hasRepeatingDigits(String pin) {
    for (int i = 0; i < pin.length - 1; i++) {
      if (pin[i] == pin[i + 1]) {
        return true;
      }
    }
    return false;
  }

  bool _hasUniqueDigits(String pin) {
    final digits = pin.split('').toSet();
    return digits.length == pin.length;
  }

  bool _isAscendingSequence(String pin) {
    for (int i = 0; i < pin.length - 1; i++) {
      if (int.parse(pin[i + 1]) != int.parse(pin[i]) + 1) {
        return false;
      }
    }
    return pin.length > 1;
  }

  bool _isDescendingSequence(String pin) {
    for (int i = 0; i < pin.length - 1; i++) {
      if (int.parse(pin[i + 1]) != int.parse(pin[i]) - 1) {
        return false;
      }
    }
    return pin.length > 1;
  }

  bool _isKeyboardPattern(String pin) {
    // Common keyboard patterns on mobile devices
    const patterns = [
      '1470', '2580', '3690', // Vertical columns
      '1590', '3570', // Diagonal patterns
      '1357', '2468', // Alternating patterns
    ];

    return patterns.contains(pin);
  }

  bool _isCommonSequence(String pin) {
    const commonSequences = [
      '0000',
      '1111',
      '2222',
      '3333',
      '4444',
      '5555',
      '6666',
      '7777',
      '8888',
      '9999',
      '1234',
      '2345',
      '3456',
      '4567',
      '5678',
      '6789',
      '4321',
      '5432',
      '6543',
      '7654',
      '8765',
      '9876',
      '0123',
      '1230',
      '000000',
      '111111',
      '222222',
      '333333',
      '444444',
      '555555',
      '666666',
      '777777',
      '888888',
      '999999',
      '123456',
      '234567',
      '345678',
      '456789',
      '654321',
      '765432',
      '876543',
      '987654',
      '012345',
      '123450',
    ];

    return commonSequences.contains(pin);
  }

  PinValidationConfig copyWith({
    int? minLength,
    int? maxLength,
    bool? requireUniqueDigits,
    bool? disallowCommonSequences,
    bool? disallowRepeatingDigits,
    bool? disallowAscendingSequences,
    bool? disallowDescendingSequences,
    bool? disallowKeyboardPatterns,
    List<PinValidationRule>? customValidationRules,
  }) {
    return PinValidationConfig(
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      requireUniqueDigits: requireUniqueDigits ?? this.requireUniqueDigits,
      disallowCommonSequences:
          disallowCommonSequences ?? this.disallowCommonSequences,
      disallowRepeatingDigits:
          disallowRepeatingDigits ?? this.disallowRepeatingDigits,
      disallowAscendingSequences:
          disallowAscendingSequences ?? this.disallowAscendingSequences,
      disallowDescendingSequences:
          disallowDescendingSequences ?? this.disallowDescendingSequences,
      disallowKeyboardPatterns:
          disallowKeyboardPatterns ?? this.disallowKeyboardPatterns,
      customValidationRules:
          customValidationRules ?? this.customValidationRules,
    );
  }
}

/// Result of PIN validation
class PinValidationResult {
  const PinValidationResult({
    required this.isValid,
    this.errorMessage,
    this.errorType,
  });

  final bool isValid;
  final String? errorMessage;
  final PinValidationErrorType? errorType;
}

/// Types of PIN validation errors
enum PinValidationErrorType {
  tooShort,
  tooLong,
  repeatingDigits,
  nonUniqueDigits,
  ascendingSequence,
  descendingSequence,
  keyboardPattern,
  commonSequence,
  customRule,
}

/// Custom PIN validation rule
abstract class PinValidationRule {
  PinValidationResult validate(String pin);
}

/// Configuration for account lockout and throttling
class AccountLockoutConfig {
  const AccountLockoutConfig({
    this.maxAttempts = 5,
    this.lockoutDuration = const Duration(minutes: 15),
    this.progressiveDelay = true,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(minutes: 5),
    this.resetAttemptsOnSuccess = true,
  });

  /// Maximum number of failed attempts before lockout
  final int maxAttempts;

  /// Duration of account lockout after max attempts
  final Duration lockoutDuration;

  /// Whether to use progressive delay (increasing delay with each attempt)
  final bool progressiveDelay;

  /// Base delay for progressive delay
  final Duration baseDelay;

  /// Maximum delay for progressive delay
  final Duration maxDelay;

  /// Whether to reset attempt count on successful authentication
  final bool resetAttemptsOnSuccess;

  /// Calculate delay for given attempt number
  Duration getDelayForAttempt(int attemptNumber) {
    if (!progressiveDelay) return Duration.zero;

    final delaySeconds = (baseDelay.inSeconds * (attemptNumber - 1)).clamp(
      baseDelay.inSeconds,
      maxDelay.inSeconds,
    );

    return Duration(seconds: delaySeconds);
  }

  AccountLockoutConfig copyWith({
    int? maxAttempts,
    Duration? lockoutDuration,
    bool? progressiveDelay,
    Duration? baseDelay,
    Duration? maxDelay,
    bool? resetAttemptsOnSuccess,
  }) {
    return AccountLockoutConfig(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lockoutDuration: lockoutDuration ?? this.lockoutDuration,
      progressiveDelay: progressiveDelay ?? this.progressiveDelay,
      baseDelay: baseDelay ?? this.baseDelay,
      maxDelay: maxDelay ?? this.maxDelay,
      resetAttemptsOnSuccess:
          resetAttemptsOnSuccess ?? this.resetAttemptsOnSuccess,
    );
  }
}

/// Configuration for PIN history tracking
class PinHistoryConfig {
  const PinHistoryConfig({
    this.enabled = true,
    this.historySize = 5,
    this.storageKey = 'pin_history',
  });

  /// Whether PIN history tracking is enabled
  final bool enabled;

  /// Number of previous PINs to remember
  final int historySize;

  /// Storage key for PIN history
  final String storageKey;

  PinHistoryConfig copyWith({
    bool? enabled,
    int? historySize,
    String? storageKey,
  }) {
    return PinHistoryConfig(
      enabled: enabled ?? this.enabled,
      historySize: historySize ?? this.historySize,
      storageKey: storageKey ?? this.storageKey,
    );
  }
}

/// Main security configuration class
class SecurityConfig {
  const SecurityConfig({
    this.pinValidation = const PinValidationConfig(),
    this.accountLockout = const AccountLockoutConfig(),
    this.pinHistory = const PinHistoryConfig(),
    this.showSecurityHints = true,
    this.requireStrongPin = true,
  });

  /// PIN validation configuration
  final PinValidationConfig pinValidation;

  /// Account lockout configuration
  final AccountLockoutConfig accountLockout;

  /// PIN history configuration
  final PinHistoryConfig pinHistory;

  /// Whether to show security hints to users
  final bool showSecurityHints;

  /// Whether to require strong PIN (enforce all validation rules)
  final bool requireStrongPin;

  SecurityConfig copyWith({
    PinValidationConfig? pinValidation,
    AccountLockoutConfig? accountLockout,
    PinHistoryConfig? pinHistory,
    bool? showSecurityHints,
    bool? requireStrongPin,
  }) {
    return SecurityConfig(
      pinValidation: pinValidation ?? this.pinValidation,
      accountLockout: accountLockout ?? this.accountLockout,
      pinHistory: pinHistory ?? this.pinHistory,
      showSecurityHints: showSecurityHints ?? this.showSecurityHints,
      requireStrongPin: requireStrongPin ?? this.requireStrongPin,
    );
  }
}
