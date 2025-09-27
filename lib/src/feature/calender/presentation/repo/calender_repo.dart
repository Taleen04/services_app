import 'package:trasport_ai/src/feature/calender/data/calender_data_sourse.dart';
import 'package:trasport_ai/src/feature/calender/domain/model/calender_model.dart';

class CalendarRepository {
  final CalendarDataSource dataSource;

  CalendarRepository(this.dataSource);

  Future<List<ServiceOrderModel>> fetchAll({required String dateRange}) async {
    try {
      return await dataSource.fetchAll(dateRange: dateRange);
    } catch (e) {
      throw Exception("فشل في جلب جميع الطلبات: $e");
    }
  }

  Future<List<ServiceOrderModel>> fetchCancelled({
    required String dateRange,
  }) async {
    try {
      return await dataSource.fetchCancelled(dateRange: dateRange);
    } catch (e) {
      throw Exception("فشل في جلب الطلبات الملغاة: $e");
    }
  }

  Future<List<ServiceOrderModel>> fetchFinished({
    required String dateRange,
  }) async {
    try {
      return await dataSource.fetchFinished(dateRange: dateRange);
    } catch (e) {
      throw Exception("فشل في جلب الطلبات المنتهية: $e");
    }
  }

  Future<List<ServiceOrderModel>> fetchAccepted({
    required String dateRange,
  }) async {
    try {
      return await dataSource.fetchAccepted(dateRange: dateRange);
    } catch (e) {
      throw Exception("فشل في جلب الطلبات المقبولة: $e");
    }
  }
}
