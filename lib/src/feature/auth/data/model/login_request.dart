

import 'package:trasport_ai/src/feature/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.serviceType,
    required super.salary,
    required super.workingFrom,
    required super.workingTo,
    required super.address,
    required super.wallet,
    super.photo,
    required super.walletBalance,
    required super.totalEarnings,
    required super.servicesCompleted,
    required super.autoPayout,
    required super.payoutThreshold,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    required super.driverPlace,
    required super.status,
    required super.vehicleType,
    super.vehicleNumber,
    super.photoLink,
    super.serviceTypeName,
    super.vehicleTypeName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      serviceType: json["service_type"],
      salary: json["salary"],
      workingFrom: json["working_from"],
      workingTo: json["working_to"],
      address: json["address"],
      wallet: (json["wallet"] as num).toDouble(),
      photo: json["photo"],
      walletBalance: json["wallet_balance"],
      totalEarnings: json["total_earnings"],
      servicesCompleted: json["services_completed"],
      autoPayout: json["auto_payout"],
      payoutThreshold: json["payout_threshold"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      isActive: json["is_active"],
      driverPlace: json["driver_place"],
      status: json["status"],
      vehicleType: json["vehicle_type"],
      vehicleNumber: json["vehicle_number"],
      photoLink: json["PhotoLink"],
      serviceTypeName: json["ServiceTypeName"],
      vehicleTypeName: json["VehicleTypeName"],
    );
  }
}
