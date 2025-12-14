import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/UserService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';
import 'package:SaloonySpecialist/core/models/User.dart';
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  final BuildContext context;
late TextEditingController firstNameController;
late TextEditingController lastNameController;

  bool _isLoading = false;
  bool _isLoadingData = true;
  User? _currentUser;
  
  // ✅ Utiliser Uint8List au lieu de File pour compatibilité Web/Mobile
  Uint8List? _imageBytes;
  String? _imageFilename;
  String? _profileImagePath;

  String _firstName = '';
  String _lastName = '';
  String _gender = 'MEN';
  String _email = '';
  String _phoneNumber = '';
  String _role = 'CUSTOMER';

  bool get isLoading => _isLoading;
  bool get isLoadingData => _isLoadingData;
  User? get currentUser => _currentUser;
  Uint8List? get imageBytes => _imageBytes;

  /// ✅ URL de l'image pour affichage (résout le chemin relatif)
  String? get profileImageUrl {
    if (_profileImagePath == null || _profileImagePath!.isEmpty) {
      return null;
    }
    if (_profileImagePath!.startsWith('http://') || 
        _profileImagePath!.startsWith('https://')) {
      return _profileImagePath;
    }
    final baseUrl = Config.userBaseUrl;
    final cleanPath = _profileImagePath!.startsWith('/') 
        ? _profileImagePath!.substring(1) 
        : _profileImagePath!;
    final uri = Uri.parse(baseUrl);
    final baseUrlWithoutPath = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    return '$baseUrlWithoutPath/$cleanPath';
  }

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => '$_firstName $_lastName'.trim();
  String get gender => _gender;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get platformRole => _role;
  String get speciality => _formatRole(_role);
  List<String> get availableGenders => ['Homme', 'Femme'];

  ProfileEditViewModel(this.context) {
    ToastService.init(context);
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    _isLoadingData = true;
    notifyListeners();

    try {
      final result = await _authService.getCurrentUser();
      if (result['success'] == true && result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
        _populateFields();
      } else {
        ToastService.showError(context, 'Impossible de charger le profil');
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'utilisateur: $e');
      ToastService.showError(context, 'Erreur de chargement du profil');
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }

  void _populateFields() {
    if (_currentUser != null) {
      _firstName = _currentUser!.userFirstName ?? '';
      _lastName = _currentUser!.userLastName ?? '';
      _gender = _currentUser!.userGender ?? 'MEN';
      _profileImagePath = _currentUser!.profilePhotoPath;
      _email = _currentUser!.userEmail ?? '';
      _phoneNumber = _currentUser!.userPhoneNumber ?? '';
      _role = _currentUser!.appRole ?? 'CUSTOMER';
 firstNameController = TextEditingController(text: _firstName);
    lastNameController  = TextEditingController(text: _lastName);
      debugPrint('📸 Profile image path: $_profileImagePath');
      debugPrint('📸 Profile image URL: $profileImageUrl');
    }
  }

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
    switch (value) {
      case 'Homme':
        _gender = 'MEN';
        break;
      case 'Femme':
        _gender = 'WOMEN';
        break;
      default:
        _gender = value;
    }
    notifyListeners();
  }

  /// ✅ SÉLECTION d'image depuis la galerie (Web & Mobile)
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
        // ✅ Lire les bytes de l'image (compatible Web & Mobile)
        _imageBytes = await pickedFile.readAsBytes();
        _imageFilename = pickedFile.name;
        
        debugPrint('✅ Image sélectionnée: ${_imageBytes!.length} bytes');
        notifyListeners();
        
        await _uploadImage();
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la sélection de l\'image: $e');
      ToastService.showError(context, 'Erreur lors de la sélection de l\'image');
    }
  }

  /// ✅ PRISE de photo avec la caméra (Web & Mobile)
  Future<void> takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // ✅ Lire les bytes de l'image
        _imageBytes = await pickedFile.readAsBytes();
        _imageFilename = pickedFile.name;
        
        debugPrint('✅ Photo prise: ${_imageBytes!.length} bytes');
        notifyListeners();
        
        await _uploadImage();
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la prise de photo: $e');
      ToastService.showError(context, 'Erreur lors de la prise de photo');
    }
  }

  /// ✅ UPLOAD de l'image vers le serveur
  Future<bool> _uploadImage() async {
    if (_imageBytes == null || _currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> result;
      final hasExistingPhoto = _currentUser?.profilePhotoPath != null &&
          _currentUser!.profilePhotoPath!.isNotEmpty;

      debugPrint('📸 Upload image - User ID: ${_currentUser!.userId}');
      debugPrint('📸 Has existing photo: $hasExistingPhoto');
      debugPrint('📸 Image size: ${_imageBytes!.length} bytes');

      if (hasExistingPhoto) {
        debugPrint('📸 Calling UPDATE profile photo API...');
        result = await _userService.updateProfilePhoto(
          userId: _currentUser!.userId,
          imageBytes: _imageBytes!,
          filename: _imageFilename ?? 'profile_image.jpg',
        );
      } else {
        debugPrint('📸 Calling ADD profile photo API...');
        result = await _userService.addProfilePhoto(
          userId: _currentUser!.userId,
          imageBytes: _imageBytes!,
          filename: _imageFilename ?? 'profile_image.jpg',
        );
      }

      debugPrint('📸 API Response: ${result['success']} - ${result['message']}');

      if (result['success'] == true && result['user'] != null) {
        _currentUser = result['user'] is User
            ? result['user']
            : User.fromJson(result['user']);
        
        _profileImagePath = _currentUser!.profilePhotoPath;
        _imageBytes = null; // ✅ Clear après upload
        _imageFilename = null;

        debugPrint('📸 Updated profile image path: $_profileImagePath');
        debugPrint('📸 Updated profile image URL: $profileImageUrl');

        ToastService.showSuccess(context, 'Photo de profil mise à jour');
        return true;
      } else {
        ToastService.showError(
          context,
          result['message'] ?? 'Erreur lors de l\'upload de la photo',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'upload de l\'image: $e');
      ToastService.showError(context, 'Erreur lors de l\'upload de l\'image');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ SUPPRESSION de la photo de profil
  Future<void> removeProfilePhoto() async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _userService.deleteProfilePhoto(_currentUser!.userId);

      if (result['success'] == true) {
        _profileImagePath = null;
        _imageBytes = null;
        _imageFilename = null;
        
        if (_currentUser != null) {
          _currentUser!.profilePhotoPath = null;
        }

        ToastService.showSuccess(context, 'Photo de profil supprimée');
      } else {
        ToastService.showError(
          context,
          result['message'] ?? 'Erreur lors de la suppression de la photo',
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la suppression de la photo: $e');
      ToastService.showError(context, 'Erreur lors de la suppression de la photo');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ SAUVEGARDE des modifications du profil
  Future<Map<String, dynamic>> saveChanges() async {
    if (_currentUser == null) {
      ToastService.showError(context, 'Utilisateur non connecté');
      return {'success': false, 'message': 'Utilisateur non connecté'};
    }

    // Validation
    if (_firstName.trim().isEmpty || _lastName.trim().isEmpty) {
      ToastService.showError(context, 'Le nom et prénom sont requis');
      return {'success': false, 'message': 'Le nom et prénom sont requis'};
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _userService.updateUser(
        userId: _currentUser!.userId,
        firstName: _firstName.trim(),
        lastName: _lastName.trim(),
        gender: _gender,
      );

      if (result['success'] == true) {
        if (result['user'] != null) {
          _currentUser = result['user'] is User
              ? result['user']
              : User.fromJson(result['user']);
          _populateFields();
        }

        final message = result['message'] ?? 'Profil mis à jour avec succès';
        ToastService.showSuccess(context, message);
        return {'success': true, 'message': message};
      }

      final errorMessage = result['message'] ?? 'Erreur lors de la mise à jour';
      ToastService.showError(context, errorMessage);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      debugPrint('❌ Erreur lors de la sauvegarde: $e');
      ToastService.showError(context, 'Erreur de connexion');
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  @override
  void dispose() {
    ToastService.cancelAll();
    super.dispose();
  }
}