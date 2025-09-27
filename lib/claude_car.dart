import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/car_model.dart';
import 'core/enums.dart';

class CarShowcaseScreen extends StatefulWidget {
  const CarShowcaseScreen({super.key});

  @override
  _CarShowcaseScreenState createState() => _CarShowcaseScreenState();
}

class _CarShowcaseScreenState extends State<CarShowcaseScreen> {
  final PageController _pageController = PageController();
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
      backgroundColor: Color(0xFF2e3032),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // 3d View
            Positioned.fill(
              child: Center(
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
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 70,
              child: Text(
                "Models",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
                // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                //   color: Colors.white,
                //   fontWeight: FontWeight.w600,
                // ),
              ),
            ),

            // 3D Car Display Area with PageView

            // Car Information Panel
            // Expanded(
            //   flex: 2,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           Colors.transparent,
            //           Colors.black.withOpacity(0.8),
            //           Colors.black,
            //         ],
            //       ),
            //     ),
            //     child: CarInfoPanel(
            //       carModel: carModels[_currentIndex],
            //       currentIndex: _currentIndex,
            //       totalCars: carModels.length,
            //       // loadingStates: _persistentLoadingStates,
            //       onPageChanged: (index) {
            //         _pageController.animateToPage(
            //           index,
            //           duration: Duration(milliseconds: 300),
            //           curve: Curves.easeInOut,
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
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

class CameraControlPanel extends StatelessWidget {
  final CameraAngle currentAngle;
  final Function(CameraAngle) onAngleChanged;
  final Color accentColor;

  const CameraControlPanel({
    super.key,
    required this.currentAngle,
    required this.onAngleChanged,
    required this.accentColor,
  });

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
    super.key,
    required this.carModel,
    required this.currentIndex,
    required this.totalCars,
    required this.onPageChanged,
  });

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
              CarSpecs(label: "TOP SPEED", value: carModel.topSpeed),
              CarSpecs(label: "PERFORMANCE", value: carModel.performance),
              CarSpecs(label: "WEIGHT", value: carModel.weight),
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
}

class CarSpecs extends StatelessWidget {
  final String label;
  final String value;

  const CarSpecs({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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

class PersistentCar3DViewer extends StatefulWidget {
  final CarModel carModel;
  final Flutter3DController controller;
  final CameraAngle currentAngle;
  final Function(CameraAngle) onAngleChanged;
  final Function(bool) onLoadingChanged;

  const PersistentCar3DViewer({
    super.key,
    required this.carModel,
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
  // This is key - keeps the widget alive when scrolled out of view
  @override
  bool get wantKeepAlive => true;

  final Map<CameraAngle, List<double>> _cameraPositions = {
    ///x axis horizontal, y axis vertical, camera distance
    CameraAngle.front: [0, 80, 100],
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
        // gradient: RadialGradient(
        //   center: Alignment.center,
        //   radius: 1.0,
        //   colors: [widget.carModel.primaryColor.withOpacity(0.3), Colors.black],
        // ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            left: 0,
            right: 0,
            top: 170,
            child: Column(
              children: [
                Text(
                  widget.carModel.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4,
                    color: Colors.white70,
                  ),
                  // style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  //   color: Color(0xFFa2a5a6),
                  //   // fontWeight: FontWeight.w600,
                  // ),
                ),
                SizedBox(height: 15),
                Text(
                  widget.carModel.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                  // style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  //   color: Colors.white,
                  //   fontWeight: FontWeight.w600,
                  // ),
                ),
              ],
            ),
          ),

          // 3D Model Viewer - stays loaded due to AutomaticKeepAliveStateMixin
          Flutter3DViewer(
            controller: widget.controller,
            src: widget.carModel.modelPath,
            // autoRotate: true,
            // autoRotateDelay: 3000,
            // autoRotateSpeed: 1.0,
            // cameraControls: true,
            progressBarColor: widget.carModel.accentColor,
            onLoad: (_) {
              widget.controller.setCameraOrbit(90, 90, 100);
            },
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

          //Bottom Size
          Positioned(
            bottom: 0,
            child: Container(
              color: Color(0xFF46484a),
              height: MediaQuery.of(context).size.height * 0.435,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.carModel.description,
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                          letterSpacing: 1.5,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CarSpecs(
                            label: "TOP SPEED",
                            value: widget.carModel.topSpeed,
                          ),
                          CarSpecs(
                            label: "PERFORMANCE",
                            value: widget.carModel.performance,
                          ),
                          CarSpecs(
                            label: "WEIGHT",
                            value: widget.carModel.weight,
                          ),
                        ],
                      ),

                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFf5b463), Color(0xFFf2d796)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Buy now",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Positioned(
          //   bottom: 50,
          //   child: InkWell(
          //     onTap: () {},
          //     child: Container(
          //       width: MediaQuery.of(context).size.width,
          //       padding: EdgeInsets.all(16),
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [Color(0xFFf5b463), Color(0xFFf2d796)],
          //         ),
          //       ),
          //       child: Center(
          //         child: Text(
          //           "Buy now",
          //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // Touch Gestures Hint
          // if (_modelLoaded)
          //   Positioned(
          //     bottom: 50,
          //     left: 20,
          //     child: SafeArea(
          //       child: Container(
          //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //         decoration: BoxDecoration(
          //           color: Colors.black54,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Icon(Icons.touch_app, color: Colors.white70, size: 16),
          //             SizedBox(width: 8),
          //             Text(
          //               "Drag to rotate • Pinch to zoom • Swipe for next car",
          //               style: TextStyle(color: Colors.white70, fontSize: 12),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
