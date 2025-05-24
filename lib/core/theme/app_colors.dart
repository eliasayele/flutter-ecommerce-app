import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from Figma
  static const Color primary = Color(0xFFD49F07); // Primary golden
  static const Color primaryLight = Color(0xFFF4D374); // Light golden
  static const Color primarySuperLight = Color(
    0xFFFFE393,
  ); // Super light golden
  static const Color primaryAccent = Color(0xFFFFE8B2); // Accent golden

  // Background colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = Color(0xFFF6F6F6); // Light gray
  static const Color backgroundDark = Color(0xFF3A3A3A); // Dark gray
  static const Color backgroundBlack = Color(0xFF000000); // Black
  static const Color backgroundCharcoal = Color(0xFF1F2223); // Charcoal
  static const Color backgroundMedium = Color(0xFF57595A); // Medium gray
  static const Color backgroundDarkGray = Color(0xFF252425); // Dark gray
  static const Color backgroundSlate = Color(0xFF363939); // Slate
  static const Color backgroundLight = Color(0xFFD2D3D3); // Light gray
  static const Color backgroundDarkest = Color(0xFF1E1E1E); // Darkest

  // Text colors
  static const Color textPrimary = Color(0xFF1E1E1E); // Dark text
  static const Color textSecondary = Color(0xFF616161); // Medium gray text
  static const Color textLight = Color(0xFFD2D3D3); // Light text
  static const Color textWhite = Color(0xFFFFFFFF); // White text

  // Border colors
  static const Color borderLight = Color(0xFFE8ECF4); // Light border color

  // Overlay colors
  static const Color overlay = Color(0x1A000000); // Black with 10% opacity

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  AppColors._(); // Private constructor to prevent instantiation
}
