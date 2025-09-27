import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchOrders extends OrderEvent {}

class LoadNextOrders extends OrderEvent {}

class LoadPreviousOrders extends OrderEvent {}

class FetchAcceptedOrders extends OrderEvent {}

class LoadMoreAcceptedOrders extends OrderEvent {}

class AcceptOrder extends OrderEvent {
  final int orderId;
  const AcceptOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class finishOrder extends OrderEvent {
  final int orderId;
  const finishOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class OrderAcceptLoading extends OrderEvent {}
