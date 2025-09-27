// my_sliver_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_gradients.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_bloc.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_state.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.orangeGradient),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: BlocBuilder<InfoProfileBloc, InfoProfileState>(
        builder: (context, state) {
          String userName = 'جاري التحميل...';
          String jobTitle = 'موظف';
          String? profileImage;

          if (state is InfoProfileSuccess) {
            userName = state.user.name;
            jobTitle = state.user.serviceTypeName ?? 'موظف غسيل';
            profileImage = state.user.photo;
          } else if (state is InfoProfileFailure) {
            userName = 'خطأ في التحميل';
            jobTitle = 'موظف';
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: AppTextStyling.font14W600TextInter.copyWith(
                      color: AppColors.lightGreen,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        jobTitle,
                        style: AppTextStyling.font14W600TextInter.copyWith(
                          color: AppColors.lightGreen,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: AppSpacing.md),
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    profileImage != null
                        ? NetworkImage(profileImage)
                        : const AssetImage('assets/employee_avatar.jpg')
                            as ImageProvider,
                onBackgroundImageError: (_, __) {},
                child:
                    profileImage == null
                        ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 26,
                        )
                        : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
