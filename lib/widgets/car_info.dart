import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_pageview/linked_pageview.dart';
import 'package:threed_cars_challenge/core/AnimationConst.dart';
import 'package:threed_cars_challenge/widgets/car_specs.dart';

import '../core/car_model.dart';
import '../core/enums.dart';

// Bottom PageView - Description and Specs
class CarInfoView extends StatelessWidget {
  final CarModel carModel;
  final bool isNavigated;

  const CarInfoView({
    super.key,
    required this.carModel,
    required this.isNavigated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFF46484a),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimatedOpacity(
                opacity: isNavigated ? 0 : 1,
                duration: AnimationConsts.smallDuration,
                curve: AnimationConsts.easeCurve,
                child: Text(
                  carModel.description,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CarSpecs(label: "TOP SPEED", value: carModel.topSpeed),
                  CarSpecs(label: "PERFORMANCE", value: carModel.performance),
                  CarSpecs(label: "WEIGHT", value: carModel.weight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
