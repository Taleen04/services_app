import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  const PasswordField({
    super.key,
    required this.controller,
    required this.text,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsiveWidth(context, 350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.text,
            style: AppTextStyling.font14W600TextInter.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            textAlign: TextAlign.right,
            obscureText: !_isPasswordVisible,
            keyboardType: TextInputType.visiblePassword,
            enableInteractiveSelection: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            validator: _validatePassword,
            decoration: InputDecoration(
              hintText: "••••••••",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                  HapticFeedback.lightImpact();
                },
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
                borderSide: const BorderSide(
                  color: Color(0xFFFF7043),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
