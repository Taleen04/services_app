import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/constants/font_weight_helper.dart';

class CustomTextFromFiled extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color borderColor;
  String? Function(String?)? validator;

   CustomTextFromFiled({
    super.key,
    required this.label,
    required this.controller,
    required this.borderColor,
     this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        validator:validator ,
        controller: controller,
        textAlign: TextAlign.right, // النص يبدأ من اليمين
        textDirection: TextDirection.rtl, // اتجاه الكتابة من اليمين
        style: AppTextStyling.font16W500TextInter.copyWith(
          fontWeight: FontWeightHelper.medium,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyling.font16W500TextInter.copyWith(
            color: AppColors.backGroundIcon,
          ),
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }
}
