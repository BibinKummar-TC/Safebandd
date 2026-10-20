import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/sensor_data.dart';
import '../models/safety_models.dart';
import '../services/supabase_service.dart';

class DashboardProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SensorData? _latestSensorData;
  SensorData? get latestSensorData => _latestSensorData;

  List<UserProfile> _allWorkers = [];
  List<UserProfile> get allWorkers => _allWorkers;

  List<SafetyAlert> _alerts = [];
  List<SafetyAlert> get alerts => _alerts;

  List<SafetyIncident> _incidents = [];
  List<SafetyIncident> get incidents => _incidents;

  List<Map<String, dynamic>> _devices = [];
  List<Map<String, dynamic>> get devices => _devices;

  List<Map<String, dynamic>> _zones = [];
  List<Map<String, dynamic>> get zones => _zones;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadDashboardData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch sensor data (Returns null if no hardware connected, adhering to REAL-DATA-ONLY requirement)
      _latestSensorData = await _supabaseService.fetchLatestSensorData(userId);

      // Fetch workers list from real Supabase profiles table
      _allWorkers = await _supabaseService.fetchAllProfiles();

      // Fetch alerts, incidents, devices, zones from Supabase
      _alerts = await _supabaseService.fetchAlerts();
      _incidents = await _supabaseService.fetchIncidents();
      _devices = await _supabaseService.fetchDevices();
      _zones = await _supabaseService.fetchZones();
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadDashboardData(_latestSensorData?.userId ?? '');
  }
}
