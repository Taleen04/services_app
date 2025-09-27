import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/feature/profile/repo/edit_profile_repo.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileRepository repository;

  EditProfileBloc(this.repository) : super(EditProfileInitial()) {
    // تحديث البيانات الأساسية
    on<UpdateProfile>((event, emit) async {
      emit(EditProfileLoading());
      try {
        final updatedUser = await repository.updateProfile(event.updatedUser);

        if (!updatedUser) {
          emit(EditProfileFailure('فشل في تحديث البيانات'));
          return;
        }

        emit(EditProfileSuccess());

        // إعادة تحميل البروفايل تلقائياً
        add(RefreshProfile());
      } catch (e) {
        emit(EditProfileFailure(e.toString()));
      }
    });

    // رفع صورة الملف الشخصي
    on<UploadProfilePhoto>((event, emit) async {
      emit(EditProfileLoading());
      try {
        final success = await repository.uploadProfilePhoto(event.photo);

        if (!success) {
          emit(EditProfileFailure('فشل في رفع الصورة الشخصية'));
          return;
        }

        emit(EditProfileSuccess());

        // إعادة تحميل البروفايل تلقائياً
        add(RefreshProfile());
      } catch (e) {
        emit(EditProfileFailure(e.toString()));
      }
    });

    // رفع صورة الهوية
    on<UploadIdCardImage>((event, emit) async {
      emit(EditProfileLoading());
      try {
        final success = await repository.uploadIdCardImage(event.idCardImage);

        if (!success) {
          emit(EditProfileFailure('فشل في رفع صورة الهوية'));
          return;
        }

        emit(EditProfileSuccess());

        // إعادة تحميل البروفايل تلقائياً
        add(RefreshProfile());
      } catch (e) {
        emit(EditProfileFailure(e.toString()));
      }
    });

    // رفع صورة عدم المحكومية
    on<UploadUngovernedImage>((event, emit) async {
      emit(EditProfileLoading());
      try {
        final success = await repository.uploadUngovernedImage(
          event.ungovernedImage,
        );

        if (!success) {
          emit(EditProfileFailure('فشل في رفع صورة عدم المحكومية'));
          return;
        }

        emit(EditProfileSuccess());

        // إعادة تحميل البروفايل تلقائياً
        add(RefreshProfile());
      } catch (e) {
        emit(EditProfileFailure(e.toString()));
      }
    });

    // إعادة تحميل بيانات البروفايل
    on<RefreshProfile>((event, emit) async {
      try {
        final updatedProfile = await repository.getUpdatedProfile();

        if (updatedProfile != null) {
          emit(ProfileRefreshed(updatedProfile));
        }
        // لا نعرض خطأ، فقط نتجاهل الفشل في التحديث
      } catch (e) {
        // لا نعرض خطأ، فقط نتجاهل الفشل في التحديث
      }
    });
  }
}
