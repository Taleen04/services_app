import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/edit_profile_bloc.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/edit_profile_event.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/edit_profile_state.dart';
import 'package:trasport_ai/src/feature/profile/presentation/widget/custom_text_from_filed.dart';
import 'package:trasport_ai/src/feature/profile/repo/edit_profile_repo.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_bloc.dart';
import 'package:trasport_ai/src/core/utils/map_helper.dart';

class EditProfileView extends StatefulWidget {
  final UserEntity user;
  final EditProfileRepository repository;
  final VoidCallback? onProfileUpdated;

  const EditProfileView({
    super.key,
    required this.user,
    required this.repository,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  File? _profilePhotoFile;
  File? _idCardImageFile;
  File? _ungovernedImageFile;
  final ImagePicker _picker = ImagePicker();

  late final EditProfileBloc _bloc;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح التحقق

  @override
  void initState() {
    super.initState();
    _bloc = EditProfileBloc(widget.repository);

    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    _bloc.close();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // دالة عامة لرفع أي صورة مع Bloc
  Future<void> _pickAndUploadImage({
    required void Function(File) setImageFile,
    required Function(File) blocEvent,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final File file = File(image.path);
        setState(() => setImageFile(file));
        blocEvent(file);
      }
    } catch (e) {
      log('خطأ في اختيار الصورة: $e');
      _showErrorSnackBar(
        'خطأ في اختيار الصورة. تأكد من إعطاء التطبيق صلاحية الوصول للصور.',
      );
    }
  }

  void _showErrorSnackBar(String? message) {
    if (message == null || message.isEmpty) return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _pickLocationFromMap() async {
    await _getCurrentLocationAndUpdateAddress();
  }

  Future<void> _getCurrentLocationAndUpdateAddress() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final position = await MapHelper.getCurrentLocation();
      final address = await MapHelper.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (mounted) Navigator.pop(context);
      addressController.text = address;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث العنوان بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      log('خطأ في الحصول على الموقع: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الحصول على الموقع: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ تم تعديل البيانات بنجاح'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ ${state.error}"),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is ProfileRefreshed) {
            try {
              context.read<InfoProfileBloc>().add(FetchProfile());
            } catch (_) {}

            if (widget.onProfileUpdated != null) {
              widget.onProfileUpdated!();
            }

            if (state.updatedUser != null) {
              nameController.text = state.updatedUser?.name ?? widget.user.name;
              emailController.text =
                  state.updatedUser?.email ?? widget.user.email;
              phoneController.text =
                  state.updatedUser?.phone ?? widget.user.phone;
              addressController.text =
                  state.updatedUser?.address ?? widget.user.address;
            }
          }
        },
        builder: (context, state) {
          Color borderColor;
          bool buttonEnabled = true;

          if (state is EditProfileLoading) {
            borderColor = Colors.grey;
            buttonEnabled = false;
          } else if (state is EditProfileSuccess) {
            borderColor = Colors.green;
          } else if (state is EditProfileFailure) {
            borderColor = Colors.red;
          } else {
            borderColor = AppColors.orange;
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.orange,
              title: Align(
                alignment: Alignment.topRight,
                child: Text(
                 AppLocalizations.of(context)!.editProfile,
                  style: AppTextStyling.font14W600TextInter.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey, // ✅ النموذج
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickAndUploadImage(
                          setImageFile: (file) => _profilePhotoFile = file,
                          blocEvent: (file) => _bloc.add(UploadProfilePhoto(file)),
                        ),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _profilePhotoFile != null
                                  ? FileImage(_profilePhotoFile!)
                                  : widget.user.photoLink != null
                                      ? NetworkImage("/storage${widget.user.photoLink!}")
                                      : null as ImageProvider?,
                              child: widget.user.photoLink == null &&
                                      _profilePhotoFile == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 الاسم
                    CustomTextFromFiled(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterName;
                        }
                        return null;
                      },
                      label: AppLocalizations.of(context)!.name,
                      controller: nameController,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 البريد
                    CustomTextFromFiled(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterEmail;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(p0)) {
                          return AppLocalizations.of(context)!.invalidEmail;
                        }
                        return null;
                      },
                      label: AppLocalizations.of(context)!.email,
                      controller: emailController,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 رقم الجوال
                    CustomTextFromFiled(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterName;
                        }
                        if (!RegExp(r'^07[0-9]{8}$').hasMatch(p0)) {
                          return AppLocalizations.of(context)!.invalidPhone;
                        }
                        return null;
                      },
                      label: AppLocalizations.of(context)!.phone,
                      controller: phoneController,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 العنوان
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFromFiled(
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return AppLocalizations.of(context)!.pleaseEnterAddress;
                              }
                              return null;
                            },
                            label:AppLocalizations.of(context)!.address,
                            controller: addressController,
                            borderColor: borderColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: buttonEnabled ? _pickLocationFromMap : null,
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            tooltip: 'الحصول على الموقع الحالي',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // زر الحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              buttonEnabled ? AppColors.orange : Colors.grey,
                        ),
                        onPressed: buttonEnabled
                            ? () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final updatedUser = UserEntity(
                                    id: widget.user.id,
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    address: addressController.text,
                                    serviceType: widget.user.serviceType,
                                    salary: widget.user.salary,
                                    workingFrom: widget.user.workingFrom,
                                    workingTo: widget.user.workingTo,
                                    wallet: widget.user.wallet,
                                    walletBalance: widget.user.walletBalance,
                                    totalEarnings: widget.user.totalEarnings,
                                    servicesCompleted:
                                        widget.user.servicesCompleted,
                                    autoPayout: widget.user.autoPayout,
                                    payoutThreshold: widget.user.payoutThreshold,
                                    createdAt: widget.user.createdAt,
                                    updatedAt: widget.user.updatedAt,
                                    driverPlace: widget.user.driverPlace,
                                    status: widget.user.status,
                                    vehicleType: widget.user.vehicleType,
                                    photoLink: widget.user.photoLink,
                                    idCardImage: widget.user.idCardImage,
                                    ungoverenImage: widget.user.ungoverenImage,
                                  );

                                  _bloc.add(UpdateProfile(updatedUser));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                      content: Text(AppLocalizations.of(context)!.fillAllFields),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: state is EditProfileLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            :  Text(
                               AppLocalizations.of(context)!.saveChanges,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🟠 ويدجت رفع الصور (نفس كودك الأصلي)
  Widget _buildUploadCard({
    required String label,
    required File? file,
    required String? networkImage,
    required VoidCallback onTap,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyling.font14W600TextInter.copyWith(
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: file != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file, fit: BoxFit.cover),
                  )
                : networkImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: networkImage.startsWith('http')
                            ? Image.network(
                                networkImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _errorWidget(),
                                loadingBuilder: (context, child, loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                              )
                            : Image.file(
                                File(networkImage),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _errorWidget(),
                              ),
                      )
                    : _emptyUploadWidget(label),
          ),
        ),
      ],
    );
  }

  Widget _emptyUploadWidget(String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'اضغط لرفع $label مباشرة',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 40, color: Colors.grey),
          Text('لا يمكن تحميل الصورة', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
