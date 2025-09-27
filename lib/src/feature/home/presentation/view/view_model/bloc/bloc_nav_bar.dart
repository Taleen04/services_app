import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_nav_bar_event.dart';
import 'bloc_nav_bar_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavState(1)) {
    on<NavChanged>((event, emit) {
      emit(NavState(event.index));
    });
  }
}
