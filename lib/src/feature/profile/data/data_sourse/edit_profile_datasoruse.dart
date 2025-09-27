import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:trasport_ai/src/core/database/api/apiclient.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';
import 'package:trasport_ai/src/feature/auth/data/model/login_request.dart';

class EditProfileDataSource {
  Future<bool> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await ApiClient.dio.put(ApiConstants.editProfile, data: body);

      if (res.statusCode == 200) {
        return true;
      } else {
        log('Failed to update profile: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error updating profile: $e');
      return false;
    }
  }

  /// رفع الصور مع multipart form data
  Future<bool> uploadImages({
    File? photo,
    File? idCardImage,
    File? ungovernedImage,
  }) async {
    try {
      FormData formData = FormData();

      // إضافة الصور إذا كانت متوفرة
      if (photo != null) {
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(photo.path, filename: 'photo.jpg'),
          ),
        );
      }

      if (idCardImage != null) {
        formData.files.add(
          MapEntry(
            'id_card_image',
            await MultipartFile.fromFile(
              idCardImage.path,
              filename: 'id_card.jpg',
            ),
          ),
        );
      }

      if (ungovernedImage != null) {
        formData.files.add(
          MapEntry(
            'ungoveren_image',
            await MultipartFile.fromFile(
              ungovernedImage.path,
              filename: 'ungoverned.jpg',
            ),
          ),
        );
      }

      final res = await ApiClient.dio.post(
        ApiConstants.changePhoto,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (res.statusCode == 200) {
        log('Images uploaded successfully');
        return true;
      } else {
        log('Failed to upload images: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error uploading images: $e');
      return false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        ApiConstants.changePassword,
        data: {
          "current_password": currentPassword,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        },
      );
      return res.statusCode == 200; // true إذا تم بنجاح
    } catch (e) {
      log('Error updating password: $e');
      return false;
    }
  }

  // جلب بيانات البروفايل المحدثة
  Future<UserModel?> getProfile() async {
    try {
      final res = await ApiClient.dio.get(ApiConstants.profile);

      if (res.statusCode == 200) {
        log('Profile data fetched successfully');
        return UserModel.fromJson(res.data);
      } else {
        log('Failed to fetch profile: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching profile: $e');
      return null;
    }
  }
}
