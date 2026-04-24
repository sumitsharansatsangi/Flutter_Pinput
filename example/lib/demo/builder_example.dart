import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinputBuilderExample extends StatefulWidget {
  const PinputBuilderExample({super.key});

  @override
  State<PinputBuilderExample> createState() => _PinputBuilderExampleState();

  @override
  String toStringShort() => 'Builder';
}

class _PinputBuilderExampleState extends State<PinputBuilderExample> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Custom builder with initial, focused, submitted, and error states.',
              textAlign: TextAlign.center,
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput.builder(
              errorText: errorText,
              forceErrorState: errorText != null,
              builder: (context, pinState) {
                final borderColor = switch (pinState.type) {
                  PinItemStateType.initial => const Color.fromRGBO(
                    107,
                    137,
                    165,
                    1,
                  ),
                  PinItemStateType.following => const Color.fromRGBO(
                    180,
                    196,
                    210,
                    1,
                  ),
                  PinItemStateType.focused => const Color.fromRGBO(
                    23,
                    171,
                    144,
                    1,
                  ),
                  PinItemStateType.submitted => const Color.fromRGBO(
                    62,
                    116,
                    165,
                    1,
                  ),
                  PinItemStateType.disabled => Colors.black26,
                  PinItemStateType.error => Colors.redAccent,
                };
                return Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: switch (pinState.type) {
                      PinItemStateType.initial => Colors.white,
                      PinItemStateType.following => const Color.fromRGBO(
                        245,
                        247,
                        250,
                        1,
                      ),
                      PinItemStateType.focused => const Color.fromRGBO(
                        230,
                        251,
                        247,
                        1,
                      ),
                      PinItemStateType.submitted => const Color.fromRGBO(
                        236,
                        244,
                        252,
                        1,
                      ),
                      PinItemStateType.disabled => Colors.black12,
                      PinItemStateType.error => const Color.fromRGBO(
                        255,
                        238,
                        238,
                        1,
                      ),
                    },
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Text(
                    pinState.value.isEmpty ? '${pinState.index + 1}' : pinState.value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: borderColor,
                    ),
                  ),
                );
              },
              controller: pinController,
              focusNode: focusNode,
              separatorBuilder: (index) => const SizedBox(width: 8),
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                if (errorText != null) {
                  setState(() => errorText = null);
                }
                debugPrint('onChanged: $value');
              },
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: () {
                  focusNode.unfocus();
                  setState(() {
                    errorText = pinController.text == '2222'
                        ? null
                        : 'Use 2222 to pass validation';
                  });
                },
                child: const Text('Validate'),
              ),
              OutlinedButton(
                onPressed: () {
                  pinController.setText('2222');
                  setState(() => errorText = null);
                },
                child: const Text('Fill Valid Code'),
              ),
              TextButton(
                onPressed: () {
                  pinController.clear();
                  focusNode.requestFocus();
                  setState(() => errorText = null);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          TextButton(
            onPressed: focusNode.requestFocus,
            child: const Text('Focus Field'),
          ),
        ],
      ),
    );
  }
}
