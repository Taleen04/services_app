import 'package:trasport_ai/src/core/database/api/apiclient.dart';
import 'package:trasport_ai/src/core/resources/api_constants.dart';
import 'package:trasport_ai/src/feature/calender/domain/model/calender_model.dart';

class CalendarDataSource {
  Future<List<ServiceOrderModel>> fetchAll({required String dateRange}) async {
    return _fetchByEndpoint(ApiConstants.calender, dateRange: dateRange);
  }

  Future<List<ServiceOrderModel>> fetchCancelled({
    required String dateRange,
  }) async {
    return _fetchByEndpoint(ApiConstants.ordersCancelled, dateRange: dateRange);
  }

  Future<List<ServiceOrderModel>> fetchFinished({
    required String dateRange,
  }) async {
    return _fetchByEndpoint(ApiConstants.ordersFinished, dateRange: dateRange);
  }

  Future<List<ServiceOrderModel>> fetchAccepted({
    required String dateRange,
  }) async {
    return _fetchByEndpoint(ApiConstants.acceptOrder, dateRange: dateRange);
  }

  Future<List<ServiceOrderModel>> _fetchByEndpoint(
    String endpoint, {
    required String dateRange,
  }) async {
    try {
      final paramName = 'date';
      print('Fetching from: $endpoint with $paramName: $dateRange');
      final response = await ApiClient.dio.get(
        endpoint,
        queryParameters: {paramName: dateRange, 'per_page': 2000, 'page': 1},
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['data'];
        if (data is List) {
          final results =
              data.map((e) => ServiceOrderModel.fromJson(e)).toList();
          print('$endpoint returned ${results.length} items');
          return results;
        } else {
          print('$endpoint: data is not a list: $data');
        }
      } else {
        print('$endpoint: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching $endpoint: $e');
    }

    return [];
  }
}
