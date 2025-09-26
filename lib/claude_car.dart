import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

import 'core/car_model.dart';
import 'core/enums.dart';

//
// class CarShowcaseScreen extends StatefulWidget {
//   @override
//   _CarShowcaseScreenState createState() => _CarShowcaseScreenState();
// }
//
// class _CarShowcaseScreenState extends State<CarShowcaseScreen>  with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
//
//   Flutter3DController controller = Flutter3DController();
//   CameraAngle _currentAngle = CameraAngle.front;
//
//   PageController _pageController = PageController();
//   int _currentIndex = 0;
//
//   @override
//   bool get wantKeepAlive => true; // ✅ ensures widget is kept alive
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // ✅ important when using keepAlive mixin
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           // 3D Car Display Area
//           Expanded(
//             flex: 3,
//             child:
//             PageView(
//               controller: _pageController,
//               onPageChanged: (index) {
//                 setState(() => _currentIndex = index);
//               },
//               children: carModels.map((car) => Car3DViewer(carModel: car)).toList(),
//             )
//
//             // PageView.builder(
//             //   controller: _pageController,
//             //   itemCount: carModels.length,
//             //   onPageChanged: (index) {
//             //     setState(() {
//             //       _currentIndex = index;
//             //     });
//             //   },
//             //   itemBuilder: (context, index) {
//             //     return Car3DViewer(
//             //       carModel: carModels[index],
//             //       key: ValueKey(index), // Important for proper rebuilding
//             //     );
//             //   },
//             // ),
//           ),
//
//           // Car Information Panel
//           Expanded(
//             flex: 2,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.8),
//                     Colors.black,
//                   ],
//                 ),
//               ),
//               child: CarInfoPanel(
//                 carModel: carModels[_currentIndex],
//                 currentIndex: _currentIndex,
//                 totalCars: carModels.length,
//                 onPageChanged: (index) {
//                   _pageController.animateToPage(
//                     index,
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                   );
//                 },
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
//     _pageController.dispose();
//     super.dispose();
//   }
// }
//
// class Car3DViewer extends StatefulWidget {
//   final CarModel carModel;
//
//   const Car3DViewer({Key? key, required this.carModel}) : super(key: key);
//
//   @override
//   _Car3DViewerState createState() => _Car3DViewerState();
// }
//
// class _Car3DViewerState extends State<Car3DViewer> {
//   Flutter3DController controller = Flutter3DController();
//   CameraAngle _currentAngle = CameraAngle.front;
//
//   // Predefined camera positions for different angles
//   final Map<CameraAngle, List<double>> _cameraPositions = {
//     CameraAngle.front: [0, 0, 4],
//     CameraAngle.side: [90, 0, 4],
//     CameraAngle.rear: [30, 30, 6],
//     CameraAngle.topDown: [0, 80, 5],
//     CameraAngle.detail: [30, 30, 6],
//   };
//
//   final Map<String, List<double>> presets = {
//     'front': [0, 0, 4],
//     'side': [90, 0, 4],
//     'top': [0, 80, 5],
//     'iso': [30, 30, 6],
//   };
//   CameraAngle currentPreset = CameraAngle.front;
//
//   /// Switch camera to a preset for the currently visible model
//   void _applyPreset(CameraAngle preset) {
//     // final ctrl = controllers[currentPage];
//     // if (ctrl == null) return;
//     final p = _cameraPositions[preset]!;
//     // setCameraOrbit(azimuth, elevation, radius)
//     controller.setCameraOrbit(p[0], p[1], p[2]);
//     setState(() => currentPreset = preset);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Auto-rotate the model
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // _ensureControllerForPage(0);
//
//       // _startAutoRotation();
//     });
//   }
//
//   // void _startAutoRotation() {
//   //   // controller.setRotationY(360); // Rotate 360 degrees on Y-axis
//   //   // controller.setAnimationDuration(10000); // 10 seconds for full rotation
//   //   // controller.setAutoRotate(true);
//   // }
//
//   void _changeCameraAngle(CameraAngle angle) {
//     _applyPreset(angle);
//     // setState(() {
//     //   _currentAngle = angle;
//     // });
//     //
//     // final position = _cameraPositions[angle]!;
//
//     // Smoothly animate to new camera position
//     // controller.setCameraPosition(
//     //   position['cameraX']!,
//     //   position['cameraY']!,
//     //   position['cameraZ']!,
//     // );
//
//     // controller.setCameraTarget(
//     //   position['targetX']!,
//     //   position['targetY']!,
//     //   position['targetZ']!,
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment.center,
//           radius: 1.0,
//           colors: [widget.carModel.primaryColor.withOpacity(0.3), Colors.black],
//         ),
//       ),
//       child: Stack(
//         children: [
//           // 3D Model Viewer
//           Flutter3DViewer(
//             controller: controller,
//             src: widget.carModel.modelPath,
//             // Lighting settings
//             // environmentImage: 'assets/environments/studio.hdr', // Optional HDR environment
//             // autoRotate: true,
//             // autoRotateDelay: 3000,
//             // autoRotateSpeed: 1.0,
//             // cameraControls: true,
//             // Loading and error widgets
//             progressBarColor: widget.carModel.accentColor,
//             // backgroundColor: Colors.transparent,
//             // loading: Center(
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       CircularProgressIndicator(
//             //         color: widget.carModel.accentColor,
//             //       ),
//             //       SizedBox(height: 16),
//             //       Text(
//             //         "Loading ${widget.carModel.name}...",
//             //         style: TextStyle(
//             //           color: Colors.white,
//             //           fontSize: 16,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // error: Center(
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       Icon(
//             //         Icons.error_outline,
//             //         color: widget.carModel.accentColor,
//             //         size: 48,
//             //       ),
//             //       SizedBox(height: 16),
//             //       Text(
//             //         "Unable to load 3D model",
//             //         style: TextStyle(
//             //           color: Colors.white,
//             //           fontSize: 16,
//             //         ),
//             //       ),
//             //       Text(
//             //         "Please check if the file exists",
//             //         style: TextStyle(
//             //           color: Colors.white70,
//             //           fontSize: 12,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ),
//
//           // Camera Angle Controls
//           Positioned(
//             top: 20,
//             right: 20,
//             child: CameraControlPanel(
//               currentAngle: _currentAngle,
//               onAngleChanged: _changeCameraAngle,
//               accentColor: widget.carModel.accentColor,
//             ),
//           ),
//
//           // Touch Gestures Hint
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black54,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.touch_app, color: Colors.white70, size: 16),
//                   SizedBox(width: 8),
//                   Text(
//                     "Drag to rotate • Pinch to zoom",
//                     style: TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                 ],
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
//     // controller.dispose();
//     super.dispose();
//   }
// }
//
class CameraControlPanel extends StatelessWidget {
  final CameraAngle currentAngle;
  final Function(CameraAngle) onAngleChanged;
  final Color accentColor;

  const CameraControlPanel({
    Key? key,
    required this.currentAngle,
    required this.onAngleChanged,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCameraButton(CameraAngle.front, Icons.visibility, "Front"),
          SizedBox(height: 4),
          _buildCameraButton(CameraAngle.side, Icons.arrow_forward, "Side"),
          SizedBox(height: 4),
          _buildCameraButton(CameraAngle.rear, Icons.arrow_back, "Rear"),
          SizedBox(height: 4),
          _buildCameraButton(
            CameraAngle.topDown,
            Icons.keyboard_arrow_up,
            "Top",
          ),
          SizedBox(height: 4),
          _buildCameraButton(CameraAngle.detail, Icons.zoom_in, "Detail"),
        ],
      ),
    );
  }

  Widget _buildCameraButton(CameraAngle angle, IconData icon, String label) {
    final bool isActive = currentAngle == angle;

    return GestureDetector(
      onTap: () => onAngleChanged(angle),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.white70,
              size: 20,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white70,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarInfoPanel extends StatelessWidget {
  final CarModel carModel;
  final int currentIndex;
  final int totalCars;
  final Function(int) onPageChanged;

  const CarInfoPanel({
    Key? key,
    required this.carModel,
    required this.currentIndex,
    required this.totalCars,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          Text(
            carModel.subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: 8),
          Text(
            carModel.name,
            // maxLines: 1,
            // overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              // fontSize: 28,

              fontWeight: FontWeight.bold,

              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Experience the pinnacle of automotive engineering and design with immersive 3D interaction.",
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 24),

          // Specifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSpec("TOP SPEED", carModel.topSpeed),
              _buildSpec("PERFORMANCE", carModel.performance),
              _buildSpec("WEIGHT", carModel.weight),
            ],
          ),
          SizedBox(height: 24),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalCars,
              (index) => GestureDetector(
                onTap: () => onPageChanged(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? carModel.accentColor
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpec(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CarShowcaseScreen extends StatefulWidget {
  @override
  _CarShowcaseScreenState createState() => _CarShowcaseScreenState();
}

class _CarShowcaseScreenState extends State<CarShowcaseScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  // Static controllers that persist across page changes
  static final Map<int, Flutter3DController> _persistentControllers = {};
  static final Map<int, CameraAngle> _persistentAngles = {};
  static final Map<int, bool> _persistentLoadingStates = {};

  @override
  void initState() {
    super.initState();
    // Initialize persistent controllers only once
    _initializePersistentControllers();
  }

  void _initializePersistentControllers() {
    for (int i = 0; i < carModels.length; i++) {
      if (!_persistentControllers.containsKey(i)) {
        _persistentControllers[i] = Flutter3DController();
        _persistentAngles[i] = CameraAngle.front;
        _persistentLoadingStates[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 3D Car Display Area with PageView
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: carModels.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
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
                  onLoadingChanged: (isLoading) {
                    setState(() {
                      _persistentLoadingStates[index] = isLoading;
                    });
                  },
                );
              },
            ),
          ),

          // Car Information Panel
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
              child: CarInfoPanel(
                carModel: carModels[_currentIndex],
                currentIndex: _currentIndex,
                totalCars: carModels.length,
                // loadingStates: _persistentLoadingStates,
                onPageChanged: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Don't dispose controllers here - they're static and persistent
    super.dispose();
  }
}

class PersistentCar3DViewer extends StatefulWidget {
  final CarModel carModel;
  final Flutter3DController controller;
  final CameraAngle currentAngle;
  final Function(CameraAngle) onAngleChanged;
  final Function(bool) onLoadingChanged;

  const PersistentCar3DViewer({
    Key? key,
    required this.carModel,
    required this.controller,
    required this.currentAngle,
    required this.onAngleChanged,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  _PersistentCar3DViewerState createState() => _PersistentCar3DViewerState();
}

class _PersistentCar3DViewerState extends State<PersistentCar3DViewer>
    with AutomaticKeepAliveClientMixin {
  // This is key - keeps the widget alive when scrolled out of view
  @override
  bool get wantKeepAlive => true;

  final Map<CameraAngle, List<double>> _cameraPositions = {
    ///x axis horizontal, y axis vertical, camera distance
    CameraAngle.front:  [0, 80, 100],
    CameraAngle.side: [90, 90, 100],
    CameraAngle.rear: [180, 90, 100],
    CameraAngle.topDown: [0, 0, 100],
    CameraAngle.detail: [40, 80, 100],
  };

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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveStateMixin

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [widget.carModel.primaryColor.withOpacity(0.3), Colors.black],
        ),
      ),
      child: Stack(
        children: [
          // 3D Model Viewer - stays loaded due to AutomaticKeepAliveStateMixin
          Flutter3DViewer(
            controller: widget.controller,
            src: widget.carModel.modelPath,
            // autoRotate: true,
            // autoRotateDelay: 3000,
            // autoRotateSpeed: 1.0,
            // cameraControls: true,
            progressBarColor: widget.carModel.accentColor,
            // onLoad: () {
            //   print("✅ Model loaded: ${widget.carModel.name}");
            //   if (mounted) {
            //     setState(() {
            //       _modelLoaded = true;
            //     });
            //     widget.onLoadingChanged(false);
            //   }
            // },
            onError: (error) {
              print("❌ Error loading model: ${widget.carModel.name} - $error");
              if (mounted) {
                widget.onLoadingChanged(false);
              }
            },
          ),

          // Loading Overlay
          if (!_modelLoaded)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: widget.carModel.accentColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading ${widget.carModel.name}...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // Camera Angle Controls
          Positioned(
            top: 20,
            right: 20,
            child: CameraControlPanel(
              currentAngle: widget.currentAngle,
              onAngleChanged: _applyPreset,
              accentColor: widget.carModel.accentColor,
            ),
          ),

          // Touch Gestures Hint
          if (_modelLoaded)
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Drag to rotate • Pinch to zoom • Swipe for next car",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
