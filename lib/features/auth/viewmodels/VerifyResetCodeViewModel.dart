import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/constants/app_routes.dart';

class VerifyResetCodeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // Controller unique pour le code de vérification
  final TextEditingController codeController = TextEditingController();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Vérifie le code de réinitialisation
  Future<void> verifyCode(BuildContext context, String email) async {
    final verificationCode = codeController.text.trim();

    if (verificationCode.length != 6) {
      _showSnackBar(
        context,
        'Please enter the complete 6-digit code',
        Colors.red,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.verifyResetCode(
        email: email,
        code: verificationCode,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success'] == true && context.mounted) {
        // Navigate to reset password screen with email and code
        Navigator.pushNamed(
          context,
          '/resetPassword',
          arguments: {'email': email, 'code': verificationCode},
        );
      } else if (context.mounted) {
        _showSnackBar(
          context,
          result['message'] ?? 'Invalid or expired code',
          Colors.red,
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      if (context.mounted) {
        _showSnackBar(
          context,
          'An error occurred. Please try again.',
          Colors.red,
        );
      }
    }
  }

  /// Redemande un code de vérification
  Future<void> resendCode(BuildContext context, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.requestPasswordReset(email);

      _isLoading = false;
      notifyListeners();

      if (result['success'] == true && context.mounted) {
        _showSnackBar(
          context,
          'Code resent to your email',
          Colors.green,
        );
        // Clear le code précédent
        codeController.clear();
      } else if (context.mounted) {
        _showSnackBar(
          context,
          result['message'] ?? 'Error resending code',
          Colors.red,
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      if (context.mounted) {
        _showSnackBar(
          context,
          'An error occurred. Please try again.',
          Colors.red,
        );
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}