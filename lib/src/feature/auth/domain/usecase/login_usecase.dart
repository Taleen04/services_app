

import 'package:trasport_ai/src/core/usecases/base_usecase.dart';
import 'package:trasport_ai/src/feature/auth/domain/entity/login_res_entity.dart';
import 'package:trasport_ai/src/feature/auth/domain/repository/auth_repository.dart';

/// UseCase لتسجيل الدخول
/// 
/// هذه الفئة مسؤولة عن منطق تسجيل الدخول وتنظيم تدفق البيانات
/// بين طبقة الـ Repository وطبقة الـ Presentation
class LoginUseCase extends BaseUseCase<LoginParams, LoginResponseEntity> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// تنفيذ عملية تسجيل الدخول
  /// 
  /// [params] - تحتوي على رقم الهاتف وكلمة المرور
  /// 
  /// ترجع [LoginResponseEntity] تحتوي على بيانات المستخدم ورمز التوكن
  @override
  Future<LoginResponseEntity> call(LoginParams params) async {
    // يمكن إضافة منطق إضافي هنا مثل التحقق من صحة البيانات
    // قبل إرسالها إلى الـ Repository

    return await repository.login(params.phone, params.password);
  }
}

/// معلمات تسجيل الدخول
/// 
/// هذه الفئة تحتوي على معلمات تسجيل الدخول المطلوبة
class LoginParams {
  final String phone;
  final String password;

  LoginParams({required this.phone, required this.password});
}

