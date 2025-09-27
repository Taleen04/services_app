import 'package:bloc/bloc.dart';
import 'package:trasport_ai/src/core/database/api/apiclient.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final response = await ApiClient.dio.get(ApiConstants.logout);
      if (response.statusCode == 200) {
        emit(LogoutSuccess('تم تسجيل الخروج بنجاح'));
      } else {
        emit(LogoutFailure('فشل تسجيل الخروج: ${response.statusCode}'));
      }
    } catch (e) {
      emit(LogoutFailure('خطأ: $e'));
    }
  }
}
