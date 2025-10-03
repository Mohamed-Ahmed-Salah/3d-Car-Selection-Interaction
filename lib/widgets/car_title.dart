import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_pageview/linked_pageview.dart';
import 'package:threed_cars_challenge/core/AnimationConst.dart';

import '../core/car_model.dart';
import '../core/enums.dart';

// Top PageView - Title/Subtitle
class CarTitleView extends StatelessWidget {
  final bool isNavigated;
  final CarModel carModel;

  const CarTitleView({
    super.key,
    required this.carModel,
    required this.isNavigated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedOpacity(
                    duration: AnimationConsts.mainDuration,
                    curve: isNavigated ? Curves.easeInExpo
                        : Curves.easeOutExpo,
                    opacity: isNavigated ? 1 : 0,
                    child: Icon(Icons.arrow_back, color: Colors.white70),
                  ),
                ),
              ),
            ),
            Text(
              carModel.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 4,
                color: Colors.white70,
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 15),
        Text(
          carModel.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
