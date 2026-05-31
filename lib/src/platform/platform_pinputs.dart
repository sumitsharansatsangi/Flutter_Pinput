import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../pinput.dart';

/// Shared constructor surface for toolkit-specific Pinput widgets.
abstract class PlatformPinputBase extends Pinput {
  /// Creates a toolkit-specific Pinput backed by the shared editing engine.
  const PlatformPinputBase({
    super.key,
    super.length,
    super.defaultPinTheme,
    super.focusedPinTheme,
    super.submittedPinTheme,
    super.followingPinTheme,
    super.disabledPinTheme,
    super.errorPinTheme,
    super.onChanged,
    super.onCompleted,
    super.onSubmitted,
    super.onTap,
    super.onLongPress,
    super.onTapOutside,
    super.onTapUpOutside,
    super.controller,
    super.focusNode,
    super.preFilledWidget,
    super.separatorBuilder,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.pinContentAlignment,
    super.animationCurve,
    super.animationDuration,
    super.pinAnimationType,
    super.enabled,
    super.readOnly,
    super.useNativeKeyboard,
    super.toolbarEnabled,
    super.autofocus,
    super.obscureText,
    super.showCursor,
    super.isCursorAnimationEnabled,
    super.enableIMEPersonalizedLearning,
    super.enableInteractiveSelection,
    super.enableSuggestions,
    super.hapticFeedbackType,
    super.closeKeyboardWhenCompleted,
    super.keyboardType,
    super.textCapitalization,
    super.slideTransitionBeginOffset,
    super.cursor,
    super.keyboardAppearance,
    super.inputFormatters,
    super.textInputAction,
    super.autofillHints,
    super.obscuringCharacter,
    super.obscuringWidget,
    super.selectionControls,
    super.restorationId,
    super.onClipboardFound,
    super.onAppPrivateCommand,
    super.mouseCursor,
    super.forceErrorState,
    super.showErrorWhenFocused,
    super.errorText,
    super.validator,
    super.errorBuilder,
    super.errorTextStyle,
    super.pinputAutovalidateMode,
    super.scrollPadding,
    super.contextMenuBuilder,
  });

  /// Resolves a toolkit color against the current platform brightness.
  Color surface(BuildContext context, Color light, Color dark) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark
      ? dark
      : light;

  /// Native accent color used for focused pin cells.
  Color get accentColor;

  /// Native error color used for invalid pin cells and messages.
  Color get errorColor;

  @override
  PinTheme platformFocusedPinTheme(BuildContext context) {
    final theme = platformDefaultPinTheme(context);
    return theme.copyDecorationWith(
      border: Border.all(color: accentColor, width: 1.5),
    );
  }

  @override
  PinTheme platformErrorPinTheme(BuildContext context) {
    final theme = platformDefaultPinTheme(context);
    return theme.copyDecorationWith(
      border: Border.all(color: errorColor, width: 1.5),
    );
  }

  @override
  TextStyle platformErrorTextStyle(BuildContext context) =>
      TextStyle(color: errorColor, fontSize: 12);
}

/// Material-styled pin input for Android and Material applications.
class MaterialPinput extends PlatformPinputBase {
  /// Creates a Material-styled pin input.
  const MaterialPinput({
    super.key,
    super.length,
    this.smsRetriever,
    super.defaultPinTheme,
    super.focusedPinTheme,
    super.submittedPinTheme,
    super.followingPinTheme,
    super.disabledPinTheme,
    super.errorPinTheme,
    super.onChanged,
    super.onCompleted,
    super.onSubmitted,
    super.controller,
    super.focusNode,
    super.separatorBuilder,
    super.mainAxisAlignment,
    super.enabled,
    super.autofocus,
    super.hapticFeedbackType,
    super.cursor,
    super.onClipboardFound,
    super.forceErrorState,
    super.errorText,
    super.validator,
  });

  /// Android SMS Retriever integration, typically backed by `smart_auth`.
  final SmsRetriever? smsRetriever;

  @override
  SmsRetriever? get androidSmsRetriever =>
      defaultTargetPlatform == TargetPlatform.android ? smsRetriever : null;

  @override
  Color get accentColor => const Color(0xFF6750A4);

  @override
  Color get errorColor => const Color(0xFFD32F2F);
}

/// Cupertino-styled pin input for iOS applications.
class CupertinoPinput extends PlatformPinputBase {
  /// Creates a Cupertino-styled pin input.
  const CupertinoPinput({
    super.key,
    super.length,
    super.defaultPinTheme,
    super.focusedPinTheme,
    super.submittedPinTheme,
    super.followingPinTheme,
    super.disabledPinTheme,
    super.errorPinTheme,
    super.onChanged,
    super.onCompleted,
    super.onSubmitted,
    super.controller,
    super.focusNode,
    super.separatorBuilder,
    super.mainAxisAlignment,
    super.enabled,
    super.autofocus,
    super.onClipboardFound,
    super.forceErrorState,
    super.errorText,
    super.validator,
  });

  @override
  Color get accentColor => const Color(0xFF007AFF);

  @override
  Color get errorColor => const Color(0xFFFF3B30);

  @override
  PinTheme platformDefaultPinTheme(BuildContext context) => PinTheme(
    width: 52,
    height: 52,
    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: surface(context, const Color(0xFFF2F2F7), const Color(0xFF1C1C1E)),
      border: Border.all(
        color: surface(
          context,
          const Color(0xFFD1D1D6),
          const Color(0xFF545458),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

/// macOS-styled pin input for MacosApp applications.
class MacosPinput extends PlatformPinputBase {
  /// Creates a macOS-styled pin input.
  const MacosPinput({
    super.key,
    super.length,
    super.defaultPinTheme,
    super.focusedPinTheme,
    super.submittedPinTheme,
    super.followingPinTheme,
    super.disabledPinTheme,
    super.errorPinTheme,
    super.onChanged,
    super.onCompleted,
    super.onSubmitted,
    super.controller,
    super.focusNode,
    super.separatorBuilder,
    super.mainAxisAlignment,
    super.enabled,
    super.autofocus,
    super.onClipboardFound,
    super.forceErrorState,
    super.errorText,
    super.validator,
  });

  @override
  Color get accentColor => const Color(0xFF0A84FF);

  @override
  Color get errorColor => const Color(0xFFFF3B30);

  @override
  PinTheme platformDefaultPinTheme(BuildContext context) => PinTheme(
    width: 44,
    height: 32,
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    decoration: BoxDecoration(
      color: surface(context, const Color(0xFFFFFFFF), const Color(0xFF1E1E1E)),
      border: Border.all(
        color: surface(
          context,
          const Color(0xFFB8B8B8),
          const Color(0xFF5A5A5A),
        ),
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

/// Fluent-styled pin input for Windows applications.
class FluentPinput extends PlatformPinputBase {
  /// Creates a Fluent-styled pin input.
  const FluentPinput({
    super.key,
    super.length,
    super.defaultPinTheme,
    super.focusedPinTheme,
    super.submittedPinTheme,
    super.followingPinTheme,
    super.disabledPinTheme,
    super.errorPinTheme,
    super.onChanged,
    super.onCompleted,
    super.onSubmitted,
    super.controller,
    super.focusNode,
    super.separatorBuilder,
    super.mainAxisAlignment,
    super.enabled,
    super.autofocus,
    super.onClipboardFound,
    super.forceErrorState,
    super.errorText,
    super.validator,
  });

  @override
  Color get accentColor => const Color(0xFF0078D4);

  @override
  Color get errorColor => const Color(0xFFC42B1C);

  @override
  PinTheme platformDefaultPinTheme(BuildContext context) => PinTheme(
    width: 48,
    height: 40,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: surface(context, const Color(0xFFFFFFFF), const Color(0xFF292929)),
      border: Border.all(
        color: surface(
          context,
          const Color(0xFF8A8886),
          const Color(0xFF9A9A9A),
        ),
      ),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

/// Yaru-styled pin input for Linux applications.
class YaruPinput extends PlatformPinputBase {
  /// Creates a Yaru-styled pin input.
  const YaruPinput({
    super.key,
    super.length,
    super.defaultPinTheme,
    super.focusedPinTheme,
    super.submittedPinTheme,
    super.followingPinTheme,
    super.disabledPinTheme,
    super.errorPinTheme,
    super.onChanged,
    super.onCompleted,
    super.onSubmitted,
    super.controller,
    super.focusNode,
    super.separatorBuilder,
    super.mainAxisAlignment,
    super.enabled,
    super.autofocus,
    super.onClipboardFound,
    super.forceErrorState,
    super.errorText,
    super.validator,
  });

  @override
  Color get accentColor => const Color(0xFFE95420);

  @override
  Color get errorColor => const Color(0xFFC01C28);

  @override
  PinTheme platformDefaultPinTheme(BuildContext context) => PinTheme(
    width: 48,
    height: 44,
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: surface(context, const Color(0xFFFFFFFF), const Color(0xFF2D2D2D)),
      border: Border.all(
        color: surface(
          context,
          const Color(0xFFC0BFBC),
          const Color(0xFF77767B),
        ),
      ),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}
