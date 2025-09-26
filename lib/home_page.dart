import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

import 'core/car_model.dart' ;

class CarPageViewScreen extends StatefulWidget {
  const CarPageViewScreen({super.key});

  @override
  State<CarPageViewScreen> createState() => _CarPageViewScreenState();
}

class _CarPageViewScreenState extends State<CarPageViewScreen> {
  final PageController pageController = PageController();
  final Map<int, Flutter3DController> controllers = {};
  final Map<int, bool> modelLoaded = {};
  int currentPage = 0;

  // camera presets: (azimuth, elevation, radius) — tweak per model
  final Map<String, List<double>> presets = {
    'front': [0, 0, 4],
    'side': [90, 0, 4],
    'top': [0, 80, 5],
    'iso': [30, 30, 6],
  };
  String currentPreset = 'front';

  @override
  void initState() {
    super.initState();
    // lazily create controller for first page
    _ensureControllerForPage(0);
  }

  void _ensureControllerForPage(int index) {
    if (controllers.containsKey(index)) return;
    final ctrl = Flutter3DController();
    controllers[index] = ctrl;
    modelLoaded[index] = false;
    ctrl.onModelLoaded.addListener(() {
      if (ctrl.onModelLoaded.value == true) {
        setState(() => modelLoaded[index] = true);
        // optional: set a good default camera orbit on load
        ctrl.setCameraOrbit(
          presets[currentPreset]![0],
          presets[currentPreset]![1],
          presets[currentPreset]![2],
        );
      }
    });
  }

  void _disposeControllerForPage(int index) {
    final c = controllers.remove(index);
    modelLoaded.remove(index);
    // c?.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => currentPage = page);
    // create controller for new page
    _ensureControllerForPage(page);

    // optionally dispose controllers far away to save memory
    final toDispose = controllers.keys
        .where((i) => (i - page).abs() > 1)
        .toList();
    for (final i in toDispose) _disposeControllerForPage(i);
  }

  /// Switch camera to a preset for the currently visible model
  void _applyPreset(String preset) {
    final ctrl = controllers[currentPage];
    if (ctrl == null) return;
    final p = presets[preset]!;
    // setCameraOrbit(azimuth, elevation, radius)
    ctrl.setCameraOrbit(p[0], p[1], p[2]);
    setState(() => currentPreset = preset);
  }

  @override
  void dispose() {
    // for (final c in controllers.values) c.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget _buildViewer(int index) {
    _ensureControllerForPage(index);
    final ctrl = controllers[index]!;
    final car = carModels[index];

    return Flutter3DViewer(
      controller: ctrl,
      src: car.modelPath,
      enableTouch: true,
      // user can rotate/pinch
      progressBarColor: Colors.amber,
      onLoad: (addr) {
        // model is loaded - controller.onModelLoaded will also fire
        debugPrint('Loaded model: $addr');
      },
      onError: (err) => debugPrint('Failed to load: $err'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cars 3D — PageView')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: carModels.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (ctx, i) {
                // show only the car viewer (centered), like your reference image
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            color: Colors.grey[900],
                            child: GestureDetector(
                              onTap: () {
                                // a quick tap cycles camera preset (example)
                                final order = ['front', 'side', 'top', 'iso'];
                                final next =
                                    order[(order.indexOf(currentPreset) + 1) %
                                        order.length];
                                _applyPreset(next);
                              },
                              child: _buildViewer(i),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        carModels[i].name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),

          // small control row to choose preset explicitly
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: presets.keys.map((k) {
                final selected = k == currentPreset;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected ? Colors.amber : null,
                  ),
                  onPressed: () => _applyPreset(k),
                  child: Text(k.toUpperCase()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
