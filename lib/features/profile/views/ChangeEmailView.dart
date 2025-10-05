import 'package:flutter/material.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/core/services/AuthService.dart';

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({Key? key}) : super(key: key);

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<ChangeEmailView> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestEmailChange() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Veuillez entrer votre ancien email', isError: true);
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Email invalide', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.requestPasswordReset(email);
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          // Navigation vers la page de vérification du code
          Navigator.pushNamed(
            context,
            '/verify-email-change',
            arguments: email,
          );
        } else {
          _showSnackBar(
            result['message'] ?? 'Erreur lors de l\'envoi du code',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Erreur de connexion', isError: true);
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? SaloonyColors.error : SaloonyColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.background,
      appBar: AppBar(
        backgroundColor: SaloonyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SaloonyColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Changer d\'e-mail',
          style: TextStyle(
            color: SaloonyColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SaloonyColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.email_outlined,
                  size: 48,
                  color: SaloonyColors.secondary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Changer d\'e-mail',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SaloonyColors.primary,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                'Modifiez votre adresse e-mail et conservez un contrôle total sur votre nouvelle adresse e-mail.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: SaloonyColors.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Email Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Entrez votre ancien email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'exemple@domaine.com',
                      hintStyle: TextStyle(
                        color: SaloonyColors.textSecondary.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: SaloonyColors.tertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: SaloonyColors.tertiary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: SaloonyColors.secondary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _requestEmailChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SaloonyColors.secondary,
                    foregroundColor: SaloonyColors.primary,
                    elevation: 0,
                    disabledBackgroundColor: SaloonyColors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              SaloonyColors.primary,
                            ),
                          ),
                        )
                      : const Text(
                          'Suivant',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Alternative Method Link
              TextButton(
                onPressed: () {
                  // Navigation vers une autre méthode
                },
                child: const Text(
                  'Utiliser une autre méthode de vérification',
                  style: TextStyle(
                    color: SaloonyColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}