import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_events.dart';
import 'order_state.dart';
import 'package:trasport_ai/src/feature/home/presentation/repo/order_home_repo.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderHomeRepo _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await _orderRepository.fetchOrders(page: 1, perPage: 20);
        final hasNextPage = orders.length == 20;
        emit(
          OrderLoaded(
            currentOrders: orders,
            currentPage: 1,
            hasNextPage: hasNextPage, // إذا جلبنا 20 => قد توجد صفحات إضافية
          ),
        );
      } catch (e) {
        emit(OrderError('Failed to fetch orders'));
      }
    });

    on<LoadNextOrders>((event, emit) async {
      if (state is OrderLoaded) {
        final loadedState = state as OrderLoaded;
        final nextPage = loadedState.currentPage + 1;

        try {
          final newOrders = await _orderRepository.fetchOrders(
            page: nextPage,
            perPage: 20,
          );
          final hasNextPage = newOrders.length == 20;
          final allOrders = [...loadedState.currentOrders, ...newOrders];
          emit(
            OrderLoaded(
              currentOrders: allOrders, // دمج القائمة الحالية مع الجديدة
              currentPage: nextPage,
              hasNextPage: hasNextPage,
            ),
          );
        } catch (e) {
          emit(OrderError('Failed to load next orders'));
        }
      }
    });

    on<LoadPreviousOrders>((event, emit) async {
      if (state is OrderLoaded) {
        final loadedState = state as OrderLoaded;
        final prevPage = loadedState.currentPage - 1;
        if (prevPage < 1) return;

        try {
          final orders = await _orderRepository.fetchOrders(
            page: prevPage,
            perPage: 20,
          );
          final hasNextPage = orders.length == 20;
          emit(
            OrderLoaded(
              currentOrders: orders,
              currentPage: prevPage,
              hasNextPage: hasNextPage,
            ),
          );
        } catch (e) {
          emit(OrderError('Failed to load previous orders'));
        }
      }
    });
    //AcceptOrder
    on<AcceptOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        await _orderRepository.accept_Service(event.orderId);

        // بعد قبول الطلب، أعد تحميل الطلبات
        final orders = await _orderRepository.fetchOrders(page: 1, perPage: 20);
        final hasNextPage = orders.length == 20;

        emit(
          OrderLoaded(
            currentOrders: orders,
            currentPage: 1,
            hasNextPage: hasNextPage,
          ),
        );
      } catch (e, stack) {
  debugPrint("❌ Error in AcceptOrder: $e");
  debugPrintStack(stackTrace: stack);
  emit(OrderError('فشل: $e'));
}
    });
    //FinishOrder
    on<finishOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        final response = await _orderRepository.finish_Service(event.orderId);

        // بعد قبول الطلب، أعد تحميل الطلبات
        final orders = await _orderRepository.fetchOrders(page: 1, perPage: 20);
        final hasNextPage = orders.length == 20;
        emit(SuccessAccepted(response.message));

        emit(
          OrderLoaded(
            currentOrders: orders,
            currentPage: 1,
            hasNextPage: hasNextPage,
          ),
        );
      } catch (e) {
        emit(OrderError('فشل قبول الطلب'));
      }
    });
    on<FetchAcceptedOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final tasks = await _orderRepository.fetchTasks(page: 1, perPage: 20);
        final hasNextPage =
            tasks.length == 20; // إذا جلبنا 20 => قد توجد صفحات لاحقة

        emit(
          OrderLoaded(
            currentOrders: tasks,
            currentPage: 1,
            hasNextPage: hasNextPage,
          ),
        );
      } catch (e) {
        emit(OrderError('Failed to fetch accepted orders'));
      }
    });

    on<LoadMoreAcceptedOrders>((event, emit) async {
      if (state is OrderLoaded) {
        final loadedState = state as OrderLoaded;
        if (!loadedState.hasNextPage) return; // لا توجد صفحات إضافية

        final nextPage = loadedState.currentPage + 1;

        try {
          final newTasks = await _orderRepository.fetchTasks(
            page: nextPage,
            perPage: 20,
          );

          final hasNextPage = newTasks.length == 20;

          // دمج المهام الجديدة مع القديمة
          final allTasks = [...loadedState.currentOrders, ...newTasks];

          emit(
            OrderLoaded(
              currentOrders: allTasks,
              currentPage: nextPage,
              hasNextPage: hasNextPage,
            ),
          );
        } catch (e) {
          emit(OrderError('Failed to load more accepted orders'));
        }
      }
    });
  }
}
