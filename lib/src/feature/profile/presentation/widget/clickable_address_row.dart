import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';

class ClickableAddressRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ClickableAddressRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: AppTextStyling.font16W500TextInter.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onTap != null)
                        Icon(
                          Icons.open_in_new,
                          color: AppColors.primaryText,
                          size: 16,
                        ),
                      if (onTap != null) const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          value,
                          style: AppTextStyling.font16W500TextInter.copyWith(
                            color: AppColors.textWhite,
                            decoration:
                                onTap != null
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Icon(icon, color: AppColors.primaryText, size: 20),
          ],
        ),
      ),
    );
  }
}
