import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/database/cache/shared_pref_helper.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/core/go_route/go_route.dart';
import 'package:trasport_ai/src/feature/profile/data/data_sourse/edit_profile_datasoruse.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view/change_password.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_lang/change_language_cubit.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/logout_cutbit.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/logout_state.dart';
import 'package:trasport_ai/src/feature/profile/presentation/widget/custom_list_tile.dart';
import 'package:trasport_ai/src/feature/profile/repo/edit_profile_repo.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backGroundIcon,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              AppLocalizations.of(context)!.settings,
            style: AppTextStyling.font14W600TextInter.copyWith(
              color: AppColors.textWhite,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),

          // العناصر
            CustomListTile(
            icon: Icons.language,
            title:  AppLocalizations.of(context)!.changeLanguage,
            isLanguageSwitch: true,
            switchValue:
                context.read<LanguageCubit>().state.locale.languageCode == 'en',
            onSwitchChanged: (value) {
              final cubit = context.read<LanguageCubit>();
              if (value) {
                cubit.changeLanguage(const Locale('en'));
              } else {
                cubit.changeLanguage(const Locale('ar'));
              }
            },
          ),

          CustomListTile(
            icon: Icons.policy,
            title:   AppLocalizations.of(context)!.termsAndPolicies,
            onTap: () {
              context.push('/terms');
            },
          ),
          CustomListTile(
            icon: Icons.password,
            colortext: AppColors.textWhite,
            isLogout: true,
            title:   AppLocalizations.of(context)!.changePassword,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ChangePassword(
                        repository: EditProfileRepository(
                          EditProfileDataSource(),
                        ),
                      ),
                ),
              );
            },
          ),

          CustomListTile(
            icon: Icons.logout,
            title:  AppLocalizations.of(context)!.logout,
            colortext: AppColors.red,
            isLogout: true,
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => BlocProvider(
                      create: (_) => LogoutCubit(),
                      child: BlocConsumer<LogoutCubit, LogoutState>(
                        listener: (context, state) {
                          if (state is LogoutSuccess) {
                            SharedPrefHelper.removeData(StorageKeys.token);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.go('/login');
                          } else if (state is LogoutFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is LogoutLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                      AppLocalizations.of(context)!.logout,
                                    style: AppTextStyling.font14W600TextInter
                                        .copyWith(
                                          color: AppColors.red,
                                          fontSize: 18,
                                        ),
                                  ),

                                  const SizedBox(height: 10),
                                  Text(
                                   AppLocalizations.of(context)!.areYouSureYouWantToLogOutOfYourAccount,
                                    style: AppTextStyling.font14W600TextInter
                                        .copyWith(color: AppColors.textWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          context.read<LogoutCubit>().logout();
                                        },
                                        child: Text(
                                         AppLocalizations.of(context)!.logout,
                                          style: AppTextStyling
                                              .font14W600TextInter
                                              .copyWith(
                                                color: AppColors.textWhite,
                                              ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                         AppLocalizations.of(context)!.cancle,
                                          style: AppTextStyling
                                              .font14W600TextInter
                                              .copyWith(
                                                color: AppColors.textWhite,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
