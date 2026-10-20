import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
    required String employeeId,
    required String role,
    required String department,
    required String workLocation,
    required String shift,
    String? phone,
  }) async {
    final normalizedRole = UserProfile.normalizeRole(role);
    final normalizedShift = UserProfile.normalizeShift(shift);

    return await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'full_name': fullName.trim(),
        'employee_id': employeeId.trim(),
        'role': normalizedRole,
        'department': department.trim(),
        'work_location': workLocation.trim(),
        'shift': normalizedShift,
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      },
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    await _supabase.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: redirectTo,
    );
  }
}
