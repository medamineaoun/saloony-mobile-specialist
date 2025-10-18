import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/AuthService.dart';

class SalonService {
  static String get baseUrl => Config.salonBaseUrl;
  final AuthService _authService = AuthService();

  /// 🏢 Créer un nouveau salon
  Future<Map<String, dynamic>> createSalon({
    required String salonName,
    required String salonDescription,
    required String salonCategory,
    required List<String> additionalServices,
    required String genderType,
    required double latitude,
    required double longitude,
    required List<String> treatmentIds,
    required List<String> specialistIds,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required'
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/salon/add-salon'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'salonName': salonName,
          'salonDescription': salonDescription,
          'salonCategory': salonCategory,
          'additionalService': additionalServices,
          'type': genderType,
          'salonLatitude': latitude,
          'salonLongitude': longitude,
          'salonTreatmentsIds': treatmentIds,
          'salonSpecialistsIds': specialistIds,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
          'message': 'Salon created successfully'
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to create salon'
        };
      }
    } catch (e) {
      debugPrint('❌ Error creating salon: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// 📸 Ajouter une photo au salon
  Future<Map<String, dynamic>> addSalonPhoto({
    required String salonId,
    required String imagePath,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required'
        };
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/salon/$salonId/photos'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
          'message': 'Photo added successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to add photo'
        };
      }
    } catch (e) {
      debugPrint('❌ Error adding photo: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// 📍 Mettre à jour la localisation du salon
  Future<Map<String, dynamic>> updateSalonLocation({
    required String salonId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required'
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/salon/$salonId/update-location?salonLatitude=$latitude&salonLongitude=$longitude'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.body
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update location'
        };
      }
    } catch (e) {
      debugPrint('❌ Error updating location: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// 📋 Récupérer tous les traitements disponibles
  Future<Map<String, dynamic>> getAllTreatments() async {
    try {
      final token = await _authService.getAccessToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/treatment/retrieve-all-treatments'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'treatments': data
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch treatments'
        };
      }
    } catch (e) {
      debugPrint('❌ Error fetching treatments: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// 👥 Récupérer tous les spécialistes disponibles
  Future<Map<String, dynamic>> getAvailableSpecialists() async {
    try {
      final token = await _authService.getAccessToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/specialists/available'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'specialists': data
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch specialists'
        };
      }
    } catch (e) {
      debugPrint('❌ Error fetching specialists: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// 🔍 Récupérer un salon par ID
  Future<Map<String, dynamic>> getSalonById(String salonId) async {
    try {
      final token = await _authService.getAccessToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/salon/retrieve-salon/$salonId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data
        };
      } else {
        return {
          'success': false,
          'message': 'Salon not found'
        };
      }
    } catch (e) {
      debugPrint('❌ Error fetching salon: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// ✏️ Modifier un salon existant
  Future<Map<String, dynamic>> updateSalon({
    required String salonId,
    required String salonName,
    required String salonDescription,
    required String salonCategory,
    required List<String> additionalServices,
    required String genderType,
    required List<String> treatmentIds,
    required List<String> specialistIds,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required'
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/salon/modify-salon'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'salonId': salonId,
          'salonName': salonName,
          'salonDescription': salonDescription,
          'salonCategory': salonCategory,
          'additionalService': additionalServices,
          'type': genderType,
          'salonTreatmentsIds': treatmentIds,
          'salonSpecialistsIds': specialistIds,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
          'message': 'Salon updated successfully'
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to update salon'
        };
      }
    } catch (e) {
      debugPrint('❌ Error updating salon: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  /// 🗑️ Supprimer une photo du salon
  Future<Map<String, dynamic>> deleteSalonPhoto({
    required String salonId,
    required int photoIndex,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required'
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/salon/$salonId/photos/$photoIndex'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Photo deleted successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete photo'
        };
      }
    } catch (e) {
      debugPrint('❌ Error deleting photo: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}