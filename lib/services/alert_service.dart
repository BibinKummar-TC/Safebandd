import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/safety_models.dart';

class AlertService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<SafetyAlert>> fetchAlerts() async {
    try {
      final List<dynamic> res = await _supabase
          .from('alerts')
          .select()
          .order('timestamp', ascending: false);
      return res.map((item) => SafetyAlert.fromJson(item)).toList();
    } catch (e) {
      debugPrint('No alerts found: $e');
      return [];
    }
  }

  Future<List<SafetyIncident>> fetchIncidents() async {
    try {
      final List<dynamic> res = await _supabase
          .from('incidents')
          .select()
          .order('created_at', ascending: false);
      return res.map((item) => SafetyIncident.fromJson(item)).toList();
    } catch (e) {
      debugPrint('No incidents found: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchZones() async {
    try {
      final List<dynamic> res = await _supabase.from('zones').select();
      return res.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('No zones found: $e');
      return [];
    }
  }
}
