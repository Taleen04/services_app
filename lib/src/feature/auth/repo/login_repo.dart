

import 'package:trasport_ai/src/feature/auth/data/data_sourse/auth_data_source.dart';
import 'package:trasport_ai/src/feature/auth/domain/entity/login_res_entity.dart';
import 'package:trasport_ai/src/feature/auth/domain/repository/auth_repository.dart';

class LoginRepository implements AuthRepository {
  final LoginDataSource dataSource;

  LoginRepository(this.dataSource);

  @override
  Future<LoginResponseEntity> login(String phone, String password) async {
    try {
      final model = await dataSource.login(phone, password);
      return LoginResponseEntity(
        token: model!.token,
        user: model.user,
        message: model.message,
        status: model.status,
      );
    } catch (e) {
      throw Exception('فشل عملية تسجيل الدخول: ${e.toString()}');
    }
  }
}
