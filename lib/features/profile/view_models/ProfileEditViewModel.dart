import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/UserService.dart';
import 'package:saloony/core/models/User.dart';

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

  // Champs du formulaire
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phoneNumber = '';
  String _gender = 'MAN';
  String _role = 'CUSTOMER';

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingData => _isLoadingData;
  User? get currentUser => _currentUser;
  File? get imageFile => _imageFile;
  String? get profileImagePath => _profileImagePath;
  
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => '$_firstName $_lastName'.trim();
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get gender => _gender;
  String get platformRole => _role;
  String get speciality => _formatRole(_role);

  List<String> get availableRoles => ['Client', 'Spécialiste', 'Administrateur'];
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
      _firstName = _currentUser!.userFirstName;
      _lastName = _currentUser!.userLastName;
      _email = _currentUser!.userEmail;
      _phoneNumber = _currentUser!.userPhoneNumber ?? '';
      _gender = _currentUser!.userGender ?? 'MAN';
      _role = _currentUser!.appRole;
      _profileImagePath = _currentUser!.profilePhotoPath;
    }
  }

  // ==================== SETTERS ====================

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

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
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

  void setPlatformRole(String value) {
    // Convertir de l'affichage vers l'API
    switch (value) {
      case 'Client':
        _role = 'CUSTOMER';
        break;
      case 'Spécialiste':
        _role = 'SPECIALIST';
        break;
      case 'Administrateur':
        _role = 'ADMIN';
        break;
      default:
        _role = value;
    }
    notifyListeners();
  }

  void setSpeciality(String value) {
    setPlatformRole(value);
  }

  // ==================== IMAGE ====================

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
        requestFullMetadata: false, // Important pour éviter les problèmes
      );

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        notifyListeners();
        
        // Upload automatique
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
        
        // Upload automatique
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
      
      // Si l'utilisateur a déjà une photo, on fait un UPDATE, sinon un ADD
      if (_currentUser!.profilePhotoPath != null && 
          _currentUser!.profilePhotoPath!.isNotEmpty) {
        result = await _userService.updateProfilePhoto(
          userId: _currentUser!.userId,
          imageFile: _imageFile!,
        );
      } else {
        result = await _userService.addProfilePhoto(
          userId: _currentUser!.userId,
          imageFile: _imageFile!,
        );
      }

      if (result['success'] == true) {
        _currentUser = result['user'];
        _profileImagePath = _currentUser!.profilePhotoPath;
        _imageFile = null;
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Erreur lors de l\'upload de l\'image: $e');
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
          // Mettre à jour l'utilisateur local
          await _loadCurrentUser();
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

    if (!_isValidEmail(_email)) {
      return {
        'success': false,
        'message': 'Email invalide'
      };
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _userService.updateUser(
        userId: _currentUser!.userId,
        firstName: _firstName.trim(),
        lastName: _lastName.trim(),
        email: _email.trim(),
        phoneNumber: _phoneNumber.trim(),
        gender: _gender,
      );

      if (result['success'] == true) {
        // Recharger l'utilisateur complet
        await _loadCurrentUser();
        
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> refreshData() async {
    await _loadCurrentUser();
  }
}