import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_pageview/linked_pageview.dart';
import 'package:threed_cars_challenge/core/AnimationConst.dart';
import 'package:threed_cars_challenge/core/circle_config_model.dart';
import 'package:threed_cars_challenge/home_page.dart' show CameraControlPanel;
import 'package:threed_cars_challenge/widgets/car_info.dart';
import 'package:threed_cars_challenge/widgets/car_title.dart';
import 'package:threed_cars_challenge/widgets/persistant_3d_car.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'core/car_model.dart';
import 'core/enums.dart';

const Map<CameraAngle, List<double>> _cameraPositions = {
  CameraAngle.front: [0, 80, 100],
  CameraAngle.side: [-90, 90, 100],
  CameraAngle.rear: [180, 90, 100],
  CameraAngle.topDown: [0, 0, 100],
  CameraAngle.detail: [40, 80, 100],
};

class CarShowcaseScreen extends StatefulWidget {
  const CarShowcaseScreen({super.key});

  @override
  _CarShowcaseScreenState createState() => _CarShowcaseScreenState();
}

class _CarShowcaseScreenState extends State<CarShowcaseScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _positionedAnimation;
  late Animation<double> _leftPositionedAnimation;
  late Animation<double> _heightAnimation;

  late AnimationController _containerController;
  late Animation<double> _containerAnimation;

  late AnimationController _containerShowController;
  late Animation<double> _outerScale;
  late Animation<double> _outerOpacity;
  late Animation<double> _innerScale;
  late Animation<double> _innerOpacity;

  final controllerGroup = LinkedPageControllerGroup();

  late final controller1;

  late final controller2;

  late final controller3;

  int _currentIndex = 0;
  bool _isNavigated = false;
  bool _isAnimating = false;

  // Static controllers that persist across page changes
  static final Map<int, Flutter3DController> _persistentControllers = {};
  static final Map<int, CameraAngle> _persistentAngles = {};
  static final Map<int, bool> _persistentLoadingStates = {};

  @override
  void initState() {
    super.initState();
    _initializePersistentControllers();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    ///the repeated animation
    _containerShowController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Outer container animation (first half of timeline)
    _outerScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _containerShowController,
        curve: const Interval(0.0, 0.3, curve: AnimationConsts.easeCurve),
      ),
    );

    _outerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _containerShowController,
        reverseCurve: const Interval(0.8, 1, curve: AnimationConsts.easeCurve),
        curve: const Interval(0.0, 0.3, curve: AnimationConsts.easeCurve),
      ),
    );

    // Inner container animation (starts later with a delay)
    _innerScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _containerShowController,
        curve: const Interval(0.3, 0.7, curve: AnimationConsts.easeCurve),
      ),
    );

    _innerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        reverseCurve: const Interval(0.8, 1, curve: AnimationConsts.easeCurve),
        parent: _containerShowController,
        curve: const Interval(0.3, 0.5, curve: AnimationConsts.easeCurve),
      ),
    );

    _containerController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Create a tween animation that scales between 0.8 and 1.2
    _containerAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _containerController, curve: AnimationConsts.easeCurve),
    );

    // Animation Sequence:
    // 1. Rotate from left to right (0 to 90 degrees)
    _rotationAnimation =
        Tween<double>(
          begin: 0,
          end: 1.5708, // 90 degrees in radians (π/2)
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.7, curve: AnimationConsts.easeCurve),
          ),
        );

    // 2. Grow to full height and 50% width

    _heightAnimation =
        Tween<double>(
          begin: 0, // Original height
          end: 4.7, // Full screen height
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.5, curve: AnimationConsts.easeCurve),
          ),
        );

    _positionedAnimation =
        Tween<double>(
          begin: 0, // Original height
          end: 1, // Full screen height
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1, curve: AnimationConsts.easeCurve),
          ),
        );
    _leftPositionedAnimation =
        Tween<double>(
          begin: -1, // Original height
          end: 1, // Full screen height
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1, curve: AnimationConsts.easeCurve),
          ),
        );

    controller1 = controllerGroup.create();
    controller2 = controllerGroup.create();
    controller3 = controllerGroup.create();
  }

  void _toggleAnimation() async {
    ///wait for first animation to finish to show this animation
    if (!_isAnimating) {
      await Future.delayed(Duration(milliseconds: 700));
    }

    if (_isAnimating) {
      _containerShowController.reverse();
      _containerController.stop();
    } else {
      _containerShowController.forward();
      _containerController.repeat(reverse: true);
    }
    _isAnimating = !_isAnimating;
    setState(() {});
  }

  void startAnimation() async {
    await Future.delayed(Duration(milliseconds: 100));
    _controller.forward();
  }

  void resetAnimation() {
    _controller.reset();
  }

  void reverseAnimation() {
    _controller.reverse();
  }

  void _initializePersistentControllers() {
    for (int i = 0; i < carModels.length; i++) {
      if (!_persistentControllers.containsKey(i)) {
        _persistentControllers[i] = Flutter3DController();
        _persistentAngles[i] = CameraAngle.side;
        _persistentLoadingStates[i] = true;
      }
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controllerGroup.dispose();
    _controller.dispose();
    _containerShowController.dispose();
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    final titleHeight = screenHeight * 0.15;
    final carHeight = screenHeight * 0.5;
    final infoHeight = screenHeight * 0.35;

    return Scaffold(
      backgroundColor: Color(0xFF2e3032),
      body: Stack(
        clipBehavior: Clip.none, // This allows children to overflow

        children: [
          /// bottom Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    bottom: _positionedAnimation.value * size.height * 0.5,
                    // bottom: 0,
                    left: _leftPositionedAnimation.value * size.width,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      // angle: 0,
                      alignment: AlignmentGeometry.topLeft,
                      // alignment: Alignment.centerLeft,
                      child: Container(
                        clipBehavior: Clip.none,
                        // height: size.height,
                        height: infoHeight + 90 + (70 * _heightAnimation.value),
                        width: size.height * 10,
                        // height: currentHeight,
                        color: Color(0xFF46484a),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Top Section - Title PageView
          AnimatedPositioned(
            duration: AnimationConsts.mainDuration,
            curve: AnimationConsts.curve,
            top: _isNavigated ? 50 : 120,
            left: 0,
            right: 0,
            height: titleHeight,
            child: LinkedPageView.builder(
              controller: controller1,
              itemCount: carModels.length,
              itemBuilder: (context, index) {
                return CarTitleView(
                  carModel: carModels[index],
                  isNavigated: _isNavigated,
                );
              },
            ),
          ),

          // Bottom Section - Info PageView
          AnimatedPositioned(
            duration: AnimationConsts.secondaryDuration,
            curve: AnimationConsts.easeCurve,
            bottom: _isNavigated ? -20 : 80,
            left: 0,
            right: 0,
            height: infoHeight,
            child: LinkedPageView.builder(
              controller: controller3,
              onPageChanged: (value) {
                _currentIndex = value;
              },
              itemCount: carModels.length,
              itemBuilder: (context, index) {
                return CarInfoView(
                  carModel: carModels[index],
                  isNavigated: _isNavigated,
                );
              },
            ),
          ),

          // Middle Section - 3D Car PageView (Persistent)
          Positioned(
            top: 95 + titleHeight,
            left: 0,
            right: 0,
            height: carHeight,
            child: AnimatedScale(
              scale: _isNavigated ? 1.6 : 1,
              curve: AnimationConsts.easeCurve,
              duration: AnimationConsts.mainDuration,
              child: LinkedPageView.builder(
                controller: controller2,
                itemCount: carModels.length,
                itemBuilder: (context, index) {
                  return PersistentCar3DViewer(
                    carModel: carModels[index],
                    controller: _persistentControllers[index]!,
                    currentAngle: _persistentAngles[index]!,
                    onAngleChanged: (angle) {
                      setState(() {
                        _persistentAngles[index] = angle;
                      });
                    },
                    onTap: () {
                      _toggleAnimation();

                      setState(() {
                        _isNavigated = !_isNavigated;
                      });

                      if (_isNavigated) {
                        startAnimation();
                      } else {
                        reverseAnimation();
                      }
                    },
                    onLoadingChanged: (isLoading) {
                      setState(() {
                        _persistentLoadingStates[index] = isLoading;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          // Static "Models" Text
          Positioned(
            left: 0,
            right: 0,
            top: 70,
            child: AnimatedOpacity(
              duration: AnimationConsts.secondaryDuration,
              curve: AnimationConsts.easeCurve,
              opacity: _isNavigated ? 0 : 1,
              child: Text(
                "Models",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Buy Now Button (Independent)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: AnimatedOpacity(
                duration: AnimationConsts.secondaryDuration,
                curve: _isNavigated ? Curves.easeOutExpo : Curves.easeInExpo,
                opacity: _isNavigated ? 0 : 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFf2d796), Color(0xFFf5b463)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Buy now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          ///--------------------------------------------------------------------------------------------------------------------------------------------
          // positioned
          ...circles
              .map((config) => _buildAnimatedCircle(size, config))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle(Size size, CircleConfig config) {
    return Positioned(
      top: config.topFraction != null
          ? size.height * config.topFraction!
          : null,
      bottom: config.bottomFraction != null
          ? size.height * config.bottomFraction!
          : null,
      left: config.leftFraction != null
          ? size.width * config.leftFraction! + (config.leftOffset ?? 0)
          : null,
      right: config.rightFraction != null
          ? size.width * config.rightFraction! + (config.rightOffset ?? 0)
          : null,
      child: AnimatedBuilder(
        animation: _containerShowController,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _containerAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle
                  Opacity(
                    opacity: _outerOpacity.value,
                    child: Transform.scale(
                      scale: _outerScale.value,
                      child: Transform.scale(
                        scale: _containerAnimation.value,
                        child: Container(
                          width: config.outerSize,
                          height: config.outerSize,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Inner circle
                  Opacity(
                    opacity: _innerOpacity.value,
                    child: Transform.scale(
                      scale: _innerScale.value,
                      child: Container(
                        width: config.innerSize,
                        height: config.innerSize,
                        decoration: const BoxDecoration(
                          color: Color(0xFFf5b463),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
