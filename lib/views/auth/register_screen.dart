import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'registration_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 1;
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // Controllers Step 1
  final _fullNameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2 Fields
  String _department = 'Chemical Processing';
  String _role = 'Supervisor';
  String _workLocation = 'Sector A - Chemical Refinery';
  String _shift = 'Day Shift (06:00 - 14:00)';
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _departments = [
    'Chemical Processing',
    'Underground Mining',
    'Industrial Maintenance',
    'Plant Operations',
    'Safety & Security',
    'Logistics & Supply Chain',
    'Administrative',
  ];

  final List<String> _roles = [
    'Supervisor',
  ];

  final List<String> _locations = [
    'Sector A - Chemical Refinery',
    'Shaft 3 - Deep Underground',
    'Plant B - Processing Terminal',
    'Central Control Room',
    'Zone C - Heavy Equipment Operations',
  ];

  final List<String> _shifts = [
    'Day Shift (06:00 - 14:00)',
    'Swing Shift (14:00 - 22:00)',
    'Night Shift (22:00 - 06:00)',
    'Rotating Shift',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step1FormKey.currentState?.validate() ?? false) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _handleRegistration() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service & Industrial Safety Policy'),
          backgroundColor: AppColors.critical,
        ),
      );
      return;
    }

    if (_step2FormKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final newProfile = await authProvider.registerUser(
        fullName: _fullNameController.text,
        employeeId: _employeeIdController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        department: _department,
        role: _role,
        workLocation: _workLocation,
        shift: _shift,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (newProfile != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RegistrationSuccessScreen(
              employeeId: newProfile.employeeId,
              role: newProfile.role,
            ),
          ),
        );
      } else if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: AppColors.critical,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () {
            if (_currentStep == 2) {
              setState(() {
                _currentStep = 1;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'SafeBand Registration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20,
            vertical: 30,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 580),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Title
                const Text(
                  'Create Worker Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Register your profile for SafeBand safety monitoring & zone access.',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 28),

                // Step Indicator: 01 Personal | 02 Work Profile
                Row(
                  children: [
                    _buildStepBadge(step: 1, label: '01 Personal', isActive: _currentStep == 1, isDone: _currentStep > 1),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: _currentStep > 1 ? AppColors.safetyAccent : AppColors.border,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    _buildStepBadge(step: 2, label: '02 Work Profile', isActive: _currentStep == 2, isDone: false),
                  ],
                ),
                const SizedBox(height: 32),

                // Step 1 or Step 2 Content
                _currentStep == 1 ? _buildStep1Form() : _buildStep2Form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepBadge({required int step, required String label, required bool isActive, required bool isDone}) {
    final color = isActive || isDone ? AppColors.safetyAccent : AppColors.mutedText;

    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.safetyAccent : (isDone ? AppColors.safetyAccent : AppColors.elevatedSurface),
            border: Border.all(color: color),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: AppColors.background)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.background : AppColors.secondaryText,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.w500,
            color: isActive || isDone ? AppColors.primaryText : AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1Form() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'e.g. Marcus Vance',
            prefixIcon: Icons.person_outline_rounded,
            isRequired: true,
            validator: (val) => (val == null || val.trim().isEmpty) ? 'Full Name is required' : null,
          ),
          const SizedBox(height: 18),
          CustomTextField(
            controller: _employeeIdController,
            label: 'Employee ID',
            hint: 'e.g. EMP-84920',
            prefixIcon: Icons.badge_outlined,
            isRequired: true,
            validator: (val) => (val == null || val.trim().isEmpty) ? 'Employee ID is required' : null,
          ),
          const SizedBox(height: 18),
          CustomTextField(
            controller: _emailController,
            label: 'Corporate Email',
            hint: 'worker@safeband.io',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email is required';
              if (!val.contains('@')) return 'Please enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 18),
          CustomTextField(
            controller: _phoneController,
            label: 'Phone Number (Optional)',
            hint: '+1 (555) 019-2834',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('CONTINUE TO WORK PROFILE'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Form() {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.status == AuthStatus.authenticating;

    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department Dropdown
          const Text('Department *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _department,
            dropdownColor: AppColors.elevatedSurface,
            style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
            decoration: const InputDecoration(),
            items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (val) => setState(() => _department = val!),
          ),
          const SizedBox(height: 18),

          // Role Dropdown
          const Text('Role *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _role,
            dropdownColor: AppColors.elevatedSurface,
            style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
            decoration: const InputDecoration(),
            items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
            onChanged: (val) => setState(() => _role = val!),
          ),
          const SizedBox(height: 18),

          // Work Location Dropdown
          const Text('Work Location / Facility *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _workLocation,
            dropdownColor: AppColors.elevatedSurface,
            style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
            decoration: const InputDecoration(),
            items: _locations.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (val) => setState(() => _workLocation = val!),
          ),
          const SizedBox(height: 18),

          // Shift Dropdown
          const Text('Assigned Shift *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _shift,
            dropdownColor: AppColors.elevatedSurface,
            style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
            decoration: const InputDecoration(),
            items: _shifts.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (val) => setState(() => _shift = val!),
          ),
          const SizedBox(height: 18),

          // Password
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Min 6 characters',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            isRequired: true,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.secondaryText),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (val) {
              if (val == null || val.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 18),

          // Confirm Password
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirmPassword,
            isRequired: true,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.secondaryText),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (val) {
              if (val != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Terms Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _agreedToTerms,
                  activeColor: AppColors.safetyAccent,
                  checkColor: AppColors.background,
                  side: const BorderSide(color: AppColors.border),
                  onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'I agree to the SafeBand Terms of Service and Industrial Environmental Safety Regulations.',
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Buttons Row
          Row(
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _currentStep = 1),
                child: const Text('BACK'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleRegistration,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                          )
                        : const Text('CREATE ACCOUNT'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
