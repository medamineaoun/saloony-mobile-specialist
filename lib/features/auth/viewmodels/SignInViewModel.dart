import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';
import 'package:SaloonySpecialist/core/constants/app_routes.dart';

class SignInViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  /// Vérifie si le compte nécessite une vérification email
  bool _isPendingVerification(Map<String, dynamic> result) {
    final status = result['status']?.toString().toLowerCase() ?? '';
    final message = result['message']?.toString().toLowerCase() ?? '';
    
    // Liste des mots-clés indiquant un compte non vérifié
    const verificationKeywords = [
      'pending',
      'verify',
      'vérif',
      'verification',
      'confirm',
      'activate',
      'activation',
      'email not verified',
      'email non vérifié',
      'account not verified',
      'compte non vérifié',
    ];
    
    // Vérification du statut exact
    if (status == 'pending') {
      return true;
    }
    
    // Vérification des mots-clés dans le message
    for (var keyword in verificationKeywords) {
      if (message.contains(keyword)) {
        return true;
      }
    }
    
    return false;
  }

  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validation des champs vides
    if (email.isEmpty || password.isEmpty) {
      ToastService.showError(
        context,
        'Please enter your email and password',
      );
      return;
    }

    // Validation du format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ToastService.showError(
        context,
        'Please enter a valid email address',
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final authService = AuthService();
      final result = await authService.signIn(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        // ✅ Connexion réussie
        ToastService.showSuccess(context, 'Welcome back!');
        
        // Petit délai pour que l'utilisateur voie le message de succès
        await Future.delayed(const Duration(milliseconds: 300));
        
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
        
      } else {
        // ❌ Échec de connexion
        final message = result['message'] ?? 'Login failed';
        
        // 🔔 Vérification si le compte nécessite une validation email
        if (_isPendingVerification(result)) {
          // Compte en attente de vérification
          ToastService.showInfo(
            context,
            'Please verify your email to continue',
          );
          
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (context.mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.verifyEmail,
              arguments: email,
            );
          }
          
        } else {
          // Autres erreurs (mauvais mot de passe, compte inexistant, compte bloqué, etc.)
          ToastService.showError(context, message);
        }
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      ToastService.showError(
        context,
        'Connection error. Please try again.',
      );
      
      debugPrint('Sign In Error: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}