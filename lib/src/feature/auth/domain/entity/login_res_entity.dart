

import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';

class LoginResponseEntity {
  final String token;
  final UserEntity user;
  final String message;
  final bool status;

  LoginResponseEntity({
    required this.token,
    required this.user,
    required this.message,
    required this.status,
  });
}
