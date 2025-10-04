
// Define circle configurations
final List<CircleConfig> circles = [
  ///top
  CircleConfig(
    topFraction: 0.19,
    leftFraction: 0.5,
    leftOffset: -25,
    outerSize: 50,
    innerSize: 12,
  ),
  ///left
  CircleConfig(
    topFraction: 0.44,
    leftFraction: 0.2,
    outerSize: 40,
    innerSize: 10,
  ),
  ///bottom
  CircleConfig(
    bottomFraction: 0.18,
    leftFraction: 0.5,
    leftOffset: -17,
    outerSize: 35,
    innerSize: 10,
  ),

  ///right
  CircleConfig(
    bottomFraction: 0.3,
    rightFraction: 0.2,
    rightOffset: -17,
    outerSize: 35,
    innerSize: 10,
  ),
];

// Configuration class
class CircleConfig {
  final double? topFraction;
  final double? bottomFraction;
  final double? leftFraction;
  final double? rightFraction;
  final double? leftOffset;
  final double? rightOffset;
  final double outerSize;
  final double innerSize;

  CircleConfig({
    this.topFraction,
    this.bottomFraction,
    this.leftFraction,
    this.rightFraction,
    this.leftOffset,
    this.rightOffset,
    required this.outerSize,
    required this.innerSize,
  });
}