class ServiceOrderModel {
  final int id;
  final int serviceId;
  final int clientId;
  final int enterVehicleId;
  final double priceRecorded;
  final int employeePaymentProcessed;
  final String? employeePaymentAmount;
  final DateTime? employeePaymentProcessedAt;
  final double servicePrice;
  final String? description;
  final int status;
  final DateTime? acceptedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? cancelledAt;
  final int? assignedEmployeeId;
  final DateTime? deadlineAt;
  final String statusName;
  final String serviceName;
  final String clientName;
  final String vehicleNumber;
  final String vehicleName;
  final String? vehicleModel;
  final DateTime? expectedToGoOutAt;

  ServiceOrderModel({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.enterVehicleId,
    required this.priceRecorded,
    required this.employeePaymentProcessed,
    this.employeePaymentAmount,
    this.employeePaymentProcessedAt,
    required this.servicePrice,
    this.description,
    required this.status,
    this.acceptedAt,
    required this.createdAt,
    required this.updatedAt,
    this.cancelledAt,
    this.assignedEmployeeId,
    this.deadlineAt,
    required this.statusName,
    required this.serviceName,
    required this.clientName,
    required this.vehicleNumber,
    required this.vehicleName,
    this.vehicleModel,
    this.expectedToGoOutAt,
  });

  static DateTime? _parseDateTimeFlexible(dynamic value) {
    if (value == null) return null;
    final String str = value.toString().trim();
    if (str.isEmpty) return null;
    try {
      return DateTime.parse(str);
    } catch (_) {
      // Try replacing space with 'T' for formats like 'yyyy-MM-dd HH:mm:ss'
      try {
        final fixed = str.contains(' ') ? str.replaceFirst(' ', 'T') : str;
        return DateTime.parse(fixed);
      } catch (_) {
        return null;
      }
    }
  }

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      id: json['id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      enterVehicleId: json['enter_vehicle_id'] ?? 0,
      priceRecorded: (json['price_recorded'] ?? 0).toDouble(),
      employeePaymentProcessed: json['employee_payment_processed'] ?? 0,
      employeePaymentAmount: json['employee_payment_amount'],
      employeePaymentProcessedAt: _parseDateTimeFlexible(
        json['employee_payment_processed_at'],
      ),
      servicePrice: (json['service_price'] ?? 0).toDouble(),
      description: json['description'],
      status: json['status'] ?? 0,
      acceptedAt: _parseDateTimeFlexible(json['accepted_at']),
      createdAt: _parseDateTimeFlexible(json['created_at'])!,
      updatedAt: _parseDateTimeFlexible(json['updated_at'])!,
      cancelledAt: _parseDateTimeFlexible(json['cancelled_at']),
      assignedEmployeeId: json['assigned_employee_id'],
      deadlineAt: _parseDateTimeFlexible(json['deadline_at']),
      statusName: json['status_name'] ?? '',
      serviceName: json['service_name'] ?? '',
      clientName: json['client_name'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleName: json['vehicle_name'] ?? '',
      vehicleModel: json['vehicle_model'],
      expectedToGoOutAt: _parseDateTimeFlexible(json['expected_to_go_out_at']),
    );
  }
  bool get isCompleted => status == 3; // Done
  bool get isInProgress => status == 1; // In progress
  bool get isAccepted => status == 2; // Accepted
  bool get isCancelled => status == 4; // Cancelled
  bool get isPending => status == 1 || status == 2;
}
