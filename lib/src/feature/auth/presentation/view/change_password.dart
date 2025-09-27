import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/constants/app_text_styling.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/password_field.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width * 0.9;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: fieldWidth,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final newPass = newPasswordController.text.trim();
                  final confirm = confirmPasswordController.text.trim();

                  if (newPass != confirm) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("كلمة المرور غير متطابقة")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم تغيير كلمة المرور بنجاح ✅"),
                    ),
                  );

                  context.go("/");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("الرجاء تعبئة جميع الحقول")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backGroundIcon,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "إعادة تعيين",
                style: AppTextStyling.font16W500TextInter,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.85,
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "إعادة تعيين كلمة المرور",
                    style: AppTextStyling.font26W00TextInter,
                  ),
                  SizedBox(height: responsiveHeight(context, 40)),
                  Text(
                    "يجب أن تحتوي كلمة المرور على مجموعة",
                    style: AppTextStyling.font16W500TextInter.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: responsiveHeight(context, 10)),
                  Text(
                    "من الأرقام والأحرف والرموز الخاصة",
                    style: AppTextStyling.font16W500TextInter.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: responsiveHeight(context, 50)),

                  // كلمة المرور الحالية
                  PasswordField(
                    controller: currentPasswordController,
                    text: 'كلمة المرور الحالية',
                  ),
                  SizedBox(height: responsiveHeight(context, 20)),

                  // كلمة المرور الجديدة
                  PasswordField(
                    controller: newPasswordController,
                    text: 'كلمة المرور الجديدة',
                  ),
                  SizedBox(height: responsiveHeight(context, 20)),

                  // تأكيد كلمة المرور
                  PasswordField(
                    controller: confirmPasswordController,
                    text: 'تأكيد كلمة المرور',
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
