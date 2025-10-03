import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_pageview/linked_pageview.dart';

import '../core/car_model.dart';
import '../core/enums.dart';
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