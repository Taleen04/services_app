import 'dart:developer';
import 'package:trasport_ai/src/core/database/api/apiclient.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';
import 'package:trasport_ai/src/feature/auth/data/model/login_request.dart';


class InfoProfile {
  Future<UserModel?> getProfile() async {
    try {
      final res = await ApiClient.dio.get(ApiConstants.profile);

      if (res.statusCode == 200) {

        final data = res.data;
        return UserModel.fromJson(data);
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
