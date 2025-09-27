import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: Text(
            AppLocalizations.of(context)?.login??"Login",
            style: AppTextStyling.font26W00TextInter.copyWith(fontSize: 32),
          ),
        ),
        const SizedBox(height: 8),

        Text(
         AppLocalizations.of(context)!.logInToContinueYourJourney,
          style: AppTextStyling.font16W500TextInter.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
