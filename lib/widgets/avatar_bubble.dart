import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AvatarBubble extends StatelessWidget {
  final String initials;
  final double radius;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;

  const AvatarBubble({
    super.key,
    required this.initials,
    this.radius = 24,
    this.backgroundColor,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundGradient == null
            ? (backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1))
            : null,
        gradient: backgroundGradient,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
