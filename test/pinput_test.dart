import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinput/pinput.dart';

import 'helpers/helpers.dart';

void main() {
  testWidgets('Works without a Material ancestor', (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: CupertinoPageScaffold(
          child: CupertinoPinput(
            errorText: 'Invalid PIN',
            forceErrorState: true,
          ),
        ),
      ),
    );

    expect(find.byType(CupertinoPinput), findsOneWidget);
    expect(find.text('Invalid PIN'), findsOneWidget);
  });

  testWidgets('Platform variants provide distinct native defaults', (
    WidgetTester tester,
  ) async {
    Future<Size> pinSize(Widget child) async {
      await tester.pumpApp(child);
      return tester.getSize(find.byType(AnimatedContainer).first);
    }

    expect(await pinSize(const CupertinoPinput()), const Size(52, 52));
    expect(await pinSize(const MacosPinput()), const Size(44, 32));
    expect(await pinSize(const FluentPinput()), const Size(48, 40));
    expect(await pinSize(const YaruPinput()), const Size(48, 44));
  });

  testWidgets('Platform variants provide native focus accents', (
    WidgetTester tester,
  ) async {
    final focusNode = FocusNode();
    await tester.pumpApp(MacosPinput(focusNode: focusNode));

    focusNode.requestFocus();
    await tester.pump();

    final pin = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final border = pin.decoration! as BoxDecoration;
    expect((border.border! as Border).top.color, const Color(0xFF0A84FF));
  });

  testWidgets('Pins are displayed', (WidgetTester tester) async {
    const length = 4;
    await tester.pumpApp(const Pinput(length: length));

    expect(find.byType(Flexible), findsNothing);
    expect(find.byType(AnimatedContainer), findsNWidgets(length));
    expect(find.byType(Text), findsNWidgets(length));
  });

  testWidgets('Non-centered layouts still use flexible pin items', (
    WidgetTester tester,
  ) async {
    const length = 4;
    await tester.pumpApp(
      const Pinput(
        length: length,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );

    expect(find.byType(Flexible), findsNWidgets(length));
  });

  testWidgets('Should properly handle states', (WidgetTester tester) async {
    const length = 4;
    final focusNode = FocusNode();
    const defaultTheme = PinTheme(decoration: BoxDecoration(color: Colors.red));
    final focusedTheme = defaultTheme.copyDecorationWith(
      color: Colors.greenAccent.withValues(alpha: .9),
    );
    final submittedTheme = defaultTheme.copyDecorationWith(
      color: Colors.greenAccent.withValues(alpha: .8),
    );
    final followingTheme = defaultTheme.copyDecorationWith(
      color: Colors.greenAccent.withValues(alpha: .7),
    );
    final disabledTheme = defaultTheme.copyDecorationWith(
      color: Colors.greenAccent.withValues(alpha: .6),
    );
    final errorTheme = defaultTheme.copyDecorationWith(
      color: Colors.greenAccent.withValues(alpha: .5),
    );

    await tester.pumpApp(
      Pinput(
        length: length,
        focusNode: focusNode,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focusedTheme,
        submittedPinTheme: submittedTheme,
        followingPinTheme: followingTheme,
        disabledPinTheme: disabledTheme,
        errorPinTheme: errorTheme,
      ),
    );

    void testState(int count, PinTheme theme) {
      expect(
        find.byWidgetPredicate(
          (w) => w is AnimatedContainer && w.decoration == theme.decoration,
        ),
        findsNWidgets(count),
      );
    }

    // Unfocused
    testState(length, defaultTheme);
    testState(0, focusedTheme);
    testState(0, submittedTheme);
    testState(0, errorTheme);
    testState(0, disabledTheme);

    //Focused
    focusNode.requestFocus();
    await tester.pump();

    testState(length - 1, followingTheme);
    testState(1, focusedTheme);
    testState(0, submittedTheme);
    testState(0, errorTheme);
    testState(0, disabledTheme);

    // Focused submitted
    await tester.enterText(find.byType(EditableText), '1');
    await tester.pump();

    testState(length - 2, followingTheme);
    testState(1, focusedTheme);
    testState(1, submittedTheme);
    testState(0, errorTheme);
    testState(0, disabledTheme);

    // UnFocused submitted
    focusNode.unfocus();
    await tester.pump();

    testState(length - 1, followingTheme);
    testState(0, focusedTheme);
    testState(1, submittedTheme);
    testState(0, errorTheme);
    testState(0, disabledTheme);
  });

  testWidgets('Should properly handle focused state', (
    WidgetTester tester,
  ) async {
    final focusNode = FocusNode();
    const defaultTheme = PinTheme(decoration: BoxDecoration());
    final focusedTheme = defaultTheme.copyDecorationWith(color: Colors.red);
    await tester.pumpApp(
      Pinput(
        focusNode: focusNode,
        autofocus: true,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focusedTheme,
      ),
    );

    expect(focusNode.hasFocus, isTrue);

    await tester.pump();
    // Cursor
    expect(find.text('|'), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is AnimatedContainer && w.decoration == focusedTheme.decoration,
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should display custom cursor', (WidgetTester tester) async {
    await tester.pumpApp(const Pinput(autofocus: true, cursor: FlutterLogo()));

    await tester.pump();
    expect(find.byType(FlutterLogo), findsOneWidget);
  });

  testWidgets('Builder constructor renders error content', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(
      Pinput.builder(
        length: 4,
        errorText: 'Invalid PIN',
        forceErrorState: true,
        builder: (_, state) => Text('${state.index}:${state.type.name}'),
      ),
    );

    expect(find.text('Invalid PIN'), findsOneWidget);
  });

  testWidgets('Builder constructor exposes initial pin item state', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(
      Pinput.builder(
        length: 4,
        builder: (_, state) => Text('${state.index}:${state.type.name}'),
      ),
    );

    expect(find.text('0:initial'), findsOneWidget);
    expect(find.text('1:initial'), findsOneWidget);
    expect(find.text('2:initial'), findsOneWidget);
    expect(find.text('3:initial'), findsOneWidget);
  });

  group('onChanged should work properly', () {
    testWidgets('onChanged should work with controller', (
      WidgetTester tester,
    ) async {
      String? fieldValue;
      int called = 0;

      await tester.pumpApp(
        Pinput(
          onChanged: (value) {
            fieldValue = value;
            called++;
          },
        ),
      );

      expect(fieldValue, isNull);
      expect(called, 0);

      Future<void> checkText(String testValue) async {
        await tester.enterText(find.byType(EditableText), testValue);
        expect(fieldValue, equals(testValue));
      }

      await checkText('123');
      expect(called, 1);

      await checkText('123');
      expect(called, 1);

      await checkText('');
      expect(called, 2);
    });

    testWidgets('onChanged should work with controller', (
      WidgetTester tester,
    ) async {
      String? fieldValue;
      int called = 0;
      final TextEditingController controller = TextEditingController();

      await tester.pumpApp(
        Pinput(
          controller: controller,
          onChanged: (value) {
            fieldValue = value;
            called++;
          },
        ),
      );

      expect(fieldValue, isNull);
      expect(called, 0);

      await tester.enterText(find.byType(EditableText), '11');
      expect(fieldValue, equals('11'));
      expect(called, 1);

      controller.setText('12');
      expect(fieldValue, equals('12'));
      expect(called, 2);

      controller.setText('12');
      expect(fieldValue, equals('12'));
      expect(called, 2);

      controller.clear();
      expect(fieldValue, equals(''));
      expect(called, 3);
    });
  });

  group('onCompleted should work properly', () {
    testWidgets('onCompleted works without controller', (
      WidgetTester tester,
    ) async {
      String? fieldValue;
      int called = 0;

      await tester.pumpApp(
        Pinput(
          length: 4,
          onCompleted: (value) {
            fieldValue = value;
            called++;
          },
        ),
      );

      expect(fieldValue, isNull);
      expect(called, 0);

      await tester.enterText(find.byType(EditableText), '1234');
      expect(fieldValue, equals('1234'));
      expect(called, 1);

      fieldValue = null;
      await tester.enterText(find.byType(EditableText), '123');
      expect(fieldValue, isNull);
      expect(called, 1);
    });

    testWidgets('onCompleted callback is called', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      String? fieldValue;
      int called = 0;

      await tester.pumpApp(
        Pinput(
          controller: controller,
          onCompleted: (value) {
            fieldValue = value;
            called++;
          },
        ),
      );

      expect(fieldValue, isNull);
      expect(called, 0);

      controller.setText('1234');
      expect(fieldValue, equals('1234'));
      expect(called, 1);

      controller.clear();
      expect(fieldValue, equals('1234'));
      expect(called, 1);

      fieldValue = null;
      await tester.enterText(find.byType(EditableText), '123');
      expect(fieldValue, isNull);
      expect(called, 1);

      controller.setText('12345');
      expect(fieldValue, isNull);
      expect(called, 1);
    });
  });

  testWidgets('onTap is called upon tap', (WidgetTester tester) async {
    int tapCount = 0;

    await tester.pumpApp(Pinput(onTap: () => ++tapCount));

    expect(tapCount, 0);
    await tester.tap(find.byType(EditableText));
    // Wait a bit so they're all single taps and not double taps.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byType(EditableText));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byType(EditableText));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tapCount, 3);
  });

  testWidgets('onTap is not called, field is disabled', (
    WidgetTester tester,
  ) async {
    int tapCount = 0;

    await tester.pumpApp(Pinput(enabled: false, onTap: () => ++tapCount));

    expect(tapCount, 0);
    await tester.tap(find.byType(EditableText), warnIfMissed: false);
    await tester.tap(find.byType(EditableText), warnIfMissed: false);
    expect(tapCount, 0);
  });

  testWidgets('onLongPress is called', (WidgetTester tester) async {
    int tapCount = 0;

    await tester.pumpApp(Pinput(onLongPress: () => ++tapCount));

    expect(tapCount, 0);
    await tester.longPress(find.byType(EditableText));
    // Wait a bit so they're all single taps and not double taps.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.longPress(find.byType(EditableText));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.longPress(find.byType(EditableText));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tapCount, 3);
  });

  testWidgets('onSubmitted callback is called', (WidgetTester tester) async {
    String? fieldValue;

    await tester.pumpApp(Pinput(onSubmitted: (value) => fieldValue = value));

    expect(fieldValue, isNull);

    await tester.enterText(find.byType(EditableText), '123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(fieldValue, equals('123'));
  });

  testWidgets('Validator error is cleared when pin changes after validation', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpApp(
      Pinput(
        controller: controller,
        validator: (value) => value == '1234' ? 'Invalid PIN' : null,
      ),
    );

    controller.setText('1234');
    await tester.pump();
    expect(find.text('Invalid PIN'), findsOneWidget);

    controller.setText('12');
    await tester.pump();
    expect(find.text('Invalid PIN'), findsNothing);
  });

  testWidgets('External errorText applies error theme', (
    WidgetTester tester,
  ) async {
    const errorTheme = PinTheme(decoration: BoxDecoration(color: Colors.red));

    await tester.pumpApp(
      const Pinput(errorText: 'Server error', errorPinTheme: errorTheme),
    );

    expect(find.text('Server error'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedContainer &&
            widget.decoration == errorTheme.decoration,
      ),
      findsNWidgets(4),
    );
  });
}
