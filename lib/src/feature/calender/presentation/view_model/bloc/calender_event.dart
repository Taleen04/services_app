import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class FetchCalendarEvent extends CalendarEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchCalendarEvent(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}




// abstract class CalendarEvent {
//   const CalendarEvent();

//   @override
//   List<Object?> get props => [];
// }

// class LoadCalendarData extends CalendarEvent {
//   final Map<String, String>? headers;
  
//   const LoadCalendarData({this.headers});

//   @override
//   List<Object?> get props => [headers];
// }

// class SelectDate extends CalendarEvent {
//   final DateTime selectedDate;

//   const SelectDate(this.selectedDate);

//   @override
//   List<Object> get props => [selectedDate];
// }

// class ChangeTab extends CalendarEvent {
//   final int tabIndex;

//   const ChangeTab(this.tabIndex);

//   @override
//   List<Object> get props => [tabIndex];
// }

// class RefreshCalendarData extends CalendarEvent {
//   final Map<String, String>? headers;
  
//   const RefreshCalendarData({this.headers});

//   @override
//   List<Object?> get props => [headers];
// }
