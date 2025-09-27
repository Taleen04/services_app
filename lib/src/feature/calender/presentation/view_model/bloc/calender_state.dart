import 'package:equatable/equatable.dart';
import 'package:trasport_ai/src/feature/calender/domain/model/calender_model.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<ServiceOrderModel> allOrders;
  final List<ServiceOrderModel> cancelledOrders;
  final List<ServiceOrderModel> finishedOrders;
  final List<ServiceOrderModel> acceptedOrders;

  const CalendarLoaded({
    required this.allOrders,
    required this.cancelledOrders,
    required this.finishedOrders,
    required this.acceptedOrders,
  });

  @override
  List<Object?> get props => [
    allOrders,
    cancelledOrders,
    finishedOrders,
    acceptedOrders,
  ];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}

