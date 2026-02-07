import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/widgets/SaloonyInputFields.dart';
import '../../../core/widgets/SaloonyButtons.dart';
import '../viewmodels/ResetPasswordViewModel.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments 
        as Map<String, String>;
    final email = args['email']!;
    final code = args['code']!;

    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(),
      child: Consumer<ResetPasswordViewModel>(
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: SaloonyColors.backgroundSecondary,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: SaloonyColors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Color(0xFF1B2B3E),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            
                            // Image reset password
                            Center(
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1B2B3E).withOpacity(0.15),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/reset_password_illustration.jpg',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF1B2B3E), Color(0xFF2D4356)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.lock_reset_rounded,
                                          size: 60,
                                          color: Color(0xFFF0CD97),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 28),
                            
                            // Titre
                            Text(
                              'Reset Password',
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.heading1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create a strong password to secure your account',
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.subtitle,
                            ),

                            const SizedBox(height: 36),

                            // New Password
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Password',
                                  style: SaloonyTextStyles.labelLarge,
                                ),
                                const SizedBox(height: 8),
                                SaloonyInputField(
                                  controller: vm.passwordController,
                                  label: '',
                                  readOnly: vm.isLoading,
                                  obscureText: !vm.passwordVisible1,
                                  onChanged: (_) => vm.validatePassword(),
                                  hintText: 'Enter new password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  onSuffixIconTap: vm.togglePasswordVisibility1,
                                  suffixIcon: vm.passwordVisible1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Password Requirements
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password must contain:',
                                    style: SaloonyTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildRequirement(
                                    'At least 8 characters',
                                    vm.hasMinLength,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildRequirement(
                                    'One uppercase letter (A-Z)',
                                    vm.hasUppercase,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildRequirement(
                                    'One lowercase letter (a-z)',
                                    vm.hasLowercase,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildRequirement(
                                    'One number (0-9)',
                                    vm.hasNumber,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildRequirement(
                                    'One special character (!@#\$%^&*)',
                                    vm.hasSpecialChar,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Confirm Password
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Password',
                                  style: SaloonyTextStyles.labelLarge,
                                ),
                                const SizedBox(height: 8),
                                SaloonyInputField(
                                  controller: vm.confirmPasswordController,
                                  label: '',
                                  readOnly: vm.isLoading,
                                  obscureText: !vm.passwordVisible2,
                                  onChanged: (_) => vm.validatePassword(),
                                  hintText: 'Confirm your password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  onSuffixIconTap: vm.togglePasswordVisibility2,
                                  suffixIcon: vm.passwordVisible2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                ),
                                if (vm.confirmPasswordController.text.isNotEmpty && !vm.passwordsMatch)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 16,
                                          color: Color(0xFFE74C3C),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Passwords do not match',
                                          style: SaloonyTextStyles.caption.copyWith(color: const Color(0xFFE74C3C)),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Change Password button
                            SaloonyPrimaryButton(
                              label: 'Change Password',
                              isLoading: vm.isLoading,
                              onPressed: (vm.isLoading || !vm.isPasswordValid) ? () {} : () => vm.changePassword(context, email, code),
                            ),

                            const SizedBox(height: 24),

                            // Security note
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: SaloonyColors.goldLight.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: SaloonyColors.gold.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.security_rounded,
                                    color: SaloonyColors.gold,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Your password is encrypted and secure',
                                      style: SaloonyTextStyles.caption.copyWith(fontWeight: FontWeight.w500, color: SaloonyColors.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isMet ? const Color(0xFF27AE60) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isMet ? Icons.check : Icons.close,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: SaloonyTextStyles.bodySmall.copyWith(
              color: isMet ? const Color(0xFF27AE60) : SaloonyColors.textSecondary,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}