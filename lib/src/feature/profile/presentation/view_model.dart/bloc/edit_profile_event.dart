import 'dart:io';
import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';

abstract class EditProfileEvent {}

class UpdateProfile extends EditProfileEvent {
  final UserEntity updatedUser;

  UpdateProfile(this.updatedUser);
}

// أحداث رفع الصور المنفردة
class UploadProfilePhoto extends EditProfileEvent {
  final File photo;

  UploadProfilePhoto(this.photo);
}

class UploadIdCardImage extends EditProfileEvent {
  final File idCardImage;

  UploadIdCardImage(this.idCardImage);
}

class UploadUngovernedImage extends EditProfileEvent {
  final File ungovernedImage;

  UploadUngovernedImage(this.ungovernedImage);
}

// حدث إعادة تحميل بيانات البروفايل
class RefreshProfile extends EditProfileEvent {}
