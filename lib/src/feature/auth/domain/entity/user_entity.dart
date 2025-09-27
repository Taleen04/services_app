class UserEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String serviceType;
  final int salary;
  final String workingFrom;
  final String workingTo;
  final String? address;
  final double wallet;
  final String? photo;
  final String walletBalance;
  final String totalEarnings;
  final int servicesCompleted;
  final bool autoPayout;
  final String payoutThreshold;
  final String createdAt;
  final String updatedAt;
  final int? isActive;
  final int driverPlace;
  final int status;
  final int vehicleType;
  final String? vehicleNumber;
  final String? photoLink;
  final String? serviceTypeName;
  final String? vehicleTypeName;

  // الحقول الإضافية
  final String? emailVerifiedAt;
  final String? deletedAt;
  final String? startedAt;
  final int? waitList;
  final String? joinedToWaitListAt;
  final String? finishedWorkAt;
  final String? fcm;
  final int? lastLocation;
  final int? isBusy;

  // الصور الإضافية
  final String? idCardImage;
  final String? ungoverenImage;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.serviceType,
    required this.salary,
    required this.workingFrom,
    required this.workingTo,
    this.address,
    required this.wallet,
    this.photo,
    required this.walletBalance,
    required this.totalEarnings,
    required this.servicesCompleted,
    required this.autoPayout,
    required this.payoutThreshold,
    required this.createdAt,
    required this.updatedAt,
    this.isActive,
    required this.driverPlace,
    required this.status,
    required this.vehicleType,
    this.vehicleNumber,
    this.photoLink,
    this.serviceTypeName,
    this.vehicleTypeName,
    this.emailVerifiedAt,
    this.deletedAt,
    this.startedAt,
    this.waitList,
    this.joinedToWaitListAt,
    this.finishedWorkAt,
    this.fcm,
    this.lastLocation,
    this.isBusy,
    this.idCardImage,
    this.ungoverenImage,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      serviceType: json['service_type']?.toString() ?? '',
      salary: json['salary'] ?? 0,
      workingFrom: json['working_from'] ?? '',
      workingTo: json['working_to'] ?? '',
      address: json['address'],
      wallet: (json['wallet'] ?? 0).toDouble(),
      photo: json['photo'],
      walletBalance: json['wallet_balance'] ?? '0',
      totalEarnings: json['total_earnings'] ?? '0',
      servicesCompleted: json['services_completed'] ?? 0,
      autoPayout: json['auto_payout'] ?? false,
      payoutThreshold: json['payout_threshold'] ?? '0',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isActive: json['is_active'],
      driverPlace: json['driver_place'] ?? 0,
      status: json['status'] ?? 0,
      vehicleType: json['vehicle_type'] ?? 0,
      vehicleNumber: json['vehicle_number'],
      photoLink: json['PhotoLink'],
      serviceTypeName: json['ServiceTypeName'],
      vehicleTypeName: json['VehicleTypeName'],
      emailVerifiedAt: json['email_verified_at'],
      deletedAt: json['deleted_at'],
      startedAt: json['started_at'],
      waitList: json['wait_list'],
      joinedToWaitListAt: json['joined_to_wait_list_at'],
      finishedWorkAt: json['finished_work_at'],
      fcm: json['fcm'],
      lastLocation: json['last_location'],
      isBusy: json['is_busy'],
      idCardImage: json['id_card_image'],
      ungoverenImage: json['ungoveren_image'],
    );
  }
}
