import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/font_weight_helper.dart'
    show FontWeightHelper;

class AppTextStyling {
  AppTextStyling._();
  //inter font styles& FontSize 16
  static TextStyle font16W500TextInter = GoogleFonts.cairo(
    color: AppColors.textWhite,
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    height: 1,
    letterSpacing: 0,
  );
  //inter font styles FontSize 26
  static TextStyle font26W00TextInter = GoogleFonts.cairo(
    color: AppColors.primaryText,
    fontSize: 26,
    fontWeight: FontWeightHelper.bold,
    height: 1,
    letterSpacing: 0,
  );
  static TextStyle font14W600TextInter = GoogleFonts.cairo(
    color: AppColors.primaryText,
    fontSize: 12,
    fontWeight: FontWeightHelper.semiBold,
    height: 1,
    letterSpacing: 0,
  );
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Caption & Labels
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Button Text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
}
