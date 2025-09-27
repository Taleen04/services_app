
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';

class CustomPhoneInput extends StatelessWidget {
  final TextEditingController controller;

  const CustomPhoneInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsiveWidth(context, 350),
      child: TextField(
        textAlign: TextAlign.right,
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // أرقام فقط
          LengthLimitingTextInputFormatter(10), // أقصى طول 10 أرقام
        ],
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
            borderSide: BorderSide(
              color: AppColors.textWhite, // برتقالي غامق
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
