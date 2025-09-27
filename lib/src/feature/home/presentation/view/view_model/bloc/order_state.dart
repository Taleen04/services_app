import 'package:equatable/equatable.dart';
import 'package:trasport_ai/src/feature/home/data/model/model_order.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> currentOrders;
  final int currentPage;
  final bool hasNextPage;

  const OrderLoaded({
    required this.currentOrders,
    required this.currentPage,
    required this.hasNextPage,
  });

  OrderLoaded copyWith({
    List<Order>? currentOrders,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return OrderLoaded(
      currentOrders: currentOrders ?? this.currentOrders,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  @override
  List<Object> get props => [currentOrders, currentPage, hasNextPage];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderAccepted extends OrderState {
  final Order order;
  const OrderAccepted(this.order);

  @override
  List<Object> get props => [order];
}
class SuccessAccepted extends OrderState {
  final String orderMessage; // ← الرسالة
  const SuccessAccepted(this.orderMessage);

  @override
  List<Object> get props => [orderMessage];
}