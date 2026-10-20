import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final res = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (res != null) {
        return UserProfile.fromJson(res);
      }
    } catch (e) {
      debugPrint('Error fetching profile for $userId: $e');
    }
    return null;
  }

  Future<UserProfile?> getProfileByEmployeeId(String employeeId) async {
    try {
      final res = await _supabase
          .from('profiles')
          .select()
          .eq('employee_id', employeeId.trim())
          .maybeSingle();

      if (res != null) {
        return UserProfile.fromJson(res);
      }
    } catch (e) {
      debugPrint('Error fetching profile by employee ID: $e');
    }
    return null;
  }

  Future<bool> createOrUpdateProfile(UserProfile profile) async {
    try {
      await _supabase.from('profiles').upsert(profile.toJson());
      return true;
    } catch (e) {
      debugPrint('Error upserting profile: $e');
      return false;
    }
  }

  Future<List<UserProfile>> getAllProfiles() async {
    try {
      final List<dynamic> res = await _supabase
          .from('profiles')
          .select()
          .order('created_at', ascending: false);
      return res.map((item) => UserProfile.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error fetching all profiles: $e');
      return [];
    }
  }
}
