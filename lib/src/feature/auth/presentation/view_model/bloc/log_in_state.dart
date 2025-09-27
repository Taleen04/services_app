
import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';

abstract class LogInState {}

class LogInInitial extends LogInState {}

class LogInLoading extends LogInState {}

class LogInAuthenticated extends LogInState {
  final String token;
  LogInAuthenticated(this.token);
}

class LogInSuccess extends LogInState {
  final UserEntity user;
  final String token;
  LogInSuccess(this.user, this.token);
}

class LogFailure extends LogInState {
  final String error;
  LogFailure(this.error);
}
