import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trasport_ai/src/feature/calender/presentation/repo/calender_repo.dart';
import 'package:trasport_ai/src/feature/calender/presentation/view_model/bloc/calender_event.dart';
import 'package:trasport_ai/src/feature/calender/presentation/view_model/bloc/calender_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository repository;
  String? _lastDateParam; // لمنع الطلبات المتكررة لنفس التاريخ

  CalendarBloc(this.repository) : super(CalendarInitial()) {
    on<FetchCalendarEvent>(_onFetchCalendar);
  }

  Future<void> _onFetchCalendar(
    FetchCalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    final start = event.startDate.toIso8601String().split('T').first;
    final end = event.endDate.toIso8601String().split('T').first;
    final String dateParam = start == end ? start : '$start,$end';

    // منع الطلبات المتكررة لنفس التاريخ
    if (_lastDateParam == dateParam && state is CalendarLoaded) {
      print('تجاهل طلب مكرر للتاريخ: $dateParam');
      return;
    }

    _lastDateParam = dateParam;
    emit(CalendarLoading());

    try {
      print('جلب بيانات التقويم للتاريخ: $dateParam');

      // Call each endpoint with proper date parameter
      final allFuture = repository.fetchAll(dateRange: dateParam);
      final cancelledFuture = repository.fetchCancelled(dateRange: dateParam);
      final finishedFuture = repository.fetchFinished(dateRange: dateParam);
      final acceptedFuture = repository.fetchAccepted(dateRange: dateParam);

      final results = await Future.wait([
        allFuture,
        cancelledFuture,
        finishedFuture,
        acceptedFuture,
      ]);

      emit(
        CalendarLoaded(
          allOrders: results[0],
          cancelledOrders: results[1],
          finishedOrders: results[2],
          acceptedOrders: results[3],
        ),
      );
    } catch (e) {
      emit(CalendarError("فشل في تحميل البيانات من السيرفر: ${e.toString()}"));
    }
  }
}
