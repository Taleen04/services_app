
import 'package:trasport_ai/src/feature/auth/data/model/login_request.dart';
import 'package:trasport_ai/src/feature/auth/domain/entity/login_res_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  LoginResponseModel({
    required super.token,
    required super.user,
    required super.message,
    required super.status,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return LoginResponseModel(
      token: data["token"],
      user: UserModel.fromJson(data["user"]),
      message: json["message"],
      status: json["status"],
    );
  }
}
