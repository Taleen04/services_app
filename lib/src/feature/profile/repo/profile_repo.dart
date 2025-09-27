import 'package:trasport_ai/src/feature/auth/data/model/login_request.dart';
import 'package:trasport_ai/src/feature/profile/data/data_sourse/profile.dart';

class ProfileRepository {
  final InfoProfile dataSource;

  ProfileRepository(this.dataSource);

  Future<UserModel?> getProfile() async {
    try {
      final userModel = await dataSource.getProfile();
      if (userModel != null) {
        return userModel;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
} 