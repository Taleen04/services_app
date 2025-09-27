import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_gradients.dart';
import 'package:trasport_ai/src/core/constants/app_spacing.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/constants/font_weight_helper.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/feature/profile/data/data_sourse/edit_profile_datasoruse.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view/edit_profile.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view/notfication.dart';
import 'package:trasport_ai/src/feature/profile/presentation/widget/card_logout.dart';
import 'package:trasport_ai/src/feature/profile/presentation/widget/card_profile.dart';
import 'package:trasport_ai/src/feature/profile/presentation/widget/clickable_address_row.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_bloc.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_state.dart';
import 'package:trasport_ai/src/feature/profile/repo/edit_profile_repo.dart';
import 'package:trasport_ai/src/core/utils/map_helper.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _refreshProfile() {
    context.read<InfoProfileBloc>().add(FetchProfile());
  }

// بناء URL كامل للصورة
  String _buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';

    // إذا كان المسار يحتوي على URL كامل، استخدمه مباشرة
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }

    // إذا كان المسار نسبي، أضف البادئة
    const baseUrl = 'https://parking.engmahmoudali.com/storage/';
    if (imageUrl.startsWith('storage/')) {
      return '$baseUrl$imageUrl';
    }

    // إذا لم تكن البادئة موجودة، أضفها
    return '$baseUrl$imageUrl';
  }

  // فتح الخريطة بالعنوان
  Future<void> _openMapWithAddress(String address) async {
    try {
      if (address.isNotEmpty && address != 'null') {
        await MapHelper.openMapWithAddress(address);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('العنوان غير متوفر'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في فتح الخريطة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<InfoProfileBloc, InfoProfileState>(
          builder: (context, state) {
            if (state is InfoProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InfoProfileFailure) {
              return Center(child: Text('حدث خطأ: ${state.error}'));
            } else if (state is InfoProfileSuccess) {
              final user = state.user;
              final photo=user.photo;
              return RefreshIndicator(
                onRefresh: () async {
                  _refreshProfile();
                  // انتظار قصير للـ animation
                  await Future.delayed(Duration(milliseconds: 500));
                },
                child: SingleChildScrollView(
                  physics:
                      AlwaysScrollableScrollPhysics(), // للـ pull to refresh
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            gradient: AppGradients.orangeGradient,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => EditProfileView(
                                                  user: user,
                                                  repository:
                                                      EditProfileRepository(
                                                        EditProfileDataSource(),
                                                      ),
                                                  onProfileUpdated: () {
                                                    // إعادة تحميل البروفايل عند التحديث
                                                    _refreshProfile();
                                                  },
                                                 
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.notifications_active,
                                        color: Colors.white,
                                      ),
                                      onPressed:
                                          () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => NotificationsScreen(),
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    user.photo != null &&
                                            user.photo!.isNotEmpty
                                        ? NetworkImage(_buildImageUrl(photo))
                                        : null,
                                child:
                                    user.photo == null ||
                                            user.photo!.isEmpty
                                        ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 50,
                                        )
                                        : null,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                user.name,
                                style: AppTextStyling.font16W500TextInter
                                    .copyWith(
                                      color: AppColors.textWhite,
                                      fontWeight: FontWeightHelper.bold,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                user.serviceTypeName ?? '',
                                style: AppTextStyling.font16W500TextInter
                                    .copyWith(
                                      color: AppColors.textWhite,
                                      fontWeight: FontWeightHelper.bold,
                                    ),
                              ),
                              // Text(
                              //   user. ?? '',
                              //   style: AppTextStyling.font16W500TextInter
                              //       .copyWith(
                              //         color: AppColors.textWhite,
                              //         fontWeight: FontWeightHelper.bold,
                              //       ),
                              // ),
                            ],
                          ),
                        ),

                        // CardProfile مخصص للعنوان القابل للضغط
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backGroundIcon,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                        AppLocalizations.of(context)!.contactInformation,
                                          style: AppTextStyling
                                              .font16W500TextInter
                                              .copyWith(
                                                color: AppColors.textWhite,
                                                fontWeight:
                                                    FontWeightHelper.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.contact_phone,
                                      color: AppColors.primaryText,
                                      size: 40,
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.sm),
                                Divider(height: 1, color: Colors.grey[200]),
                                SizedBox(height: AppSpacing.lg),

                                // رقم الجوال
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppSpacing.lg,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!.phoneNumber,
                                            style: AppTextStyling
                                                .font16W500TextInter
                                                .copyWith(
                                                  color: AppColors.textWhite,
                                                ),
                                          ),
                                          SizedBox(height: AppSpacing.sm),
                                          Text(
                                            user.phone,
                                            style: AppTextStyling
                                                .font16W500TextInter
                                                .copyWith(
                                                  color: AppColors.textWhite,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: AppSpacing.md),
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.primaryText,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),

                                // البريد الإلكتروني
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppSpacing.lg,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!.email,
                                            style: AppTextStyling
                                                .font16W500TextInter
                                                .copyWith(
                                                  color: AppColors.textWhite,
                                                ),
                                          ),
                                          SizedBox(height: AppSpacing.sm),
                                          Text(
                                            user.email,
                                            style: AppTextStyling
                                                .font16W500TextInter
                                                .copyWith(
                                                  color: AppColors.textWhite,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: AppSpacing.md),
                                      Icon(
                                        Icons.email,
                                        color: AppColors.primaryText,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),

                                // العنوان القابل للضغط
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppSpacing.lg,
                                  ),
                                  child: ClickableAddressRow(
                                    icon: Icons.location_on,
                                    label:   AppLocalizations.of(context)!.address,
                                    value: user.address ??   AppLocalizations.of(context)!.notFound,
                                    onTap:
                                        () => _openMapWithAddress(
                                          user.address ?? '',
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        CardProfile(
                          title:  AppLocalizations.of(context)!.walletAndStatistics,
                          icon: Icons.account_balance_wallet,
                          visible: 1,
                          rows: [
                            {
                              'icon': Icons.monetization_on,
                              'label':  AppLocalizations.of(context)!.currentBalance,
                              'value': '${user.wallet}',
                            },
                          ],
                        ),

                        CardProfile(
                          title:   AppLocalizations.of(context)!.officialDocuments,
                          icon: Icons.document_scanner_outlined,
                          visible: 2,
                          rows: [
                            {
                              'icon': Icons.credit_card,
                              'label':   AppLocalizations.of(context)!.idImage,
                              'value':
                                  user.idCardImage != null
                                      ?   AppLocalizations.of(context)!.done
                                      :   AppLocalizations.of(context)!.select,
                            },
                            {
                              'icon': Icons.assignment_turned_in,
                              'label':   AppLocalizations.of(context)!.certificateOfNoCriminalRecord,
                              'value':
                                  user.ungoverenImage != null
                                      ?   AppLocalizations.of(context)!.done
                                      :   AppLocalizations.of(context)!.select,
                            },
                          ],
                        ),

                        SettingsCard(),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
