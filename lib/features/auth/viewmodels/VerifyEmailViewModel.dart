import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';
import 'package:SaloonySpecialist/core/constants/app_routes.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  final String email;
  final BuildContext context;
  final TextEditingController codeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  VerifyEmailViewModel(this.email, this.context) {
    ToastService.init(context);
  }

  /// Vérifie le code et connecte l'utilisateur si valide
  Future<bool> verifyCode() async {
    if (codeController.text.trim().isEmpty) {
      ToastService.showError(context, 'Veuillez entrer le code de vérification');
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.verifySignupCode(
        email: email,
        code: codeController.text.trim(),
      );

      isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        ToastService.showSuccess(context, 'Email vérifié avec succès !');
        
        // ✅ Après vérification réussie, rediriger vers l'accueil
        await Future.delayed(const Duration(milliseconds: 500));
        
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false, // Supprime tout l'historique de navigation
        );
        
        return true;
      } else {
        final message = result['message'] ?? 'Code de vérification incorrect';
        ToastService.showError(context, message);
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ToastService.showError(context, 'Une erreur est survenue');
      debugPrint('Verify Code Error: $e');
      return false;
    }
  }

  /// Renvoie un nouveau code de vérification
  Future<bool> resendCode() async {
    isLoading = true;
    notifyListeners();

    try {
      // Utilisez la méthode appropriée pour renvoyer le code de vérification
      // Si vous avez une méthode dédiée, utilisez-la au lieu de requestPasswordReset
      final result = await _authService.requestPasswordReset (email);

      isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        ToastService.showSuccess(
          context,
          'Nouveau code envoyé à $email',
        );
        codeController.clear();
        return true;
      } else {
        final message = result['message'] ?? 'Erreur lors de l\'envoi du code';
        
        // Gestion spécifique des erreurs serveur
        if (message.contains('No static resource') || message.contains('500')) {
          ToastService.showError(
            context, 
            'Service temporairement indisponible. Réessayez plus tard.'
          );
        } else {
          ToastService.showError(context, message);
        }
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      
      // Messages d'erreur plus clairs
      String errorMessage = 'Impossible de renvoyer le code';
      if (e.toString().contains('No static resource') || e.toString().contains('500')) {
        errorMessage = 'Service de vérification indisponible. Contactez le support.';
      } else if (e.toString().contains('Connection') || e.toString().contains('Network')) {
        errorMessage = 'Erreur de connexion. Vérifiez votre internet.';
      }
      
      ToastService.showError(context, errorMessage);
      debugPrint('Resend Code Error: $e');
      return false;
    }
  }
 
  @override
  void dispose() {
    codeController.dispose();
    ToastService.cancelAll();
    super.dispose();
  }
}