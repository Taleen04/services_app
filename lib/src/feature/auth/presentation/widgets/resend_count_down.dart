import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';

class ResendCountdown extends StatefulWidget {
  const ResendCountdown({super.key});

  @override
  State<ResendCountdown> createState() => _ResendCountdownState();
}

class _ResendCountdownState extends State<ResendCountdown> {
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryText.withOpacity(0.2), // خلفية حمراء
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'لم يتم استلام أي رمز؟ ',
              style: AppTextStyling.font14W600TextInter.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            TextSpan(
              text:
                  _secondsLeft > 0
                      ? 'إعادة الإرسال خلال $_secondsLeft ثانية'
                      : 'إعادة الإرسال',
              style: AppTextStyling.font14W600TextInter.copyWith(
                color:
                    _secondsLeft > 0
                        ? AppColors.textPrimary
                        : AppColors.primaryText.withOpacity(
                          0.2,
                        ), // خلفية حمراء,
                fontWeight: FontWeight.bold,
                decoration: _secondsLeft == 0 ? TextDecoration.underline : null,
              ),
              recognizer:
                  _secondsLeft == 0
                      ? (TapGestureRecognizer()
                        ..onTap = () {
                          //! logic of resend otp
                          _startCountdown();
                        })
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
