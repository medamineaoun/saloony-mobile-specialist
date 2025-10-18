import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/UserService.dart' hide debugPrint;
import 'package:saloony/core/models/User.dart';
import 'package:saloony/core/Config/ProviderSetup.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  // État
  bool _isLoading = false;
  bool _isLoadingData = true;
  User? _currentUser;
  File? _imageFile;
  String? _profileImagePath;

  // Champs du formulaire (seulement les modifiables)
  String _firstName = '';
  String _lastName = '';
  String _gender = 'MAN';

  // Champs non-modifiables (pour affichage uniquement)
  String _email = '';
  String _phoneNumber = '';
  String _role = 'CUSTOMER';

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingData => _isLoadingData;
  User? get currentUser => _currentUser;
  File? get imageFile => _imageFile;
  
  // Getter pour l'URL complète de l'image
  String? get profileImageUrl {
    if (_profileImagePath == null || _profileImagePath!.isEmpty) {
      return null;
    }
    
    // Si c'est déjà une URL complète, la retourner
    if (_profileImagePath!.startsWith('http://') || 
        _profileImagePath!.startsWith('https://')) {
      return _profileImagePath;
    }
    
    // Sinon, construire l'URL complète
    final baseUrl = Config.userBaseUrl;
    final cleanPath = _profileImagePath!.startsWith('/') 
        ? _profileImagePath!.substring(1) 
        : _profileImagePath!;
    
    // Extraire le domaine de base sans /api/v1/auth/user
    final uri = Uri.parse(baseUrl);
    final baseUrlWithoutPath = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    
    return '$baseUrlWithoutPath/$cleanPath';
  }
  
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => '$_firstName $_lastName'.trim();
  String get gender => _gender;
  
  // Champs en lecture seule
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get platformRole => _role;
  String get speciality => _formatRole(_role);

  List<String> get availableGenders => ['Homme', 'Femme'];

  ProfileEditViewModel() {
    _loadCurrentUser();
  }

  // ==================== CHARGEMENT UTILISATEUR ====================

  Future<void> _loadCurrentUser() async {
    _isLoadingData = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();
      
      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
        _populateFields();
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'utilisateur: $e');
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }

  void _populateFields() {
    if (_currentUser != null) {
      _firstName = _currentUser!.userFirstName ?? '';
      _lastName = _currentUser!.userLastName ?? '';
      _gender = _currentUser!.userGender ?? 'MAN';
      _profileImagePath = _currentUser!.profilePhotoPath;
      
      // Champs non-modifiables
      _email = _currentUser!.userEmail ?? '';
      _phoneNumber = _currentUser!.userPhoneNumber ?? '';
      _role = _currentUser!.appRole ?? 'CUSTOMER';
      
      debugPrint('📸 Profile image path: $_profileImagePath');
      debugPrint('📸 Profile image URL: $profileImageUrl');
    }
  }

  // ==================== SETTERS (seulement pour les champs modifiables) ====================

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setFullName(String value) {
    final parts = value.split(' ');
    if (parts.isNotEmpty) {
      _firstName = parts.first;
      _lastName = parts.skip(1).join(' ');
      notifyListeners();
    }
  }

  void setGender(String value) {
    // Convertir de l'affichage vers l'API
    switch (value) {
      case 'Homme':
        _gender = 'MAN';
        break;
      case 'Femme':
        _gender = 'WOMAN';
        break;
      default:
        _gender = value;
    }
    notifyListeners();
  }

  // ==================== IMAGE ====================

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        notifyListeners();
        await _uploadImage();
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection de l\'image: $e');
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        notifyListeners();
        await _uploadImage();
      }
    } catch (e) {
      debugPrint('Erreur lors de la prise de photo: $e');
    }
  }

  Future<bool> _uploadImage() async {
    if (_imageFile == null || _currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> result;
      
      // Vérifier si l'utilisateur a déjà une photo
      final hasExistingPhoto = _currentUser?.profilePhotoPath != null && 
                              _currentUser!.profilePhotoPath!.isNotEmpty;
      
      debugPrint('📸 Upload image - User ID: ${_currentUser!.userId}');
      debugPrint('📸 Has existing photo: $hasExistingPhoto');
      
      if (hasExistingPhoto) {
        debugPrint('📸 Calling UPDATE profile photo API...');
        result = await _userService.updateProfilePhoto(
          userId: _currentUser!.userId,
          imageFile: _imageFile!,
        );
      } else {
        debugPrint('📸 Calling ADD profile photo API...');
        result = await _userService.addProfilePhoto(
          userId: _currentUser!.userId,
          imageFile: _imageFile!,
        );
      }
      
      debugPrint('📸 API Response: ${result['success']} - ${result['message']}');

      if (result['success'] == true && result['user'] != null) {
        _currentUser = result['user'] is User 
            ? result['user'] 
            : User.fromJson(result['user']);
        _profileImagePath = _currentUser!.profilePhotoPath;
        _imageFile = null;
        
        debugPrint('📸 Updated profile image path: $_profileImagePath');
        debugPrint('📸 Updated profile image URL: $profileImageUrl');
        
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'upload de l\'image: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeProfilePhoto() async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _userService.deleteProfilePhoto(_currentUser!.userId);
      
      if (result['success'] == true) {
        _profileImagePath = null;
        _imageFile = null;
        if (_currentUser != null) {
          _currentUser!.profilePhotoPath = null;
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la photo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== SAUVEGARDE ====================

  Future<Map<String, dynamic>> saveChanges() async {
    if (_currentUser == null) {
      return {
        'success': false,
        'message': 'Utilisateur non connecté'
      };
    }

    // Validation
    if (_firstName.trim().isEmpty || _lastName.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Le nom et prénom sont requis'
      };
    }

    _isLoading = true;
    notifyListeners();

    try {
      // N'envoyer QUE les champs modifiables
      final result = await _userService.updateUser(
        userId: _currentUser!.userId,
        firstName: _firstName.trim(),
        lastName: _lastName.trim(),
        gender: _gender,
      );

      if (result['success'] == true) {
        // Mettre à jour l'utilisateur local
        if (result['user'] != null) {
          _currentUser = result['user'] is User 
              ? result['user'] 
              : User.fromJson(result['user']);
          _populateFields();
        }
        
        return {
          'success': true,
          'message': result['message'] ?? 'Profil mis à jour avec succès'
        };
      }
      
      return {
        'success': false,
        'message': result['message'] ?? 'Erreur lors de la mise à jour'
      };
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e'
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== HELPERS ====================

  String _formatRole(String role) {
    switch (role.toUpperCase()) {
      case 'CUSTOMER':
        return 'Client';
      case 'SPECIALIST':
        return 'Spécialiste';
      case 'ADMIN':
        return 'Administrateur';
      default:
        return role;
    }
  }

  Future<void> refreshData() async {
    await _loadCurrentUser();
  }
}