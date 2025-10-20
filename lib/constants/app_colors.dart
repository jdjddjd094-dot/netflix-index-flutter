import 'package:flutter/material.dart';
import 'app_constants.dart';

class AppColors {
  static const Color netflixRed = Color(AppConstants.netflixRedValue);
  static const Color netflixBlack = Color(AppConstants.netflixBlackValue);
  static const Color netflixDarkGray = Color(AppConstants.netflixDarkGrayValue);
  static const Color netflixGray = Color(AppConstants.netflixGrayValue);
  static const Color netflixLightGray = Color(AppConstants.netflixLightGrayValue);
  static const Color netflixWhite = Color(AppConstants.netflixWhiteValue);
  
  // Additional colors for better UI
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);
  static const Color transparent = Colors.transparent;
  
  // Gradient colors
  static const LinearGradient blackGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x80000000),
      Color(0xFF000000),
    ],
  );
  
  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      netflixRed,
      Color(0xFFB20710),
    ],
  );
}