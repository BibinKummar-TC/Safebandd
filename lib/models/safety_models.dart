class SafetyAlert {
  final String id;
  final String title;
  final String severity; // Low, Warning, High Risk, Critical
  final String category; // Gas Leak, Pressure Anomaly, Temperature Spike, Low O2, Cardiac Event
  final String location;
  final String? description;
  final String? employeeId;
  final String status; // Active, Acknowledged, Resolved
  final DateTime timestamp;

  SafetyAlert({
    required this.id,
    required this.title,
    required this.severity,
    required this.category,
    required this.location,
    this.description,
    this.employeeId,
    required this.status,
    required this.timestamp,
  });

  factory SafetyAlert.fromJson(Map<String, dynamic> json) {
    return SafetyAlert(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Safety Alert',
      severity: json['severity']?.toString() ?? 'Warning',
      category: json['category']?.toString() ?? 'Environmental',
      location: json['location']?.toString() ?? 'Unknown Zone',
      description: json['description']?.toString(),
      employeeId: json['employee_id']?.toString(),
      status: json['status']?.toString() ?? 'Active',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class SafetyIncident {
  final String id;
  final String incidentCode;
  final String title;
  final String zone;
  final String severity;
  final String status;
  final String reportedBy;
  final String? description;
  final DateTime createdAt;

  SafetyIncident({
    required this.id,
    required this.incidentCode,
    required this.title,
    required this.zone,
    required this.severity,
    required this.status,
    required this.reportedBy,
    this.description,
    required this.createdAt,
  });

  factory SafetyIncident.fromJson(Map<String, dynamic> json) {
    return SafetyIncident(
      id: json['id']?.toString() ?? '',
      incidentCode: json['incident_code']?.toString() ?? 'INC-000',
      title: json['title']?.toString() ?? 'Safety Incident',
      zone: json['zone']?.toString() ?? 'General Area',
      severity: json['severity']?.toString() ?? 'Medium',
      status: json['status']?.toString() ?? 'Under Investigation',
      reportedBy: json['reported_by']?.toString() ?? 'System',
      description: json['description']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
