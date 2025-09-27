
import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/constants/font_weight_helper.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? colortext;
  final double? fontSize;
  final Gradient? gradient; // Gradient اختياري

  const ElevatedButtonCustom({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryText,
    this.colortext = AppColors.textWhite,
    this.fontSize = 18,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Center(
      child: Text(
        text,
        style: AppTextStyling.font16W500TextInter.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeightHelper.bold,
          color: colortext,
        ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: gradient != null
          ? DecoratedBox(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(6),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                onPressed: onPressed,
                child: buttonChild,
              ),
            )
          : ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(backgroundColor),
                side: WidgetStateProperty.all(
                  BorderSide(color: backgroundColor!, width: 1),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              onPressed: onPressed,
              child: buttonChild,
            ),
    );
  }
}
