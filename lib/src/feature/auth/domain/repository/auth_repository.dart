
import 'package:trasport_ai/src/feature/auth/domain/entity/login_res_entity.dart';

/// واجهة مستودع المصادقة (Auth Repository)
/// 
/// هذه الواجهة تحدد العقود (Contracts) لعمليات المصادقة
/// التي يجب أن يوفرها أي تطبيق للمستودع
abstract class AuthRepository {
  /// تسجيل الدخول إلى التطبيق
  /// 
  /// [phone] - رقم الهاتف الخاص بالمستخدم
  /// [password] - كلمة المرور الخاصة بالمستخدم
  /// 
  /// ترجع [LoginResponseEntity] تحتوي على بيانات المستخدم ورمز التوكن
  Future<LoginResponseEntity> login(String phone, String password);


}
