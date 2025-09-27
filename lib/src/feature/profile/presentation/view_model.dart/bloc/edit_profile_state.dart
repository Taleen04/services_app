abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileFailure extends EditProfileState {
  final String error;
  EditProfileFailure(this.error);
}

class ProfileRefreshed extends EditProfileState {
  final dynamic updatedUser; // يمكن أن يكون UserEntity أو UserModel
  ProfileRefreshed(this.updatedUser);
}
