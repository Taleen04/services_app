import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trasport_ai/src/core/constants/app_colors.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/core/utils/responsive_size_helper.dart';
import 'package:trasport_ai/src/core/utils/snackbar_helper.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view_model/bloc/log_in_bloc.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view_model/bloc/log_in_event.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view_model/bloc/log_in_state.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/forget_password_button.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/header_text.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/login_button.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/password_field.dart';
import 'package:trasport_ai/src/feature/auth/presentation/widgets/phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int failedAttempts = 0; // عدد المحاولات الفاشلة
  bool isLocked = false; // حالة القفل
  int lockDuration = 60; // المدة بالثواني
  DateTime? lockEndTime; // وقت انتهاء القفل

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogInBloc>().add(LogInInitialEvent());
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    HapticFeedback.mediumImpact();

    if (isLocked) {
      _showDialog();
      return;
    }

    final rawPhone = phoneController.text.trim();
    final userName = rawPhone.startsWith('0') ? rawPhone : '0$rawPhone';
    final password = passwordController.text.trim();

    context.read<LogInBloc>().add(LogInButtonPressed(userName, password));
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_outlined, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("محاولات كثيرة"),
        content: Text(
          "لقد تجاوزت 5 محاولات فاشلة.\nالرجاء الانتظار $lockDuration ثانية قبل المحاولة مجددًا.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("موافق"),
          ),
        ],
      ),
    );
  }

  void _startLockTimer() {
    setState(() {
      isLocked = true;
      lockEndTime = DateTime.now().add(Duration(seconds: lockDuration));
    });

    Future.delayed(Duration(seconds: lockDuration), () {
      setState(() {
        isLocked = false;
        failedAttempts = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backGroundPrimary,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeaderText(),
                    SizedBox(height: responsiveHeight(context, 90)),
                    PhoneField(controller: phoneController),
                    SizedBox(height: responsiveHeight(context, 20)),
                    PasswordField(
                      controller: passwordController,
                      text: AppLocalizations.of(context)?.password ?? "Password",
                    ),
                    SizedBox(height: responsiveHeight(context, 10)),
                    const ForgetPasswordButton(),
                    BlocConsumer<LogInBloc, LogInState>(
                      listener: (context, state) {
                        if (state is LogInAuthenticated || state is LogInSuccess) {
                          failedAttempts = 0; // نجاح → تصفير العداد
                          context.go('/home');
                          if (state is LogInSuccess) {
                            SnackbarUtils.showSuccess(
                              context,
                              '${state.user.name}${AppLocalizations.of(context)?.loggedInSuccessfully ?? "Logged In Successfully"}',
                            );
                          }
                        } else if (state is LogFailure) {
                          failedAttempts++;
                          if (failedAttempts >= 5) {
                            _startLockTimer();
                            _showDialog();
                          } else {
                            SnackbarUtils.showError(context, state.error);
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is LogInLoading) {
                          return const CircularProgressIndicator(
                            color: AppColors.primaryText,
                          );
                        }
                        return LoginButton(
                          onPressed: isLocked
                              ? _showDialog
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    handleLogin();
                                  } else {
                                    _showSnack(
                                      AppLocalizations.of(context)!.fillAllFields,
                                      Colors.orange,
                                    );
                                  }
                                },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
