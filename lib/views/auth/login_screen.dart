import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../shell/app_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signIn(
        loginInput: _loginController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      if (success) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AppShell()),
          (route) => false,
        );
      } else if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppColors.critical,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  // Left side abstract industrial visual
                  Expanded(
                    flex: 5,
                    child: _buildLeftVisual(),
                  ),
                  // Right side login form
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                        child: _buildRightLoginForm(),
                      ),
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildMobileHeader(),
                    const SizedBox(height: 32),
                    _buildRightLoginForm(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLeftVisual() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.all(60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Brand Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.safetyAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.background,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SAFEBAND',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Text(
                    'ENTERPRISE SAFETY PLATFORM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.safetyAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Central Visual Abstract Industrial Element (NO MOCK DATA)
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Ring
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.8), width: 1.5),
                      ),
                    ),
                    // Middle Ring
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.safetyAccent.withValues(alpha: 0.3), width: 1),
                      ),
                    ),
                    // Core Radar Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.elevatedSurface,
                        border: Border.all(color: AppColors.safetyAccent, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.accentGlow,
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.radar_rounded,
                        size: 56,
                        color: AppColors.safetyAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.circle, size: 8, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(
                        'SECURE AUTHENTICATION GATEWAY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryText,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Description Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'SAFEBAND Industrial Safety & Environmental Monitoring',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                  letterSpacing: -0.5,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Protecting workers through intelligent environmental awareness across chemical, mining, and heavy industrial facilities.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.safetyAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: AppColors.background,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'SAFEBAND',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Industrial Safety & Monitoring Platform',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildRightLoginForm() {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.status == AuthStatus.authenticating;

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to continue to your SafeBand workspace.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 32),

            // Employee ID or Email Input
            CustomTextField(
              controller: _loginController,
              label: 'Employee ID or Email',
              hint: 'e.g. EMP-10492 or user@safeband.io',
              prefixIcon: Icons.badge_outlined,
              isRequired: true,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your Employee ID or Email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password Input
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your account password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              isRequired: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.secondaryText,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Remember me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.safetyAccent,
                        checkColor: AppColors.background,
                        side: const BorderSide(color: AppColors.border),
                        onChanged: (val) {
                          setState(() {
                            _rememberMe = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.safetyAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSignIn,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : const Text('SIGN IN'),
              ),
            ),
            const SizedBox(height: 24),

            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.safetyAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Supervisor Access (Demo / Direct Entry)
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.shield_rounded, size: 16, color: AppColors.safetyAccent),
                label: const Text(
                  'Quick Supervisor Access (Demo)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.safetyAccent,
                  ),
                ),
                onPressed: () {
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  auth.signInDirectly();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AppShell()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final resetEmailController = TextEditingController(text: _loginController.text.contains('@') ? _loginController.text : '');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              title: const Text(
                'Reset Password',
                style: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your corporate email address to receive password reset instructions.',
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: resetEmailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.primaryText, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'worker@safeband.io',
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.secondaryText, size: 20),
                      fillColor: AppColors.inputBackground,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final email = resetEmailController.text.trim();
                          if (email.isEmpty || !email.contains('@')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid corporate email address.'),
                                backgroundColor: AppColors.critical,
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isSubmitting = true);
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final ok = await authProvider.resetPassword(email);
                          setDialogState(() => isSubmitting = false);

                          if (context.mounted) {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok
                                      ? 'Password reset email sent to $email. Please check your inbox.'
                                      : (authProvider.errorMessage ?? 'Failed to send reset email.'),
                                ),
                                backgroundColor: ok ? AppColors.success : AppColors.critical,
                              ),
                            );
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                      : const Text('SEND RESET LINK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
