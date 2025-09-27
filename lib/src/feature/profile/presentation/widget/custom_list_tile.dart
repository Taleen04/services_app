import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final bool isLanguageSwitch;
  final bool isActive;
  final bool isSwitch; // لتفعيل وضع Switch
  final bool switchValue; // قيمة المفتاح
  final ValueChanged<bool>? onSwitchChanged; // دالة عند تغيير القيمة
  final VoidCallback? onTap;
  final ValueChanged<bool>? onStatusChanged;
  final Color colortext;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    this.isLanguageSwitch = false,
    this.isActive = false,
    this.onStatusChanged,
    this.colortext = AppColors.primaryText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          textDirection: TextDirection.rtl, // مهم للعربي
          children: [
            // الأيقونة على اليمين
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryText,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isLogout ? AppColors.textWhite : AppColors.textWhite,
                size: 20,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              title,
              style: AppTextStyling.font14W600TextInter.copyWith(
                color: isLogout ? colortext : AppColors.textWhite,
                fontSize: 12,
              ),
            ),

            Spacer(),
            if (isLanguageSwitch) ...[
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: AppColors.primaryText,
              ),
              SizedBox(width: 8),
              Text(
                switchValue ? 'English' : 'العربية',
                style: AppTextStyling.font14W600TextInter.copyWith(),
              ),
            ],

            if (!isLogout && !isLanguageSwitch && !isActive)
              const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.primaryText,
                size: 16,
              ),
            if (isActive) ...[
              Switch(
                value: switchValue,
                onChanged: onStatusChanged,
                activeColor: AppColors.primaryText,
              ),
              SizedBox(width: 8),
              Text(
                switchValue ? 'ايقاف' : 'تشغيل',
                style: AppTextStyling.font14W600TextInter.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
