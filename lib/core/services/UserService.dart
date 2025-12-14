import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/models/User.dart';
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

  Future<Map<String, dynamic>> getUserByEmailPublic(String email) async {
    try {
      final uri = Uri.parse('$baseUrl/retrieve-user-by-email/$email');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {'success': true, 'user': User.fromJson(userData)};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'User not found'};
      } else {
        return {'success': false, 'message': 'Failed to retrieve user'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> requestEmailUpdate({
    required String currentEmail,
    required String newEmail,
  }) async {
    try {
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
        return {'success': true, 'message': 'Email mis à jour avec succès'};
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

  Future<Map<String, dynamic>> requestPhoneUpdate({
    required String newPhoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.authBaseUrl}/send-verification-sms?phoneNumber=$newPhoneNumber'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Code de vérification envoyé par SMS'
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

  Future<Map<String, dynamic>> updatePhoneNumber({
    required String code,
    required String newPhoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.userBaseUrl}/update-phone-number?code=$code&newPhoneNumber=$newPhoneNumber'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Numéro de téléphone mis à jour avec succès'};
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
        return {'success': true, 'message': 'Mot de passe changé avec succès'};
      } else {
        return {'success': false, 'message': 'Ancien mot de passe incorrect'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  /// ✅ MÉTHODE UNIVERSELLE pour créer un MultipartFile (Web & Mobile)
  Future<http.MultipartFile> _createMultipartFile(
    Uint8List bytes,
    String fieldName,
    String filename,
  ) async {
    return http.MultipartFile.fromBytes(
      fieldName,
      bytes,
      filename: filename,
      contentType: MediaType('image', 'jpeg'),
    );
  }

  /// ✅ AJOUT de photo de profil (Web & Mobile compatible)
  Future<Map<String, dynamic>> addProfilePhoto({
    required String userId,
    required Uint8List imageBytes,
    String filename = 'profile_image.jpg',
  }) async {
    try {
      final url = '$baseUrl/$userId/profile-photo';
      debugPrint('📤 POST Request URL: $url');

      final token = await _authService.getAccessToken();
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers['Authorization'] = 'Bearer ${token ?? ''}';

      var multipartFile = await _createMultipartFile(
        imageBytes,
        'file',
        filename,
      );
      request.files.add(multipartFile);

      debugPrint('📤 Sending request...');
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
          'message': 'Erreur lors de l\'ajout de la photo (${response.statusCode})'
        };
      }
    } catch (e) {
      debugPrint('❌ Error adding profile photo: $e');
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  /// ✅ MISE À JOUR de photo de profil (Web & Mobile compatible)
  Future<Map<String, dynamic>> updateProfilePhoto({
    required String userId,
    required Uint8List imageBytes,
    String filename = 'profile_image.jpg',
  }) async {
    try {
      final url = '$baseUrl/$userId/profile-photo';
      debugPrint('📤 PUT Request URL: $url');

      final token = await _authService.getAccessToken();
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      request.headers['Authorization'] = 'Bearer ${token ?? ''}';

      var multipartFile = await _createMultipartFile(
        imageBytes,
        'file',
        filename,
      );
      request.files.add(multipartFile);

      debugPrint('📤 Sending request...');
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
          'message': 'Erreur lors de la mise à jour de la photo (${response.statusCode})'
        };
      }
    } catch (e) {
      debugPrint('❌ Error updating profile photo: $e');
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteProfilePhoto(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId/profile-photo'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Photo de profil supprimée avec succès'};
      } else {
        return {'success': false, 'message': 'Erreur lors de la suppression'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

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

  Future<Map<String, dynamic>> checkIfSpecialistHasSalon(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/checkIfSpecialistHasSalon'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final bool hasSalon = jsonDecode(response.body);
        return {'success': true, 'hasSalon': hasSalon};
      } else {
        return {'success': false, 'message': 'Erreur lors de la vérification du salon'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  Future<Map<String, dynamic>> deactivateAccount() async {
    try {
      final response = await http.put(
        Uri.parse('${Config.userBaseUrl}/deactivate'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Account deactivated successfully'};
      } else {
        return {'success': false, 'message': 'Failed to deactivate account'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> activateAccount() async {
    try {
      final response = await http.put(
        Uri.parse('${Config.userBaseUrl}/activate'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Account activated successfully'};
      } else {
        String errorMessage = 'Failed to activate account';
        try {
          if (response.body.isNotEmpty) {
            final decoded = jsonDecode(response.body);
            if (decoded is Map && decoded['message'] != null) {
              errorMessage = decoded['message'].toString();
            } else if (decoded is String && decoded.isNotEmpty) {
              errorMessage = decoded;
            } else {
              errorMessage = response.body;
            }
          }
        } catch (_) {
          if (response.body.isNotEmpty) errorMessage = response.body;
        }

        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}