// Car model class
import 'dart:ui';

import 'media.dart';

class CarModel {
  final String name;
  final String subtitle;
  final String modelPath;
  final String topSpeed;
  final String performance;
  final String weight;
  final Color primaryColor;
  final Color accentColor;

  CarModel({
    required this.name,
    required this.subtitle,
    required this.modelPath,
    required this.topSpeed,
    required this.performance,
    required this.weight,
    required this.primaryColor,
    required this.accentColor,
  });
}

final List<CarModel> carModels = [
  CarModel(
    name: "BUGATTI CHIRON",
    subtitle: "THE PUREST",
    modelPath: Media.bugatti1,
    topSpeed: "261 mph",
    performance: "1,479 hp",
    weight: "1,996 kg",
    primaryColor: const Color(0xFF1E3A8A),
    accentColor: const Color(0xFF3B82F6),
  ),
  CarModel(
    name: "BUGATTI TOURBILLON",
    subtitle: "THE ULTIMATE",
    modelPath: Media.bugatti2,
    topSpeed: "236 mph",
    performance: "1,775 hp",
    weight: "1,950 kg",
    primaryColor: const Color(0xFF991B1B),
    accentColor: const Color(0xFFEF4444),
  ),
  CarModel(
    name: "PORSCHE 911",
    subtitle: "THE LEGEND",
    modelPath: Media.porche,
    topSpeed: "193 mph",
    performance: "640 hp",
    weight: "1,640 kg",
    primaryColor: const Color(0xFF059669),
    accentColor: const Color(0xFF10B981),
  ),
  CarModel(
    name: "FERRARI 488 PISTA",
    subtitle: "THE BEAST",
    modelPath: Media.ferrari,
    topSpeed: "211 mph",
    performance: "710 hp",
    weight: "1,280 kg",
    primaryColor: const Color(0xFFDC2626),
    accentColor: const Color(0xFFF87171),
  ),
];
