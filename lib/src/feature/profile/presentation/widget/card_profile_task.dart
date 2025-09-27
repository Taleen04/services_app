import 'package:flutter/material.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';

class CardProfileTask extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items; // العناصر اللي بدك تعرضها

  const CardProfileTask({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
  });

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5, // نص الشاشة
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "كل العناصر",
                style: AppTextStyling.font16W500TextInter.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        items[index],
                        style: AppTextStyling.font16W500TextInter.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                      leading: Icon(
                        Icons.check_circle,
                        color: AppColors.primaryText,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 18,
              color: AppColors.primaryText,
            ),
            onPressed: () => _showBottomSheet(context),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: AppTextStyling.font16W500TextInter.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                value,
                style: AppTextStyling.font16W500TextInter.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
          SizedBox(width: AppSpacing.md),
          Icon(icon, color: AppColors.primaryText, size: 20),
        ],
      ),
    );
  }
}
