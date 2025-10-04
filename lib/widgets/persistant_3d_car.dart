// Middle PageView - Persistent 3D Car

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_pageview/linked_pageview.dart';
import 'package:threed_cars_challenge/core/AnimationConst.dart';
import 'package:threed_cars_challenge/core/car_model.dart';
import 'package:threed_cars_challenge/core/enums.dart';
import 'package:threed_cars_challenge/home_page.dart' show CameraControlPanel;
import 'package:threed_cars_challenge/widgets/car_info.dart';
import 'package:threed_cars_challenge/widgets/car_title.dart';
import 'package:webview_flutter/webview_flutter.dart';

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