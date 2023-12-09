import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedOnTapContainer extends StatefulWidget {
  const AnimatedOnTapContainer({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<AnimatedOnTapContainer> createState() => _AnimatedOnTapContainerState();
}

class _AnimatedOnTapContainerState extends State<AnimatedOnTapContainer>
    with TickerProviderStateMixin {
  double squareScaleA = 1;
  late AnimationController _controllerA;

  @override
  void initState() {
    super.initState();

    _controllerA = AnimationController(
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
      value: 1,
      duration: const Duration(milliseconds: 50),
    );
    _controllerA.addListener(() {
      setState(() {
        squareScaleA = _controllerA.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _controllerA.reverse().whenComplete(() {
          widget.onTap?.call();
        });
      },
      onTapDown: (dp) {
        _controllerA.reverse();
      },
      onTapUp: (dp) {
        Timer(const Duration(milliseconds: 200), () {
          try {
            _controllerA.fling();
          } catch (e) {
            if (kDebugMode) {
              print(e.toString());
            }
          }
        });
      },
      onTapCancel: () {
        _controllerA.fling();
      },
      onLongPress: widget.onLongPress,
      child: Transform.scale(
        scale: squareScaleA,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controllerA.dispose();
    super.dispose();
  }
}
