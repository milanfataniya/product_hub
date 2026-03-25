import 'package:flutter/material.dart';
class InfoBoxRow extends StatelessWidget {
  final String label;
  final String value;
  final double width;
  final List<Color> gradientColors;

  const InfoBoxRow({
    super.key,
    required this.label,
    required this.value,
    this.width = 150,
    this.gradientColors = const [
      Color(0xFFFFE5B4),
      Color(0xFFFFB74D),
    ],
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: gradientColors,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}