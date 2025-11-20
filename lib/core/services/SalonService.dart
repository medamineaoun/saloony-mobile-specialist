import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/features/Salon/view_models/SalonCreationViewModel.dart';

class SalonService {
  final AuthService _authService = AuthService();

  Future<String?> _getAuthToken() async {
    final token = await _authService.getAccessToken();
    return token;
  }

  // ✅ NOUVELLE MÉTHODE: Récupérer l'ID de l'utilisateur connecté
  Future<String?> _getCurrentUserId() async {
    try {
      final userResult = await _authService.getCurrentUser();
      if (userResult['success'] == true && userResult['user'] != null) {
        final user = userResult['user'];
        return user['userId'] ?? user['id'];
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erreur récupération userId: $e');
      return null;
    }
  }

  /// Récupérer le salon d'un spécialiste par son userId
  Future<Map<String, dynamic>> getSpecialistSalon(String userId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.salonBaseUrl}/get-salon-by-specialist/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération salon spécialiste: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Aucun salon trouvé pour ce spécialiste',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salon: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  Future<Map<String, dynamic>> verifySpecialistEmail(String email) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.userBaseUrl}/verify-specialist-email?email=$email'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📧 Vérification email: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur vérification email: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  /// Obtenir tous les traitements disponibles
  Future<Map<String, dynamic>> getAllTreatments() async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.treatmentBaseUrl}/retrieve-all-treatments'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('💆 Récupération traitements: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> treatments = jsonDecode(response.body);
        return {
          'success': true,
          'treatments': treatments,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des traitements',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération traitements: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Créer un nouveau traitement
  Future<Map<String, dynamic>> addTreatment({
    required String name,
    required String description,
    required double price,
    required double duration,
    required String category,
    String? photoPath,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final treatmentData = {
        'treatmentName': name,
        'treatmentDescription': description,
        'treatmentPrice': price,
        'treatmentTime': duration,
        'treatmentCategory': category,
      };

      final response = await http.post(
        Uri.parse('${Config.treatmentBaseUrl}/add-treatment'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(treatmentData),
      );

      debugPrint('➕ Ajout traitement: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        if (photoPath != null && data['treatmentId'] != null) {
          await uploadTreatmentPhoto(data['treatmentId'], photoPath);
        }
        
        return {
          'success': true,
          'treatment': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout du traitement',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur ajout traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Upload photo de traitement
  Future<Map<String, dynamic>> uploadTreatmentPhoto(String treatmentId, String imagePath) async {
    try {
      final token = await _getAuthToken();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.treatmentBaseUrl}/$treatmentId/photo'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      await response.stream.bytesToString();

      debugPrint('📷 Upload photo traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Photo uploadée avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur upload photo',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur upload photo traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  // ✅ CORRIGÉ: Méthode createSalon avec salonOwnerId
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
    required Map<String, dynamic> availability,
    String? salonOwnerId, // ✅ Paramètre optionnel pour l'owner ID
  }) async {
    try {
      final token = await _getAuthToken();

      // ✅ Récupérer l'owner ID si non fourni
      final String ownerId = salonOwnerId ?? await _getCurrentUserId() ?? specialistIds.first;

      final salonData = {
        "salonName": salonName,
        "salonDescription": salonDescription,
        "salonCategory": salonCategory,
        "additionalService": additionalServices,
        "salonGenderType": genderType,
        "salonLatitude": latitude,
        "salonLongitude": longitude,
        "salonTreatmentsIds": treatmentIds,
        "salonSpecialistsIds": specialistIds,
        "salonAvailabilities": _formatAvailabilitiesForApi(availability),
        "salonOwnerId": ownerId, // ✅ AJOUT CRITIQUE
      };

      debugPrint('📤 Données salon complètes: ${jsonEncode(salonData)}');

      final response = await http.post(
        Uri.parse('${Config.salonBaseUrl}/add-salon'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(salonData),
      );

      debugPrint('🏢 Création salon: ${response.statusCode}');
      debugPrint('🏢 Réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Erreur lors de la création du salon',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur création salon: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  // Méthode _formatAvailabilitiesForApi
  List<Map<String, dynamic>> _formatAvailabilitiesForApi(Map<String, dynamic>? availability) {
    if (availability == null) return [];
    
    final List<Map<String, dynamic>> availabilities = [];
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (final day in days) {
      final dayKey = day;
      final dayData = availability[dayKey];
      
      if (dayData != null && dayData is Map<String, dynamic>) {
        final availabilityEntry = {
          'dayOfWeek': dayData['dayOfWeek'],
          'available': dayData['available'],
        };
        
        // Ajouter fromHour et toHour seulement si available est true
        if (dayData['available'] == true) {
          availabilityEntry['fromHour'] = dayData['fromHour'];
          availabilityEntry['toHour'] = dayData['toHour'];
        } else {
          availabilityEntry['fromHour'] = null;
          availabilityEntry['toHour'] = null;
        }
        
        availabilities.add(availabilityEntry);
      }
    }
    
    debugPrint('📅 Disponibilités formatées pour API: ${availabilities.length} jours');
    for (final avail in availabilities) {
      debugPrint('  - ${avail['dayOfWeek']}: ${avail['available']} (${avail['fromHour']} - ${avail['toHour']})');
    }
    
    return availabilities;
  }

  Future<Map<String, dynamic>> addCustomServices({
    required String salonId,
    required List<CustomService> customServices,
  }) async {
    try {
      final token = await _getAuthToken();

      final customServicesData = customServices.map((service) => {
        'serviceName': service.name,
        'serviceDescription': service.description,
        'servicePrice': service.price,
        'specificGender': service.specificGender,
        'serviceCategory': service.category,
      }).toList();

      final response = await http.post(
        Uri.parse('${Config.salonBaseUrl}/$salonId/custom-services'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'services': customServicesData}),
      );

      debugPrint('➕ Ajout services personnalisés: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Services ajoutés avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout des services',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur ajout services: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Ajouter la disponibilité après la création du salon
  Future<Map<String, dynamic>> addSalonAvailability({
    required String salonId,
    required Map<String, DayAvailabilityWithSlots> availability,
  }) async {
    try {
      final token = await _getAuthToken();

      final availabilityData = availability.map((key, value) {
        return MapEntry(key, {
          'day': key,
          'isAvailable': value.isAvailable,
          'startTime': value.timeRange != null 
              ? '${value.timeRange!.startTime.hour.toString().padLeft(2, '0')}:${value.timeRange!.startTime.minute.toString().padLeft(2, '0')}'
              : null,
          'endTime': value.timeRange != null
              ? '${value.timeRange!.endTime.hour.toString().padLeft(2, '0')}:${value.timeRange!.endTime.minute.toString().padLeft(2, '0')}'
              : null,
        });
      });

      final response = await http.post(
        Uri.parse('${Config.salonBaseUrl}/$salonId/availability'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'availability': availabilityData}),
      );

      debugPrint('📅 Ajout disponibilité: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Disponibilité ajoutée avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'ajout de la disponibilité',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur ajout disponibilité: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Ajouter une photo au salon
  Future<Map<String, dynamic>> addSalonPhoto({
    required String salonId,
    required String imagePath,
  }) async {
    try {
      final token = await _getAuthToken();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.salonBaseUrl}/$salonId/photos'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('📷 Upload photo salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Photo uploadée avec succès',
          'data': jsonDecode(responseBody),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'upload de la photo',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur upload photo salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Obtenir les détails d'un salon par ID
  Future<Map<String, dynamic>> getSalonDetails(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.salonBaseUrl}/retrieve-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération détails salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Salon non trouvé',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Mettre à jour un salon
  Future<Map<String, dynamic>> updateSalon({
    required String salonId,
    Map<String, dynamic>? updateData,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.put(
        Uri.parse('${Config.salonBaseUrl}/modify-salon'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      debugPrint('✏️ Mise à jour salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur mise à jour salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Supprimer un salon
  Future<Map<String, dynamic>> deleteSalon(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.delete(
        Uri.parse('${Config.salonBaseUrl}/remove-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🗑️ Suppression salon: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Salon supprimé avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur suppression salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getSalonById(String salonId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/salon/retrieve-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Échec de récupération du salon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du salon: $e');
    }
  }

  /// Obtenir tous les salons
  Future<Map<String, dynamic>> getAllSalons() async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.salonBaseUrl}/retrieve-all-salons'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération tous les salons: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> salons = jsonDecode(response.body);
        return {
          'success': true,
          'salons': salons,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des salons',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salons: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }
}