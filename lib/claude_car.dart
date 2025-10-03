// import 'package:flutter/material.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:linked_pageview/linked_pageview.dart';
// import 'package:threed_cars_challenge/core/AnimationConst.dart';
// import 'package:threed_cars_challenge/home_page.dart' show CameraControlPanel;
// import 'package:threed_cars_challenge/widgets/car_info.dart';
// import 'package:threed_cars_challenge/widgets/car_title.dart';
//
// import 'core/car_model.dart';
// import 'core/enums.dart';
//
// const Map<CameraAngle, List<double>> _cameraPositions = {
//   CameraAngle.front: [0, 80, 100],
//   CameraAngle.side: [-90, 90, 100],
//   CameraAngle.rear: [180, 90, 100],
//   CameraAngle.topDown: [0, 0, 100],
//   CameraAngle.detail: [40, 80, 100],
// };
//
// class CarShowcaseScreen extends StatefulWidget {
//   const CarShowcaseScreen({super.key});
//
//   @override
//   _CarShowcaseScreenState createState() => _CarShowcaseScreenState();
// }
//
// class _CarShowcaseScreenState extends State<CarShowcaseScreen> {
//   final controllerGroup = LinkedPageControllerGroup();
//
//   late final controller1;
//
//   late final controller2;
//
//   late final controller3;
//
//   int _currentIndex = 0;
//   bool _isNavigated = false;
//
//   // Static controllers that persist across page changes
//   static final Map<int, Flutter3DController> _persistentControllers = {};
//   static final Map<int, CameraAngle> _persistentAngles = {};
//   static final Map<int, bool> _persistentLoadingStates = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePersistentControllers();
//     controller1 = controllerGroup.create();
//     controller2 = controllerGroup.create();
//     controller3 = controllerGroup.create();
//   }
//
//   void _initializePersistentControllers() {
//     for (int i = 0; i < carModels.length; i++) {
//       if (!_persistentControllers.containsKey(i)) {
//         _persistentControllers[i] = Flutter3DController();
//         _persistentAngles[i] = CameraAngle.side;
//         _persistentLoadingStates[i] = true;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("BUILDING FULL");
//     final screenHeight = MediaQuery.of(context).size.height;
//     final titleHeight = screenHeight * 0.15;
//     final carHeight = screenHeight * 0.5;
//     final infoHeight = screenHeight * 0.35;
//
//     return Scaffold(
//       backgroundColor: Color(0xFF2e3032),
//       body: Stack(
//         children: [
//           // Top Section - Title PageView
//           AnimatedPositioned(
//             duration: AnimationConsts.mainDuration,
//             curve: AnimationConsts.curve,
//             top: _isNavigated ? 50 : 120,
//             left: 0,
//             right: 0,
//             height: titleHeight,
//             child: LinkedPageView.builder(
//               controller: controller1,
//               itemCount: carModels.length,
//               itemBuilder: (context, index) {
//                 return CarTitleView(
//                   carModel: carModels[index],
//                   isNavigated: _isNavigated,
//                 );
//               },
//             ),
//           ),
//
//           /// bottom Background
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: infoHeight + 80,
//             child: Container(color: Color(0xFF46484a)),
//           ),
//
//           // Bottom Section - Info PageView
//           AnimatedPositioned(
//             duration: AnimationConsts.secondaryDuration,
//             curve: Curves.easeInOut,
//             bottom: _isNavigated ? -20 : 80,
//             left: 0,
//             right: 0,
//             height: infoHeight,
//             child: LinkedPageView.builder(
//               controller: controller3,
//               onPageChanged: (value) {
//                 _currentIndex = value;
//               },
//               itemCount: carModels.length,
//               itemBuilder: (context, index) {
//                 return CarInfoView(carModel: carModels[index]);
//               },
//             ),
//           ),
//
//           // Middle Section - 3D Car PageView (Persistent)
//           Positioned(
//             top: 95 + titleHeight,
//             left: 0,
//             right: 0,
//             height: carHeight,
//             child: LinkedPageView.builder(
//               controller: controller2,
//               itemCount: carModels.length,
//               itemBuilder: (context, index) {
//                 return PersistentCar3DViewer(
//                   carModel: carModels[index],
//                   controller: _persistentControllers[index]!,
//                   currentAngle: _persistentAngles[index]!,
//                   onAngleChanged: (angle) {
//                     setState(() {
//                       _persistentAngles[index] = angle;
//                     });
//                   },
//                   onTap: () {
//                     setState(() {
//                       _isNavigated = !_isNavigated;
//
//                       final preset = _isNavigated
//                           ? CameraAngle.topDown
//                           : CameraAngle.side;
//                       final p = _cameraPositions[preset]!;
//                       _persistentControllers[_currentIndex]?.setCameraOrbit(
//                         p[0],
//                         p[1],
//                         p[2],
//                       );
//                     });
//                   },
//                   onLoadingChanged: (isLoading) {
//                     setState(() {
//                       _persistentLoadingStates[index] = isLoading;
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//
//           // Static "Models" Text
//           Positioned(
//             left: 0,
//             right: 0,
//             top: 70,
//             child: AnimatedOpacity(
//               duration: AnimationConsts.secondaryDuration,
//               curve: Curves.easeInOut,
//               opacity: _isNavigated ? 0 : 1,
//               child: Text(
//                 "Models",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 2,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//
//           // Buy Now Button (Independent)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SafeArea(
//               child: AnimatedOpacity(
//                 duration: AnimationConsts.secondaryDuration,
//                 curve: _isNavigated ? Curves.easeOutExpo : Curves.easeInExpo,
//                 opacity: _isNavigated ? 0 : 1,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFFf2d796), Color(0xFFf5b463)],
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Buy now",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller1.dispose();
//     controller2.dispose();
//     controller3.dispose();
//     controllerGroup.dispose();
//     super.dispose();
//   }
// }
//
// // Middle PageView - Persistent 3D Car
// class PersistentCar3DViewer extends StatefulWidget {
//   final CarModel carModel;
//   final Flutter3DController controller;
//   final CameraAngle currentAngle;
//   final Function(CameraAngle) onAngleChanged;
//   final Function() onTap;
//   final Function(bool) onLoadingChanged;
//
//   const PersistentCar3DViewer({
//     super.key,
//     required this.carModel,
//     required this.onTap,
//     required this.controller,
//     required this.currentAngle,
//     required this.onAngleChanged,
//     required this.onLoadingChanged,
//   });
//
//   @override
//   _PersistentCar3DViewerState createState() => _PersistentCar3DViewerState();
// }
//
// class _PersistentCar3DViewerState extends State<PersistentCar3DViewer>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//
//   bool _modelLoaded = false;
//   bool _initialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (!_initialized) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _setupLoadingCallbacks();
//         _initialized = true;
//       });
//     }
//   }
//
//   void _setupLoadingCallbacks() {
//     widget.controller.onModelLoaded.addListener(() {
//       final loaded = widget.controller.onModelLoaded.value;
//       if (mounted) {
//         setState(() {
//           _modelLoaded = loaded;
//         });
//         widget.onLoadingChanged(!loaded);
//       }
//     });
//   }
//
//   void _applyPreset(CameraAngle preset) {
//     final p = _cameraPositions[preset]!;
//     widget.controller.setCameraOrbit(p[0], p[1], p[2]);
//     widget.onAngleChanged(preset);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     return Stack(
//       children: [
//         // 3D Model Viewer
//         Positioned.fill(
//           child: GestureDetector(
//             onTap: () {
//               widget.onTap();
//               print("object");
//             },
//             child: AbsorbPointer(
//               // prevents camera interactions
//               absorbing: true,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Flutter3DViewer(
//                   controller: widget.controller,
//                   src: widget.carModel.modelPath,
//                   progressBarColor: widget.carModel.accentColor,
//                   onLoad: (_) {
//                     widget.controller.setCameraOrbit(-90, 90, 100);
//                   },
//                   onError: (error) {
//                     print(
//                       "❌ Error loading model: ${widget.carModel.name} - $error",
//                     );
//                     if (mounted) {
//                       widget.onLoadingChanged(false);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         // Loading Overlay
//         if (!_modelLoaded)
//           Container(
//             color: Colors.black54,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: widget.carModel.accentColor),
//                   SizedBox(height: 16),
//                   Text(
//                     "Loading ${widget.carModel.name}...",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//         // Camera Angle Controls
//         Positioned(
//           top: 20,
//           right: 20,
//           child: CameraControlPanel(
//             currentAngle: widget.currentAngle,
//             onAngleChanged: _applyPreset,
//             accentColor: widget.carModel.accentColor,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_pageview/linked_pageview.dart';
import 'package:threed_cars_challenge/core/AnimationConst.dart';
import 'package:threed_cars_challenge/home_page.dart' show CameraControlPanel;
import 'package:threed_cars_challenge/widgets/car_info.dart';
import 'package:threed_cars_challenge/widgets/car_title.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _positionedAnimation;
  late Animation<double> _leftPositionedAnimation;
  late Animation<double> _heightAnimation;

  final controllerGroup = LinkedPageControllerGroup();

  late final controller1;

  late final controller2;

  late final controller3;

  int _currentIndex = 0;
  bool _isNavigated = false;

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

    // Animation Sequence:
    // 1. Rotate from left to right (0 to 90 degrees)
    _rotationAnimation =
        Tween<double>(
          begin: 0,
          end: 1.5708, // 90 degrees in radians (π/2)
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.7, curve: Curves.easeInOut),
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
            curve: Interval(0.0, 1, curve: Curves.easeInOut),
          ),
        );

    _positionedAnimation =
        Tween<double>(
          begin: 0, // Original height
          end: 1, // Full screen height
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1, curve: Curves.easeInOut),
          ),
        );
    _leftPositionedAnimation =
        Tween<double>(
          begin: -1, // Original height
          end: 1, // Full screen height
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1, curve: Curves.easeInOut),
          ),
        );

    // 3. Expand to full width (while maintaining full height)

    controller1 = controllerGroup.create();
    controller2 = controllerGroup.create();
    controller3 = controllerGroup.create();
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
  Widget build(BuildContext context) {
    print("BUILDING FULL");
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    final titleHeight = screenHeight * 0.15;
    final carHeight = screenHeight * 0.5;
    final infoHeight = screenHeight * 0.35;

    String _getPhaseText() {
      if (_controller.value < 0.3) return 'Phase 1: Rotating';
      if (_controller.value < 0.6) return 'Phase 2: Growing';
      return 'Phase 3: Expanding';
    }

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
                    // bottom: _rotationAnimation.value * (size.height - 20),
                    // top:
                    //     size.height -
                    //     infoHeight -
                    //     80 ,
                    // top:
                    //     size.height * _heightAnimation.value ,
                    bottom: _positionedAnimation.value * size.height * 0.5,
                    // bottom: 0,
                    left: _leftPositionedAnimation.value * size.width  ,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      // angle: 0,
                      alignment: AlignmentGeometry.topLeft,
                      // alignment: Alignment.centerLeft,
                      child: Container(
                        clipBehavior: Clip.none,
                        // height: size.height,
                        height: infoHeight + 80 + (70 * _heightAnimation.value),
                        width: size.height * 10,
                        // height: currentHeight,
                        color: Color(0xFF46484a),
                        child: Center(
                          child: Text(
                            _getPhaseText(),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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



          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   height: infoHeight + 80,
          //   child: Container(color: Color(0xFF46484a)),
          // ),

          // Bottom Section - Info PageView
          AnimatedPositioned(
            duration: AnimationConsts.secondaryDuration,
            curve: Curves.easeInOut,
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
                return CarInfoView(carModel: carModels[index]);
              },
            ),
          ),

          // Middle Section - 3D Car PageView (Persistent)
          Positioned(
            top: 95 + titleHeight,
            left: 0,
            right: 0,
            height: carHeight,
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

          // Static "Models" Text
          Positioned(
            left: 0,
            right: 0,
            top: 70,
            child: AnimatedOpacity(
              duration: AnimationConsts.secondaryDuration,
              curve: Curves.easeInOut,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controllerGroup.dispose();
    super.dispose();
  }
}

// Middle PageView - Persistent 3D Car
class PersistentCar3DViewer extends StatefulWidget {
  final CarModel carModel;
  final Flutter3DController controller;
  final CameraAngle currentAngle;
  final Function(CameraAngle) onAngleChanged;
  final Function() onTap;
  final Function(bool) onLoadingChanged;

  const PersistentCar3DViewer({
    super.key,
    required this.carModel,
    required this.onTap,
    required this.controller,
    required this.currentAngle,
    required this.onAngleChanged,
    required this.onLoadingChanged,
  });

  @override
  _PersistentCar3DViewerState createState() => _PersistentCar3DViewerState();
}

class _PersistentCar3DViewerState extends State<PersistentCar3DViewer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _modelLoaded = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setupLoadingCallbacks();
        _initialized = true;
      });
    }
  }

  void _setupLoadingCallbacks() {
    widget.controller.onModelLoaded.addListener(() {
      final loaded = widget.controller.onModelLoaded.value;
      if (mounted) {
        setState(() {
          _modelLoaded = loaded;
        });
        widget.onLoadingChanged(!loaded);
      }
    });
  }

  void _applyPreset(CameraAngle preset) {
    final p = _cameraPositions[preset]!;
    widget.controller.setCameraOrbit(p[0], p[1], p[2]);
    widget.onAngleChanged(preset);
  }

  // Store the web view controller
  WebViewController? _webViewController;

  // Current camera orbit
  String _currentOrbit = '-90deg 90deg 100m'; // Start with side view

  bool _isTopDownView = false;

  // Method to change orbital view
  void _changeOrbitalView() {
    if (_isTopDownView) {
      _currentOrbit = '-90deg 90deg 100m'; // Side view
      _isTopDownView = false;
    } else {
      _currentOrbit = '0deg 0deg 100m'; // Top down view
      _isTopDownView = true;
    }

    print("Changing view - Top Down: $_isTopDownView, orbit: $_currentOrbit");

    // Updated JavaScript with proper animation handling
    _webViewController?.runJavaScript("""
    (function() {
      const mv = document.querySelector('model-viewer');
      if (mv) {
        // Enable camera controls temporarily for animation
        mv.cameraControls = true;
        
        // Set the new orbit with animation
        mv.cameraOrbit = '$_currentOrbit';
        
        // Ensure smooth animation
        mv.interactionPrompt = 'none';
        
        
        // Disable controls after animation completes
        setTimeout(() => {
          mv.cameraControls = false;
        }, 1000);
        
        console.log("Animating camera to: $_currentOrbit");
      } else {
        console.log("Model viewer not found");
      }
    })();
  """);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        // 3D Model Viewer
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              widget.onTap();
              print("Model viewer tapped - changing orbit");
              // Change camera orbit on tap
              _changeOrbitalView();
            },
            child: AbsorbPointer(
              // prevents camera interactions
              absorbing: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ModelViewer(
                  src: widget.carModel.modelPath,
                  alt: widget.carModel.name,
                  backgroundColor: Colors.transparent,
                  cameraControls: false,
                  disableZoom: true,
                  disablePan: true,
                  interpolationDecay: 150,
                  cameraOrbit: _currentOrbit,
                  loading: Loading.eager,
                  onWebViewCreated: (webController) {
                    _webViewController = webController;

                    // Initialize the model viewer with proper settings
                    webController.runJavaScript("""
  
""");
                  },
                  javascriptChannels: {
                    JavascriptChannel(
                      'ModelViewerChannel',
                      onMessageReceived: (message) {
                        final payload = message.message;
                        if (payload == 'loaded') {
                          widget.onLoadingChanged(false);
                          print('✅ Model loaded successfully');
                        } else if (payload == 'view_tapped') {
                          // Handle tap from JavaScript side
                          _changeOrbitalView();
                        } else if (payload.startsWith('error:')) {
                          final err = payload.substring(6);
                          print(
                            "❌ Error loading model: ${widget.carModel.name} - $err",
                          );
                          widget.onLoadingChanged(false);
                        }
                      },
                    ),
                    JavascriptChannel(
                      'ConsoleChannel',
                      onMessageReceived: (message) {
                        print('🔍 WEBVIEW LOG: ${message.message}');
                      },
                    ),
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
