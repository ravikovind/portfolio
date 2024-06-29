import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Abstract base class for text animations.
abstract class AnimatedText {
  /// Text for [Text] widget.
  final String text;

  /// [TextAlign] property for [Text] widget.
  ///
  /// By default it is set to [TextAlign.start]
  final TextAlign textAlign;

  /// [TextStyle] property for [Text] widget.
  final TextStyle? textStyle;

  /// The Duration for the Animation Controller.
  ///
  /// This will set the total duration for the animated widget.
  /// For example, if you want the text animation to take 3 seconds,
  /// then you have to set [duration] to 3 seconds.
  final Duration duration;

  /// Same as [text] but as [Characters].
  ///
  /// Need to use character length, not String length, to propertly support
  /// Unicode and Emojis.
  final Characters textCharacters;

  AnimatedText({
    required this.text,
    this.textAlign = TextAlign.start,
    this.textStyle,
    required this.duration,
  }) : textCharacters = text.characters;

  /// Return the remaining Duration for the Animation (when applicable).
  Duration? get remaining => null;

  /// Initialize the Animation.
  void initAnimation(AnimationController controller);

  /// Utility method to create a styled [Text] widget using the [textAlign] and
  /// [textStyle], but you can specify the [data].
  Widget textWidget(String data) => Text(
        data,
        textAlign: textAlign,
        style: textStyle,
      );

  /// Widget showing the complete text (when animation is complete or paused).
  /// By default, it shows a Text widget, but this may be overridden.
  Widget completeText(BuildContext context) => textWidget(text);

  /// Widget showing animated text, based on animation value(s).
  Widget animatedBuilder(BuildContext context, Widget? child);
}

/// Base class for Animated Text widgets.
class AnimatedTextKit extends StatefulWidget {
  /// List of [AnimatedText] to display subsequently in the animation.
  final List<AnimatedText> animatedTexts;

  /// Define the [Duration] of the pause between texts
  ///
  /// By default it is set to 1000 milliseconds.
  final Duration pause;

  /// Should the animation ends up early and display full text if you tap on it?
  ///
  /// By default it is set to false.
  final bool displayFullTextOnTap;

  /// If on pause, should a tap remove the remaining pause time ?
  ///
  /// By default it is set to false.
  final bool stopPauseOnTap;

  /// Adds the onTap [VoidCallback] to the animated widget.
  final VoidCallback? onTap;

  /// Adds the onFinished [VoidCallback] to the animated widget.
  ///
  /// This method will run only if [isRepeatingAnimation] is set to false.
  final VoidCallback? onFinished;

  /// Adds the onNext callback to the animated widget.
  ///
  /// Will be called right before the next text, after the pause parameter
  final void Function(int, bool)? onNext;

  /// Adds the onNextBeforePause callback to the animated widget.
  ///
  /// Will be called at the end of n-1 animation, before the pause parameter
  final void Function(int, bool)? onNextBeforePause;

  /// Set if the animation should not repeat by changing the value of it to false.
  ///
  /// By default it is set to true.
  final bool isRepeatingAnimation;

  /// Sets if the animation should repeat forever. [isRepeatingAnimation] also
  /// needs to be set to true if you want to repeat forever.
  ///
  /// By default it is set to false, if set to true, [totalRepeatCount] is ignored.
  final bool repeatForever;

  /// Sets the number of times animation should repeat
  ///
  /// By default it is set to 3
  final int totalRepeatCount;

  const AnimatedTextKit({
    super.key,
    required this.animatedTexts,
    this.pause = const Duration(milliseconds: 1000),
    this.displayFullTextOnTap = false,
    this.stopPauseOnTap = false,
    this.onTap,
    this.onNext,
    this.onNextBeforePause,
    this.onFinished,
    this.isRepeatingAnimation = true,
    this.totalRepeatCount = 3,
    this.repeatForever = false,
  })  : assert(animatedTexts.length > 0),
        assert(!isRepeatingAnimation || totalRepeatCount > 0 || repeatForever),
        assert(null == onFinished || !repeatForever);

  /// Creates the mutable state for this widget. See [StatefulWidget.createState].
  @override
  AnimatedTextKitState createState() => AnimatedTextKitState();
}

class AnimatedTextKitState extends State<AnimatedTextKit>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late AnimatedText _currentAnimatedText;

  int _currentRepeatCount = 0;

  int _index = 0;

  bool _isCurrentlyPausing = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completeText = _currentAnimatedText.completeText(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: _isCurrentlyPausing || !_controller.isAnimating
          ? completeText
          : AnimatedBuilder(
              animation: _controller,
              builder: _currentAnimatedText.animatedBuilder,
              child: completeText,
            ),
    );
  }

  bool get _isLast => _index == widget.animatedTexts.length - 1;

  void _nextAnimation() {
    final isLast = _isLast;

    _isCurrentlyPausing = false;

    // Handling onNext callback
    widget.onNext?.call(_index, isLast);

    if (isLast) {
      if (widget.isRepeatingAnimation &&
          (widget.repeatForever ||
              _currentRepeatCount != (widget.totalRepeatCount - 1))) {
        _index = 0;
        if (!widget.repeatForever) {
          _currentRepeatCount++;
        }
      } else {
        widget.onFinished?.call();
        return;
      }
    } else {
      _index++;
    }

    if (mounted) setState(() {});

    _controller.dispose();

    // Re-initialize animation
    _initAnimation();
  }

  void _initAnimation() {
    _currentAnimatedText = widget.animatedTexts[_index];

    _controller = AnimationController(
      duration: _currentAnimatedText.duration,
      vsync: this,
    );

    _currentAnimatedText.initAnimation(_controller);

    _controller
      ..addStatusListener(_animationEndCallback)
      ..forward();
  }

  void _setPause() {
    final isLast = _isLast;

    _isCurrentlyPausing = true;
    if (mounted) setState(() {});

    // Handle onNextBeforePause callback
    widget.onNextBeforePause?.call(_index, isLast);
  }

  void _animationEndCallback(AnimationStatus state) {
    if (state == AnimationStatus.completed) {
      _setPause();
      assert(null == _timer || _timer?.isActive == false);
      _timer = Timer(widget.pause, _nextAnimation);
    }
  }

  void _onTap() {
    if (widget.displayFullTextOnTap) {
      if (_isCurrentlyPausing) {
        if (widget.stopPauseOnTap) {
          _timer?.cancel();
          _nextAnimation();
        }
      } else {
        final left =
            (_currentAnimatedText.remaining ?? _currentAnimatedText.duration)
                .inMilliseconds;

        _controller.stop();

        _setPause();

        assert(null == _timer || _timer?.isActive == false);
        _timer = Timer(
          Duration(
            milliseconds: max(
              widget.pause.inMilliseconds,
              left,
            ),
          ),
          _nextAnimation,
        );
      }
    }

    widget.onTap?.call();
  }
}

/// Animated Text that displays a [Text] element as if it is being typed one
/// character at a time. Similar to [TyperAnimatedText], but shows a cursor.
///
/// ![Typewriter example](https://raw.githubusercontent.com/aagarwal1012/Animated-Text-Kit/master/display/typewriter.gif)
class TypewriterAnimatedText extends AnimatedText {
  // The text length is padded to cause extra cursor blinking after typing.
  static const extraLengthForBlinks = 8;

  /// The [Duration] of the delay between the apparition of each characters
  ///
  /// By default it is set to 30 milliseconds.
  final Duration speed;

  /// The [Curve] of the rate of change of animation over time.
  ///
  /// By default it is set to Curves.linear.
  final Curve curve;

  /// Cursor text. Defaults to underscore.
  final String cursor;

  TypewriterAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
    this.cursor = '_',
  }) : super(
          text: text,
          duration: speed * (text.characters.length + extraLengthForBlinks),
        );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed *
      (textCharacters.length + extraLengthForBlinks - _typewriterText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget completeText(BuildContext context) => RichText(
        text: TextSpan(
          children: [
            TextSpan(text: text),
            TextSpan(
              text: cursor,
              style: const TextStyle(color: Colors.transparent),
            )
          ],
          style: DefaultTextStyle.of(context).style.merge(textStyle),
        ),
        textAlign: textAlign,
      );

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    /// Output of CurveTween is in the range [0, 1] for majority of the curves.
    /// It is converted to [0, textCharacters.length + extraLengthForBlinks].
    final textLen = textCharacters.length;
    final typewriterValue = (_typewriterText.value.clamp(0, 1) *
            (textCharacters.length + extraLengthForBlinks))
        .round();

    var showCursor = true;
    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString = '';
      showCursor = false;
    } else if (typewriterValue > textLen) {
      showCursor = (typewriterValue - textLen) % 2 == 0;
    } else {
      visibleString = textCharacters.take(typewriterValue).toString();
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: visibleString),
          TextSpan(
            text: cursor,
            style:
                showCursor ? null : const TextStyle(color: Colors.transparent),
          )
        ],
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      textAlign: textAlign,
    );
  }
}
