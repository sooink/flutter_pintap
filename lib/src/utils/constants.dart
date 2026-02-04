import 'package:flutter/material.dart';

class PintapColors {
  // Base colors - Light Glassmorphism
  static const primary = Color(0xFF3B82F6); // Vivid blue
  static const surface = Color(0xFFFAFAFA); // Light gray
  static const surfaceGlass = Color(0xE6FFFFFF); // rgba(255, 255, 255, 0.9)
  static const border = Color(0x26000000); // rgba(0, 0, 0, 0.15)
  static const borderStrong = Color(0x40000000); // rgba(0, 0, 0, 0.25)

  // Tool active colors
  static const selectActive = Color(0xFF3B82F6); // Blue
  static const freezeActive = Color(0xFFF59E0B); // Amber
  static const successGreen = Color(0xFF10B981); // Emerald

  // Text
  static const textPrimary = Color(0xFF1F2937); // Dark gray
  static const textSecondary = Color(0xFF6B7280); // Medium gray
  static const textMuted = Color(0xFF9CA3AF); // Light gray

  // Pin
  static const pinBackground = Color(0xFF3B82F6);
  static const pinText = Colors.white;
  static const pinShadow = Color(0x403B82F6); // rgba(59, 130, 246, 0.25)

  // Highlight
  static const highlightBorder = Color(0xFF3B82F6);
  static const highlightHover = Color(0x803B82F6); // rgba(59, 130, 246, 0.5)

  // Button hover
  static const buttonHover = Color(0x0A000000); // rgba(0, 0, 0, 0.04)
}

class PintapConstants {
  static const double fabSize = 48.0;
  static const double fabBorderRadius = 14.0;

  static const double toolButtonSize = 40.0;
  static const double toolButtonRadius = 10.0;

  static const double toolbarRadius = 14.0;
  static const double toolbarBorderWidth = 1.0;
}
