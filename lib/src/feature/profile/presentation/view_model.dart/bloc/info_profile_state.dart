import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';

abstract class InfoProfileState {}

class InfoProfileInitial extends InfoProfileState {}

class InfoProfileLoading extends InfoProfileState {}

class InfoProfileSuccess extends InfoProfileState {
  final UserEntity user;
  InfoProfileSuccess(this.user);
}

class InfoProfileFailure extends InfoProfileState {
  final String error;
  InfoProfileFailure(this.error);
}
