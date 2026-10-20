import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'config/app_theme.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'views/auth/login_screen.dart';
import 'views/shell/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase configuration
  await SupabaseService.initialize();

  runApp(const SafeBandApp());
}

class SafeBandApp extends StatelessWidget {
  const SafeBandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.status == AuthStatus.authenticating && authProvider.currentProfile == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.safetyAccent),
                  SizedBox(height: 16),
                  Text(
                    'AUTHENTICATING SAFEBAND GATEWAY...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (authProvider.status == AuthStatus.authenticated && authProvider.currentProfile != null) {
          return const AppShell();
        }

        return const LoginScreen();
      },
    );
  }
}
