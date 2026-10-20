import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/constants.dart';
import '../models/user_profile.dart';
import '../models/sensor_data.dart';
import '../models/safety_models.dart';
import 'auth_service.dart';
import 'profile_service.dart';
import 'sensor_service.dart';
import 'alert_service.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final AuthService authService = AuthService();
  final ProfileService profileService = ProfileService();

  SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.publishableKey,
        debug: kDebugMode,
      );
      debugPrint('Supabase SDK initialized using project URL: ${SupabaseConfig.url}');
    } catch (e) {
      debugPrint('Supabase init warning: $e');
    }
  }

  // Delegated Profile functions
  Future<UserProfile?> fetchProfile(String userId) => profileService.getProfile(userId);
  Future<String?> findEmailByEmployeeId(String employeeId) async {
    final profile = await profileService.getProfileByEmployeeId(employeeId);
    return profile?.email;
  }
  Future<bool> createOrUpdateProfile(UserProfile profile) => profileService.createOrUpdateProfile(profile);
  Future<List<UserProfile>> fetchAllProfiles() => profileService.getAllProfiles();

  // Delegated Sensor & Alert functions
  Future<SensorData?> fetchLatestSensorData(String userId) => SensorService().fetchLatestSensorData(userId);
  Future<List<SafetyAlert>> fetchAlerts() => AlertService().fetchAlerts();
  Future<List<SafetyIncident>> fetchIncidents() => AlertService().fetchIncidents();
  Future<List<Map<String, dynamic>>> fetchDevices() => SensorService().fetchDevices();
  Future<List<Map<String, dynamic>>> fetchZones() => AlertService().fetchZones();
}
