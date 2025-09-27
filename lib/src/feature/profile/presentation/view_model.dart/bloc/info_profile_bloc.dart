import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/bloc/info_profile_state.dart';
import 'package:trasport_ai/src/feature/profile/repo/profile_repo.dart';

part 'info_profile_event.dart';

class InfoProfileBloc extends Bloc<InfoProfileEvent, InfoProfileState> {
  final ProfileRepository profileRepository;

  InfoProfileBloc(this.profileRepository) : super(InfoProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(InfoProfileLoading());
      try {
        final user = await profileRepository.getProfile();
        if (user != null) {
          emit(InfoProfileSuccess(user));
        } else {
          emit(InfoProfileFailure('Failed to fetch profile'));
        }
      } catch (e) {
        emit(InfoProfileFailure(e.toString())); // <-- هنا يظهر الخطأ
      }
    });
  }
}
