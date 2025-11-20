import 'package:flutter/material.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône de déconnexion
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: SaloonyColors.secondary, // Fond violet clair
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color:  SaloonyColors.navy, // Violet
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              
              // Message de confirmation
              const Text(
                'Êtes-vous sûr de vouloir vous déconnecter ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              
              // Boutons d'action
              Row(
                children: [
                  // Bouton Annuler
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Bouton Oui, déconnexion
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        await _handleLogout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  SaloonyColors.secondary, // Violet
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Oui',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.secondary),
          ),
        ),
      );

      // Appeler le service de déconnexion
      final authService = AuthService();
      await authService.signOut();

      // Fermer l'indicateur de chargement
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Rediriger vers la page de connexion
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.signIn,
          (route) => false,
        );
      }
    } catch (e) {
      // Fermer l'indicateur de chargement en cas d'erreur
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Afficher un message d'erreur avec ToastService
      if (context.mounted) {
        ToastService.showError(context, 'Erreur lors de la déconnexion: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEDC087),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Se déconnecter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== VERSION LISTTILE POUR MENU ====================

class LogoutListTile extends StatelessWidget {
  const LogoutListTile({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color:  SaloonyColors.secondary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Êtes-vous sûr de vouloir vous déconnecter ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        await _handleLogout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  SaloonyColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Oui',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.secondary),
          ),
        ),
      );

      final authService = AuthService();
      await authService.signOut();

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.signIn,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Utiliser ToastService au lieu de SnackBar
      if (context.mounted) {
        ToastService.showError(context, 'Erreur lors de la déconnexion: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: SaloonyColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.logout,
          color: SaloonyColors.error,
          size: 20,
        ),
      ),
      title: const Text(
        'Déconnexion',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color:  SaloonyColors.secondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: SaloonyColors.textSecondary,
      ),
      onTap: () => _showLogoutDialog(context),
    );
  }
}