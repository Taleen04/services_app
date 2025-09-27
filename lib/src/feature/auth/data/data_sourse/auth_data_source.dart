import 'dart:developer';

import 'package:trasport_ai/src/core/database/api/apiclient.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';
import 'package:trasport_ai/src/feature/auth/data/model/login_res_model.dart';

class LoginDataSource{ //convert models to json and call api
Future<LoginResponseModel?>login(String phone,String password)async{

final data={
  'username':phone,
  'password':password
};

  try{
    final res=await ApiClient.dio.post(ApiConstants.login,data:data );
    if(res.statusCode==200){
     final loginRes=LoginResponseModel.fromJson(res.data);
      return loginRes;
    }else{
      log('Login failed: ${res.statusCode}');
      return null;
    }
  }
  catch(e){
    log('Error during login: $e');
    return null;
  }
}
}
