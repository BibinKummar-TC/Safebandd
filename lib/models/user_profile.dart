class UserProfile {
  final String id;
  final String employeeId;
  final String fullName;
  final String email;
  final String? phone;
  final String department;
  final String role;
  final String workLocation;
  final String shift;
  final String accountStatus;
  final String? assignedZone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  UserProfile({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.department,
    required this.role,
    required this.workLocation,
    required this.shift,
    this.accountStatus = 'active',
    this.assignedZone,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
  });

  static String normalizeRole(String r) {
    final lower = r.toLowerCase().trim();
    if (lower.contains('super')) return 'supervisor';
    if (lower.contains('officer') || lower.contains('safety')) return 'safety_officer';
    if (lower.contains('admin')) return 'admin';
    return 'worker';
  }

  static String normalizeShift(String s) {
    final lower = s.toLowerCase().trim();
    if (lower.contains('afternoon')) return 'afternoon';
    if (lower.contains('night')) return 'night';
    if (lower.contains('rotational')) return 'rotational';
    return 'morning';
  }

  static String normalizeAccountStatus(String a) {
    final lower = a.toLowerCase().trim();
    if (lower.contains('inactive')) return 'inactive';
    if (lower.contains('suspend')) return 'suspended';
    return 'active';
  }

  String get displayRole {
    final norm = normalizeRole(role);
    switch (norm) {
      case 'supervisor':
        return 'Supervisor';
      case 'safety_officer':
        return 'Safety Officer';
      case 'admin':
        return 'Admin';
      default:
        return 'Worker';
    }
  }

  String get displayShift {
    final norm = normalizeShift(shift);
    switch (norm) {
      case 'afternoon':
        return 'Afternoon Shift (14:00 - 22:00)';
      case 'night':
        return 'Night Shift (22:00 - 06:00)';
      case 'rotational':
        return 'Rotational Shift';
      default:
        return 'Morning Shift (06:00 - 14:00)';
    }
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      employeeId: json['employee_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Unknown User',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      department: json['department']?.toString() ?? 'Chemical Unit',
      role: json['role']?.toString() ?? 'worker',
      workLocation: json['work_location']?.toString() ?? 'Chemical Industry Plant',
      shift: json['shift']?.toString() ?? 'morning',
      accountStatus: json['account_status']?.toString() ?? 'active',
      assignedZone: json['assigned_zone']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
      lastLogin: json['last_login'] != null ? DateTime.tryParse(json['last_login'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'full_name': fullName,
      'email': email,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      'department': department,
      'role': normalizeRole(role),
      'work_location': workLocation,
      'shift': normalizeShift(shift),
      'account_status': normalizeAccountStatus(accountStatus),
      if (assignedZone != null && assignedZone!.isNotEmpty) 'assigned_zone': assignedZone,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (lastLogin != null) 'last_login': lastLogin!.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? employeeId,
    String? fullName,
    String? email,
    String? phone,
    String? department,
    String? role,
    String? workLocation,
    String? shift,
    String? accountStatus,
    String? assignedZone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return UserProfile(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      role: role ?? this.role,
      workLocation: workLocation ?? this.workLocation,
      shift: shift ?? this.shift,
      accountStatus: accountStatus ?? this.accountStatus,
      assignedZone: assignedZone ?? this.assignedZone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
