import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_password_cubit.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_password_state.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/feature/profile/presentation/widget/custom_text_from_filed.dart';
import 'package:trasport_ai/src/feature/profile/repo/edit_profile_repo.dart';

class ChangePassword extends StatelessWidget {
  final EditProfileRepository repository;
  ChangePassword({super.key, required this.repository});

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(repository),
      child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primaryText.withOpacity(0.9),
              title: Align(
                alignment: Alignment.topRight,
                child: Text(
                AppLocalizations.of(context)!.changePassword,
                  style: AppTextStyling.font16W500TextInter.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFromFiled(
                    validator: (value) {
              if (value == null || value.isEmpty) {
                return 'كلمة المرور مطلوبة';
              }
              if (value.length < 6) {
                return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
              }
              return null;
            },
                    label: AppLocalizations.of(context)!.currentPassword,
                    controller: oldPasswordController,
                    borderColor: AppColors.orange,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFromFiled(
                    validator: (value) {
              if (value == null || value.isEmpty) {
                return 'كلمة المرور مطلوبة';
              }
              if (value.length < 6) {
                return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
              }
              return null;
            },
                    label: AppLocalizations.of(context)!.newPassword,
                    controller: newPasswordController,
                    borderColor: AppColors.orange,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFromFiled(
                    validator: (value) {
              if (value == null || value.isEmpty) {
                return 'كلمة المرور مطلوبة';
              }
              if (value.length < 6) {
                return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
              }
              return null;
            },
                    label:AppLocalizations.of(context)!.newPasswordConfirmatio,
                    controller: confirmPasswordController,
                    borderColor: AppColors.orange,
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      bool isLoading = state is ChangePasswordLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    context
                                        .read<ChangePasswordCubit>()
                                        .changePassword(
                                          oldPasswordController.text,
                                          newPasswordController.text,
                                          confirmPasswordController.text,
                                          context
                                        );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isLoading ? Colors.grey : AppColors.orange,
                          ),
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                   AppLocalizations.of(context)!.changePassword,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
