// lib/src/core/constants/api_constants.dart
class ApiConstants {
  // 🔗 الرابط الأساسي
  static const String baseUrl =
      "https://parking.engmahmoudali.com/api/employee/";

  // =====================
  // 🟦 Authentication
  // =====================
  static const String login = 'login';
  //=========================
  //InfoProifile
  //=========================
  static const String profile = 'profile';
  static const String editProfile = 'update';
  static const String logout = 'logout';
  static const String changePassword = 'change-password';
  static const String changePhoto = 'change-photo';
  //==============================
  //Calender
  //==============================
  static const String calender = 'orders/all';
  static const String ordersCancelled = 'orders/cancelled';
  static const String ordersFinished = 'orders/finished';
  //=========================
  //Home order
  //=========================
  static const String order = 'orders';
  static const String acceptOrder = 'orders/accepted';
  // =====================
  // 🟩 Tickets
  // =====================
  static const String tickets = 'tickets';
  static String ticketsByVehicleType(String vehicleType) =>
      'tickets?vehicle_type=$vehicleType';
  static String ticketsByClientName(String name) => 'tickets?client_name=$name';
  static String ticketsSorted(String order) => 'tickets?sort=$order';

  // =====================
  // 🟨 Clients
  // =====================
  static String clientTickets(int clientId) => 'clients/$clientId/tickets';

  // =====================
  // 🟥 Employees
  // =====================
  static String employee(int id) => 'employee/$id';
  static String employees(int id) => 'employees/$id';
}
