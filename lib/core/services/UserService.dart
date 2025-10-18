import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/User.dart';
import 'package:http_parser/http_parser.dart';

class UserService {
  static String get baseUrl => Config.userBaseUrl;
    static String get baseUrlauth => Config.authBaseUrl;

  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // ==================== GET USER ====================

  /// Récupérer un utilisateur par son ID
  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/retrieve-user/$userId'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {'success': true, 'user': User.fromJson(userData)};
      } else {
        return {'success': false, 'message': 'Utilisateur non trouvé'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }
// ==================== UPDATE EMAIL ====================

/// Demander le code de vérification pour changer l'email
/// Cette méthode envoie un code au nouvel email
Future<Map<String, dynamic>> requestEmailUpdate({
  required String currentEmail,
  required String newEmail,
}) async {
  try {
    // Utiliser l'endpoint d'AuthService pour envoyer le code au nouvel email
    final response = await http.post(
      Uri.parse('${Config.authBaseUrl}/send-verification-email?email=$newEmail'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Code de vérification envoyé à votre nouvelle adresse email'
      };
    } else {
      String errorMessage = 'Erreur lors de l\'envoi du code';
      try {
        final error = jsonDecode(response.body);
        errorMessage = error['message'] ?? errorMessage;
      } catch (_) {}
      return {'success': false, 'message': errorMessage};
    }
  } catch (e) {
    return {'success': false, 'message': 'Erreur de connexion: $e'};
  }
}

/// Mettre à jour l'email avec le code de vérification
/// Le backend utilise le token JWT pour identifier l'utilisateur actuel
Future<Map<String, dynamic>> updateEmail({
  required String code,
  required String newEmail,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${Config.userBaseUrl}/update-email?code=$code&newEmail=$newEmail'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Email mis à jour avec succès'
      };
    } else {
      String errorMessage = 'Code invalide ou expiré';
      try {
        final error = jsonDecode(response.body);
        errorMessage = error['message'] ?? errorMessage;
      } catch (_) {}
      return {'success': false, 'message': errorMessage};
    }
  } catch (e) {
    return {'success': false, 'message': 'Erreur de connexion: $e'};
  }
}
  Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? firstName,
    String? lastName,
    String? gender,
  }) async {
    try {
      final body = {
        'userId': userId,
        if (firstName != null) 'userFirstName': firstName,
        if (lastName != null) 'userLastName': lastName,
        if (gender != null) 'userGender': gender,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/modify-user'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final result = await _authService.getCurrentUser();
        
        if (result['success'] == true && result['user'] != null) {
          return {
            'success': true,
            'user': User.fromJson(result['user']),
            'message': 'Profil mis à jour avec succès'
          };
        } else {
          try {
            final userData = jsonDecode(response.body);
            return {
              'success': true,
              'user': User.fromJson(userData),
              'message': 'Profil mis à jour avec succès'
            };
          } catch (_) {
            return {
              'success': true,
              'message': 'Profil mis à jour avec succès'
            };
          }
        }
      } else {
        String errorMessage = 'Erreur lors de la mise à jour';
        try {
          final error = jsonDecode(response.body);
          errorMessage = error['message'] ?? errorMessage;
        } catch (_) {}
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== CHANGE PASSWORD ====================

  /// Changer le mot de passe
  Future<Map<String, dynamic>> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change-password?email=$email&oldPassword=$oldPassword&newPassword=$newPassword'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Mot de passe changé avec succès'
        };
      } else {
        return {
          'success': false,
          'message': 'Ancien mot de passe incorrect'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== PROFILE PHOTO ====================

  /// Créer un MultipartFile compatible Web & Mobile
  Future<http.MultipartFile> _createMultipartFile(File imageFile, String fieldName) async {
    if (kIsWeb) {
      // Pour le Web: utiliser fromBytes
      final bytes = await imageFile.readAsBytes();
      return http.MultipartFile.fromBytes(
        fieldName,
        bytes,
        filename: 'profile_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    } else {
      // Pour Mobile: utiliser fromPath
      return await http.MultipartFile.fromPath(
        fieldName,
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
    }
  }

  /// Ajouter une photo de profil
  Future<Map<String, dynamic>> addProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final url = '$baseUrl/$userId/profile-photo';
      debugPrint('📤 POST Request URL: $url');
      
      final token = await _authService.getAccessToken();
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers['Authorization'] = 'Bearer ${token ?? ''}';
      
      // Créer le fichier multipart (compatible web & mobile)
      var multipartFile = await _createMultipartFile(imageFile, 'file');
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('📤 Response Status: ${response.statusCode}');
      debugPrint('📤 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {
          'success': true,
          'user': User.fromJson(userData),
          'message': 'Photo de profil ajoutée avec succès'
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout de la photo'
        };
      }
    } catch (e) {
      debugPrint('❌ Error adding profile photo: $e');
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  /// Mettre à jour la photo de profil
  Future<Map<String, dynamic>> updateProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final url = '$baseUrl/$userId/profile-photo';
      debugPrint('📤 PUT Request URL: $url');
      
      final token = await _authService.getAccessToken();
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      request.headers['Authorization'] = 'Bearer ${token ?? ''}';
      
      // Créer le fichier multipart (compatible web & mobile)
      var multipartFile = await _createMultipartFile(imageFile, 'file');
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('📤 PUT Response Status: ${response.statusCode}');
      debugPrint('📤 PUT Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {
          'success': true,
          'user': User.fromJson(userData),
          'message': 'Photo de profil mise à jour avec succès'
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour de la photo'
        };
      }
    } catch (e) {
      debugPrint('❌ Error updating profile photo: $e');
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }
// ==================== UPDATE EMAIL ====================

 /// Supprimer la photo de profil
  Future<Map<String, dynamic>> deleteProfilePhoto(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId/profile-photo'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Photo de profil supprimée avec succès'
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== GET USERS BY ROLE ====================

  /// Récupérer tous les utilisateurs par rôle
  Future<Map<String, dynamic>> getUsersByRole(String role) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/retrieve-user-by-role/$role'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = jsonDecode(response.body);
        final users = usersJson.map((json) => User.fromJson(json)).toList();
        return {'success': true, 'users': users};
      } else {
        return {'success': false, 'message': 'Erreur lors de la récupération'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }
}

// Import nécessaire pour kIsWeb (ajoutez ceci en haut du fichier)
void debugPrint(String message) {
  print(message);
}