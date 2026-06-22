/// Tenant model — maps directly to the API response from /auth/tenant/verify-otp
class Owner {
  // ── Auth ────────────────────────────────────────────────────────────────
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;

  // ── Tenant core ──────────────────────────────────────────────────────────
  final int id;
  final String name;
  final String phoneNumber;
  final String alternatePhoneNumber;
  final String email;
  final String? photoUrl;
  final String gender;
  final bool active;
  final bool identityVerified;

  // ── Room / Hostel ────────────────────────────────────────────────────────
  final int hostelId;
  final int? roomId;
  final double rent;
  final double securityDeposit;
  final String joinDate;

  // ── Address ──────────────────────────────────────────────────────────────
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipcode;

  // ── Emergency contact ────────────────────────────────────────────────────
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactRelationship;

  // ── Identity ─────────────────────────────────────────────────────────────
  final String? aadhaarNumber;
  final String? organization;
  final String? employeeId;

  // ── Timestamps ───────────────────────────────────────────────────────────
  final String createdAt;
  final String updatedAt;

  // ── Legacy fields kept for backward compat ───────────────────────────────
  final bool? isManager;
  final List<Subscription> subscriptions;
  final Plan? plan;
  final List<Manager>? manager;
  final int? ownerId;

  Owner({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.alternatePhoneNumber = '',
    required this.email,
    this.photoUrl,
    this.gender = '',
    this.active = true,
    this.identityVerified = false,
    this.hostelId = 0,
    this.roomId,
    this.rent = 0,
    this.securityDeposit = 0,
    this.joinDate = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.zipcode = '',
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
    this.emergencyContactRelationship = '',
    this.aadhaarNumber,
    this.organization,
    this.employeeId,
    this.createdAt = '',
    this.updatedAt = '',
    this.isManager,
    this.subscriptions = const [],
    this.plan,
    this.manager,
    this.ownerId,
  });

  /// Handles both the full verify-otp response (has access_token + tenant)
  /// and a flat tenant-only map (stored in SharedPreferences).
  factory Owner.fromJson(Map<String, dynamic> json) {
    // When coming from API the tenant fields live under "tenant" key;
    // when restored from storage they are flat.
    final t = (json['tenant'] as Map<String, dynamic>?) ?? json;

    return Owner(
      // Auth
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'] is int ? json['expires_in'] : null,

      // Core tenant
      id: (t['id'] as num?)?.toInt() ?? 0,
      name: t['name'] ?? '',
      phoneNumber: t['phone_number'] ?? '',
      alternatePhoneNumber: t['alternate_phone_number'] ?? '',
      email: t['email'] ?? '',
      photoUrl: t['photo_url'],
      gender: t['gender'] ?? '',
      active: t['active'] ?? true,
      identityVerified: t['identity_verified'] ?? false,

      // Room / Hostel
      hostelId: (t['hostel_id'] as num?)?.toInt() ?? 0,
      roomId: (t['room_id'] as num?)?.toInt(),
      rent: (t['rent'] as num?)?.toDouble() ?? 0,
      securityDeposit: (t['security_deposit'] as num?)?.toDouble() ?? 0,
      joinDate: t['join_date'] ?? '',
ownerId: (json['owner_id'] as num?)?.toInt(),      address: t['address'] ?? '',
      city: t['city'] ?? '',
      state: t['state'] ?? '',
      country: t['country'] ?? '',
      zipcode: t['zipcode'] ?? '',

      // Emergency contact
      emergencyContactName: t['emergency_contact_name'] ?? '',
      emergencyContactPhone: t['emergency_contact_phone'] ?? '',
      emergencyContactRelationship: t['emergency_contact_relationship'] ?? '',

      // Identity
      aadhaarNumber: t['aadhaar_number'],
      organization: t['organization'],
      employeeId: t['employee_id'],

      // Timestamps
      createdAt: t['created_at'] ?? '',
      updatedAt: t['updated_at'] ?? '',

      // Legacy
      isManager: json['is_manager'] ?? false,
      subscriptions: (t['subscriptions'] as List?)
              ?.map((e) => Subscription.fromJson(e))
              .toList() ??
          [],
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      manager: (json['managers'] as List?)
          ?.map((e) => Manager.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'owner_id': ownerId, 
      'tenant': {
        'id': id,
        'name': name,
        'phone_number': phoneNumber,
        'alternate_phone_number': alternatePhoneNumber,
        'email': email,
        'photo_url': photoUrl,
        'gender': gender,
        'active': active,
        'identity_verified': identityVerified,
        'hostel_id': hostelId,
        'room_id': roomId,
        'rent': rent,
        'security_deposit': securityDeposit,
        'join_date': joinDate,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'zipcode': zipcode,
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
        'emergency_contact_relationship': emergencyContactRelationship,
        'aadhaar_number': aadhaarNumber,
        'organization': organization,
        'employee_id': employeeId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'subscriptions': subscriptions.map((e) => e.toJson()).toList(),
      },
      'is_manager': isManager,
      'managers': manager?.map((e) => e.toJson()).toList(),
      'plan': plan?.toJson(),
    };
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns first name (first word of name).
  String get firstName =>
      name.trim().isEmpty ? '' : name.trim().split(' ').first;

  /// Returns last name (everything after first word).
  String get lastName {
    final parts = name.trim().split(' ');
    return parts.length > 1 ? parts.skip(1).join(' ') : '';
  }

  /// Formats rent as ₹5,000
  String get formattedRent => '₹${rent.toStringAsFixed(0)}';

  /// Formats security deposit
  String get formattedDeposit => '₹${securityDeposit.toStringAsFixed(0)}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Manager (kept for owner-side compatibility)
// ─────────────────────────────────────────────────────────────────────────────
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
      id: json['id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,
      hostelId: json['hostel_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      status: json['status'] ?? '',
      lastLoginIp: json['last_login_ip'] ?? '',
      lastLoginAt: json['last_login_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_id': ownerId,
        'hostel_id': hostelId,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'status': status,
        'last_login_ip': lastLoginIp,
        'last_login_at': lastLoginAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Subscription
// ─────────────────────────────────────────────────────────────────────────────
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
      id: json['id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      customerId: json['customer_id'] ?? '',
      subscriptionId: json['subscription_id'] ?? '',
      ownerId: json['owner_id'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plan_id': planId,
        'customer_id': customerId,
        'subscription_id': subscriptionId,
        'owner_id': ownerId,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Plan
// ─────────────────────────────────────────────────────────────────────────────
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      durationMonths: json['duration_months'] ?? 0,
      planId: json['plan_id'] ?? '',
      features: json['features'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'duration_months': durationMonths,
        'plan_id': planId,
        'features': features,
      };
}
