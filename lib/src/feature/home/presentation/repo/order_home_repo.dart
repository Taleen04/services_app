import 'package:trasport_ai/src/feature/home/data/data_sourse.dart/order_data_sourse.dart';
import 'package:trasport_ai/src/feature/home/data/model/model_order.dart';

class OrderHomeRepo {
  final OrderDataSourse dataSource;

  OrderHomeRepo(this.dataSource);

  Future<List<Order>> fetchOrders({int page = 1, int perPage = 20}) async {
    try {
      final orders = await dataSource.getOrder(page: page, perPage: perPage);
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> accept_Service(int id) async {
    try {
      return await dataSource.accept_Service(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> finish_Service(int id) async {
    try {
      return await dataSource.finish_Service(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> fetchTasks({int page = 1, int perPage = 20}) async {
    try {
      return await dataSource.fetchTasks(page: page, perPage: perPage);
    } catch (e) {
      rethrow;
    }
  }
}
