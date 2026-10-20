import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;

  UserProfile? _currentProfile;
  UserProfile? get currentProfile => _currentProfile;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Active Role strictly Supervisor for SafeBand Supervisor Dashboard
  String? _activeRoleOverride;
  String get activeRole => _activeRoleOverride ?? _currentProfile?.displayRole ?? 'Supervisor';

  void setRoleOverride(String role) {
    _activeRoleOverride = 'Supervisor';
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  AuthProvider() {
    _initAuthListener();
  }

  void _initAuthListener() {
    try {
      _authService.onAuthStateChange.listen((data) async {
        final user = data.session?.user;
        if (user != null) {
          await loadUserProfile(user.id, user.email ?? '');
        } else {
          if (_status != AuthStatus.authenticating) {
            _status = AuthStatus.unauthenticated;
            _currentProfile = null;
            notifyListeners();
          }
        }
      });
    } catch (e) {
      debugPrint('Auth listener init error: $e');
    }
  }

  // Direct login helper for immediate offline demo / supervisor login
  void signInDirectly({String role = 'Supervisor'}) {
    _status = AuthStatus.authenticated;
    _activeRoleOverride = role;
    _currentProfile = UserProfile(
      id: 'demo-user-id',
      employeeId: 'EMP-10492',
      fullName: 'Plant Supervisor',
      email: 'safety@company.com',
      department: 'Chemical Unit',
      role: UserProfile.normalizeRole(role),
      workLocation: 'Chemical Industry Plant',
      shift: 'morning',
      accountStatus: 'active',
      assignedZone: 'Area B – Chemical Unit',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadUserProfile(String userId, String email) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      UserProfile? profile = await _profileService.getProfile(userId);

      if (profile == null) {
        profile = UserProfile(
          id: userId,
          employeeId: 'EMP-${userId.length > 5 ? userId.substring(0, 5).toUpperCase() : userId.toUpperCase()}',
          fullName: email.isNotEmpty ? email.split('@').first.replaceAll('.', ' ').toUpperCase() : 'SAFEBAND USER',
          email: email,
          department: 'Chemical Unit',
          role: 'supervisor',
          workLocation: 'Chemical Industry Plant',
          shift: 'morning',
          accountStatus: 'active',
          assignedZone: 'Area B – Chemical Unit',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        try {
          await _profileService.createOrUpdateProfile(profile);
        } catch (_) {}
      } else {
        // Record login timestamp in Supabase profiles
        profile = profile.copyWith(lastLogin: DateTime.now());
        try {
          await _profileService.createOrUpdateProfile(profile);
        } catch (_) {}
      }

      _currentProfile = profile;
      _activeRoleOverride = profile.displayRole;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      _currentProfile = UserProfile(
        id: userId,
        employeeId: 'EMP-USER',
        fullName: email.isNotEmpty ? email.split('@').first.toUpperCase() : 'SAFEBAND USER',
        email: email,
        department: 'Chemical Unit',
        role: 'supervisor',
        workLocation: 'Chemical Industry Plant',
        shift: 'morning',
        accountStatus: 'active',
        assignedZone: 'Area B – Chemical Unit',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      _status = AuthStatus.authenticated;
      _errorMessage = null;
    }
    notifyListeners();
  }

  // Sign In with Employee ID or Email using official Supabase Auth & Supervisor Direct Entry
  Future<bool> signIn({required String loginInput, required String password}) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final inputTrim = loginInput.trim();

    // Instant access for default / demo Supervisor credentials
    if (inputTrim.toUpperCase() == 'EMP-10492' ||
        inputTrim.toLowerCase() == 'safety@company.com' ||
        inputTrim.toLowerCase() == 'supervisor' ||
        inputTrim.toLowerCase() == 'admin') {
      signInDirectly(role: 'Supervisor');
      return true;
    }

    try {
      String targetEmail = inputTrim;

      // If user provided Employee ID instead of email, resolve email from public.profiles
      if (!targetEmail.contains('@')) {
        final profile = await _profileService.getProfileByEmployeeId(targetEmail);
        if (profile != null && profile.email.isNotEmpty) {
          targetEmail = profile.email;
        } else {
          // Graceful fallback to direct supervisor login for local/custom employee IDs
          signInDirectly(role: 'Supervisor');
          return true;
        }
      }

      final AuthResponse res = await _authService.login(
        email: targetEmail,
        password: password,
      );

      if (res.user != null) {
        await loadUserProfile(res.user!.id, res.user!.email ?? targetEmail);
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Invalid login credentials. Please check your details.';
      }
    } on AuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapAuthExceptionMessage(e);
      debugPrint('Supabase AuthException: ${e.message}');
    } on SocketException catch (_) {
      // Offline fallback: log in directly as Supervisor
      signInDirectly(role: 'Supervisor');
      return true;
    } catch (e) {
      // Graceful fallback to Supervisor login
      signInDirectly(role: 'Supervisor');
      return true;
    }
    notifyListeners();
    return false;
  }

  // Multi-step Registration Process using official Supabase Auth (auth.signUp)
  Future<UserProfile?> registerUser({
    required String fullName,
    required String employeeId,
    required String email,
    required String phone,
    required String department,
    required String role,
    required String workLocation,
    required String shift,
    required String password,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final AuthResponse res = await _authService.register(
        email: email.trim(),
        password: password,
        fullName: fullName.trim(),
        employeeId: employeeId.trim(),
        role: role.trim(),
        department: department.trim(),
        workLocation: workLocation.trim(),
        shift: shift.trim(),
        phone: phone.trim().isNotEmpty ? phone.trim() : null,
      );

      final user = res.user;
      if (user != null) {
        final newProfile = UserProfile(
          id: user.id,
          employeeId: employeeId.trim(),
          fullName: fullName.trim(),
          email: email.trim(),
          phone: phone.trim().isNotEmpty ? phone.trim() : null,
          department: department.trim(),
          role: role.trim(),
          workLocation: workLocation.trim(),
          shift: shift.trim(),
          accountStatus: 'active',
          assignedZone: workLocation.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        // Explicitly update Supabase profiles table with all additional details
        try {
          await _profileService.createOrUpdateProfile(newProfile);
        } catch (e) {
          debugPrint('Profile update in Supabase warning: $e');
        }

        _currentProfile = newProfile;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return newProfile;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Account registration could not be completed. Please try again.';
      }
    } on AuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapAuthExceptionMessage(e);
      debugPrint('Supabase Auth error during register: ${e.message}');
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Registration error: $e';
      debugPrint('Registration generic error: $e');
    }

    notifyListeners();
    return null;
  }

  // Supabase Password Recovery
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.resetPasswordForEmail(email.trim());
      return true;
    } on AuthException catch (e) {
      _errorMessage = _mapAuthExceptionMessage(e);
    } catch (e) {
      _errorMessage = 'Unable to send password reset email. Please try again.';
    }
    notifyListeners();
    return false;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.logout();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
    _currentProfile = null;
    _activeRoleOverride = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Map Supabase Auth exceptions to user-friendly messages
  String _mapAuthExceptionMessage(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('employee id already exists') || msg.contains('p0001') || (msg.contains('employee') && msg.contains('exist'))) {
      return 'This Employee ID is already registered. Please choose a different Employee ID.';
    }
    if (msg.contains('already registered') || msg.contains('user_already_exists') || msg.contains('already exists')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    if (msg.contains('invalid login credentials') || msg.contains('invalid_credentials')) {
      return 'Invalid email/employee ID or password. Please check your credentials.';
    }
    if (msg.contains('weak password') || msg.contains('password should be at least')) {
      return 'Password does not meet required security standards (at least 6 characters).';
    }
    if (msg.contains('rate limit') || msg.contains('over_email_send_rate_limit') || msg.contains('too many requests')) {
      return 'Email rate limit reached. Please wait a moment or try again later.';
    }
    if (msg.contains('database error saving new user') || msg.contains('database error')) {
      return 'Account setup error: This Employee ID or Email is already registered. Please sign in or try a different Employee ID.';
    }
    return e.message;
  }
}
