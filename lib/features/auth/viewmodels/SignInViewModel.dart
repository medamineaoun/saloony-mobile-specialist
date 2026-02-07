import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/UserService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';
import 'package:SaloonySpecialist/core/constants/app_routes.dart';
import 'package:SaloonySpecialist/core/models/User.dart';


class SignInViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _passwordVisible = false;
  bool _isLoading = false;

  bool get passwordVisible => _passwordVisible;
  bool get isLoading => _isLoading;


  /// Basculer la visibilité du mot de passe
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  /// Effectuer la connexion
  /// 
  Future<void> signIn(BuildContext context) async {
    final validation = _validateInputs();
    if (validation != null) {
      ToastService.showError(context, validation);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final result = await _authService.signIn(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      if (!context.mounted) return;

      if (result['success'] == true) {
        await _checkUserAccountStatusAndProceed(context);
      } else {
        final statusCode = result['statusCode'];
        final message = (result['message'] ?? '').toString().toLowerCase();
        
        if (message.contains('deactiv') || message.contains('deactivated')) {
          if (context.mounted) {
            _isLoading = false;
            notifyListeners();
            _showAccountStatusDialog(context, 'DEACTIVATE');
          }
          return;
        }
        
        if (message.contains('block') || message.contains('blocked')) {
          if (context.mounted) {
            _isLoading = false;
            notifyListeners();
            _showAccountStatusDialog(context, 'BLOCKED');
          }
          return;
        }

        if (statusCode == 401) {
          try {
            final email = emailController.text.trim();
            final lookup = await _userService.getUserByEmailPublic(email);
            if (lookup['success'] == true && lookup['user'] != null) {
              final user = lookup['user'] is User ? lookup['user'] : User.fromJson(lookup['user']);
              final userStatus = user.userStatus.toUpperCase();
              
              _isLoading = false;
              notifyListeners();
              
              if (userStatus == 'DEACTIVATE') {
                if (context.mounted) _showAccountStatusDialog(context, 'DEACTIVATE');
                return;
              }
              if (userStatus == 'BLOCKED') {
                if (context.mounted) _showAccountStatusDialog(context, 'BLOCKED');
                return;
              }
            }
          } catch (e) {
            debugPrint('Error checking account status by email: $e');
          }
        }

        _handleFailedLogin(context, result);
      }
    } catch (e) {
      _handleError(context, e);
    }
  }

  /// Check user account status and proceed accordingly
  Future<void> _checkUserAccountStatusAndProceed(BuildContext context) async {
    try {
      final userResult = await _authService.getCurrentUser();
      
      if (userResult['success'] == true && userResult['user'] != null) {
        final userData = userResult['user'] is User
            ? userResult['user']
            : User.fromJson(userResult['user']);
        
        final status = userData.userStatus.toUpperCase();
        
        if (status == 'DEACTIVATE') {
          // Account is deactivated - show reactivation dialog
          if (context.mounted) {
            _showAccountStatusDialog(context, 'DEACTIVATE');
          }
        } else if (status == 'BLOCKED') {
          // Account is blocked - show contact admin dialog
          if (context.mounted) {
            _showAccountStatusDialog(context, 'BLOCKED');
          }
        } else if (status == 'ACTIVE') {
          // Account is active - proceed to home
          if (context.mounted) {
            _handleSuccessfulLogin(context);
          }
        } else if (status == 'PENDING') {
          // Account verification pending
          if (context.mounted) {
            ToastService.showInfo(
              context,
              'Please verify your email to continue',
            );
            
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                final email = emailController.text.trim();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.verifyEmail,
                  arguments: email,
                );
              }
            });
          }
        } else {
          // Unknown status - proceed to home
          if (context.mounted) {
            _handleSuccessfulLogin(context);
          }
        }
      } else {
        // Could not fetch user data, proceed to home anyway
        if (context.mounted) {
          _handleSuccessfulLogin(context);
        }
      }
    } catch (e) {
      // Error checking status - proceed to home
      debugPrint('Error checking account status: $e');
      if (context.mounted) {
        _handleSuccessfulLogin(context);
      }
    }
  }

  /// Show account status dialog (deactivated or blocked)
  void _showAccountStatusDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _buildAccountStatusDialog(dialogContext, status),
    );
  }

  /// Build account status dialog content
  Widget _buildAccountStatusDialog(BuildContext context, String status) {
    final isDeactivated = status == 'DEACTIVATE';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDeactivated
                      ? Colors.amber.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                ),
                child: Icon(
                  isDeactivated ? Icons.lock_outline : Icons.block_rounded,
                  size: 40,
                  color: isDeactivated ? Colors.amber[700] : Colors.red[700],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                isDeactivated
                    ? 'Account Deactivated'
                    : 'Account Blocked',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2B3E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                isDeactivated
                    ? 'Your account has been deactivated. You can reactivate it anytime to continue using Saloony.'
                    : 'Your account has been blocked by the Saloony administrator. Please contact our support team for assistance.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Buttons
              if (isDeactivated) ...[
                _buildReactivateButton(context),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Maybe Later',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B2B3E),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Saloony Support:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B2B3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: support@saloony.com\nPhone: +1 (555) 000-0000',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildCloseButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactivateButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B2B3E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: () async {
        try {
          final result = await _userService.activateAccount();
          
          if (context.mounted) {
            if (result['success'] == true) {
              ToastService.showSuccess(context, 'Account activated successfully');
              
              await Future.delayed(const Duration(milliseconds: 500));
              
              if (context.mounted) {
                Navigator.of(context).pop();
                _handleSuccessfulLogin(context);
              }
            } else {
              ToastService.showError(
                context,
                result['message'] ?? 'Failed to activate account',
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ToastService.showError(context, 'Error activating account: $e');
          }
        }
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reactivate Account',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B2B3E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Close',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Méthodes Privées ====================

  /// Valider les entrées utilisateur
  /// 
  /// Retourne un message d'erreur s'il y a un problème, null sinon
  String? _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return 'Please enter your email and password';
    }

    if (!_isValidEmail(email)) {
      return 'Please enter a valid email address';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Vérifier si l'email a un format valide
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Vérifier si le compte nécessite une vérification email
  bool _isPendingVerification(Map<String, dynamic> result) {
    final status = result['status']?.toString().toLowerCase() ?? '';
    final message = result['message']?.toString().toLowerCase() ?? '';

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

    if (status == 'pending') return true;

    for (var keyword in verificationKeywords) {
      if (message.contains(keyword)) return true;
    }

    return false;
  }

  /// Gérer la connexion réussie
  void _handleSuccessfulLogin(BuildContext context) {
    ToastService.showSuccess(context, 'Welcome back!');
    
    // Petit délai pour que l'utilisateur voie le message
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  /// Gérer l'échec de la connexion
  void _handleFailedLogin(BuildContext context, Map<String, dynamic> result) {
    if (_isPendingVerification(result)) {
      // Compte en attente de vérification
      ToastService.showInfo(
        context,
        'Please verify your email to continue',
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          final email = emailController.text.trim();
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.verifyEmail,
            arguments: email,
          );
        }
      });
    } else {
      // Detect deactivated / blocked accounts from backend message
      final message = (result['message'] ?? '').toString().toLowerCase();

      if (message.contains('deactiv') || message.contains('deactivated')) {
        // Show reactivation modal
        if (context.mounted) {
          _showAccountStatusDialog(context, 'DEACTIVATE');
        }
        return;
      }

      if (message.contains('block') || message.contains('blocked')) {
        // Show blocked modal with support info
        if (context.mounted) {
          _showAccountStatusDialog(context, 'BLOCKED');
        }
        return;
      }

      // Other errors
      final fallback = result['message'] ?? 'Login failed';
      ToastService.showError(context, fallback);
    }
  }

  /// Gérer les erreurs de connexion
  void _handleError(BuildContext context, dynamic error) {
    _isLoading = false;
    notifyListeners();

    if (context.mounted) {
      ToastService.showError(
        context,
        'Connection error. Please try again.',
      );
    }

    debugPrint('❌ Sign In Error: $error');
  }

  // ==================== Nettoyage ====================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}