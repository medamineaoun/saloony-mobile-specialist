import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/features/profile/views/VerifyResetCodeView.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isLoadingEmail = true;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserEmail();
  }

  Future<void> _loadCurrentUserEmail() async {
    setState(() => _isLoadingEmail = true);

    try {
      final result = await _authService.getCurrentUser();
      
      if (result['success'] == true && result['user'] != null) {
        setState(() {
          _userEmail = result['user']['userEmail'] ?? '';
          _isLoadingEmail = false;
        });
      } else {
        if (mounted) {
          setState(() => _isLoadingEmail = false);
          _showSnackBar('Impossible de récupérer l\'email', isError: true);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingEmail = false);
        _showSnackBar('Erreur de connexion', isError: true);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _requestPasswordReset() async {
    if (_userEmail.isEmpty) {
      _showSnackBar('Email non disponible', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.requestPasswordReset(_userEmail);
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyResetCodeView(email: _userEmail),
            ),
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

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? SaloonyColors.error : SaloonyColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingEmail) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.secondary),
            strokeWidth: 3,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SaloonyColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Réinitialiser le mot de passe',
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
                  
                  // Logo avec design moderne
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
                  
                  // Titre
                  Text(
                    'Mot de passe oublié ?',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SaloonyColors.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  Text(
                    'Pas de souci ! Entrez votre adresse email et nous vous enverrons un code de vérification pour réinitialiser votre mot de passe.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: SaloonyColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Email Display (Non-editable)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adresse e-mail',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: SaloonyColors.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.email_outlined,
                                size: 20,
                                color: SaloonyColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _userEmail,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: SaloonyColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: SaloonyColors.textSecondary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Cette adresse ne peut pas être modifiée',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: SaloonyColors.textSecondary.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Submit Button avec gradient
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SaloonyColors.secondary,
                          SaloonyColors.gold,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: SaloonyColors.secondary.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _requestPasswordReset,
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Envoyer le code',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: SaloonyColors.primary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                  color: SaloonyColors.primary,
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Info supplémentaire
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SaloonyColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: SaloonyColors.primary.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security_rounded,
                          size: 20,
                          color: SaloonyColors.primary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Le code de vérification sera valide pendant 15 minutes',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: SaloonyColors.primary.withOpacity(0.8),
                              height: 1.4,
                            ),
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
    );
  }
}