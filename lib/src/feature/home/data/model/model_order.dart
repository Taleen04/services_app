class Order {
  final int id;
  final String serviceName;
  final int status;
  final String clientName;
  final String? clientPhone;
  final String vehicleNumber;
  final String vehicleName;
  final String? expectedToGoOutAt;
  final int starsCount;
  final String? deadlineAt;
  final String statusName;
  final String createdAt;
  final String message;
  final String? acceptedAt;

  Order({
    required this.id,
    required this.serviceName,
    required this.status,
    required this.clientPhone,
    required this.clientName,
    required this.vehicleNumber,
    required this.vehicleName,
    this.expectedToGoOutAt,
    required this.starsCount,
    this.deadlineAt,
    required this.statusName,
    required this.createdAt,
    this.message = '',
    this.acceptedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: _parseInt(json['id']) ?? 0,
      clientPhone: json['client']['phone'],
      serviceName: json['service_name']?.toString() ?? '',
      status: _parseInt(json['status']) ?? 0,
      clientName: json['client_name']?.toString() ?? '',
      vehicleNumber: json['vehicle_number']?.toString() ?? '',
      vehicleName: json['vehicle_name']?.toString() ?? '',
      expectedToGoOutAt: json['expected_to_go_out_at']?.toString(),
      starsCount: _parseStarsCount(json),
      deadlineAt: json['deadline_at']?.toString(),
      statusName: json['status_name']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      acceptedAt: json['accepted_at']?.toString(),
    );
  }

  /// دالة مساعدة لتحويل القيم الرقمية بشكل آمن إلى int
  static int? _parseInt(dynamic value) {
    try {
      if (value == null) return null;

      // إذا كان النوع int بالفعل
      if (value is int) {
        return value;
      }

      // إذا كان النوع String، حاول تحويله
      if (value is String) {
        return int.tryParse(value);
      }

      // إذا كان النوع double، حوله إلى int
      if (value is double) {
        return value.toInt();
      }

      return null;
    } catch (e) {
      print('Error parsing int value: $e');
      return null;
    }
  }

  /// دالة مساعدة لتحويل StarsCount بشكل آمن من أي نوع إلى int
  static int _parseStarsCount(Map<String, dynamic> json) {
    try {
      if (json['client'] != null && json['client']['StarsCount'] != null) {
        final starsValue = json['client']['StarsCount'];

        // إذا كان النوع int بالفعل
        if (starsValue is int) {
          return starsValue;
        }

        // إذا كان النوع String، حاول تحويله
        if (starsValue is String) {
          return int.tryParse(starsValue) ?? 0;
        }

        // إذا كان النوع double، حوله إلى int
        if (starsValue is double) {
          return starsValue.toInt();
        }
      }

      return 0; // القيمة الافتراضية
    } catch (e) {
      print('Error parsing StarsCount: $e');
      return 0;
    }
  }
}
