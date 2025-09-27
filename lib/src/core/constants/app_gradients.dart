import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColors.primary,
      Color(0xFF2563EB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [
      AppColors.orange,
      Color(0xFFFF8A00),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      AppColors.cardBackground,
      Color(0xFF1A2A47),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}