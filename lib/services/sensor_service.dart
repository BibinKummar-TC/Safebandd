import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sensor_data.dart';

class SensorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<SensorData?> fetchLatestSensorData(String userId) async {
    try {
      final res = await _supabase
          .from('sensor_readings')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false)
          .limit(1)
          .maybeSingle();

      if (res != null) {
        return SensorData.fromJson(res);
      }
    } catch (e) {
      debugPrint('No sensor readings record/table found: $e');
    }
    // Real data only rule: return null if no hardware record exists
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchDevices() async {
    try {
      final List<dynamic> res = await _supabase.from('devices').select();
      return res.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('No devices record/table found: $e');
      return [];
    }
  }
}
