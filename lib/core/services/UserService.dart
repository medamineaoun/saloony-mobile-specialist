import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/User.dart';
import 'package:http_parser/http_parser.dart';

class UserService {
  static String get baseUrl => Config.userBaseUrl; // Ajoutez cette config
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

  // ==================== UPDATE USER ====================

  /// Modifier les informations de l'utilisateur
  Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? status,
  }) async {
    try {
      final body = {
        'userId': userId,
        if (firstName != null) 'userFirstName': firstName,
        if (lastName != null) 'userLastName': lastName,
        if (email != null) 'userEmail': email,
        if (phoneNumber != null) 'userPhoneNumber': phoneNumber,
        if (gender != null) 'userGender': gender,
        if (status != null) 'userStatus': status,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/modify-user'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Le backend retourne UpdateUserDTO, on doit recharger l'utilisateur complet
        final result = await _authService.getCurrentUser();
        
        if (result['success'] == true && result['user'] != null) {
          return {
            'success': true,
            'user': User.fromJson(result['user']),
            'message': 'Profil mis à jour avec succès'
          };
        } else {
          // Fallback: essayer de parser la réponse directement
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

  /// Ajouter une photo de profil
  Future<Map<String, dynamic>> addProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/$userId/profile-photo'),
      );

      request.headers['Authorization'] = 'Bearer ${token ?? ''}';
      
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  /// Mettre à jour la photo de profil
  Future<Map<String, dynamic>> updateProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/$userId/profile-photo'),
      );

      request.headers['Authorization'] = 'Bearer ${token ?? ''}';
      
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

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