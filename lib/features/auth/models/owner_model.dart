class Owner {
  final int id;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String status;

  final String city;
  final String state;
  final String country;
  final String area;
  final String street1;
  final String street2;
  final String zipcode;
  final bool? isManager;
  final int? subscriptionId;
  final String? photoUrl;

  // Login response fields
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;

  final List<Subscription> subscriptions;
  final Plan? plan;
  final List<Manager>? manager;

  Owner({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
    required this.city,
    required this.state,
    required this.country,
    required this.area,
    required this.street1,
    required this.street2,
    required this.zipcode,
    this.subscriptionId,
    this.photoUrl,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    required this.subscriptions,
    this.plan,
     this.manager,
    this.isManager,
  });

factory Owner.fromJson(Map<String, dynamic> json) {
  final ownerJson = json["owner"] ?? json;
 List<Manager> parsedManagers = [];

  final managersData = json["managers"];

  if (managersData is List) {
    parsedManagers = managersData
        .map<Manager>(
          (e) => Manager.fromJson(e),
        )
        .toList();
  } else if (managersData is Map<String, dynamic>) {
    parsedManagers = [
      Manager.fromJson(managersData),
    ];
  }
  return Owner(
    isManager: json["is_manager"] ?? false,

    id: ownerJson["id"] ?? 0,
    phoneNumber: ownerJson["phone_number"] ?? "",
    firstName: ownerJson["first_name"] ?? "",
    lastName: ownerJson["last_name"] ?? "",
    email: ownerJson["email"] ?? "",
    status: ownerJson["status"] ?? "",

    city: ownerJson["city"] ?? "",
    state: ownerJson["state"] ?? "",
    country: ownerJson["country"] ?? "",
    area: ownerJson["area"] ?? "",
    street1: ownerJson["street_1"] ?? "",
    street2: ownerJson["street_2"] ?? "",
    zipcode: ownerJson["zipcode"] ?? "",

    subscriptionId: ownerJson["subscription_id"],
    photoUrl: ownerJson["photo_url"],

    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],

    subscriptions:
        (ownerJson["subscriptions"] as List?)
                ?.map(
                  (e) => Subscription.fromJson(e),
                )
                .toList() ??
            [],

    plan: json["plan"] != null
        ? Plan.fromJson(json["plan"])
        : null,

    manager: parsedManagers,
  );
}
Map<String, dynamic> toJson() {
  return {
    "id": id,
    "phone_number": phoneNumber,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "status": status,
    "city": city,
    "state": state,
    "country": country,
    "area": area,
    "street_1": street1,
    "street_2": street2,
    "zipcode": zipcode,
    "subscription_id": subscriptionId,
    "photo_url": photoUrl,

    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,

    "is_manager": isManager,

    // IMPORTANT
     "managers":
        manager?.map((e) => e.toJson()).toList(),

    "subscriptions":
        subscriptions.map((e) => e.toJson()).toList(),

    "plan": plan?.toJson(),
  };
}}

class Manager {
  final int id;
  final int ownerId;
  final int hostelId;

  final String name;
  final String email;
  final String phoneNumber;

  final String status;
  final String lastLoginIp;
  final String lastLoginAt;

  final String createdAt;
  final String updatedAt;

  Manager({
    required this.id,
    required this.ownerId,
    required this.hostelId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.lastLoginIp,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json["id"] ?? 0,
      ownerId: json["owner_id"] ?? 0,
      hostelId: json["hostel_id"] ?? 0,

      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phone_number"] ?? "",

      status: json["status"] ?? "",
      lastLoginIp: json["last_login_ip"] ?? "",
      lastLoginAt: json["last_login_at"] ?? "",

      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
Map<String, dynamic> toJson() {
  return {
    "id": id,
    "owner_id": ownerId,
    "hostel_id": hostelId,
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "status": status,
    "last_login_ip": lastLoginIp,
    "last_login_at": lastLoginAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
}

class Subscription {
  final int id;
  final int planId;
  final String customerId;
  final String subscriptionId;
  final int ownerId;

  final String startDate;
  final String endDate;

  final bool isActive;

  Subscription({
    required this.id,
    required this.planId,
    required this.customerId,
    required this.subscriptionId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json["id"] ?? 0,
      planId: json["plan_id"] ?? 0,
      customerId: json["customer_id"] ?? "",
      subscriptionId: json["subscription_id"] ?? "",
      ownerId: json["owner_id"] ?? 0,
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      isActive: json["is_active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "plan_id": planId,
      "customer_id": customerId,
      "subscription_id": subscriptionId,
      "owner_id": ownerId,
      "start_date": startDate,
      "end_date": endDate,
      "is_active": isActive,
    };
  }
}

class Plan {
  final int id;
  final String name;
  final String description;
  final int price;
  final int durationMonths;
  final String planId;
  final List<dynamic> features;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMonths,
    required this.planId,
    required this.features,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      durationMonths: json["duration_months"] ?? 0,
      planId: json["plan_id"] ?? "",
      features: json["features"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "duration_months": durationMonths,
      "plan_id": planId,
      "features": features,
    };
  }
}
