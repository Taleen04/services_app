
import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';


class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.backGroundIcon.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 50),
            child: Text(
              AppLocalizations.of(context)?.login??"Login",
              style: AppTextStyling.font16W500TextInter.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
