import 'package:flutter/material.dart';
import 'dart:math';
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  // debugPaintSizeEnabled = true;

  runApp(const MaterialApp(
      home: Scaffold(
          body: Center(
    child: ClickableAnimatedClockView(),
  ))));
}

class ClickableAnimatedClockView extends StatefulWidget {
  const ClickableAnimatedClockView({super.key});

  @override
  State<ClickableAnimatedClockView> createState() =>
      _ClickableAnimatedClockViewState();
}

class _ClickableAnimatedClockViewState extends State<ClickableAnimatedClockView>
    with TickerProviderStateMixin {
  late int seconds;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    seconds = 0;
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("user tapped");
        debugPrint("current animation status: ${controller.status}");
        switch (controller.status) {
          case AnimationStatus.dismissed:
            debugPrint("start animation for 1 second");
            controller.forward().whenComplete(() {
              debugPrint("completed");
              setState(() {
                seconds += 1;
              });
              if (seconds == 60) {
                seconds = 0;
              }
              controller.reset();
            });
            break;
          case AnimationStatus.forward:

          default:
        }
      },
      child: AnimatedClockView(
        controller: controller,
        intSeconds: seconds,
      ),
    );
  }
}

class AnimatedClockView extends AnimatedWidget {
  final int intSeconds;

  const AnimatedClockView({
    super.key,
    required AnimationController controller,
    required this.intSeconds,
  }) : super(listenable: controller);

  double get seconds => intSeconds + (listenable as Animation<double>).value;

  @override
  Widget build(BuildContext context) {
    return ClockView(seconds: seconds);
  }
}

class ClockView extends StatelessWidget {
  final double seconds;

  const ClockView({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.maxHeight * 0.5;

      return Stack(alignment: Alignment.topCenter, children: [
        ClockBorderView(
          size: size,
          ringWidth: size * 0.06,
        ),
        ClockHandView(
          size: size,
          handWidth: size * 0.03,
          seconds: seconds,
        ),
      ]);
    });
  }
}

class ClockHandView extends StatelessWidget {
  final double size;
  final double handWidth;
  final double seconds;

  const ClockHandView(
      {super.key,
      required this.size,
      required this.seconds,
      required this.handWidth});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      alignment: Alignment.bottomCenter,
      angle: seconds / 60 * 2 * pi,
      child: SizedBox(
        height: size * 0.5,
        width: handWidth,
        child: VerticalDivider(color: Colors.black, thickness: handWidth),
      ),
    );
  }
}

class ClockBorderView extends StatelessWidget {
  final double size;
  final double ringWidth;

  const ClockBorderView(
      {super.key, required this.size, required this.ringWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(width: ringWidth, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
