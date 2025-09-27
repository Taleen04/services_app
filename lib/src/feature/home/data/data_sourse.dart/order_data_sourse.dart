import 'package:trasport_ai/src/core/database/api/apiclient.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';
import 'package:trasport_ai/src/feature/home/data/model/model_order.dart';

class OrderDataSourse {
  /// جلب الطلبات مع دعم الصفحة وعدد العناصر لكل صفحة
  Future<List<Order>> getOrder({int page = 1, int perPage = 20}) async {
    try {
      final res = await ApiClient.dio.get(
        ApiConstants.order,
        queryParameters: {"per_page": perPage, "page": page, "sort": "desc"},
      );

      if (res.data['status'] == true) {
        final List data = res.data['data'];
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception(res.data['message'] ?? 'Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Order> accept_Service(int id) async {
    try {
      final res = await ApiClient.dio.get('orders/accept/$id');
      if (res.data['status'] == true) {
        return Order.fromJson(res.data['data']);
      } else {
        throw Exception(res.data['message'] ?? 'Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<List<Order>> fetchTasks({int page = 1, int perPage = 20}) async {
    try {
      print('Fetching tasks with page: $page, perPage: $perPage');

      final res = await ApiClient.dio.get(
        ApiConstants.acceptOrder,
        queryParameters: {'page': page, 'per_page': perPage, "sort": "desc"},
      );

      print('Response status code: ${res.statusCode}');
      print('Response data: ${res.data}');

      if (res.statusCode == 200 && res.data != null) {
        // بعض الواجهات ترجع القائمة مباشرة داخل data، وأخرى داخل data.data
        final dynamic outerData = res.data['data'];

        List<dynamic> dataList = [];
        if (outerData is List) {
          // الشكل: { data: [ {...}, {...} ] }
          dataList = outerData;
        } else if (outerData is Map && outerData['data'] is List) {
          // الشكل (Laravel pagination): { data: { data: [ {...}, {...} ] } }
          dataList = outerData['data'] as List;
        } else {
          print('Unexpected tasks payload shape. outerData=$outerData');
          return [];
        }

        print('Tasks count: ${dataList.length}');

        // معالجة آمنة لتحويل العناصر إلى Order
        final List<Order> orders = [];
        for (final item in dataList) {
          try {
            if (item is Map<String, dynamic>) {
              orders.add(Order.fromJson(item));
            } else if (item is Map) {
              orders.add(Order.fromJson(Map<String, dynamic>.from(item)));
            } else {
              print('Skipping invalid item (not a map): $item');
            }
          } catch (e) {
            print('Error parsing single order: $e');
            print('Problematic data: $item');
            // تخطي العنصر التالف والمتابعة
          }
        }

        return orders;
      } else {
        throw Exception(
          'Server returned status ${res.statusCode}: ${res.data?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('Error in fetchTasks: $e');
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<Order> finish_Service(int id) async {
    try {
      final res = await ApiClient.dio.get('orders/finish/$id');
      if (res.data['status'] == true) {
        return Order.fromJson(res.data['data']);
      } else {
        throw Exception(res.data['message'] ?? 'Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }
}
