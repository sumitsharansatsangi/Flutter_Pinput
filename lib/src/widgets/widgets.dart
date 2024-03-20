part of '../pinput.dart';

typedef JustIndexedWidgetBuilder = Widget Function(int index);

class _PinputFormField extends FormField<String> {
  const _PinputFormField({
    required super.validator,
    required super.enabled,
    required super.initialValue,
    required super.builder,
    super.key,
  }) : super(
          autovalidateMode: AutovalidateMode.disabled,
        );
}

class _SeparatedRaw extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final JustIndexedWidgetBuilder? separatorBuilder;

  const _SeparatedRaw({
    required this.children,
    required this.mainAxisAlignment,
    this.separatorBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = max(0, children.length * 2 - 1);
    final indexedList = [for (int i = 0; i < itemCount; i += 1) i];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisAlignment == MainAxisAlignment.center
          ? MainAxisSize.min
          : MainAxisSize.max,
      children: indexedList.map((index) {
        final itemIndex = index ~/ 2;
        return index.isEven ? children[itemIndex] : _separator(itemIndex);
      }).toList(growable: false),
    );
  }

  Widget _separator(int index) =>
      separatorBuilder?.call(index) ?? PinputConstants._defaultSeparator;
}

class _PinputCursor extends StatelessWidget {
  final Widget? cursor;
  final TextStyle? textStyle;

  const _PinputCursor({required this.textStyle, required this.cursor});

  @override
  Widget build(BuildContext context) => cursor ?? Text('|', style: textStyle);
}

class _PinputAnimatedCursor extends StatefulWidget {
  final Widget? cursor;
  final TextStyle? textStyle;

  const _PinputAnimatedCursor({
    required this.textStyle,
    required this.cursor,
  });

  @override
  State<_PinputAnimatedCursor> createState() => _PinputAnimatedCursorState();
}

class _PinputAnimatedCursorState extends State<_PinputAnimatedCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _startCursorAnimation();
  }

  void _startCursorAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat(reverse: true);
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: _PinputCursor(textStyle: widget.textStyle, cursor: widget.cursor),
    );
  }
}
