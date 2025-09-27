
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 16)),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go('/forget');
          },
          child: Text(
          
             AppLocalizations.of(context)!.forgotPassword,
            style: AppTextStyling.font14W600TextInter.copyWith(
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textWhite.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
