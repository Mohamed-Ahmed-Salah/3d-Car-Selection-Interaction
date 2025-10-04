import 'package:flutter/animation.dart';

class AnimationConsts {
  AnimationConsts._();

  static const Duration mainDuration = Duration(milliseconds: 700);
  static const Duration longDuration = Duration(milliseconds: 900);
  static const Duration secondaryDuration = Duration(milliseconds: 500);
  static const Duration smallDuration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeInOutQuart;
  static const Curve easeCurve = Curves.easeInOut;
}
