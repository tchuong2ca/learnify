
import 'package:flutter/widgets.dart';

import '../../../../common/functions.dart';
import '../gradient_circle.dart';

class Sun extends AnimatedWidget {
  Sun({required this.controller}) : super(listenable: controller);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: controller
          .drive(
            Tween<Offset>(
              begin: Offset(0, 0),
              end: Offset(0, -80),
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          )
          .value,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientCircle(
            width: getWidthDevice(context) * 0.9,
            stops: [
              0.88,
              1,
            ],
            child: GradientCircle(
              width: getWidthDevice(context) * 0.7,
              stops: [0.8, 1],
              child: GradientCircle(
                width: getWidthDevice(context) * 0.5,
                stops: [0.6, 1],
                child: Container(
                  width: getWidthDevice(context) * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: getWidthDevice(context) * 0.5,
            height: getHeightDevice(context) * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFfad9a5),
                  const Color(0x00fad9a5),
                ],
                stops: [0.3, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
