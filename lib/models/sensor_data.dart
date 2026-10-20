class SensorData {
  final String? deviceId;
  final String? userId;
  final double? gasPpm;
  final String? gasType;
  final double? pressureHpa;
  final double? temperatureC;
  final double? oxygenPercent;
  final double? humidityPercent;
  final int? heartRateBpm;
  final String? status;
  final DateTime? timestamp;

  SensorData({
    this.deviceId,
    this.userId,
    this.gasPpm,
    this.gasType,
    this.pressureHpa,
    this.temperatureC,
    this.oxygenPercent,
    this.humidityPercent,
    this.heartRateBpm,
    this.status,
    this.timestamp,
  });

  bool get isAvailable =>
      gasPpm != null ||
      pressureHpa != null ||
      temperatureC != null ||
      oxygenPercent != null ||
      humidityPercent != null ||
      heartRateBpm != null;

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      deviceId: json['device_id']?.toString(),
      userId: json['user_id']?.toString(),
      gasPpm: json['gas_ppm'] != null ? double.tryParse(json['gas_ppm'].toString()) : null,
      gasType: json['gas_type']?.toString(),
      pressureHpa: json['pressure_hpa'] != null ? double.tryParse(json['pressure_hpa'].toString()) : null,
      temperatureC: json['temperature_c'] != null ? double.tryParse(json['temperature_c'].toString()) : null,
      oxygenPercent: json['oxygen_percent'] != null ? double.tryParse(json['oxygen_percent'].toString()) : null,
      humidityPercent: json['humidity_percent'] != null ? double.tryParse(json['humidity_percent'].toString()) : null,
      heartRateBpm: json['heart_rate_bpm'] != null ? int.tryParse(json['heart_rate_bpm'].toString()) : null,
      status: json['status']?.toString(),
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp'].toString()) : null,
    );
  }
}
