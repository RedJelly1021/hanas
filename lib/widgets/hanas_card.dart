import 'package:flutter/material.dart';

class HanasCard extends StatelessWidget
{
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? background;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color shadowColor;
  final double shadowBlur;
  final double shadowOpacity;
  final VoidCallback? onTap;

  const HanasCard
  ({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.background,
    this.borderColor,
    this.borderWidth = 1.2,
    this.borderRadius = 16,
    this.shadowColor = Colors.black,
    this.shadowBlur = 6,
    this.shadowOpacity = 0.25,
    this.onTap,
  });

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector
    (
      onTap: onTap,
      child: Container
      (
        margin: margin,
        padding: padding,
        decoration: BoxDecoration
        (
          color: background ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all
          (
            color: borderColor ?? Colors.transparent,
            width: borderWidth,
          ),
          boxShadow:
          [
            BoxShadow
            (
              color: shadowColor.withOpacity(shadowOpacity),
              blurRadius: shadowBlur,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}