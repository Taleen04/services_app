import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/phone_input_field.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.9;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,

        // زر أسفل الشاشة
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveWidth(context, 16),
            vertical: responsiveHeight(context, 16),
          ),
          child: SizedBox(
            width: fieldWidth,
            child: ElevatedButton(
              onPressed: () {
                log("إرسال رمز التحقق إلى: ${phoneController.text}");
                context.go('/otp');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backGroundIcon,
                padding: EdgeInsets.symmetric(
                  vertical: responsiveHeight(context, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "إرسال رمز التحقق",
                style: AppTextStyling.font16W500TextInter,
              ),
            ),
          ),
        ),

        // المحتوى
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85, // مرن مع الشاشة
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // حسب المحتوى
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: responsiveHeight(context, 60)),
                  Text(
                    "ادخل رقم الهاتف الخاص بك",
                    style: AppTextStyling.font26W00TextInter,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsiveHeight(context, 10)),
                  Text(
                    "سوف نرسل لك رمز التحقق",
                    style: AppTextStyling.font16W500TextInter,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsiveHeight(context, 40)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsiveWidth(context, 20),
                    ),
                    child: CustomPhoneInput(controller: phoneController),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
