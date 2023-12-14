import 'dart:math';

import 'package:flutter/material.dart';

class TurntableAnimation extends StatefulWidget {
  final Widget child;
  final bool isCentered;

  TurntableAnimation({
    Key? key,
    required this.child,
    required this.isCentered,
  }) : super(key: key);

  @override
  _TurntableAnimationState createState() => _TurntableAnimationState();
}

class _TurntableAnimationState extends State<TurntableAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });

    if (widget.isCentered) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TurntableAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCentered) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return widget.isCentered
            ? Transform.rotate(
                angle: _animation.value,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage:
                      const AssetImage('images/turnTable/record.png'),
                  child: widget.child,
                ),
              )
            : CircleAvatar(
                radius: 55,
                backgroundImage:
                    const AssetImage('images/turnTable/record.png'),
                child: widget.child,
              );
      },
    );
  }
}
