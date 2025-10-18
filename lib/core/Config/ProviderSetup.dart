import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:saloony/features/auth/viewmodels/ForgotPasswordViewModel.dart';
import 'package:saloony/features/auth/viewmodels/ResetPasswordViewModel.dart';
import 'package:saloony/features/auth/viewmodels/SignInViewModel.dart';
import 'package:saloony/features/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';

class ProviderSetup {
  /// Liste de tous les providers de l'application
  static List<SingleChildWidget> providers = [
    // Authentication Providers
    ChangeNotifierProvider(create: (_) => SignInViewModel()),
    ChangeNotifierProvider(create: (_) => SignUpViewModel()),
    ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
    ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
    
    // Salon Providers
    ChangeNotifierProvider(create: (_) => SalonCreationViewModel()),
  ];
}

// ==================== CONFIG ====================
class Config {
  // Configuration du serveur
  static const String ipAddressAndPort ='172.16.15.51:8081';
  
  // Base URL pour les requêtes API
  static const String baseUrl = 'http://$ipAddressAndPort';
  
  // Endpoints d'authentification
  static const String authBaseUrl = '$baseUrl/api/v1/auth';
  static const String userBaseUrl = '$baseUrl/api/v1/auth/user';
  
  // Endpoints Salon
  static const String salonBaseUrl = '$baseUrl/api/salon';
  static const String treatmentBaseUrl = '$baseUrl/api/treatment';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Clés de stockage local
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  
  // Paramètres de validation
  static const int minPasswordLength = 6;
  static const int verificationCodeLength = 6;
  static const int codeExpirationMinutes = 15;
  
  // Paramètres Salon
  static const int minSalonNameLength = 2;
  static const int maxSalonNameLength = 100;
  static const int maxSalonDescriptionLength = 500;
}