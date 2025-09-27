import 'package:trasport_ai/src/feature/auth/data/model/login_request.dart';

class LoginData {
  final String token;
  final UserModel user;

  LoginData({required this.token, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'UserModel': user};
  }
}
