
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/database/cache/shared_pref_helper.dart';
import 'package:trasport_ai/src/core/go_route/go_route.dart';
import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';
import 'package:trasport_ai/src/feature/auth/domain/usecase/login_usecase.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view_model/bloc/log_in_event.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view_model/bloc/log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  final LoginUseCase loginUseCase;

  LogInBloc(this.loginUseCase) : super(LogInInitial()) {
    on<LogInInitialEvent>((event, emit) async {
      // التحقق من وجود مستخدم مسجل دخوله حالياً
      final token = SharedPrefHelper.getString(StorageKeys.token);
      if (token.isNotEmpty && token != 'null') {
        emit(LogInAuthenticated(token));
      } else {
        emit(LogInInitial());
      }
    });

    on<LogInButtonPressed>((event, emit) async {
      emit(LogInLoading());
      try {
        final response = await loginUseCase(
          LoginParams(phone: event.userName, password: event.password),
        );

        // حفظ التوكن في التخزين المحلي
        await SharedPrefHelper.setData(StorageKeys.token, response.token);

        // حفظ بيانات المستخدم في التخزين المحلي
        await _saveUserData(response.user);

        emit(LogInSuccess(response.user, response.token));
      } catch (e) {
        emit(LogFailure(e.toString()));
      }
    });

    on<LogOutEvent>((event, emit) async {
      // مسح بيانات المستخدم من التخزين المحلي
      await SharedPrefHelper.clearAllData();
      emit(LogInInitial());
    });
  }

  /// حفظ بيانات المستخدم في التخزين المحلي
  Future<void> _saveUserData(UserEntity user) async {
    // يمكن حفظ البيانات المطلوبة فقط بدلاً من كائن المستخدم كاملاً
    await SharedPrefHelper.setData('user_id', user.id.toString());
    await SharedPrefHelper.setData('user_name', user.name);
    await SharedPrefHelper.setData('user_phone', user.phone);
    await SharedPrefHelper.setData('user_email', user.email);
    // يمكن إضافة المزيد من البيانات حسب الحاجة
  }
}
