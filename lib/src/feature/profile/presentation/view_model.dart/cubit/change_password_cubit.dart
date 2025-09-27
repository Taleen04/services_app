import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_password_state.dart';
import 'package:trasport_ai/src/feature/profile/repo/edit_profile_repo.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final EditProfileRepository repository;

  ChangePasswordCubit(this.repository) : super(ChangePasswordInitial());

   Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword,context) async {
    emit(ChangePasswordLoading());
    final success = await repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (success) {
      emit(ChangePasswordSuccess(AppLocalizations.of(context)!.success));
    } else {
      emit(ChangePasswordFailure(AppLocalizations.of(context)!.failure));
    }
  }

}
