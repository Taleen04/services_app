import 'dart:io';
import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';
import 'package:trasport_ai/src/feature/auth/data/model/login_request.dart';
import 'package:trasport_ai/src/feature/profile/data/data_sourse/edit_profile_datasoruse.dart';

class EditProfileRepository {
  final EditProfileDataSource dataSource;

  EditProfileRepository(this.dataSource);

  Future<bool> updateProfile(UserEntity updatedUser) async {
    final Map<String, dynamic> body = {
      "name": updatedUser.name,
      "email": updatedUser.email,
      "phone": updatedUser.phone,
      "address": updatedUser.address,
    };

    return await dataSource.updateProfile(body);
  }

  // رفع صورة الملف الشخصي
  Future<bool> uploadProfilePhoto(File photo) async {
    return await dataSource.uploadImages(photo: photo);
  }

  // رفع صورة الهوية
  Future<bool> uploadIdCardImage(File idCardImage) async {
    return await dataSource.uploadImages(idCardImage: idCardImage);
  }

  // رفع صورة عدم المحكومية
  Future<bool> uploadUngovernedImage(File ungovernedImage) async {
    return await dataSource.uploadImages(ungovernedImage: ungovernedImage);
  }

  // رفع جميع الصور معاً (للاستخدام المستقبلي)
  Future<bool> uploadAllImages({
    File? photo,
    File? idCardImage,
    File? ungovernedImage,
  }) async {
    return await dataSource.uploadImages(
      photo: photo,
      idCardImage: idCardImage,
      ungovernedImage: ungovernedImage,
    );
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await dataSource.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  // جلب بيانات البروفايل المحدثة
  Future<UserModel?> getUpdatedProfile() async {
    try {
      return await dataSource.getProfile();
    } catch (e) {
      rethrow;
    }
  }
}
