import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyColors.dart';
import 'package:SaloonySpecialist/core/constants/app_routes.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';

class NewPasswordView extends StatefulWidget {
  final String email;
  final String code;
 
  const NewPasswordView({
    Key? key,
    required this.email,
    required this.code,
  }) : super(key: key);
  
  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final AuthService _authService = AuthService();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
 
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  // Real-time password validation
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  
  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(() => setState(() {}));
  }
  
  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
    });
  }
  
  bool _isPasswordValid() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    return _hasMinLength &&
        _hasUpperCase &&
        _hasLowerCase &&
        _hasNumber &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        newPassword == confirmPassword;
  }
  
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    if (!_isPasswordValid()) {
      ToastService.showError(context, 'Please meet all password requirements');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final result = await _authService.resetPassword(
        email: widget.email,
        code: widget.code,
        newPassword: newPassword,
      );
     
      if (mounted) {
        setState(() => _isLoading = false);
       
        if (result['success'] == true) {
          ToastService.showSuccess(context, 'Password changed successfully');
         
          // Navigate back to profile after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.profile,
                (route) => false,
              );
            }
          });
        } else {
          ToastService.showError(
            context,
            result['message'] ?? 'Error resetting password',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastService.showError(context, 'Connection error');
      }
    }
  }
  
  Widget _buildPasswordCriteria(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: isMet ? SaloonyColors.success : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isMet ? SaloonyColors.success : SaloonyColors.textSecondary,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _isPasswordValid() && !_isLoading;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SaloonyColors.primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Password',
          style: GoogleFonts.poppins(
            color: SaloonyColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SaloonyColors.primary,
                            SaloonyColors.navy,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: SaloonyColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 56,
                        color: SaloonyColors.secondary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Create a new\npassword',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SaloonyColors.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Your new password must be different from previous passwords',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: SaloonyColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your new password',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: SaloonyColors.secondary,
                            size: 22,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: SaloonyColors.secondary,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: SaloonyColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm your new password',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: SaloonyColors.secondary,
                            size: 22,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: SaloonyColors.secondary,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: SaloonyColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: SaloonyColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Password Requirements',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: SaloonyColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildPasswordCriteria('At least 8 characters', _hasMinLength),
                        _buildPasswordCriteria('One uppercase letter', _hasUpperCase),
                        _buildPasswordCriteria('One lowercase letter', _hasLowerCase),
                        _buildPasswordCriteria('One number', _hasNumber),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isButtonEnabled
                          ? LinearGradient(
                              colors: [
                                SaloonyColors.secondary,
                                SaloonyColors.gold,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : LinearGradient(
                              colors: [
                                Colors.grey[400]!,
                                Colors.grey[300]!,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isButtonEnabled
                          ? [
                              BoxShadow(
                                color: SaloonyColors.secondary.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      onPressed: isButtonEnabled ? _resetPassword : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  SaloonyColors.primary,
                                ),
                              ),
                            )
                          : Text(
                              'Reset Password',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isButtonEnabled
                                    ? SaloonyColors.primary
                                    : Colors.grey[600],
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}