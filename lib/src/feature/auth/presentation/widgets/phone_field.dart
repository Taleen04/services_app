import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const PhoneField({
    super.key,
    required this.controller,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber,
          style: AppTextStyling.font14W600TextInter.copyWith(
            color: AppColors.textWhite,
          ),
        ),
        SizedBox(height: responsiveHeight(context, 10)),
        SizedBox(
          width: responsiveWidth(context, 350),
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.phone,
            enableInteractiveSelection: true,
            autovalidateMode: AutovalidateMode.onUserInteraction, // التحقق أثناء الكتابة
            onSaved: onSaved,
            validator: validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'ادخل رقم هاتفك';
                  }
                  if (value.length != 10) {
                    return "رقم الهاتف يجب أن يكون 10 أرقام بالضبط";
                  }
                  return null; // كل شيء صحيح
                },
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: "07xxxxxxxx",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.white.withOpacity(0.8),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.textWhite, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
        ),
      ],
    );
  }
}
